CLASS ltcl_metadata DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS .

  PRIVATE SECTION.
    CONSTANTS c_tab TYPE tabname VALUE 'VTRKH' .

    METHODS:
      key_fields_exclude_mandt FOR TESTING,
      projection_always_has_keys FOR TESTING .
ENDCLASS.



CLASS ltcl_metadata IMPLEMENTATION.

  METHOD key_fields_exclude_mandt.
    DATA(lt_keys) = /ctdi/cl_table_metadata=>get_key_fields( c_tab ).
    cl_abap_unit_assert=>assert_not_initial(
      act = lt_keys msg = 'Table must have primary key fields' ).
    cl_abap_unit_assert=>assert_false(
      act = xsdbool( line_exists( lt_keys[ table_line = 'MANDT' ] ) )
      msg = 'MANDT must be excluded from key fields' ).
  ENDMETHOD.


  METHOD projection_always_has_keys.
    DATA: lr_struct TYPE REF TO cl_abap_structdescr,
          lv_cols   TYPE string.
    /ctdi/cl_table_metadata=>build_projection(
      EXPORTING iv_table  = c_tab
                it_fields = VALUE #( ( 'TRKDLVTO' ) )
      IMPORTING ev_cols   = lv_cols
                er_struct = lr_struct ).

    cl_abap_unit_assert=>assert_true(
      act = xsdbool( lv_cols CS 'VBELN' )
      msg = 'Projection column clause must include key VBELN' ).
    cl_abap_unit_assert=>assert_true(
      act = xsdbool( lv_cols CS 'TRKDLVTO' )
      msg = 'Projection column clause must include requested text field' ).
  ENDMETHOD.

ENDCLASS.
