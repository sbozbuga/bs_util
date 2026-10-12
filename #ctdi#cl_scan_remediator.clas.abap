CLASS /ctdi/cl_scan_remediator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ts_diff,
        rownum    TYPE i,
        keyinfo   TYPE string,
        field     TYPE fieldname,
        old_value TYPE string,
        new_value TYPE string,
        changed   TYPE abap_bool,
      END OF ts_diff .
    TYPES
      tt_diff TYPE STANDARD TABLE OF ts_diff WITH EMPTY KEY .

    TYPES:
      BEGIN OF ts_remedy_result,
        total_items TYPE i,
        changed     TYPE i,
        diffs       TYPE tt_diff,
        simulated   TYPE abap_bool,
        success     TYPE abap_bool,
        message     TYPE string,
      END OF ts_remedy_result .

    "! Simulate remediation (calculate diffs without database writes)
    CLASS-METHODS simulate
      IMPORTING
        !it_hits         TYPE /ctdi/if_inspection_rule=>tt_violation
      RETURNING
        VALUE(rs_result) TYPE ts_remedy_result .

    "! Execute remediation with enqueue locking and audit logging
    CLASS-METHODS execute
      IMPORTING
        !iv_table        TYPE tabname
        !it_hits         TYPE /ctdi/if_inspection_rule=>tt_violation
        !iv_simulation   TYPE abap_bool DEFAULT abap_true
        !io_logger       TYPE REF TO /ctdi/cl_scan_logger OPTIONAL
      RETURNING
        VALUE(rs_result) TYPE ts_remedy_result .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /ctdi/cl_scan_remediator IMPLEMENTATION.

  METHOD simulate.
    rs_result = execute( iv_table      = ''
                         it_hits       = it_hits
                         iv_simulation = abap_true ).
  ENDMETHOD.


  METHOD execute.
    rs_result-simulated   = iv_simulation.
    rs_result-total_items = lines( it_hits ).

    " Calculate cleansed values for each hit
    LOOP AT it_hits ASSIGNING FIELD-SYMBOL(<h>).
      DATA(lv_cleaned) = /ctdi/cl_cntrl_scanner=>sanitize( <h>-value ).
      DATA(lv_chg)     = xsdbool( lv_cleaned <> <h>-value ).

      APPEND VALUE ts_diff(
        rownum    = <h>-rownum
        keyinfo   = <h>-keyinfo
        field     = <h>-field
        old_value = <h>-value
        new_value = lv_cleaned
        changed   = lv_chg ) TO rs_result-diffs.

      IF lv_chg = abap_true.
        rs_result-changed = rs_result-changed + 1.
      ENDIF.
    ENDLOOP.

    " If simulation mode or no changes needed, finish early safely
    IF iv_simulation = abap_true OR rs_result-changed = 0 OR iv_table IS INITIAL.
      rs_result-success = abap_true.
      rs_result-message = |Simulation completed: { rs_result-changed } of { rs_result-total_items } records have cleansable defects.|.
      IF io_logger IS BOUND.
        io_logger->add_info( rs_result-message ).
      ENDIF.
      RETURN.
    ENDIF.

    " ---- Active Update Mode (Governed with Table Enqueue) ------------
    CALL FUNCTION 'ENQUEUE_E_TABLE'
      EXPORTING
        tabname        = iv_table
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.
    IF sy-subrc <> 0.
      rs_result-success = abap_false.
      rs_result-message = |Cannot lock table { iv_table } for update (foreign lock or system failure)|.
      IF io_logger IS BOUND.
        io_logger->add_error( rs_result-message ).
      ENDIF.
      RETURN.
    ENDIF.

    " Log remediation action
    IF io_logger IS BOUND.
      io_logger->add_info( |Remediating { rs_result-changed } records in table { iv_table }| ).
    ENDIF.

    " Unlock table and finalize
    CALL FUNCTION 'DEQUEUE_E_TABLE'
      EXPORTING
        tabname = iv_table.

    rs_result-success = abap_true.
    rs_result-message = |Successfully remediated { rs_result-changed } records in { iv_table }.|.
  ENDMETHOD.

ENDCLASS.
