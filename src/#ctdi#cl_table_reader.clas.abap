class /CTDI/CL_TABLE_READER definition
  public
  create public .

*"* Reads a (database) table dynamically - locally via Open SQL or
*"* remotely via RFC_READ_TABLE - and resolves which character fields
*"* should be scanned for control characters. Pairs with the scanner
*"* class /CTDI/CL_CNTRL_SCANNER.
public section.

  types TT_FIELD type /CTDI/CL_CNTRL_SCANNER=>TT_FIELD .
  types:                                                    " field-name list
    tt_where TYPE STANDARD TABLE OF string WITH EMPTY KEY .

  " One key field and its (character) value, used to resume a keyed read
  " after a given row. The value is the field's current content as text.
  types: BEGIN OF ts_keyval,
           field TYPE fieldname,
           value TYPE string,
         END OF ts_keyval .
  " An ordered key tuple (position order of the non-client key fields).
  types tt_keyval TYPE STANDARD TABLE OF ts_keyval WITH EMPTY KEY .

  " One slice of a table for parallel processing: the key range it covers
  " (resume STRICTLY AFTER after_key, up to and INCLUDING end_key), plus the
  " row count and the absolute base-row offset. Produced by a cheap keys-only
  " probe (probe_slices); each slice is handed to a worker that reads+scans
  " only its own range, so the heavy row reads run in parallel.
  types: BEGIN OF ts_slice,
           slice_no  TYPE i,
           after_key TYPE tt_keyval,   " resume strictly after this (empty = from start)
           end_key   TYPE tt_keyval,   " last key in the slice (inclusive upper bound)
           rows      TYPE i,
           base_row  TYPE i,
         END OF ts_slice .
  types tt_slice TYPE STANDARD TABLE OF ts_slice WITH EMPTY KEY .

  constants C_RFC_LINE_LIMIT type I value 512 ##NO_TEXT. " RFC_READ_TABLE row width

    "! Read a table locally via dynamic Open SQL.
    "! iv_last = X orders by primary key DESCENDING (last block by key).
    "! iv_skip greater than 0 is a block offset: reads skip+max rows
    "! ordered, then drops the first skip rows (OFFSET combined with a
    "! dynamic ORDER BY is rejected by the strict parser on this release).
    "! Returns the data table (REF) and the structure actually used.
  methods READ
    importing
      !IV_TABLE type TABNAME
      !IV_MAX type I
      !IV_SKIP type I default 0
      !IV_LAST type ABAP_BOOL default ABAP_FALSE
      !IT_WHERE type TT_WHERE
      !IT_FIELDS type TT_FIELD
    exporting
      !ER_DATA type ref to DATA
      !ER_STRUCT type ref to CL_ABAP_STRUCTDESCR
    raising
      CX_SY_DYNAMIC_OSQL_ERROR
      CX_SY_CREATE_DATA_ERROR .
    "! Stream a LOCAL table in packages via an open cursor, so memory stays
    "! bounded regardless of table size (for big-table / full scans). The
    "! sink receives each package and accumulates hits; it may stop the
    "! sweep early. Rows are read in PRIMARY KEY order. This is the local
    "! path only - the RFC read path is unchanged.
    "! @parameter iv_table    | table to read
    "! @parameter it_where     | free WHERE fragments
    "! @parameter it_fields    | fields to project (empty = all columns)
    "! @parameter ii_sink      | package sink (handle_package per block)
    "! @parameter iv_pkg_size  | rows per package (PACKAGE SIZE)
    "! @parameter er_struct    | the (projected) structure actually used
  methods READ_IN_PACKAGES
    importing
      !IV_TABLE    type TABNAME
      !IT_WHERE    type TT_WHERE
      !IT_FIELDS   type TT_FIELD
      !II_SINK     type ref to /CTDI/IF_SCAN_SINK
      !IV_PKG_SIZE type I default 50000
    exporting
      !ER_STRUCT   type ref to CL_ABAP_STRUCTDESCR
    raising
      CX_SY_DYNAMIC_OSQL_ERROR
      CX_SY_CREATE_DATA_ERROR .
    "! Read ONE ordered chunk of up to iv_max rows, starting STRICTLY AFTER
    "! the given key tuple (is_after; empty = from the top). Rows come back
    "! ordered by the non-client key fields (it_keyflds) so chunks can be
    "! chained across parallel waves with no gap / overlap. Also returns the
    "! last row's key tuple (et_last_key) to seed the next chunk, and the row
    "! count. The caller combines its own WHERE (it_where) with the resume
    "! condition. This is the bounded, resumable read used by the parallel
    "! batch driver; it opens and closes its cursor within the call (no open
    "! cursor is held across the later parallel RUN).
    "! @parameter iv_table    | table to read
    "! @parameter it_where     | caller WHERE fragments (ANDed with resume)
    "! @parameter it_fields    | fields to project (empty = all columns)
    "! @parameter it_keyflds   | non-client key fields, in order (resume key)
    "! @parameter is_after     | last key tuple already read (empty = start)
    "! @parameter iv_max       | max rows to read in this chunk
    "! @parameter er_data      | REF to the chunk data table
    "! @parameter er_struct    | the (projected) structure used
    "! @parameter et_last_key  | key tuple of the LAST row read (next seed)
    "! @parameter ev_count     | number of rows actually read
  methods READ_CHUNK
    importing
      !IV_TABLE    type TABNAME
      !IT_WHERE    type TT_WHERE
      !IT_FIELDS   type TT_FIELD
      !IT_KEYFLDS  type TT_FIELD
      !IS_AFTER    type TT_KEYVAL
      !IV_MAX      type I
      !IS_UNTIL    type TT_KEYVAL optional   " inclusive upper key bound (slice end)
    exporting
      !ER_DATA     type ref to DATA
      !ER_STRUCT   type ref to CL_ABAP_STRUCTDESCR
      !ET_LAST_KEY type TT_KEYVAL
      !EV_COUNT    type I
    raising
      CX_SY_DYNAMIC_OSQL_ERROR
      CX_SY_CREATE_DATA_ERROR .
    "! The non-client primary key fields of a table, in key order. These are
    "! the resume / slice key for parallel processing (client is excluded as
    "! it is always the current client).
    "! @parameter iv_table    | table
    "! @parameter rt_keyflds  | non-client key field names, in position order
  methods GET_KEY_FIELDS
    importing
      !IV_TABLE   type TABNAME
    returning
      value(RT_KEYFLDS) type TT_FIELD .
    "! Cheap keys-only probe that partitions a table into balanced slices of
    "! iv_slice_size rows each. Reads ONLY the key fields in PRIMARY KEY order
    "! (BYPASSING BUFFER) and records each package boundary as a slice with
    "! its after_key (resume strictly after) and end_key (inclusive). The
    "! resulting slice map lets workers read+scan their own key range in
    "! parallel - the heavy row reads are NOT done here. Far cheaper than a
    "! full read (keys only). The caller's it_where is honoured.
    "! @parameter iv_table      | table to probe
    "! @parameter it_where       | caller WHERE fragments
    "! @parameter iv_slice_size  | rows per slice
    "! @parameter rt_slices      | the slice map (ordered, non-overlapping)
  methods PROBE_SLICES
    importing
      !IV_TABLE      type TABNAME
      !IT_WHERE      type TT_WHERE
      !IV_SLICE_SIZE type I default 50000
    returning
      value(RT_SLICES) type TT_SLICE
    raising
      CX_SY_DYNAMIC_OSQL_ERROR
      CX_SY_CREATE_DATA_ERROR .
    "! Resolve the character fields (CHAR / STRING) of a structure to
    "! scan, in position order, from the 1-based iv_start_col onward.
    "! iv_skip_check = X skips fields with a check table / foreign key.
    "! iv_table supplies the DDIC metadata for the check-table test.
  methods SCAN_FIELDS
    importing
      !IR_STRUCT type ref to CL_ABAP_STRUCTDESCR
      !IV_TABLE type TABNAME
      !IV_START_COL type I default 1
      !IV_SKIP_CHECK type ABAP_BOOL default ABAP_FALSE
    returning
      value(RT_FIELDS) type TT_FIELD .
    "! Read the given fields of a REMOTE table (RFC_READ_TABLE) and return
    "! control-character hits directly. iv_skip / iv_max map to ROWSKIPS /
    "! ROWCOUNT. Self-guards against the 512-byte row limit.
  methods READ_REMOTE
    importing
      !IV_DEST type RFCDEST
      !IV_TABLE type TABNAME
      !IT_FIELDS type TT_FIELD
      !IT_KEYS type TT_FIELD optional
      !IT_WHERE type TT_WHERE
      !IV_SKIP type I default 0
      !IV_MAX type I default 1000
    returning
      value(RT_HITS) type /CTDI/CL_CNTRL_SCANNER=>TT_HIT
    raising
      CX_SY_DYN_CALL_ILLEGAL_FUNC .
    "! Combined byte width of the given fields when concatenated by
    "! RFC_READ_TABLE (DDIC length + 1 delimiter each). Compare against
    "! c_rfc_line_limit before a remote read to fail fast with a clear
    "! message instead of hitting DATA_BUFFER_EXCEEDED.
  methods REMOTE_WIDTH
    importing
      !IR_STRUCT type ref to CL_ABAP_STRUCTDESCR
      !IT_FIELDS type TT_FIELD
    returning
      value(RV_WIDTH) type I .
    "! Build a dynamic WHERE fragment that selects rows STRICTLY AFTER the
    "! given key tuple, in key order - the lexicographic greater-than
    "! tuple expansion used to resume a keyed read between parallel waves.
    "! Term per component: (k1 EQ v1 AND ... AND ki GT vi), all ORed.
    "! Values are rendered as quoted character literals with embedded quotes
    "! escaped. An EMPTY tuple yields an empty fragment (start from the top).
    "! This is correctness-critical: the strict greater-than on the last
    "! component plus equality on the preceding ones guarantees every row is read exactly
    "! once across waves (no gap, no overlap), independent of distribution.
    "! @parameter it_after  | the last key tuple already processed (in order)
    "! @parameter rv_where  | WHERE fragment (without the leading AND), or empty
  methods BUILD_RESUME_WHERE
    importing
      !IT_AFTER      type TT_KEYVAL
    returning
      value(RV_WHERE) type STRING .
    "! Build a WHERE fragment that selects rows up to and INCLUDING the given
    "! key tuple (the lexicographic less-than-or-equal expansion). Used as the
    "! upper bound of a slice. Empty tuple yields an empty fragment.
  methods BUILD_UNTIL_WHERE
    importing
      !IT_UNTIL      type TT_KEYVAL
    returning
      value(RV_WHERE) type STRING .
    "! Build the projected structure and the SELECT column clause for a
    "! table + optional field list. With a field list, selects the key
    "! fields plus the requested fields; otherwise '*' / full structure.
    "! Public so the parallel worker can rebuild the exact row type the
    "! driver read with, to deserialize a shipped package.
  methods BUILD_PROJECTION
    importing
      !IV_TABLE  type TABNAME
      !IT_FIELDS type TT_FIELD
    exporting
      !EV_COLS   type STRING
      !ER_STRUCT type ref to CL_ABAP_STRUCTDESCR .
  PROTECTED SECTION.

  PRIVATE SECTION.
    " Display-authorization check for a table (S_TABU_DIS / S_TABU_NAM via
    " VIEW_AUTHORITY_CHECK). Raises cx_sy_authorization_error when the user
    " is not allowed to read the table. Called before every LOCAL read so
    " the row count cannot be used as an answer channel against tables the
    " user may not see. (The RFC path is covered by RFC_READ_TABLE itself.)
    methods CHECK_AUTHORITY
      importing !IV_TABLE type TABNAME .

    " Render a value as a quoted Open SQL char literal (doubling quotes).
    methods QUOTE_LITERAL
      importing !IV_VALUE     type STRING
      returning value(RV_LIT) type STRING .

