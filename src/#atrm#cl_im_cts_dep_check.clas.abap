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
    " Initial release: later release of trm-server will expose more apis making this method more readable
    TYPES: BEGIN OF ty_dependency,
             name     TYPE string,
             registry TYPE string,
           END OF ty_dependency,
           tyt_dependency TYPE STANDARD TABLE OF ty_dependency WITH DEFAULT KEY,
           BEGIN OF ty_manifest,
             dependencies TYPE tyt_dependency,
           END OF ty_manifest.
    CHECK request IS NOT INITIAL.
    DATA: lt_packages           TYPE zcl_trm_core=>tyt_trm_package,
          ls_package            LIKE LINE OF lt_packages,
          ls_manifest           TYPE ty_manifest,
          ls_dependency         TYPE ty_dependency,
          ls_dependency_package LIKE LINE OF lt_packages,
          lt_check_trkorr       TYPE STANDARD TABLE OF trkorr,
          lt_modifiable_trkorr  TYPE STANDARD TABLE OF trkorr,
          lv_modifiable_trkorr  TYPE trkorr.
    lt_packages = /atrm/cl_cts_dep_check_ctx=>get_instance( )->trm_packages.
    READ TABLE lt_packages INTO ls_package WITH KEY trkorr = request.
    CHECK sy-subrc EQ 0.
    CALL TRANSFORMATION id
    SOURCE XML ls_package-xmanifest
    RESULT trm_manifest = ls_manifest.
    CHECK ls_manifest-dependencies[] IS NOT INITIAL.
    LOOP AT ls_manifest-dependencies INTO ls_dependency.
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
