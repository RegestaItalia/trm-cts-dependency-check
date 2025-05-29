CLASS /atrm/cl_cts_dep_check_ctx DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor.
    CLASS-METHODS get_instance
      RETURNING VALUE(ro_instance) TYPE REF TO /atrm/cl_cts_dep_check_ctx.

    DATA: trm_packages TYPE zcl_trm_core=>tyt_trm_package READ-ONLY.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA: go_instance TYPE REF TO /atrm/cl_cts_dep_check_ctx.

ENDCLASS.



CLASS /atrm/cl_cts_dep_check_ctx IMPLEMENTATION.

  METHOD constructor.
    me->trm_packages = zcl_trm_core=>get_installed_packages( ).
  ENDMETHOD.

  METHOD get_instance.
    IF go_instance IS NOT BOUND.
      CREATE OBJECT go_instance.
    ENDIF.
    ro_instance = go_instance.
  ENDMETHOD.

ENDCLASS.
