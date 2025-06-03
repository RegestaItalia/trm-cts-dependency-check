CLASS /atrm/cl_im_cts_dep_check DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_ex_cts_request_check .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /ATRM/CL_IM_CTS_DEP_CHECK IMPLEMENTATION.


  METHOD if_ex_cts_request_check~check_before_add_objects.
  ENDMETHOD.


  METHOD if_ex_cts_request_check~check_before_changing_owner.
  ENDMETHOD.


  METHOD if_ex_cts_request_check~check_before_creation.
  ENDMETHOD.


  METHOD if_ex_cts_request_check~check_before_release.
    CHECK request IS NOT INITIAL.
    DATA: lt_packages           TYPE zcl_trm_core=>tyt_trm_package,
          ls_package            LIKE LINE OF lt_packages,
          ls_dependency         TYPE zif_trm_core=>ty_dependency,
          ls_dependency_package LIKE LINE OF lt_packages,
          lt_check_trkorr       TYPE STANDARD TABLE OF trkorr,
          lt_modifiable_trkorr  TYPE STANDARD TABLE OF trkorr,
          lv_modifiable_trkorr  TYPE trkorr.
    lt_packages = zcl_trm_singleton=>get( )->get_installed_packages( ).
    READ TABLE lt_packages INTO ls_package WITH KEY trkorr = request.
    CHECK sy-subrc EQ 0.
    CHECK ls_package-manifest-dependencies[] IS NOT INITIAL.
    LOOP AT ls_package-manifest-dependencies INTO ls_dependency.
      CLEAR ls_dependency_package.
      READ TABLE lt_packages INTO ls_dependency_package WITH KEY name = ls_dependency-name registry = ls_dependency-registry.
      CHECK ls_dependency_package-trkorr IS NOT INITIAL.
      APPEND ls_dependency_package-trkorr TO lt_check_trkorr.
    ENDLOOP.
    CHECK lt_check_trkorr[] IS NOT INITIAL.
    SELECT trkorr FROM e070
      INTO TABLE lt_modifiable_trkorr
      FOR ALL ENTRIES IN lt_check_trkorr
      WHERE trkorr EQ lt_check_trkorr-table_line AND ( trstatus EQ 'D' OR trstatus EQ 'L' ).
    LOOP AT lt_modifiable_trkorr INTO lv_modifiable_trkorr.
      CLEAR ls_dependency_package.
      READ TABLE lt_packages INTO ls_dependency_package WITH KEY trkorr = lv_modifiable_trkorr.
      CHECK sy-subrc EQ 0.
      MESSAGE ID '/ATRM/CTS_DEP_CHECK' TYPE 'E' NUMBER '001' WITH lv_modifiable_trkorr ls_dependency_package-name RAISING cancel.
    ENDLOOP.
  ENDMETHOD.


  METHOD if_ex_cts_request_check~check_before_release_slin.
  ENDMETHOD.
ENDCLASS.
