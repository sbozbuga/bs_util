CLASS zcl_dummy DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS hello_world
      RETURNING
        VALUE(rv_result) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_dummy IMPLEMENTATION.
  METHOD hello_world.
    rv_result = 'Hello World'.
  ENDMETHOD.
ENDCLASS.
