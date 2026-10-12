CLASS /ctdi/cl_scan_checkpoint DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ts_checkpoint,
        run_id       TYPE sysuuid_c22,
        tabname      TYPE tabname,
        last_end_key TYPE /ctdi/cl_key_partitioner=>tt_keyval,
        rows_scanned TYPE i,
        hits_count   TYPE i,
        status       TYPE c LENGTH 1, " 'R'=Running, 'C'=Completed, 'E'=Error
        tstamp       TYPE timestamp,
      END OF ts_checkpoint .

    "! Create a new tracked scan run
    CLASS-METHODS create_run
      IMPORTING
        !iv_table        TYPE tabname
      RETURNING
        VALUE(rv_run_id) TYPE sysuuid_c22 .

    "! Save or update checkpoint state
    CLASS-METHODS save_checkpoint
      IMPORTING
        !is_checkpoint TYPE ts_checkpoint .

    "! Retrieve checkpoint state by run ID
    CLASS-METHODS get_checkpoint
      IMPORTING
        !iv_run_id           TYPE sysuuid_c22
      RETURNING
        VALUE(rs_checkpoint) TYPE ts_checkpoint .

    "! Retrieve the latest run checkpoint for a given table
    CLASS-METHODS get_latest_for_table
      IMPORTING
        !iv_table            TYPE tabname
      RETURNING
        VALUE(rs_checkpoint) TYPE ts_checkpoint .

    "! Clear/delete checkpoint when a scan completes normally
    CLASS-METHODS clear_checkpoint
      IMPORTING
        !iv_run_id TYPE sysuuid_c22 .

  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS c_relid TYPE indx-relid VALUE 'SC' .
ENDCLASS.



CLASS /ctdi/cl_scan_checkpoint IMPLEMENTATION.

  METHOD create_run.
    TRY.
        " 22-char UUID: fits the INDX SRTFD key (CHAR 22) exactly and is used
        " verbatim as the checkpoint key - no prefix, no truncation.
        rv_run_id = cl_system_uuid=>create_uuid_c22_static( ).
      CATCH cx_root.
        " Fallback id if UUID generation is unavailable: a 22-char value
        " derived from a timestamp (left-justified, truncated to fit).
        DATA lv_ts TYPE timestamp.
        GET TIME STAMP FIELD lv_ts.
        rv_run_id = |T{ lv_ts }|.
    ENDTRY.

    DATA(ls_ckpt) = VALUE ts_checkpoint(
      run_id  = rv_run_id
      tabname = iv_table
      status  = 'R' ).
    GET TIME STAMP FIELD ls_ckpt-tstamp.

    save_checkpoint( ls_ckpt ).

    " Index as the latest run for this table. SRTFD is CHAR 22 and a table
    " name is CHAR 30, so the pointer is keyed on a 22-char hash of the name:
    " '#' + first 21 hex chars of its SHA1. The '#' prefix keeps it disjoint
    " from the UUID run keys (a C22 UUID never starts with '#').
    DATA lv_lat_id TYPE c LENGTH 22.
    DATA lv_lhash  TYPE string.
    CALL FUNCTION 'CALCULATE_HASH_FOR_CHAR'
      EXPORTING
        alg        = 'SHA1'
        data       = CONV string( iv_table )
      IMPORTING
        hashstring = lv_lhash
      EXCEPTIONS
        OTHERS     = 1.
    lv_lat_id = COND #( WHEN sy-subrc = 0 THEN |#{ lv_lhash(21) }| ELSE |#{ iv_table }| ).
    EXPORT id = rv_run_id TO DATABASE indx(sc) ID lv_lat_id.
  ENDMETHOD.


  METHOD save_checkpoint.
    " The run_id (SYSUUID_C22) is itself the key - it fits SRTFD (CHAR 22).
    DATA lv_id TYPE c LENGTH 22.
    lv_id = is_checkpoint-run_id.
    EXPORT ckpt = is_checkpoint TO DATABASE indx(sc) ID lv_id.
  ENDMETHOD.


  METHOD get_checkpoint.
    DATA lv_id TYPE c LENGTH 22.
    lv_id = iv_run_id.
    IMPORT ckpt = rs_checkpoint FROM DATABASE indx(sc) ID lv_id.
  ENDMETHOD.


  METHOD get_latest_for_table.
    " Same 22-char hashed per-table pointer key as create_run writes.
    DATA lv_lat_id TYPE c LENGTH 22.
    DATA lv_lhash  TYPE string.
    CALL FUNCTION 'CALCULATE_HASH_FOR_CHAR'
      EXPORTING
        alg        = 'SHA1'
        data       = CONV string( iv_table )
      IMPORTING
        hashstring = lv_lhash
      EXCEPTIONS
        OTHERS     = 1.
    lv_lat_id = COND #( WHEN sy-subrc = 0 THEN |#{ lv_lhash(21) }| ELSE |#{ iv_table }| ).
    DATA lv_run_id TYPE sysuuid_c22.
    IMPORT id = lv_run_id FROM DATABASE indx(sc) ID lv_lat_id.
    IF lv_run_id IS NOT INITIAL.
      rs_checkpoint = get_checkpoint( lv_run_id ).
    ENDIF.
  ENDMETHOD.


  METHOD clear_checkpoint.
    DATA lv_id TYPE c LENGTH 22.
    lv_id = iv_run_id.
    DELETE FROM DATABASE indx(sc) ID lv_id.
  ENDMETHOD.


ENDCLASS.
