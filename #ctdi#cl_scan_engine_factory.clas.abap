CLASS /ctdi/cl_scan_engine_factory DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.
    "! Resolve and instantiate the appropriate scanner engine strategy.
    "! Today (ECC 7.50 AnyDB): Returns Universal Parallel Engine.
    "! Future (SAP HANA): Resolves HANA Pushdown engine when sy-dbsys = 'HDB'.
    CLASS-METHODS get_engine
      IMPORTING
        !iv_force_universal TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(ro_engine)    TYPE REF TO /ctdi/if_scan_engine .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /ctdi/cl_scan_engine_factory IMPLEMENTATION.

  METHOD get_engine.
    " 1. Explicit override (e.g. unit testing or troubleshooting)
    IF iv_force_universal = abap_true.
      ro_engine = NEW /ctdi/cl_scan_engine_univ( ).
      RETURN.
    ENDIF.

    " 2. Dynamic resolution for SAP HANA (active when migrating next year)
    IF sy-dbsys = 'HDB'.
      TRY.
          DATA lv_hana_cls TYPE seoclsname VALUE '/CTDI/CL_SCAN_ENGINE_HANA'.
          DATA lr_obj TYPE REF TO object.
          CREATE OBJECT lr_obj TYPE (lv_hana_cls).
          ro_engine ?= lr_obj.
          RETURN.
        CATCH cx_root.
          " Safe fallback to universal engine if HANA engine is not yet deployed
      ENDTRY.
    ENDIF.

    " 3. Standard Universal Engine for AnyDB (Oracle, DB2, MSSQL, ASE)
    ro_engine = NEW /ctdi/cl_scan_engine_univ( ).
  ENDMETHOD.

ENDCLASS.
