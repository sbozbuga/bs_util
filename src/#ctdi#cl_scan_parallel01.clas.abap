class /CTDI/CL_SCAN_PARALLEL01 definition
  public
  inheriting from CL_ABAP_PARALLEL
  create public .

*"* Parallel worker for the control-character scan (batched-wave model).
*"* The DRIVER reads one package of rows and ships it here as an XSTRING
*"* packet; this worker (running in a separate work process via
*"* CL_ABAP_PARALLEL->RUN) deserializes the rows, SCANS them with
*"* /CTDI/CL_CNTRL_SCANNER, and ships the hits back as XSTRING. The worker
*"* does NOT read the database - reading stays in the driver so there is no
*"* key partitioning and no per-worker DB cursor.
public section.

  types:
    " The scan work packet shipped driver -> worker. ROWS_XML is the package
    " data table serialized with CALL TRANSFORMATION id; the worker rebuilds
    " the row type from TABLENAME + FIELDS (same projection as the reader).
    BEGIN OF ts_packet,
             tablename TYPE tabname,
             fields    TYPE /ctdi/cl_cntrl_scanner=>tt_field,
             keys      TYPE /ctdi/cl_cntrl_scanner=>tt_field,
             scope     TYPE /ctdi/cl_cntrl_scanner=>ts_scope,
             base_row  TYPE i,
             rows_xml  TYPE xstring,
           END OF ts_packet .
  types:
    " Result of a parallel scan run.
    BEGIN OF ts_result,
             hits      TYPE /ctdi/cl_cntrl_scanner=>tt_hit,
             rows      TYPE i,            " total rows scanned
             truncated TYPE abap_bool,    " stopped early at the hit ceiling
             errors    TYPE string_table, " per-task error messages (if any)
           END OF ts_result .

    "! Drive a full-table control-char scan in PARALLEL, batched-wave model
    "! (local path only). Each wave reads up to iv_pkgs_per_wave packages of
    "! iv_pkg_size rows via READ_CHUNK (resuming by key, cursor closed before
    "! the parallel RUN), ships them to worker processes to SCAN, and merges
    "! the hits. Repeats until the table is exhausted or the hit ceiling is
    "! reached. Reading is serial in this process; scanning is parallel.
  class-methods RUN_PARALLEL_SCAN
    importing
      !IV_TABLE type TABNAME
      !IT_SCANFLDS type /CTDI/CL_CNTRL_SCANNER=>TT_FIELD
      !IT_KEYS type /CTDI/CL_CNTRL_SCANNER=>TT_FIELD
      !IT_KEYFLDS type /CTDI/CL_CNTRL_SCANNER=>TT_FIELD
      !IS_SCOPE type /CTDI/CL_CNTRL_SCANNER=>TS_SCOPE
      !IT_WHERE type /CTDI/CL_TABLE_READER=>TT_WHERE optional
      !IV_PKG_SIZE type I default 50000
      !IV_PKGS_PER_WAVE type I default 12
      !IV_PERCENTAGE type I default 50
      !IV_HMAX type I default 0
      !IV_TOTAL_EST type I default 0       " known row estimate (0 = count here)
    returning
      value(RS_RESULT) type TS_RESULT .
    "! Pick an adaptive package size + packages-per-wave from the total row
    "! estimate and the ACTUAL parallel width. Policy (measured on DA1A):
    "!  - target pack size ~50k, kept inside the band 40k..60k (smaller
    "!    packs overlap better; the band gives the balancer room);
    "!  - total pack count rounded to a multiple of the width W so every
    "!    wave is full (no stranded work processes on the last wave);
    "!  - when N is too small to fill a wave at the min pack size, accept
    "!    one partial wave. Pure / deterministic (unit-tested).
    "! @parameter iv_total   | estimated total rows to scan (positive)
    "! @parameter iv_width   | actual parallel width W (WPs per wave, min 1)
    "! @parameter ev_pkgsize | chosen package size (rows), in the 40k..60k band
    "! @parameter ev_perwave | packages per wave (= iv_width, min 1)
  class-methods CALC_SIZING
    importing
      !IV_TOTAL type I
      !IV_WIDTH type I
    exporting
      !EV_PKGSIZE type I
      !EV_PERWAVE type I .
    "! The ACTUAL parallel width CL_ABAP_PARALLEL would use for a given
    "! percentage: percentage * free dialog WPs / 100, at least 1. Sizing to
    "! this (not the requested per-wave count) avoids waves that strand WPs
    "! because fewer were free than asked for.
  class-methods CALC_WIDTH
    importing
      !IV_PERCENTAGE type I default 50
    returning
      value(RV_WIDTH) type I .
    " Serialize a packet to the XSTRING that RUN transports (driver side).
  class-methods SERIALIZE_PACKET
    importing
      !IS_PACKET type TS_PACKET
    returning
      value(RV_XML) type XSTRING .
    " Deserialize the hit table from a worker result XSTRING (driver side).
  class-methods DESERIALIZE_HITS
    importing
      !IV_XML type XSTRING
    returning
      value(RT_HITS) type /CTDI/CL_CNTRL_SCANNER=>TT_HIT .

    " The parallel entry point, run in a separate work process (redefines
    " the abstract CL_ABAP_PARALLEL->DO on this release - no IF_ABAP_PARALLEL).
  methods DO
    redefinition .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /CTDI/CL_SCAN_PARALLEL01 IMPLEMENTATION.


  METHOD CALC_SIZING.
    CONSTANTS: lc_min    TYPE i VALUE 40000,
               lc_target TYPE i VALUE 50000,
               lc_max    TYPE i VALUE 60000.

    DATA(lv_w) = COND i( WHEN iv_width < 1 THEN 1 ELSE iv_width ).
    ev_perwave = lv_w.

    " Degenerate / unknown total: fall back to the measured sweet spot.
    IF iv_total <= 0.
      ev_pkgsize = lc_target.
      RETURN.
    ENDIF.

    " NOTE: ABAP '/' ROUNDS (half-up), it does not truncate. For a correct
    " ceiling we must use DIV (integer truncating division): ceil(a/b) =
    " (a + b - 1) DIV b.
    " Ideal number of ~target-sized packs (at least 1).
    DATA(lv_ideal) = ( iv_total + lc_target - 1 ) DIV lc_target. " ceil
    IF lv_ideal < 1.
      lv_ideal = 1.
    ENDIF.

    " Round the pack count UP to a whole number of full waves, so no wave
    " strands work processes. waves = ceil(ideal / W); packs = waves * W.
    DATA(lv_waves) = ( lv_ideal + lv_w - 1 ) DIV lv_w.
    IF lv_waves < 1.
      lv_waves = 1.
    ENDIF.
    DATA(lv_packs) = lv_waves * lv_w.

    " Rebalance pack size to fill those packs evenly.
    ev_pkgsize = ( iv_total + lv_packs - 1 ) DIV lv_packs.        " ceil

    " Keep the pack size inside the [min,max] band. If it is too large,
    " add whole waves (more, smaller packs) until it fits or we stop
    " helping; if too small, drop whole waves (fewer, bigger packs) but
    " never below one wave.
    WHILE ev_pkgsize > lc_max.
      lv_waves  = lv_waves + 1.
      lv_packs  = lv_waves * lv_w.
      ev_pkgsize = ( iv_total + lv_packs - 1 ) DIV lv_packs.
    ENDWHILE.

    WHILE ev_pkgsize < lc_min AND lv_waves > 1.
      lv_waves  = lv_waves - 1.
      lv_packs  = lv_waves * lv_w.
      ev_pkgsize = ( iv_total + lv_packs - 1 ) DIV lv_packs.
    ENDWHILE.

    " Final safety clamp (small-N case can still land below min with one
    " wave - that is an accepted partial wave; just cap at the band edges).
    IF ev_pkgsize > lc_max.
      ev_pkgsize = lc_max.
    ENDIF.
    IF ev_pkgsize < 1.
      ev_pkgsize = 1.
    ENDIF.
  ENDMETHOD.


  METHOD CALC_WIDTH.
    " Mirror CL_ABAP_PARALLEL=>GET_NUMBER_OF_PROCESSES: percentage of free
    " dialog work processes, at least 1.
    CONSTANTS lc_opcode TYPE syhex01 VALUE 25.
    DATA lv_dia   TYPE i.
    DATA lv_free  TYPE i.
    CALL 'ThWpInfo' ID 'OPCODE'     FIELD lc_opcode
                    ID 'DIAWP'      FIELD lv_dia
                    ID 'FREE_DIAWP' FIELD lv_free.
    rv_width = iv_percentage * lv_dia / 100.
    IF rv_width < 1.
      rv_width = 1.
    ENDIF.
  ENDMETHOD.


  METHOD DESERIALIZE_HITS.
    CALL TRANSFORMATION id SOURCE XML iv_xml
                           RESULT hits = rt_hits.
  ENDMETHOD.


  METHOD DO.
    " --- runs in a separate work process -------------------------------
    " 1) deserialize the packet
    DATA ls_packet TYPE ts_packet.
    CALL TRANSFORMATION id SOURCE XML p_in
                           RESULT packet = ls_packet.

    " 2) rebuild the row type (same projection the driver read with) and
    "    deserialize the package rows into it
    DATA(lo_reader) = NEW /ctdi/cl_table_reader( ).
    DATA lv_cols TYPE string.
    DATA lr_struct TYPE REF TO cl_abap_structdescr.
    lo_reader->build_projection( EXPORTING iv_table  = ls_packet-tablename
                                           it_fields = ls_packet-fields
                                 IMPORTING ev_cols   = lv_cols
                                           er_struct = lr_struct ).
    DATA(lr_tab) = cl_abap_tabledescr=>create( lr_struct ).
    DATA lr_data TYPE REF TO data.
    CREATE DATA lr_data TYPE HANDLE lr_tab.
    FIELD-SYMBOLS <lt> TYPE STANDARD TABLE.
    ASSIGN lr_data->* TO <lt>.
    CALL TRANSFORMATION id SOURCE XML ls_packet-rows_xml
                           RESULT rows = <lt>.

    " 3) scan the package (reuse the stateless scanner, with scope)
    DATA(lt_hits) = /ctdi/cl_cntrl_scanner=>scan_table(
                      it_data   = <lt>
                      it_fields = ls_packet-fields
                      it_keys   = ls_packet-keys
                      is_scope  = ls_packet-scope ).

    " 4) shift per-package row numbers to absolute, serialize hits back
    LOOP AT lt_hits ASSIGNING FIELD-SYMBOL(<h>).
      <h>-rownum = <h>-rownum + ls_packet-base_row.
    ENDLOOP.
    CALL TRANSFORMATION id SOURCE hits = lt_hits
                           RESULT XML p_out.
  ENDMETHOD.


  METHOD RUN_PARALLEL_SCAN.
    DATA(lo_reader) = NEW /ctdi/cl_table_reader( ).
    DATA lt_after   TYPE /ctdi/cl_table_reader=>tt_keyval.  " running resume key
    DATA lv_base    TYPE i.                                 " absolute row offset
    DATA lv_done    TYPE abap_bool.

    " ---- resolve effective pack size + packages-per-wave --------------
    " iv_pkg_size <= 0 means AUTO: derive from the row estimate and the
    " actual parallel width. A positive iv_pkg_size is an explicit override
    " (adaptive is skipped, caller's wave count is honoured).
    DATA lv_pkgsize TYPE i.
    DATA lv_perwave TYPE i.
    IF iv_pkg_size > 0.
      lv_pkgsize = iv_pkg_size.
      lv_perwave = iv_pkgs_per_wave.
    ELSE.
      " Row estimate: reuse the caller's known total (e.g. the selection
      " screen already counted and cached it) to avoid a second expensive
      " COUNT(*). Only count here when no estimate was supplied, and guard
      " it (a failing / slow COUNT must not break the scan).
      DATA lv_total TYPE i.
      IF iv_total_est > 0.
        lv_total = iv_total_est.
      ELSE.
        TRY.
            IF it_where IS INITIAL.
              SELECT COUNT(*) FROM (iv_table) INTO @lv_total.
            ELSE.
              SELECT COUNT(*) FROM (iv_table) INTO @lv_total WHERE (it_where).
            ENDIF.
          CATCH cx_root.
            lv_total = 0.
        ENDTRY.
      ENDIF.
      DATA(lv_width) = calc_width( iv_percentage ).
      calc_sizing( EXPORTING iv_total   = lv_total
                             iv_width   = lv_width
                   IMPORTING ev_pkgsize = lv_pkgsize
                             ev_perwave = lv_perwave ).
    ENDIF.

    " CL_ABAP_PARALLEL instance sized by percentage of free dialog WPs; cap
    " the task count at one wave's worth of packages.
    DATA(lo_par) = NEW /ctdi/cl_scan_parallel(
                     p_num_tasks  = lv_perwave
                     p_percentage = iv_percentage ).

    WHILE lv_done = abap_false.
      " ---- build one wave: read up to N packages (serial), serialize ----
      DATA lt_in TYPE cl_abap_parallel=>t_in_tab.
      CLEAR lt_in.
      DATA lv_pkg_in_wave TYPE i.
      lv_pkg_in_wave = 0.

      WHILE lv_pkg_in_wave < lv_perwave.
        DATA: lr_data   TYPE REF TO data,
              lr_struct TYPE REF TO cl_abap_structdescr,
              lt_last   TYPE /ctdi/cl_table_reader=>tt_keyval,
              lv_count  TYPE i.
        lo_reader->read_chunk(
          EXPORTING iv_table   = iv_table
                    it_where    = COND #( WHEN it_where IS SUPPLIED THEN it_where ELSE VALUE #( ) )
                    it_fields   = it_scanflds
                    it_keyflds  = it_keyflds
                    is_after    = lt_after
                    iv_max      = lv_pkgsize
          IMPORTING er_data     = lr_data
                    er_struct   = lr_struct
                    et_last_key = lt_last
                    ev_count    = lv_count ).

        IF lv_count = 0.
          lv_done = abap_true.
          EXIT.
        ENDIF.

        " serialize this package's rows + spec into a transport packet
        FIELD-SYMBOLS <lt> TYPE STANDARD TABLE.
        ASSIGN lr_data->* TO <lt>.
        DATA lv_rows_xml TYPE xstring.
        CALL TRANSFORMATION id SOURCE rows = <lt> RESULT XML lv_rows_xml.

        APPEND serialize_packet( VALUE ts_packet(
                 tablename = iv_table
                 fields    = it_scanflds
                 keys      = it_keys
                 scope     = is_scope
                 base_row  = lv_base
                 rows_xml  = lv_rows_xml ) ) TO lt_in.

        lv_base       = lv_base + lv_count.
        lt_after      = lt_last.                 " resume after this package
        lv_pkg_in_wave = lv_pkg_in_wave + 1.

        " a short package means the table is exhausted - last wave
        IF lv_count < lv_pkgsize.
          lv_done = abap_true.
          EXIT.
        ENDIF.
      ENDWHILE.

      IF lt_in IS INITIAL.
        EXIT.   " nothing read this wave
      ENDIF.

      " ---- scan the wave in parallel, collect, merge --------------------
      DATA lt_out TYPE cl_abap_parallel=>t_out_tab.
      lo_par->run( EXPORTING p_in_tab  = lt_in
                   IMPORTING p_out_tab = lt_out ).

      LOOP AT lt_out ASSIGNING FIELD-SYMBOL(<o>).
        IF <o>-message IS NOT INITIAL.
          APPEND |Task { <o>-index }: { <o>-message }| TO rs_result-errors.
          CONTINUE.
        ENDIF.
        APPEND LINES OF deserialize_hits( <o>-result ) TO rs_result-hits.
      ENDLOOP.

      " ---- hit ceiling: truncate exactly, stop -------------------------
      IF iv_hmax > 0 AND lines( rs_result-hits ) >= iv_hmax.
        DELETE rs_result-hits FROM iv_hmax + 1.
        rs_result-truncated = abap_true.
        lv_done = abap_true.
      ENDIF.
    ENDWHILE.

    rs_result-rows = lv_base.
  ENDMETHOD.


  METHOD SERIALIZE_PACKET.
    CALL TRANSFORMATION id SOURCE packet = is_packet
                           RESULT XML rv_xml.
  ENDMETHOD.
ENDCLASS.
