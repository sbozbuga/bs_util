FUNCTION /ctdi/va02_goodpartreturn01.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(IMP_VBELN) TYPE  VBELN_VA
*"  EXPORTING
*"     VALUE(EXP_VBELN_VL) TYPE  VBELN_VL
*"----------------------------------------------------------------------



* init values


  CLEAR: gs_sdheader, gs_sdheaderx, gs_sditem, gs_sditemx, gt_sditem, gt_sditemx,
         gs_schedule, gs_schedulex, gt_schedule, gt_schedulex, gt_return,
         gs_return.

  " IW53 310022817
  " VA03 500021292


  "Auftragskopfdaten
  gs_sdheaderx-updateflag = 'U'.  "laut Beschreibung immer erforderlich

  gs_sditem-itm_number     = '001100'.
  gs_sditem-material       = '000000002900012314'.
  "gs_sditem-ship_point     = <gs_data>-vstel.       "Versandstelle aus Lieferung übernehmen
  "gs_sditem-route          = <gs_data>-route_likp.  "Route aus Lieferung übernehmen
  gs_sditem-plant          = '1110'.
  gs_sditem-hg_lv_item     = '001000'.
  "gs_sditem-purch_no_c     = <gs_data>-bstkd.
  "gs_sditem-purch_no_s     = <gs_data>-bstkd_e.
  gs_sditem-target_qty     = '1'.
  gs_sditem-item_categ     = 'ZREG'.
  gs_sditem-store_loc      = 'SWAP'.
  gs_sditem-batch          = 'REP'.
  APPEND gs_sditem TO gt_sditem.

  gs_sditemx-updateflag    = 'I'.          "Einfügen
  gs_sditemx-itm_number    = '001100'.

  gs_sditemx-material      = 'X'.
  "gs_sditemx-ship_point    = abap_true.
  "gs_sditemx-route         = abap_true.
  gs_sditemx-plant         = '1110'.
  gs_sditemx-store_loc      = 'SWAP'.
  "gs_sditemx-purch_no_c    = abap_true.
  "gs_sditemx-purch_no_s    = abap_true.
  gs_sditemx-target_qty     = 'X'.
  gs_sditemx-hg_lv_item     = '001000'.
  gs_sditemx-item_categ     = 'X'.
  gs_sditemx-batch          = 'X'.
  APPEND gs_sditemx TO gt_sditemx.

  gs_schedule-itm_number   = '001100'.
  gs_schedule-sched_line   = '0001'.     "
  gs_schedule-req_qty      = '1'.
  APPEND gs_schedule TO gt_schedule.
*
  gs_schedulex-updateflag  = 'I'.           "Einfügen
  gs_schedulex-itm_number  = '001100'.
  gs_schedulex-sched_line  = '0001'.
  gs_schedulex-req_qty     = 'X'.
  APPEND gs_schedulex TO gt_schedulex.


  CALL FUNCTION 'BAPI_SALESORDER_CHANGE' "#EC CI_USAGE_OK[2438131]  "INS S4CONV ECC - HPC(2508-614)
    EXPORTING
      salesdocument    = '0500021292'
      order_header_in  = gs_sdheader
      order_header_inx = gs_sdheaderx
      simulation       = ' '
    TABLES
      return           = gt_return
      order_item_in    = gt_sditem
      order_item_inx   = gt_sditemx
      schedule_lines   = gt_schedule
      schedule_linesx  = gt_schedulex.


  BREAK x12397.
  "IF gt_return IS INITIAL.
  COMMIT WORK.
  "ENDIF.

  WAIT UP TO 1 SECONDS.
  "break x12397.

  DATA: vbeln_vl TYPE vbeln_vl.
  DATA: it_equkey TYPE TABLE OF equi_key WITH HEADER LINE.
  DATA: l_ser_ws_delivery_update TYPE string.
  DATA: vl01n   TYPE /cellag/vl01n_retanl.

  it_equkey-equnr = '000000000000020774'.
  APPEND it_equkey.

  vl01n-vbeln   = '0500021292'.
  vl01n-lfart   = 'ZLRG'.
  vl01n-vstel   = '1MAL'.
  vl01n-posnr   = '001100'.
  vl01n-bldat   = sy-datum.
  vl01n-lfimg   = '1'.

  BREAK x12397.

  CALL FUNCTION '/CELLAG/VL01N_RETANL_CREATE'
    EXPORTING
      ctu       = 'X'
      mode      = 'E'
      update    = 'L'
*     GROUP     =
*     USER      =
*     KEEP      =
*     HOLDDATE  =
      nodata    = '/'
      is_vl01n  = vl01n
    IMPORTING
*     SUBRC     =
      e_vbeln   = vbeln_vl
    TABLES
*     MESSTAB   =
      it_equkey = it_equkey.

  exp_vbeln_vl = vbeln_vl.

  BREAK x12397.







ENDFUNCTION.