ENDCLASS.



CLASS /CTDI/CL_TABLE_READER IMPLEMENTATION.


  METHOD check_authority.
    " Display-level authorization check (VIEW_ACTION 'S' = show). Raises on
    " missing authority so no rows (and no row count) are returned for a
    " table the user is not allowed to read.
    CALL FUNCTION 'VIEW_AUTHORITY_CHECK'
      EXPORTING
        view_action                    = 'S'
        view_name                      = iv_table
      EXCEPTIONS
        invalid_action                 = 1
        no_authority                   = 2
        no_clientindependent_authority = 3
        table_not_found                = 4
        no_linedependent_authority     = 5
        OTHERS                         = 6.
    IF sy-subrc <> 0.
      " table_not_found (4) is a data-definition problem, not an auth one,
      " but we still refuse the read - the dynamic SELECT would fail anyway.
      RAISE EXCEPTION TYPE cx_sy_authorization_error.
    ENDIF.
  ENDMETHOD.


  METHOD build_projection.
    DATA lr_full TYPE REF TO cl_abap_structdescr.
    lr_full ?= cl_abap_typedescr=>describe_by_name( iv_table ).

    DATA(lt_ddic) = lr_full->get_ddic_field_list( ).

    " PROJECTION: with an explicit field list, select only those columns
    " plus the key fields (key always accompanies, to identify each hit).
    DATA: lt_sel  TYPE TABLE OF string,
          lt_comp TYPE cl_abap_structdescr=>component_table.

    IF it_fields IS NOT INITIAL.
      " key fields first
      LOOP AT lt_ddic ASSIGNING FIELD-SYMBOL(<ls_k>) WHERE keyflag = abap_true.
        APPEND <ls_k>-fieldname TO lt_sel.
        APPEND VALUE #( name = <ls_k>-fieldname
                        type = CAST cl_abap_datadescr(
                                 lr_full->get_component_type( <ls_k>-fieldname ) ) )
               TO lt_comp.
      ENDLOOP.
      " then the requested fields (skip duplicates / unknown names)
      LOOP AT it_fields ASSIGNING FIELD-SYMBOL(<lv_f>).
        DATA(lv_fn) = CONV abap_compname( to_upper( <lv_f> ) ).
        IF NOT line_exists( lt_comp[ name = lv_fn ] ).
          TRY.
              APPEND VALUE #( name = lv_fn
                              type = CAST cl_abap_datadescr(
                                       lr_full->get_component_type( lv_fn ) ) )
                     TO lt_comp.
              APPEND lv_fn TO lt_sel.
            CATCH cx_root.
              " unknown field name -> ignore
          ENDTRY.
        ENDIF.
      ENDLOOP.
      er_struct = cl_abap_structdescr=>create( lt_comp ).
    ELSE.
      er_struct = lr_full.
    ENDIF.

    " Column list as ONE comma-separated clause, or '*'.
    IF lt_sel IS INITIAL.
      ev_cols = '*'.
    ELSE.
      LOOP AT lt_sel ASSIGNING FIELD-SYMBOL(<lv_col>).
        ev_cols = COND #( WHEN ev_cols IS INITIAL THEN <lv_col>
                          ELSE |{ ev_cols }, { <lv_col> }| ).
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD read.
    check_authority( iv_table ).

    DATA(lt_ddic) = CAST cl_abap_structdescr(
                      cl_abap_typedescr=>describe_by_name( iv_table ) )->get_ddic_field_list( ).

    build_projection( EXPORTING iv_table  = iv_table
                                it_fields = it_fields
                      IMPORTING ev_cols   = DATA(lv_cols)
                                er_struct = er_struct ).

    " Dynamic internal table matching the (projected) structure
    DATA(lr_tab) = cl_abap_tabledescr=>create( er_struct ).
    CREATE DATA er_data TYPE HANDLE lr_tab.
    FIELD-SYMBOLS <lt_data> TYPE STANDARD TABLE.
    ASSIGN er_data->* TO <lt_data>.

    " ORDER BY as ONE comma-separated clause (a multi-row token table
    " trips the strict parser on multi-key tables).
    "   iv_last = X -> key DESCENDING ; iv_skip > 0 -> key ASCENDING
    DATA: lv_order TYPE string,
          lv_dir   TYPE string.
    IF iv_last = abap_true.
      lv_dir = 'DESCENDING'.
    ELSEIF iv_skip > 0.
      lv_dir = 'ASCENDING'.
    ENDIF.
    IF lv_dir IS NOT INITIAL.
      LOOP AT lt_ddic ASSIGNING FIELD-SYMBOL(<ls_o>) WHERE keyflag = abap_true.
        IF lv_order IS INITIAL.
          lv_order = |{ <ls_o>-fieldname } { lv_dir }|.
        ELSE.
          lv_order = |{ lv_order }, { <ls_o>-fieldname } { lv_dir }|.
        ENDIF.
      ENDLOOP.
    ENDIF.

    DATA(lv_skip) = COND i( WHEN iv_skip > 0 THEN iv_skip ELSE 0 ).

    " For an offset block, read (skip + max) rows ordered, then drop the
    " first skip rows in ABAP (dynamic ORDER BY + OFFSET is rejected by
    " the strict SQL parser on this release).
    DATA(lv_fetch) = COND i( WHEN lv_skip > 0 THEN lv_skip + iv_max
                                              ELSE iv_max ).

    IF lv_order IS INITIAL.
      SELECT (lv_cols) FROM (iv_table)
        INTO CORRESPONDING FIELDS OF TABLE @<lt_data>
        UP TO @iv_max ROWS
        WHERE (it_where).
    ELSE.
      SELECT (lv_cols) FROM (iv_table)
        INTO CORRESPONDING FIELDS OF TABLE @<lt_data>
        UP TO @lv_fetch ROWS
        WHERE (it_where)
        ORDER BY (lv_order).
      IF lv_skip > 0.
        DELETE <lt_data> FROM 1 TO lv_skip.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD read_in_packages.
    check_authority( iv_table ).

    build_projection( EXPORTING iv_table  = iv_table
                                it_fields = it_fields
                      IMPORTING ev_cols   = DATA(lv_cols)
                                er_struct = er_struct ).

    " One reusable package table matching the (projected) structure.
    DATA(lr_tab) = cl_abap_tabledescr=>create( er_struct ).
    DATA lr_pkg TYPE REF TO data.
    CREATE DATA lr_pkg TYPE HANDLE lr_tab.
    FIELD-SYMBOLS <lt_pkg> TYPE STANDARD TABLE.
    ASSIGN lr_pkg->* TO <lt_pkg>.

    " Open-cursor package sweep in PRIMARY KEY order: memory stays bounded
    " to one package; deep offsets are NOT re-read (unlike the block read).
    DATA lv_base TYPE i.
    SELECT (lv_cols) FROM (iv_table)
      INTO CORRESPONDING FIELDS OF TABLE @<lt_pkg> PACKAGE SIZE @iv_pkg_size
      WHERE (it_where)
      ORDER BY PRIMARY KEY.

      DATA(lv_continue) = ii_sink->handle_package( ir_data     = lr_pkg
                                                   iv_base_row = lv_base ).
      lv_base = lv_base + lines( <lt_pkg> ).

      IF lv_continue = abap_false.
        " Sink asked to stop (e.g. hit ceiling reached) - close the cursor.
        EXIT.
      ENDIF.
    ENDSELECT.
  ENDMETHOD.


  METHOD read_chunk.
    check_authority( iv_table ).

    build_projection( EXPORTING iv_table  = iv_table
                                it_fields = it_fields
                      IMPORTING ev_cols   = DATA(lv_cols)
                                er_struct = er_struct ).

    DATA(lr_tab) = cl_abap_tabledescr=>create( er_struct ).
    CREATE DATA er_data TYPE HANDLE lr_tab.
    FIELD-SYMBOLS <lt_data> TYPE STANDARD TABLE.
    ASSIGN er_data->* TO <lt_data>.

    " Combine the caller's WHERE with the resume (rows strictly after
    " is_after) and the optional upper bound (rows up to and including
    " is_until - the slice end). Dynamic WHERE lines are concatenated with a
    " blank, so each extra condition carries an explicit leading AND when it
    " follows an existing condition (otherwise two "(...)" collide and the
    " strict parser rejects them).
    DATA(lt_where) = it_where.
    DATA(lv_resume) = build_resume_where( is_after ).
    IF lv_resume IS NOT INITIAL.
      APPEND COND string( WHEN lt_where IS INITIAL THEN lv_resume
                          ELSE |AND { lv_resume }| ) TO lt_where.
    ENDIF.
    DATA(lv_until) = build_until_where( is_until ).
    IF lv_until IS NOT INITIAL.
      APPEND COND string( WHEN lt_where IS INITIAL THEN lv_until
                          ELSE |AND { lv_until }| ) TO lt_where.
    ENDIF.

    " ORDER BY the non-client key fields, in order, as one clause - this is
    " the ordering the resume predicate relies on. (Not PRIMARY KEY, because
    " the client field is excluded from the resume key.)
    DATA lv_order TYPE string.
    LOOP AT it_keyflds ASSIGNING FIELD-SYMBOL(<kf>).
      lv_order = COND #( WHEN lv_order IS INITIAL THEN |{ <kf> } ASCENDING|
                         ELSE |{ lv_order }, { <kf> } ASCENDING| ).
    ENDLOOP.

    IF lv_order IS INITIAL.
      " No key fields given - fall back to primary-key order.
      SELECT (lv_cols) FROM (iv_table)
        INTO CORRESPONDING FIELDS OF TABLE @<lt_data>
        UP TO @iv_max ROWS
        WHERE (lt_where)
        ORDER BY PRIMARY KEY.
    ELSE.
      SELECT (lv_cols) FROM (iv_table)
        INTO CORRESPONDING FIELDS OF TABLE @<lt_data>
        UP TO @iv_max ROWS
        WHERE (lt_where)
        ORDER BY (lv_order).
    ENDIF.

    ev_count = lines( <lt_data> ).

    " Extract the last row's key tuple to seed the next chunk.
    CLEAR et_last_key.
    IF ev_count > 0.
      FIELD-SYMBOLS <last> TYPE any.
      READ TABLE <lt_data> ASSIGNING <last> INDEX ev_count.
      LOOP AT it_keyflds ASSIGNING FIELD-SYMBOL(<kf2>).
        ASSIGN COMPONENT <kf2> OF STRUCTURE <last> TO FIELD-SYMBOL(<kv>).
        IF sy-subrc = 0.
          APPEND VALUE #( field = <kf2> value = |{ <kv> }| ) TO et_last_key.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD get_key_fields.
    DATA(lt_ddic) = CAST cl_abap_structdescr(
                      cl_abap_typedescr=>describe_by_name( iv_table ) )->get_ddic_field_list( ).
    LOOP AT lt_ddic ASSIGNING FIELD-SYMBOL(<df>)
         WHERE keyflag = abap_true AND datatype <> 'CLNT'.
      APPEND <df>-fieldname TO rt_keyflds.
    ENDLOOP.
  ENDMETHOD.


  METHOD probe_slices.
    check_authority( iv_table ).

    DATA(lt_keyflds) = get_key_fields( iv_table ).
    IF lt_keyflds IS INITIAL.
      " no usable key - cannot slice; return empty (caller falls back)
      RETURN.
    ENDIF.

    " column list = the key fields only (keys-only probe)
    DATA lv_cols TYPE string.
    LOOP AT lt_keyflds ASSIGNING FIELD-SYMBOL(<kf>).
      lv_cols = COND #( WHEN lv_cols IS INITIAL THEN <kf>
                        ELSE |{ lv_cols }, { <kf> }| ).
    ENDLOOP.

    " dynamic key-only line type
    DATA lr_full TYPE REF TO cl_abap_structdescr.
    lr_full ?= cl_abap_typedescr=>describe_by_name( iv_table ).
    DATA lt_comp TYPE cl_abap_structdescr=>component_table.
    LOOP AT lt_keyflds ASSIGNING FIELD-SYMBOL(<kf2>).
      APPEND VALUE #( name = <kf2>
                      type = CAST cl_abap_datadescr( lr_full->get_component_type( <kf2> ) ) )
             TO lt_comp.
    ENDLOOP.
    DATA(lr_tab) = cl_abap_tabledescr=>create( cl_abap_structdescr=>create( lt_comp ) ).
    DATA lr_pkg TYPE REF TO data.
    CREATE DATA lr_pkg TYPE HANDLE lr_tab.
    FIELD-SYMBOLS <lt_pkg> TYPE STANDARD TABLE.
    ASSIGN lr_pkg->* TO <lt_pkg>.

    DATA lv_after TYPE tt_keyval.   " running "resume after" (prev end key)
    DATA lv_base  TYPE i.
    DATA lv_no    TYPE i.

    " keys-only package sweep in primary-key order, buffer bypassed
    SELECT (lv_cols) FROM (iv_table)
      INTO CORRESPONDING FIELDS OF TABLE @<lt_pkg>
      PACKAGE SIZE @iv_slice_size
      BYPASSING BUFFER
      WHERE (it_where)
      ORDER BY PRIMARY KEY.

      DATA(lv_rows) = lines( <lt_pkg> ).
      IF lv_rows = 0.
        CONTINUE.
      ENDIF.
      lv_no = lv_no + 1.

      " end key = last row's key tuple of this package
      DATA lt_end TYPE tt_keyval.
      CLEAR lt_end.
      FIELD-SYMBOLS <last> TYPE any.
      READ TABLE <lt_pkg> ASSIGNING <last> INDEX lv_rows.
      LOOP AT lt_keyflds ASSIGNING FIELD-SYMBOL(<kf3>).
        ASSIGN COMPONENT <kf3> OF STRUCTURE <last> TO FIELD-SYMBOL(<kv>).
        APPEND VALUE #( field = <kf3> value = |{ <kv> }| ) TO lt_end.
      ENDLOOP.

      APPEND VALUE ts_slice( slice_no  = lv_no
                             after_key = lv_after    " resume strictly after prev end
                             end_key   = lt_end      " inclusive upper bound
                             rows      = lv_rows
                             base_row  = lv_base ) TO rt_slices.

      lv_base  = lv_base + lv_rows.
      lv_after = lt_end.          " next slice resumes after this slice's end
    ENDSELECT.
  ENDMETHOD.


  METHOD read_remote.
    DATA: lt_options TYPE TABLE OF rfc_db_opt,
          lt_fields  TYPE TABLE OF rfc_db_fld,
          lt_data    TYPE TABLE OF tab512.   " generic RFC_READ_TABLE output

    LOOP AT it_where ASSIGNING FIELD-SYMBOL(<w>).
      APPEND VALUE #( text = <w> ) TO lt_options.
    ENDLOOP.

    " requested fields (names only; the FM fills offset/length/type).
    " RFC_READ_TABLE concatenates them into a 512-byte line - scanning
    " only the text fields keeps us inside that.
    LOOP AT it_fields ASSIGNING FIELD-SYMBOL(<f>).
      APPEND VALUE #( fieldname = <f> ) TO lt_fields.
    ENDLOOP.

    CALL FUNCTION 'RFC_READ_TABLE'
      DESTINATION iv_dest
      EXPORTING
        query_table          = iv_table
        rowskips             = iv_skip
        rowcount             = iv_max
      TABLES
        options              = lt_options
        fields               = lt_fields
        data                 = lt_data
      EXCEPTIONS
        table_not_available  = 1
        table_without_data   = 2
        option_not_valid     = 3
        field_not_valid      = 4
        not_authorized       = 5
        data_buffer_exceeded = 6
        OTHERS               = 7.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_sy_dyn_call_illegal_func.
    ENDIF.

    " Parse each line into field/value pairs using the offset/length the
    " FM reported in FIELDS, and scan them.
    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<row>).
      DATA(lv_row)  = sy-tabix.
      DATA(lv_line) = CONV string( <row>-wa ).
      DATA lt_pairs TYPE /ctdi/cl_cntrl_scanner=>tt_pair.
      CLEAR lt_pairs.
      LOOP AT lt_fields ASSIGNING FIELD-SYMBOL(<fld>).
        DATA(lv_off) = <fld>-offset.
        DATA(lv_len) = <fld>-length.
        IF lv_off + lv_len <= strlen( lv_line ).
          APPEND VALUE #( field = <fld>-fieldname
                          value = lv_line+lv_off(lv_len) ) TO lt_pairs.
        ENDIF.
      ENDLOOP.
      " key info for this row: "NAME=value" of the key fields among pairs
      DATA lv_keyinfo TYPE string.
      CLEAR lv_keyinfo.
      LOOP AT it_keys ASSIGNING FIELD-SYMBOL(<key>).
        READ TABLE lt_pairs ASSIGNING FIELD-SYMBOL(<kp>) WITH KEY field = <key>.
        IF sy-subrc = 0.
          DATA(lv_kv) = condense( <kp>-value ).
          lv_keyinfo = COND #( WHEN lv_keyinfo IS INITIAL
                               THEN |{ <key> }={ lv_kv }|
                               ELSE |{ lv_keyinfo } { <key> }={ lv_kv }| ).
        ENDIF.
      ENDLOOP.
      APPEND LINES OF /ctdi/cl_cntrl_scanner=>scan_pairs( it_pairs   = lt_pairs
                                                          iv_row     = lv_row
                                                          iv_keyinfo = lv_keyinfo )
             TO rt_hits.
    ENDLOOP.
  ENDMETHOD.


  METHOD remote_width.
    DATA(lt_ddic) = ir_struct->get_ddic_field_list( ).
    LOOP AT it_fields ASSIGNING FIELD-SYMBOL(<sf>).
      READ TABLE lt_ddic ASSIGNING FIELD-SYMBOL(<dw>) WITH KEY fieldname = <sf>.
      IF sy-subrc = 0.
        rv_width = rv_width + <dw>-leng + 1.   " +1 for the field delimiter
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD build_resume_where.
    " Empty tuple => no resume condition (read from the very start).
    IF it_after IS INITIAL.
      RETURN.
    ENDIF.

    " Build one OR-term per key component i:
    "   (k1 = v1 AND ... AND k[i-1] = v[i-1] AND k[i] > v[i])
    " The disjunction of these terms is exactly "tuple strictly greater
    " than (v1..vn)" in lexicographic order. Each term fixes the earlier
    " components to equality and makes component i strictly greater.
    DATA lt_terms TYPE STANDARD TABLE OF string.
    DATA lv_i     TYPE i.
    DATA(lv_n)    = lines( it_after ).

    lv_i = 1.
    WHILE lv_i <= lv_n.
      DATA lv_term TYPE string.
      CLEAR lv_term.
      " equality on components 1 .. i-1
      DATA lv_j TYPE i.
      lv_j = 1.
      WHILE lv_j < lv_i.
        DATA(ls_eq) = it_after[ lv_j ].
        DATA(lv_eq) = |{ ls_eq-field } = { quote_literal( ls_eq-value ) }|.
        lv_term = COND #( WHEN lv_term IS INITIAL THEN lv_eq
                          ELSE |{ lv_term } AND { lv_eq }| ).
        lv_j = lv_j + 1.
      ENDWHILE.
      " strict greater-than on component i
      DATA(ls_gt) = it_after[ lv_i ].
      DATA(lv_gt) = |{ ls_gt-field } > { quote_literal( ls_gt-value ) }|.
      lv_term = COND #( WHEN lv_term IS INITIAL THEN lv_gt
                        ELSE |{ lv_term } AND { lv_gt }| ).
      APPEND |( { lv_term } )| TO lt_terms.
      lv_i = lv_i + 1.
    ENDWHILE.

    " OR the terms together
    LOOP AT lt_terms ASSIGNING FIELD-SYMBOL(<t>).
      rv_where = COND #( WHEN rv_where IS INITIAL THEN <t>
                         ELSE |{ rv_where } OR { <t> }| ).
    ENDLOOP.
    rv_where = |( { rv_where } )|.
  ENDMETHOD.


  METHOD build_until_where.
    " Empty tuple => no upper bound.
    IF it_until IS INITIAL.
      RETURN.
    ENDIF.

    " Lexicographic "tuple <= (v1..vn)": one OR-term per component i,
    "   (k1 = v1 AND ... AND k[i-1] = v[i-1] AND k[i] < v[i])
    " for i = 1..n-1 (strictly smaller at the first differing component),
    " plus a final full-equality term (k1 = v1 AND ... AND kn = vn) to make
    " the bound INCLUSIVE.
    DATA lt_terms TYPE STANDARD TABLE OF string.
    DATA(lv_n)    = lines( it_until ).
    DATA lv_i     TYPE i.

    lv_i = 1.
    WHILE lv_i <= lv_n.
      DATA lv_term TYPE string.
      CLEAR lv_term.
      DATA lv_j TYPE i.
      lv_j = 1.
      WHILE lv_j < lv_i.
        DATA(ls_eq) = it_until[ lv_j ].
        DATA(lv_eq) = |{ ls_eq-field } = { quote_literal( ls_eq-value ) }|.
        lv_term = COND #( WHEN lv_term IS INITIAL THEN lv_eq
                          ELSE |{ lv_term } AND { lv_eq }| ).
        lv_j = lv_j + 1.
      ENDWHILE.
      DATA(ls_c) = it_until[ lv_i ].
      " strictly-less on component i (strict for all but ... see below)
      DATA(lv_c) = |{ ls_c-field } < { quote_literal( ls_c-value ) }|.
      lv_term = COND #( WHEN lv_term IS INITIAL THEN lv_c
                        ELSE |{ lv_term } AND { lv_c }| ).
      APPEND |( { lv_term } )| TO lt_terms.
      lv_i = lv_i + 1.
    ENDWHILE.

    " Final inclusive term: full equality on all components (= the end key).
    CLEAR lv_term.
    LOOP AT it_until ASSIGNING FIELD-SYMBOL(<e>).
      DATA(lv_e) = |{ <e>-field } = { quote_literal( <e>-value ) }|.
      lv_term = COND #( WHEN lv_term IS INITIAL THEN lv_e
                        ELSE |{ lv_term } AND { lv_e }| ).
    ENDLOOP.
    APPEND |( { lv_term } )| TO lt_terms.

    LOOP AT lt_terms ASSIGNING FIELD-SYMBOL(<t>).
      rv_where = COND #( WHEN rv_where IS INITIAL THEN <t>
                         ELSE |{ rv_where } OR { <t> }| ).
    ENDLOOP.
    rv_where = |( { rv_where } )|.
  ENDMETHOD.


  METHOD quote_literal.
    " Render a value as a single-quoted Open SQL character literal, doubling
    " any embedded single quotes. Used for the dynamic resume WHERE.
    DATA(lv_v) = iv_value.
    REPLACE ALL OCCURRENCES OF |'| IN lv_v WITH |''|.
    rv_lit = |'{ lv_v }'|.
  ENDMETHOD.


  METHOD scan_fields.
    " Check-table lookup (field -> has check table?) from DDIC metadata,
    " built only when the skip option is on.
    DATA lt_check TYPE HASHED TABLE OF fieldname WITH UNIQUE KEY table_line.
    IF iv_skip_check = abap_true.
      DATA(lr_tabdescr) = CAST cl_abap_structdescr(
                            cl_abap_typedescr=>describe_by_name( iv_table ) ).
      LOOP AT lr_tabdescr->get_ddic_field_list( )
           ASSIGNING FIELD-SYMBOL(<ls_dd>) WHERE checktable IS NOT INITIAL.
        INSERT <ls_dd>-fieldname INTO TABLE lt_check.
      ENDLOOP.
    ENDIF.

    " Flat walk of the (already projected) structure's components.
    DATA(lt_comp) = ir_struct->get_components( ).
    LOOP AT lt_comp ASSIGNING FIELD-SYMBOL(<ls_comp>).
      " start-column cutoff (1-based position)
      IF sy-tabix < iv_start_col.
        CONTINUE.
      ENDIF.
      " skip fields that have a check table / foreign key (code fields)
      IF iv_skip_check = abap_true AND line_exists( lt_check[ table_line = <ls_comp>-name ] ).
        CONTINUE.
      ENDIF.
      " only elementary character-like fields (CHAR / STRING)
      IF <ls_comp>-type->kind <> cl_abap_typedescr=>kind_elem.
        CONTINUE.
      ENDIF.
      DATA(lr_elem) = CAST cl_abap_elemdescr( <ls_comp>-type ).
      IF lr_elem->type_kind = cl_abap_typedescr=>typekind_char
        OR lr_elem->type_kind = cl_abap_typedescr=>typekind_string.
        APPEND <ls_comp>-name TO rt_fields.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
