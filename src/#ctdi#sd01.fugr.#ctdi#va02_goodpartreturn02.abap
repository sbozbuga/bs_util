FUNCTION /ctdi/va02_goodpartreturn02.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(IMP_SERNR) TYPE  EQUNR
*"     VALUE(IMP_YYMDS) TYPE  YYMDS OPTIONAL
*"     VALUE(IMP_MDSMAT) TYPE  YYMDS OPTIONAL
*"     VALUE(IMP_NOBATCH) TYPE  FLAG OPTIONAL
*"     VALUE(IMP_LFART) TYPE  LFART DEFAULT 'ZLRG'
*"     VALUE(IMP_LDEST) LIKE  LTAP-LDEST DEFAULT SPACE
*"     VALUE(IMP_LGNUM) LIKE  LTAK-LGNUM DEFAULT '200'
*"     VALUE(IMP_VSTEL) TYPE  VSTEL DEFAULT '1MAL'
*"  EXPORTING
*"     VALUE(EXP_VBELN_VL) TYPE  VBELN_VL
*"     VALUE(EXP_OK_CODE) TYPE  SY-SUBRC
*"  TABLES
*"      RETURN STRUCTURE  BAPIRET2 OPTIONAL
*"----------------------------------------------------------------------
*
*----------------------------------------------------------------------*
* Firma               CTDI GmbH Malsch Headquarter                     *
*                                                                      *
* Beschreibung:  Trägerdynpro/Programm für neuen GoodPartReturn-FuBa   *
*                '/CTDI/VA02_GOODPARTRETURN02'                         *
*                                                                      *
*                                                                      *
*                                                                      *
*----------------------------------------------------------------------*
* Anforderer:  Hr. Assenheimer Stefan                                  *
* Ticket....:  Projetk -> GoodPartReturn neue Abwicklung               *
* Konzept...:  HW3 IT GmbH, Bietigheim. Holger Herz                    *
*              Siehe Dokumentation - Good_Part_neu_April_2016_V1_.docx *
* Betreuung.:  IT                                                      *
*----------------------------------------------------------------------*
* Entwickler...: User-ID    Vor- Nachname Firma/Abteilung              *
*                X12397     Holger Herz - HHE     -> Konzept erstellt  *
*                           Umsetzung erfolgte von HPC, Hr. Prus       *
*                           wurde v. J.Prus nicht fertiggestellt !!!   *
*----------------------------------------------------------------------*

************************************************************************
******************** !!!ACHTUNG BITTE BEACHTEN!!! **********************
************************************************************************
* !!!      Keine Korrekturen oder Erweiterungen ohne Absprache     !!! *
* !!!      mit der Anwendungsentwicklung                           !!! *
*----------------------------------------------------------------------*
* !!! Keine Korrekturen/Erweiterung ohne Dokumentation in Historie !!! *
************************************************************************
* Änderungshistorie                                                    *
*                                                                      *
* Datum      Entwickler  Bemerkung                                     *
*======================================================================*
* 13.10.2018 X12397(HHE) EXP_OK_CODE umstellen für WEB                 *
*                        Protokoll für "gute Buchungen" erweitern      *
*----------------------------------------------------------------------*
* 03.09.2018 X12397(HHE) Umstellen auf neuen MTS-Ablauf + Sperre der   *
*                        Belege einbauen (Auftrag + TB)                *
*----------------------------------------------------------------------*
* 19.08.2016 X12397(HHE) YYMDS muss durchgeschleust werden bis in TA   *
*                        für MDS-Projekt Stefan Assenheimer            *
*----------------------------------------------------------------------*

* init values


  CLEAR: gs_sdheader, gs_sdheaderx, gs_sditem, gs_sditemx, gt_sditem, gt_sditemx,
         gs_schedule, gs_schedulex, gt_schedule, gt_schedulex, gt_return,

         gs_return.

  TABLES: ltap, ltbp.
  TYPE-POOLS: vlggt.

  TYPES: BEGIN OF str_mblnr_q,
           kappl   TYPE sna_kappl,
           objky   TYPE na_objkey,
           kschl   TYPE sna_kschl,
           spras   TYPE na_spras,
           mblnr_q TYPE mblnr,
           mjahr_q TYPE mjahr,
         END OF str_mblnr_q.

  DATA: lt_lvbak         TYPE TABLE OF vbak,
        lt_lvbap         TYPE TABLE OF vbapvb,
        lt_lvbep         TYPE TABLE OF vbepvb,
        lt_lvbfa         TYPE TABLE OF  vbfavb,
        lt_lvbfs         TYPE TABLE OF vbfs,
        lt_lvbkd         TYPE TABLE OF vbkdvb,
        lt_lvbls         TYPE TABLE OF vbls,
        ls_lvbls         TYPE vbls,
        lt_lvbpa         TYPE TABLE OF vbpavb,
        lt_lvbuk         TYPE TABLE OF vbuk,
        lt_lvbup         TYPE TABLE OF vbupvb,
        ls_vbsk          TYPE vbsk,
        lt_sernr         TYPE shp_sernr_t,
        ls_sernr         TYPE shp_sernr,
        lt_sernr_u       TYPE shp_sernr_update_t,
        ls_sernr_u       TYPE LINE OF shp_sernr_update_t,
        lv_numki         TYPE nrnr,
        lt_prot          TYPE TABLE OF prott,
        ls_prot          TYPE prott,
        ls_vbkok         TYPE vbkok,
        lt_vorgabe_daten TYPE TABLE OF vlggt_vorgabe_daten_s,
        ls_vorgabe_daten LIKE LINE OF lt_vorgabe_daten.
  DATA: lv_sernr TYPE equnr.
  DATA: lt_systat TYPE TABLE OF bapi_itob_status.
  DATA: lt_usstat TYPE TABLE OF bapi_itob_status.
  DATA: ls_systat TYPE bapi_itob_status.
  DATA: lt_objk TYPE TABLE OF objk.
  DATA: ls_objk TYPE objk.
  DATA: lt_ser01 TYPE TABLE OF ser01.
  DATA: ls_ser01 TYPE ser01.
  DATA: ls_vbap TYPE vbap.
  DATA: ls_vbap_psp TYPE vbap.
  DATA: ls_vbap_haupt TYPE vbap.
  DATA: lt_vbap TYPE TABLE OF vbap.
  DATA: lt_vbap_haupt TYPE TABLE OF vbap.
  DATA: lv_hauptpos TYPE posnr.
  DATA: lv_zret_pos TYPE posnr.
  DATA: lv_neue_pos TYPE posnr.
  DATA: lv_matnr TYPE matnr.
  DATA: lv_menge TYPE dzmeng.
  DATA: lv_posnr TYPE posnr_vl.
  DATA: vbeln_vl TYPE vbeln_vl.
  DATA: it_equkey TYPE TABLE OF equi_key WITH HEADER LINE.
  DATA: l_ser_ws_delivery_update TYPE string.
  DATA: vl01n   TYPE /cellag/vl01n_retanl.
  DATA: lt_vbfa TYPE TABLE OF vbfa.
  DATA: ls_vbfa TYPE  vbfa.
  DATA: lv_error TYPE c.
  DATA: lv_sdaufnr TYPE kdauf.
  DATA: lv_tanum     TYPE tanum,
        ls_ltak      TYPE ltak,
        ls_lips      TYPE lips,
        ls_likp      TYPE likp,
        lt_ltap      TYPE TABLE OF ltap,
        ls_ltap      TYPE ltap,
        ls_eqbs      TYPE eqbs,
        ls_mseg_955  TYPE mseg,
        ls_lqua      TYPE lqua,
        lv_lgnum     TYPE lgnum,
        lv_lvs_sonum TYPE lvs_sonum.
  DATA: ls_key_data TYPE rserob,
        lt_sernos   TYPE TABLE OF rserob,
        lt_sernos_u TYPE TABLE OF e1rmsno,
        ls_sernos_u TYPE e1rmsno,
        ls_sernos   TYPE rserob.

*** HHE
  DATA: ls_leshp_delivery_extend_rv TYPE leshp_delivery_extend_rv,
        ls_control                  TYPE leshp_delivery_proc_control_in,
        ls_tsp03d                   TYPE tsp03d,
        ls_ltbk                     TYPE ltbk,
        lt_ltbp                     TYPE TABLE OF ltbp,
        ls_ltbp                     TYPE ltbp,
        ls_t320                     TYPE t320,
        lt_ltba                     TYPE TABLE OF ltba,
        ls_ltba                     TYPE ltba,
        ls_mkpf                     TYPE mkpf,
        ls_mseg                     TYPE mseg,
        lt_seltab                   TYPE TABLE OF rsparams  WITH HEADER LINE,           "HHE 08.10.2016
        ls_seltab                   LIKE LINE OF lt_seltab,
        lt_listobject               TYPE TABLE OF abaplist WITH HEADER LINE,
        lt_mblnr_q                  TYPE TABLE OF str_mblnr_q,                          "HHE 08.10.2016
        ls_mblnr_q                  LIKE LINE OF lt_mblnr_q,
        ls_tvst                     TYPE tvst.

  DATA:   gv_locked                       TYPE char1.          "HHE 03.09.2018

  ASSERT ID /ctdi/va02_goodpartreturn02  CONDITION sy-uname = 'NHSENTW01'.

  CLEAR: gs_log, gv_log_guid.
  gs_log-object      = 'YYGOODPARTNEU1'.
  gs_log-subobject   = 'YYWEB01'.           "WEB
  gs_log-aluser      = sy-uname.
  gs_log-alprog      = sy-cprog.
  gs_log-altcode     = sy-tcode.
  gs_log-aldate      = sy-datum.
  gs_log-altime      = sy-uzeit.

* get LOG handle
  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log                 = gs_log
    IMPORTING
      e_log_handle            = gv_log_guid
    EXCEPTIONS
      log_header_inconsistent = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
    CLEAR: return.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO return-message.
    CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
      EXPORTING
        syst     = syst
      CHANGING
        bapiret2 = return.
    APPEND return.
    CLEAR return.
    exp_ok_code = 4.
* Error SLG1 Log !!!
    MESSAGE e028(/ctdi/sd01) INTO return-message.

    CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
      EXPORTING
        syst     = syst
      CHANGING
        bapiret2 = return.
    APPEND return.
    EXIT.
  ENDIF.

  CONSTANTS: lc_abgru(2)  VALUE  'ZG'.


* HHE: convert SERNR
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = imp_sernr
    IMPORTING
      output = imp_sernr.

* SERNR in SLG1 schreiben: IMP_SERNR = &
  MESSAGE w078(/ctdi/sd01) WITH imp_sernr INTO return-message.

  CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
    EXPORTING
      syst     = syst
    CHANGING
      bapiret2 = return.
  APPEND return.
  "message in log
  PERFORM message_in_slg1 USING return gv_log_guid.

  CLEAR: exp_ok_code.

* check VSTEL
  SELECT SINGLE * FROM tvst INTO ls_tvst  WHERE vstel = imp_vstel.
  IF sy-subrc NE 0.
    CLEAR return.
    exp_ok_code = 4.
* Versandstelle & existiert nicht.
    MESSAGE w077(/ctdi/sd01) WITH imp_vstel INTO return-message.

    CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
      EXPORTING
        syst     = syst
      CHANGING
        bapiret2 = return.
    APPEND return.
    "message in log
    PERFORM message_in_slg1 USING return gv_log_guid.
    EXIT.
  ENDIF.

* VSTEL in SLG1 schreiben: IMP_VSTEL = &
  MESSAGE w079(/ctdi/sd01) WITH imp_vstel INTO return-message.

  CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
    EXPORTING
      syst     = syst
    CHANGING
      bapiret2 = return.
  APPEND return.
  "message in log
  PERFORM message_in_slg1 USING return gv_log_guid.

* check LDEST
  SELECT SINGLE * FROM tsp03d INTO ls_tsp03d  WHERE padest = imp_ldest.
  IF sy-subrc NE 0.
    CLEAR return.
    exp_ok_code = 4.
* Drucker & existiert nicht.
    MESSAGE w027(/ctdi/sd01) WITH imp_ldest INTO return-message.

    CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
      EXPORTING
        syst     = syst
      CHANGING
        bapiret2 = return.
    APPEND return.
    "message in log
    PERFORM message_in_slg1 USING return gv_log_guid.
  ENDIF.

* Drucker in SLG1 schreiben: IMP_LDEST = &
  MESSAGE w080(/ctdi/sd01) WITH imp_ldest INTO return-message.

  CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
    EXPORTING
      syst     = syst
    CHANGING
      bapiret2 = return.
  APPEND return.
  "message in log
  PERFORM message_in_slg1 USING return gv_log_guid.

* check SERNR
  SELECT SINGLE equnr FROM equi INTO lv_sernr WHERE equnr = imp_sernr.

  IF sy-subrc <> 0.
    CLEAR return.
    exp_ok_code = 4.
* SERNR & nicht vorhanden
    MESSAGE e001(/ctdi/sd01) WITH imp_sernr INTO return-message.

    CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
      EXPORTING
        syst     = syst
      CHANGING
        bapiret2 = return.
    APPEND return.
    "message in log
    PERFORM message_in_slg1 USING return gv_log_guid.
    EXIT.
  ENDIF.

* Status der SERNR prüfen
  CALL FUNCTION 'BAPI_EQUI_GETSTATUS'
    EXPORTING
      equipment     = lv_sernr
*     LANGUAGE      = SY-LANGU
*     LANGUAGE_ISO  =
*   IMPORTING
*     RETURN        =
    TABLES
      system_status = lt_systat
      user_status   = lt_usstat.

* Systemstatus muss EKUN sein
  READ TABLE lt_systat INTO ls_systat WITH KEY text = 'EKUN'."status = 'I0188'
  IF sy-subrc <> 0.
    CLEAR return.
    exp_ok_code = 4.
    MESSAGE e002(/ctdi/sd01) WITH imp_sernr INTO return-message.

    CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
      EXPORTING
        syst     = syst
      CHANGING
        bapiret2 = return.
    APPEND return.
    "message in log
    PERFORM message_in_slg1 USING return gv_log_guid.
    EXIT.
  ELSE.
* EQUNR Status in SLG1 schreiben: Systemstatus SERNR = & ist 'EKUN/I0188'.
    MESSAGE w081(/ctdi/sd01) WITH imp_sernr INTO return-message.

    CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
      EXPORTING
        syst     = syst
      CHANGING
        bapiret2 = return.
    APPEND return.
    "message in log
    PERFORM message_in_slg1 USING return gv_log_guid.
  ENDIF.

* Anwenderstatus muss FREI sein
  READ TABLE lt_usstat INTO ls_systat WITH KEY text = 'FREI'."status = 'E0001'
  IF sy-subrc <> 0.
    CLEAR return.
    exp_ok_code = 4.
    MESSAGE e003(/ctdi/sd01) WITH imp_sernr INTO return-message.

    CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
      EXPORTING
        syst     = syst
      CHANGING
        bapiret2 = return.
    APPEND return.
    "message in log
    PERFORM message_in_slg1 USING return gv_log_guid.
    EXIT.
  ELSE.
* EQUNR status in slg1 schreiben: Anwenderstatus SERNR = & ist 'FREI/E0001'.
    MESSAGE w082(/ctdi/sd01) WITH imp_sernr INTO return-message.

    CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
      EXPORTING
        syst     = syst
      CHANGING
        bapiret2 = return.
    APPEND return.
    "message in log
    PERFORM message_in_slg1 USING return gv_log_guid.
  ENDIF.

* Kundenauftrag ermitteln
  SELECT * FROM objk INTO TABLE lt_objk WHERE equnr = lv_sernr AND taser = 'SER01'.

  IF sy-subrc <> 0.
    CLEAR return.
    exp_ok_code = 4.
    MESSAGE e004(/ctdi/sd01) WITH imp_sernr INTO return-message.

    CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
      EXPORTING
        syst     = syst
      CHANGING
        bapiret2 = return.
    APPEND return.
    "message in log
    PERFORM message_in_slg1 USING return gv_log_guid.
    EXIT.
  ENDIF.
  SELECT * FROM ser01 INTO TABLE lt_ser01  "#EC CI_NO_TRANSFORM
    FOR ALL ENTRIES IN lt_objk WHERE obknr  = lt_objk-obknr
                                 AND vorgang = 'SDLS'
                                 AND bwart   = '601'.
  IF sy-subrc <> 0.
    CLEAR return.
    exp_ok_code = 4.
    MESSAGE e017(/ctdi/sd01) WITH imp_sernr INTO return-message.

    CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
      EXPORTING
        syst     = syst
      CHANGING
        bapiret2 = return.
    APPEND return.
    "message in log
    PERFORM message_in_slg1 USING return gv_log_guid.
    EXIT.


  ENDIF.
  SORT lt_ser01 BY datum DESCENDING uzeit DESCENDING.
  READ TABLE lt_ser01 INTO ls_ser01 INDEX 1.
  SELECT SINGLE * FROM vbfa INTO ls_vbfa WHERE vbeln = ls_ser01-lief_nr
                                         AND   posnn = ls_ser01-posnr.

  IF sy-subrc <> 0.
    CLEAR return.
    exp_ok_code = 4.
    MESSAGE e005(/ctdi/sd01) WITH imp_sernr INTO return-message.

    CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
      EXPORTING
        syst     = syst
      CHANGING
        bapiret2 = return.
    APPEND return.
    "message in log
    PERFORM message_in_slg1 USING return gv_log_guid.
    EXIT.
  ENDIF.

* positionen  zum Auftrag ermitteln
  SELECT * FROM vbap INTO TABLE lt_vbap WHERE vbeln = ls_vbfa-vbelv.

* Hauptposition zum ermittelten KDAUF/POSNR ermitteln
  READ TABLE lt_vbap INTO ls_vbap WITH KEY vbeln = ls_vbfa-vbelv
                                           posnr = ls_vbfa-posnv.

  lv_sdaufnr  = ls_vbfa-vbelv.
  lv_hauptpos = ls_vbap-uepos.

* werte der Hauptposition in die Struktur schreiben
  READ TABLE lt_vbap INTO ls_vbap_haupt WITH KEY vbeln = lv_sdaufnr
                                                 posnr = lv_hauptpos.
  "Check LGNUM to IMP_LGNUM
  CLEAR: ls_t320.
  SELECT SINGLE * FROM t320 INTO ls_t320 WHERE werks = ls_vbap_haupt-werks
                                           AND lgort = ls_vbap_haupt-lgort.
  IF sy-subrc = 0.
    IF imp_lgnum <> ls_t320-lgnum.
      CLEAR return.
      exp_ok_code = 4.
      "LgNum & Hauptposition ist <> LgNum Import-LgNum &.
      MESSAGE e036(/ctdi/sd01) WITH ls_t320-lgnum imp_lgnum INTO return-message.

      CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
        EXPORTING
          syst     = syst
        CHANGING
          bapiret2 = return.
      APPEND return.
      "message in log
      PERFORM message_in_slg1 USING return gv_log_guid.
      EXIT.
    ENDIF.
  ELSE.
    CLEAR return.
    exp_ok_code = 4.
    "Hauptpostion hat keine LgNum für WERK = & /LGORT = &.
    MESSAGE e035(/ctdi/sd01) WITH ls_vbap_haupt-werks ls_vbap_haupt-lgort INTO return-message.

    CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
      EXPORTING
        syst     = syst
      CHANGING
        bapiret2 = return.
    APPEND return.
    "message in log
    PERFORM message_in_slg1 USING return gv_log_guid.
    EXIT.
  ENDIF.

* die passende position mit POSTYP 'ZRET' für den ermittelten KDAUF finden
  READ TABLE lt_vbap INTO ls_vbap WITH KEY vbeln = lv_sdaufnr
                                           pstyv = 'ZRET'
                                           uepos = lv_hauptpos.
  IF sy-subrc <> 0.
    CLEAR return.
    exp_ok_code = 4.
    MESSAGE e006(/ctdi/sd01) WITH lv_sdaufnr INTO return-message.

    CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
      EXPORTING
        syst     = syst
      CHANGING
        bapiret2 = return.
    APPEND return.
    "message in log
    PERFORM message_in_slg1 USING return gv_log_guid.
    EXIT.
  ENDIF.
  lv_zret_pos =  ls_vbap-posnr.

* die position mit POSTYP 'ZREG' für den ermittelten KDAUF finden. Falls gefunden ist GoodPart Pos. angelegt => Abbruch
  READ TABLE lt_vbap INTO ls_vbap WITH KEY vbeln = lv_sdaufnr
                                           pstyv = 'ZREG'
                                           uepos = lv_hauptpos.
  IF sy-subrc = 0.
    CLEAR return.
    exp_ok_code = 4.
    MESSAGE e007(/ctdi/sd01) WITH lv_sdaufnr INTO return-message.

    CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
      EXPORTING
        syst     = syst
      CHANGING
        bapiret2 = return.
    APPEND return.
    "message in log
    PERFORM message_in_slg1 USING return gv_log_guid.
    EXIT.
  ENDIF.

* Absagegrund für Position ZRET
  CLEAR:  gs_sditem, gs_sditemx.
  gs_sditem-itm_number = lv_zret_pos.
  gs_sditem-reason_rej = lc_abgru.
  gs_sditemx-itm_number = lv_zret_pos.
  gs_sditemx-reason_rej = 'X'.
  gs_sditemx-updateflag = 'U'.
  APPEND gs_sditem TO gt_sditem.
  APPEND gs_sditemx TO gt_sditemx.

* Neue Position erzeugen  zur passenden hauptposition wg. möglichen weiteren hauptpositionen
  CLEAR:  gs_sditem, gs_sditemx, ls_vbap_psp.
  LOOP AT lt_vbap INTO ls_vbap WHERE uepos = lv_hauptpos.
    APPEND ls_vbap TO lt_vbap_haupt.
    "get PSP from VBAP -> only one is possible !
    IF NOT ls_vbap-ps_psp_pnr IS INITIAL.
      ls_vbap_psp = ls_vbap.
    ENDIF.
  ENDLOOP.
  SORT lt_vbap_haupt BY posnr DESCENDING.
  READ TABLE lt_vbap_haupt INTO ls_vbap INDEX 1.
  lv_neue_pos = ls_vbap-posnr + 1.
  gs_sditem-itm_number     = lv_neue_pos.
  gs_sditem-material       = ls_vbap_haupt-matnr.
  gs_sditem-plant          = ls_vbap_haupt-werks.
  gs_sditem-hg_lv_item     = lv_hauptpos.

  gs_sditem-target_qty     = ls_vbap_haupt-kwmeng.
  gs_sditem-item_categ     = 'ZREG'.
  "Check Lagerort 'SWAP': Stand 30.03.2017 -> nur LgOrt SWAP darf gebucht werden, d.h.
  "                       Änderung Lagerort in Kundenauftrag
  IF ls_vbap_haupt-lgort <> 'SWAP'.
    CLEAR return.
    "Auftrag & /Pos & Lagerort & geändert in 'SWAP'.
    MESSAGE i034(/ctdi/sd01) WITH lv_sdaufnr  lv_neue_pos ls_vbap_haupt-lgort INTO return-message.

    CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
      EXPORTING
        syst     = syst
      CHANGING
        bapiret2 = return.
    APPEND return.
    "message in log
    PERFORM message_in_slg1 USING return gv_log_guid.
  ENDIF.
  "gs_sditem-store_loc      = ls_vbap_haupt-lgort.  "'SWAP'.
  gs_sditem-store_loc      = 'SWAP'.
  gs_sditem-batch          = ls_vbap_haupt-charg. "REP
  APPEND gs_sditem TO gt_sditem.

  gs_sditemx-updateflag    = 'I'.          "Einfügen
  gs_sditemx-itm_number    = lv_neue_pos..
*
  gs_sditemx-material      = 'X'.
  gs_sditemx-plant         = 'X'. "ls_vbap_haupt-werks.
  gs_sditemx-store_loc     = 'X'. "ls_vbap_haupt-lgort.  "'SWAP'
  gs_sditemx-target_qty    = 'X'.
  gs_sditemx-hg_lv_item    = 'X'.
  gs_sditemx-item_categ    = 'X'.
  gs_sditemx-batch         = 'X'.
  APPEND gs_sditemx TO gt_sditemx.

  gs_schedule-itm_number   = lv_neue_pos.
  gs_schedule-sched_line   = '0001'.     "
  gs_schedule-req_qty      = ls_vbap_haupt-kwmeng.          "'1'.
  APPEND gs_schedule TO gt_schedule.
**
  gs_schedulex-updateflag  = 'I'.           "Einfügen
  gs_schedulex-itm_number  = lv_neue_pos.
  gs_schedulex-sched_line  = '0001'.
  gs_schedulex-req_qty     = 'X'.
  APPEND gs_schedulex TO gt_schedulex.
*
  gs_sdheaderx-updateflag = 'U'.

  ASSERT ID /ctdi/va02_goodpartreturn02  CONDITION sy-uname = 'NHSENTW01'.

* check VBAK/VBAP/....
  CLEAR: gv_locked.
  DO 25 TIMES.
    WAIT UP TO 1 SECONDS.
    "ls_vbap-vbeln
    CALL FUNCTION 'ENQUEUE_EVVBAKE'
      EXPORTING
        mode_vbak      = 'E'
        mandt          = sy-mandt
        vbeln          = ls_vbap-vbeln
*       X_VBELN        = ' '
*       _SCOPE         = '2'
*       _WAIT          = ' '
*       _COLLECT       = ' '
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      CLEAR return.
      gv_locked   = 'X'.
      "Auftrag & gesperrt
      MESSAGE w083(/ctdi/sd01) WITH ls_vbap-vbeln INTO return-message.

      CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
        EXPORTING
          syst     = syst
        CHANGING
          bapiret2 = return.
      APPEND return.
      "message in log
      PERFORM message_in_slg1 USING return gv_log_guid.
    ELSE.
      CLEAR: gv_locked.
      CALL FUNCTION 'DEQUEUE_EVVBAKE'
        EXPORTING
          mode_vbak = 'E'
          mandt     = sy-mandt
          vbeln     = ls_vbap-vbeln
*         X_VBELN   = ' '
*         _SCOPE    = '3'
*         _SYNCHRON = ' '
*         _COLLECT  = ' '
        .
      EXIT.
    ENDIF.
  ENDDO.

  IF gv_locked = 'X'.
    "Beleg noch immer gesperrt -> ENDE !!!
    "Auftrag & noch immer gesperrt! ENDE !
    MESSAGE e084(/ctdi/sd01) WITH ls_vbap-vbeln INTO return-message.

    CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
      EXPORTING
        syst     = syst
      CHANGING
        bapiret2 = return.
    APPEND return.
    "message in log
    PERFORM message_in_slg1 USING return gv_log_guid.
    exp_ok_code = 4.
    EXIT.
  ENDIF.

*Update vom Kundenauftrag
  CALL FUNCTION 'BAPI_SALESORDER_CHANGE' "#EC CI_USAGE_OK[2438131]  "INS S4CONV ECC - HPC(2508-614)
    EXPORTING
      salesdocument    = ls_vbap-vbeln
      order_header_in  = gs_sdheader
      order_header_inx = gs_sdheaderx
      simulation       = ' '
    TABLES
      return           = gt_return
      order_item_in    = gt_sditem
      order_item_inx   = gt_sditemx
      schedule_lines   = gt_schedule
      schedule_linesx  = gt_schedulex.

  LOOP AT gt_return INTO gs_return.
    "message in log ->  dann ENDE
    PERFORM message_in_slg1 USING gs_return gv_log_guid.
*    APPEND gs_return TO return.
    return[] = gt_return[].
    exp_ok_code = 4.
    EXIT.
  ENDLOOP.

  LOOP AT gt_return INTO gs_return WHERE type CA 'EAX'.
    "message in log -> weiter geht's
    PERFORM message_in_slg1 USING gs_return gv_log_guid.
*    APPEND gs_return TO return.
    return[] = gt_return[].
  ENDLOOP.

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = 'X'.

  ASSERT ID /ctdi/va02_goodpartreturn02  CONDITION sy-uname = 'NHSENTW01'.

* Erstellen Auslieferung/retoure, SERNR in Auslieferung eintragen, WA buchen
  IF imp_nobatch IS INITIAL.  " mit batch Input

    it_equkey-equnr = lv_sernr.
    APPEND it_equkey.

    vl01n-vbeln   = lv_sdaufnr.
    vl01n-lfart   = imp_lfart.                                "'ZLRG'.
    "vl01n-vstel   = ls_vbap_haupt-vstel.                    "'1MAL'.
    vl01n-vstel   = imp_vstel.
    vl01n-posnr   = lv_neue_pos.                            "'001100'.
    vl01n-bldat   = sy-datum.
    vl01n-lfimg   = ls_vbap_haupt-kwmeng.                   "'1'.

    ASSERT ID /ctdi/va02_goodpartreturn02  CONDITION sy-uname = 'NHSENTW01'.

* check VBAK/VBAP/....
    CLEAR: gv_locked.
    DO 25 TIMES.
      WAIT UP TO 1 SECONDS.
      "ls_vbap-vbeln
      CALL FUNCTION 'ENQUEUE_EVVBAKE'
        EXPORTING
          mode_vbak      = 'E'
          mandt          = sy-mandt
          vbeln          = vl01n-vbeln
*         X_VBELN        = ' '
*         _SCOPE         = '2'
*         _WAIT          = ' '
*         _COLLECT       = ' '
        EXCEPTIONS
          foreign_lock   = 1
          system_failure = 2
          OTHERS         = 3.
      IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        CLEAR return.
        gv_locked   = 'X'.
        "VL01N - Auftrag & gesperrt
        MESSAGE w085(/ctdi/sd01) WITH vl01n-vbeln INTO return-message.

        CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
          EXPORTING
            syst     = syst
          CHANGING
            bapiret2 = return.
        APPEND return.
        "message in log
        PERFORM message_in_slg1 USING return gv_log_guid.
      ELSE.
        CLEAR: gv_locked.
        CALL FUNCTION 'DEQUEUE_EVVBAKE'
          EXPORTING
            mode_vbak = 'E'
            mandt     = sy-mandt
            vbeln     = vl01n-vbeln
*           X_VBELN   = ' '
*           _SCOPE    = '3'
*           _SYNCHRON = ' '
*           _COLLECT  = ' '
          .
        EXIT.
      ENDIF.
    ENDDO.

    IF gv_locked = 'X'.
      "VL01N - Beleg noch immer gesperrt -> ENDE !!!
      MESSAGE e086(/ctdi/sd01) WITH vl01n-vbeln INTO return-message.

      CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
        EXPORTING
          syst     = syst
        CHANGING
          bapiret2 = return.
      APPEND return.
      "message in log
      PERFORM message_in_slg1 USING return gv_log_guid.
      exp_ok_code = 4.
      EXIT.
    ELSE.
      "VL01N - Beleg noch immer gesperrt -> ENDE !!!
      MESSAGE e090(/ctdi/sd01) WITH vl01n-vbeln INTO return-message.

      CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
        EXPORTING
          syst     = syst
        CHANGING
          bapiret2 = return.
      APPEND return.
      "message in log
      PERFORM message_in_slg1 USING return gv_log_guid.
    ENDIF.

    CALL FUNCTION '/CELLAG/VL01N_RETANL_CREATE'
      EXPORTING
        ctu       = 'X'
        mode      = 'N'  "   'E'
*       UPDATE    = 'L'
*       GROUP     =
        user      = sy-uname     "'NHSENTW01'
*       KEEP      =
*       HOLDDATE  =
        nodata    = '/'
        is_vl01n  = vl01n
      IMPORTING
*       SUBRC     =
        e_vbeln   = vbeln_vl
      TABLES
*       MESSTAB   =
        it_equkey = it_equkey.

    ASSERT ID /ctdi/va02_goodpartreturn02  CONDITION sy-uname = 'NHSENTW01'.

* commit work and wait.
    IF vbeln_vl IS INITIAL.
      CLEAR return.
      exp_ok_code = 4.
      "Zum Kundenauftrag & konnte keine Auslieferung erzeugt werden
      MESSAGE e013(/ctdi/sd01) WITH vl01n-vbeln INTO return-message.

      CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
        EXPORTING
          syst     = syst
        CHANGING
          bapiret2 = return.
      APPEND return.
      "message in log
      PERFORM message_in_slg1 USING return gv_log_guid.
      EXIT.
    ELSE.
      CLEAR return.
      "Retourenauslieferung & wurde angelegt.
      MESSAGE s090(/ctdi/sd01) WITH vbeln_vl INTO return-message.

      CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
        EXPORTING
          syst     = syst
        CHANGING
          bapiret2 = return.
      APPEND return.
      "message in log
      PERFORM message_in_slg1 USING return gv_log_guid.

      SELECT SINGLE * FROM likp INTO ls_likp WHERE vbeln = vbeln_vl.
      IF sy-subrc = 0.
        "HHE 19.08.2016: Nach Umstellung auf BAPI via Exit
        UPDATE likp SET yymds = imp_yymds WHERE vbeln = vbeln_vl.
        IF sy-subrc NE 0.
          "no message
        ENDIF.
        COMMIT WORK AND WAIT.
      ENDIF.
    ENDIF.
    exp_vbeln_vl = vbeln_vl.
    ASSERT ID /ctdi/va02_goodpartreturn02  CONDITION sy-uname = 'NHSENTW01'.
  ELSE. "mit Fubas -> wird nicht genutzt -> CELLAG FuBa bleibt als zentrale Stelle somit erhalten !!! HHE 06.12.2017
** Lieferung generieren
** Interne Tabellen füllen
*
*    CLEAR ls_vbap.
*    SELECT SINGLE * FROM vbap INTO ls_vbap
*      WHERE vbeln = lv_sdaufnr
*      AND   posnr = lv_neue_pos.
*
*    SELECT * FROM vbak INTO TABLE lt_lvbak
*      WHERE vbeln = lv_sdaufnr.
*
*    SELECT * FROM vbap INTO TABLE lt_lvbap
*      WHERE vbeln = lv_sdaufnr.
*
*    SELECT * FROM vbep INTO TABLE lt_lvbep
*      WHERE vbeln = lv_sdaufnr.
*
*    SELECT * FROM vbfa INTO TABLE lt_lvbfa
*      WHERE vbeln = lv_sdaufnr.
*
*
*    SELECT * FROM vbfs INTO TABLE lt_lvbfs
*      WHERE vbeln = lv_sdaufnr.
*
*    SELECT * FROM vbkd INTO TABLE lt_lvbkd
*      WHERE vbeln = lv_sdaufnr.
*
*    SELECT * FROM vbfs INTO TABLE lt_lvbfs
*      WHERE vbeln = lv_sdaufnr.
*
*
*    SELECT * FROM vbpa INTO TABLE lt_lvbpa
*      WHERE vbeln = lv_sdaufnr.
*
*    SELECT * FROM vbuk INTO TABLE lt_lvbuk
*      WHERE vbeln = lv_sdaufnr.
*
*    SELECT * FROM vbup INTO TABLE lt_lvbup
*      WHERE vbeln = lv_sdaufnr.
*
*    ASSERT ID /ctdi/va02_goodpartreturn02  CONDITION sy-uname = 'NHSENTW01'.break x12397.
*
** Sammelgang-Nummernkreis holen
*    SELECT SINGLE numki
*     INTO lv_numki
*     FROM tvsa
*      WHERE smart = 'L'.
*
** Nächste Nummer aus Nummernkreis holen
*    CALL FUNCTION 'NUMBER_GET_NEXT'
*      EXPORTING
*        nr_range_nr = lv_numki
*        object      = 'RV_SAMMG'
*      IMPORTING
*        number      = ls_vbsk-sammg.
*
*    ls_vbsk-mandt    = sy-mandt.
*    ls_vbsk-programm = sy-repid.
*    ls_vbsk-selset   = sy-slset.
*    ls_vbsk-batch    = sy-batch.
*    ls_vbsk-ernam    = sy-uname.
*    ls_vbsk-erdat    = sy-datlo.
*    ls_vbsk-uzeit    = sy-timlo.
*    ls_vbsk-vstel    = ls_vbap-vstel.
*    ls_vbsk-smart    = 'L'.
*
*
*    ls_vorgabe_daten-datum      = sy-datum.
*    ls_vorgabe_daten-datvw      = 2.
*    ls_vorgabe_daten-lfimg_flo  = 1 .
*    ls_vorgabe_daten-lgmng_flo  = 1  .
*    ls_vorgabe_daten-vgbel      = lv_sdaufnr.
*    ls_vorgabe_daten-vgpos      = lv_neue_pos.
*    ls_vorgabe_daten-id          =  2.
*
*
*
**Vorgabedaten füllen
*    INSERT ls_vorgabe_daten INTO TABLE lt_vorgabe_daten .
*
** Serialnummer in interne Tabelle schreiben
*    ls_sernr-rfbel = ls_vbap-vbeln.
*    ls_sernr-rfpos = ls_vbap-posnr.
*    ls_sernr-sernr = imp_sernr.
*
*    APPEND ls_sernr TO lt_sernr.
*
*
**** Umstellung auf BAPI 'BAPI_DELIVERYPROCESSING_EXEC'
**** HHE X12397 19.08.2016: MDS-Nummer von externer Applikation übernehmen
*    ASSERT ID zxv50rcreau01 CONDITION sy-uname = 'NHSENTW01'.
*    CLEAR: ls_leshp_delivery_extend_rv.
*    ls_leshp_delivery_extend_rv-yymds = imp_yymds.
*    CLEAR: ls_control.
*    ls_control-debug_flg = 'X'.
*
*
*    ASSERT ID /ctdi/va02_goodpartreturn02  CONDITION sy-uname = 'NHSENTW01'.
** Verbuchung der Lieferung
*    CALL FUNCTION 'RV_DELIVERY_CREATE'
*      EXPORTING
**   SELEKTIONSDATUM          =
*       vbsk_i                   = ls_vbsk
*       i_lieferart              = imp_lfart  " 'ZLRG'
*       it_vorgabe_daten         = lt_vorgabe_daten
*       if_nur_vorgabe_pos       = 'X'
*       if_vbls_pos_rueck        = 'X'
*       if_synchron              = 'X'
**   IF_NO_COMMIT             =
**   IF_NO_DEQUE              = ' '
**   IT_HU_SERNR              =
**   IT_HANDLING_UNITS        =
*       is_delivery_extend       = ls_leshp_delivery_extend_rv
*       is_control               = ls_control
*       if_check_spevi           = 'X'
*       it_sernr                 = lt_sernr
*     IMPORTING
*       vbsk_e                   = ls_vbsk
**   ET_SPLITPROT             =
*    TABLES
*      lvbak                    = lt_lvbak
*      lvbap                    = lt_lvbap
*      lvbep                    = lt_lvbep
*      lvbfa                    = lt_lvbfa
*      lvbfs                    = lt_lvbfs
*      lvbkd                    = lt_lvbkd
*      lvbls                    = lt_lvbls
*      lvbpa                    = lt_lvbpa
*      lvbuk                    = lt_lvbuk
*      lvbup                    = lt_lvbup
**   IT_VERKO                 =
**   IT_VERPO                 =
**   ET_VBUK                  =
**   ET_VBUP                  =
**   ET_VBFA                  =
*    EXCEPTIONS
*                  error_message      = 1
*                  OTHERS             = 2.
*    ASSERT ID /ctdi/va02_goodpartreturn02  CONDITION sy-uname = 'NHSENTW01'.
** Bei Fehler, Meldung
*    IF sy-subrc <> 0.
**      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno. EXIT.
*      CLEAR return.
*      exp_ok_code = 4.
*      MESSAGE e013(/ctdi/sd01) WITH lv_sdaufnr INTO return-message.
*
*      CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
*        EXPORTING
*          syst     = syst
*        CHANGING
*          bapiret2 = return.
*      APPEND return.
*      "message in log
*      PERFORM message_in_slg1 USING return gv_log_guid.
*      EXIT.
*
*    ENDIF.
*    READ TABLE lt_lvbls INTO ls_lvbls INDEX 1.
*    exp_vbeln_vl = ls_lvbls-vbeln_lif.
*    vbeln_vl     = ls_lvbls-vbeln_lif.
*
*    IF NOT ls_lvbls-vbeln_lif IS INITIAL.
*
*      SELECT SINGLE * FROM likp INTO ls_likp WHERE vbeln = ls_lvbls-vbeln_lif.
*      IF sy-subrc = 0.
*        "HHE 19.08.2016: Nach Umstellung auf BAPI via Exit
*        UPDATE likp SET yymds = imp_yymds WHERE vbeln = exp_vbeln_vl.
*        IF sy-subrc NE 0.
*          "no message
*        ENDIF.
*        SELECT SINGLE posnr  FROM lips INTO ls_lvbls-posnr_lif WHERE vbeln = ls_lvbls-vbeln_lif.
*
*      ENDIF.
*
*    ENDIF.

    COMMIT WORK AND WAIT.

*** HHE: Das sollte man noch überdenken !!!!
* Serialnummer zuordnen wenn mit RV_DELIVERY_CREATE nicht ging
*   zuerst prüfen ob die  Serialnummer zuzgewiesen
    CLEAR: lt_sernos.
    ls_key_data-taser = 'SER01'.
    ls_key_data-lief_nr = ls_lvbls-vbeln_lif.
    CALL FUNCTION 'GET_SERNOS_OF_DOCUMENT'
      EXPORTING
        key_data            = ls_key_data
*       STATUS_PRE_READ     = ' '
*       EQUNR_CORR          = 'X'
      TABLES
        sernos              = lt_sernos
*       SERXX               =
      EXCEPTIONS
        key_parameter_error = 1
        no_supported_access = 2
        no_data_found       = 3
        error_message       = 98
        OTHERS              = 99.

    READ TABLE lt_sernos INTO ls_sernos WITH KEY equnr = imp_sernr.

    IF  sy-subrc <> 0.  " SERNR zuordnen
* Kopfdaten füllen
      CLEAR ls_vbkok.
      ls_vbkok-vbeln_vl = ls_lvbls-vbeln_lif.
      ls_vbkok-wabuc = 'X'.                           "HHE 12.08.2016
      ls_vbkok-bldat = sy-datum.
      ls_vbkok-wadat_ist = sy-datum.

* Serialnummer in interne Tabelle schreiben
      REFRESH lt_sernr.
      ls_sernr_u-rfbel = ls_lvbls-vbeln_lif.
      ls_sernr_u-rfpos = ls_lvbls-posnr_lif.
      ls_sernr_u-sernr = imp_sernr.

      APPEND ls_sernr_u TO lt_sernr_u.

      ASSERT ID /ctdi/va02_goodpartreturn02  CONDITION sy-uname = 'NHSENTW01'.

      CALL FUNCTION 'WS_DELIVERY_UPDATE'
        EXPORTING
          vbkok_wa                 = ls_vbkok
          synchron                 = 'X'
*         NO_MESSAGES_UPDATE       = ' '
          commit                   = 'X'
          delivery                 = ls_lvbls-vbeln_lif
*         update_picking           = ' '
          nicht_sperren            = 'X'
*         IF_CONFIRM_CENTRAL       = ' '
*         IF_WMPP                  = ' '
*         IF_GET_DELIVERY_BUFFERED = ' '
*         IF_NO_GENERIC_SYSTEM_SERVICE     = ' '
*         IF_DATABASE_UPDATE       = '1'
*         IF_NO_INIT               = ' '
*         IF_NO_READ               = ' '
          if_error_messages_send_0 = 'X'
*         IF_NO_BUFFER_REFRESH     = ' '
*         IT_PARTNER_UPDATE        =
          it_sernr_update          = lt_sernr_u
*         IF_NO_REMOTE_CHG         = ' '
*         IF_NO_MES_UPD_PACK       = ' '
*         if_late_delivery_upd     = ' '
*   IMPORTING
*         EF_ERROR_ANY_0           =
*         EF_ERROR_IN_ITEM_DELETION_0      =
*         EF_ERROR_IN_POD_UPDATE_0 =
*         EF_ERROR_IN_INTERFACE_0  =
*         EF_ERROR_IN_GOODS_ISSUE_0        =
*         EF_ERROR_IN_FINAL_CHECK_0        =
*         EF_ERROR_PARTNER_UPDATE  =
*         EF_ERROR_SERNR_UPDATE    =
        TABLES
*         vbpok_tab                = lt_vbpok
          prot                     = lt_prot
*         VERKO_TAB                =
*         VERPO_TAB                =
*         VBSUPCON_TAB             =
*         it_verpo_sernr           =
*         IT_PACKING               =
*         IT_PACKING_SERNR         =
*         IT_REPACK                =
*         IT_HANDLING_UNITS        =
*         IT_OBJECTS               =
*         ET_CREATED_HUS           =
*         TVPOD_TAB                =
*         IT_TMSTMP                =
*         IT_BAPIADDR1             =
        EXCEPTIONS
          error_message            = 98
          OTHERS                   = 99.
      .

      ASSERT ID /ctdi/va02_goodpartreturn02  CONDITION sy-uname = 'NHSENTW01'.

      LOOP AT lt_prot INTO ls_prot.

        IF ls_prot-msgty = 'E'.
          exp_ok_code = 4.
          MESSAGE e011(zmsb_ct1) WITH ls_lvbls-vbeln_lif ls_prot-msgid
          ls_prot-msgno INTO return-message.
          CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
            EXPORTING
              syst     = syst
            CHANGING
              bapiret2 = return.
          APPEND return.
          "message in log
          PERFORM message_in_slg1 USING return gv_log_guid.
        ENDIF.

      ENDLOOP. "lt_prot INTO ls_prot.
      IF NOT return[] IS INITIAL.
        exp_ok_code = 4.
        EXIT.
      ENDIF.

      COMMIT WORK AND WAIT.

    ENDIF.
  ENDIF.                      "ENDIF zu BATCH/NOBATCH

  ASSERT ID /ctdi/va02_goodpartreturn02  CONDITION sy-uname = 'NHSENTW01'.

*** HHE 09.12.2017: ursprünglich TB erstellt via Customizing automatisch
***                 Wegen der Feldversorgung von MTS geht das nun nicht mehr.
***                 -> UMSTELLUNG auf TB selbst anlegen !!!!
  CLEAR: ls_vbfa.
  SELECT SINGLE * FROM vbfa INTO ls_vbfa WHERE vbelv = vbeln_vl
                                           AND vbtyp_n = 'R'.
  IF sy-subrc = 0.
    CLEAR: ls_mkpf, ls_mseg.
    SELECT SINGLE * FROM mkpf INTO ls_mkpf WHERE mblnr = ls_vbfa-vbeln
                                             AND mjahr = ls_vbfa-mjahr.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM mseg INTO ls_mseg WHERE mblnr = ls_mkpf-mblnr
                                               AND mjahr = ls_mkpf-mjahr
                                               AND zeile = ls_vbfa-posnn+2(4).
      IF sy-subrc = 0.
        REFRESH: lt_ltba, lt_mblnr_q.
        CLEAR: ls_mblnr_q.
        ls_mblnr_q-kappl       = 'ME'.
        "ls_mblnr_q-objky
        CONCATENATE ls_mseg-mblnr ls_mseg-mjahr ls_mseg-zeile INTO ls_mblnr_q-objky.
        ls_mblnr_q-kschl       = 'ZBFG'.
        ls_mblnr_q-spras       = sy-langu.
        ls_mblnr_q-mblnr_q     = ls_mseg-mblnr.
        ls_mblnr_q-mjahr_q     = ls_mseg-mjahr.
        APPEND ls_mblnr_q TO lt_mblnr_q.

        CLEAR: ls_ltba.
        ls_ltba-tabix    = sy-tabix.
        ls_ltba-lgnum    = imp_lgnum.
        ls_ltba-trart    = 'E'.
        ls_ltba-matnr    = ls_mseg-matnr.
        ls_ltba-werks    = ls_mseg-werks.
        ls_ltba-lgort    = ls_mseg-lgort.
        ls_ltba-charg    = ls_mseg-charg.
        ls_ltba-bestq    = ls_mseg-bestq.
        ls_ltba-sobkz    = ls_mseg-sobkz.
        "get SONUM for 'Q'
        IF ls_ltba-sobkz = 'Q'.
          MOVE ls_vbap_psp-ps_psp_pnr TO ls_ltba-sonum.
          SHIFT ls_ltba-sonum RIGHT DELETING TRAILING space.
          TRANSLATE ls_ltba-sonum USING ' 0'.
        ENDIF.
        ls_ltba-menga    = ls_mseg-menge.
        ls_ltba-altme    = ls_mseg-meins.
        ls_ltba-tbktx    = '/CTDI/VA02_GOODPARTRETURN02'.
        ls_ltba-wempf    = ls_mseg-wempf.
        ls_ltba-ablad    = ls_mseg-ablad.
        ls_ltba-bname    = sy-uname.
        ls_ltba-betyp    = 'M'.
        ls_ltba-benum    = ls_mseg-mblnr.               " Materialbeleg
        ls_ltba-bwlvs    = ls_mseg-bwlvs.               " 953 - FastGoodPart
        ls_ltba-vltyp    = ls_mseg-lgtyp.
        ls_ltba-vlpla    = ls_mseg-lgpla.
        "ls_ltba-vkdyn    =
        ls_ltba-mblnr    = ls_mseg-mblnr.
        ls_ltba-mjahr    = ls_mseg-mjahr.
        ls_ltba-trart    = 'E'.
        "CTDI Felder
        ls_ltba-yymds               = imp_yymds.
        ls_ltba-/ctdi/sernr         = imp_sernr.
        ls_ltba-/ctdi/sernr_q       = imp_sernr.
        ls_ltba-/ctdi/sernr         = imp_sernr.
        ls_ltba-/ctdi/mblnr         = ls_vbfa-vbeln.
        ls_ltba-/ctdi/mjahr         = ls_vbfa-mjahr.
        ls_ltba-/ctdi/zeile         = ls_vbfa-posnn+2(4).
        ls_ltba-/ctdi/sernr_q       = imp_sernr.
        ls_ltba-/ctdi/mblnr_q       = ls_vbfa-vbeln.
        ls_ltba-/ctdi/mjahr_q       = ls_vbfa-mjahr.
        ls_ltba-/ctdi/zeile_q       = ls_vbfa-posnn+2(4).
        ls_ltba-/ctdi/status_q      = '2'.                 "Bestand direkt in Qualität aus ZRAL01 (GoodPart neu)
        APPEND ls_ltba TO lt_ltba.

* check: VBELN
        CLEAR: gv_locked.
        DO 25 TIMES.
          WAIT UP TO 1 SECONDS.
          "ls_vbap-vbeln
          CALL FUNCTION 'ENQUEUE_EVVBLKE'
            EXPORTING
              mode_likp      = 'E'
              mandt          = sy-mandt
              vbeln          = vbeln_vl
*             X_VBELN        = ' '
*             _SCOPE         = '2'
*             _WAIT          = ' '
*             _COLLECT       = ' '
            EXCEPTIONS
              foreign_lock   = 1
              system_failure = 2
              OTHERS         = 3.
          IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
            CLEAR return.
            gv_locked   = 'X'.
            "TB zu VL01N - Auslieferung & gesperrt
            MESSAGE w087(/ctdi/sd01) WITH vbeln_vl INTO return-message.

            CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
              EXPORTING
                syst     = syst
              CHANGING
                bapiret2 = return.
            APPEND return.
            "message in log
            PERFORM message_in_slg1 USING return gv_log_guid.
          ELSE.
            CLEAR: gv_locked.
            CALL FUNCTION 'DEQUEUE_EVVBLKE'
              EXPORTING
                mode_likp = 'E'
                mandt     = sy-mandt
                vbeln     = vbeln_vl
*               X_VBELN   = ' '
*               _SCOPE    = '3'
*               _SYNCHRON = ' '
*               _COLLECT  = ' '
              .
            EXIT.
          ENDIF.
        ENDDO.

        IF gv_locked = 'X'.
          "TB zu VL01N - Beleg noch immer gesperrt -> ENDE !!!
          MESSAGE e088(/ctdi/sd01) WITH vl01n-vbeln INTO return-message.

          CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
            EXPORTING
              syst     = syst
            CHANGING
              bapiret2 = return.
          APPEND return.
          "message in log
          PERFORM message_in_slg1 USING return gv_log_guid.
          exp_ok_code = 4.
          EXIT.
        ENDIF.
        "Anlegen TB mit FuBa 'L_TR_CREATE' (vor FuBa).
        MESSAGE e089(/ctdi/sd01) WITH vl01n-vbeln INTO return-message.

        CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
          EXPORTING
            syst     = syst
          CHANGING
            bapiret2 = return.
        APPEND return.
        "message in log
        PERFORM message_in_slg1 USING return gv_log_guid.
        "Erzeugung TR je VBELN_VL/Retourenanlieferung
        CALL FUNCTION 'L_TR_CREATE'
          EXPORTING
*I_SINGLE_ITEM
            i_save_only_all       = 'X'
*           i_update_task         = 'X'
*I_COMMIT_WORK
          TABLES
            t_ltba                = lt_ltba
          EXCEPTIONS
            item_error            = 1
            no_entry_in_int_table = 2
            item_without_number   = 3
            no_update_item_error  = 4
            OTHERS                = 5.
        IF sy-subrc <> 0.
          "ERROR Erstellung TB: SY-UBRC = & !
          MESSAGE e130(/cellag/csral) WITH sy-subrc INTO return-message.
          CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
            EXPORTING
              syst     = syst
            CHANGING
              bapiret2 = return.
          APPEND return.
          "message in log
          PERFORM message_in_slg1 USING return gv_log_guid.
        ELSE.
          "TB angelegt
          CLEAR: ls_ltba.
          LOOP AT lt_ltba INTO ls_ltba.
            IF ls_ltba-tbnum IS NOT INITIAL.
              CLEAR return.
              "Transportbedarf & wurde angelegt.
              MESSAGE i128(/cellag/csral) WITH ls_ltba-tbnum INTO return-message.
              CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
                EXPORTING
                  syst     = syst
                CHANGING
                  bapiret2 = return.
              APPEND return.
              "message in log
              PERFORM message_in_slg1 USING return gv_log_guid.
              "Absprache Thorsten -> nur wenn ALLES OK wird EXPLIZIT OK-Code auf NULL '0' gesetzt;
              exp_ok_code = '0'.
            ELSE.
              CLEAR return.
              "TB (LS_LTBA-TBNUM IS INITIAL) wurde nicht angelegt !!!!
              MESSAGE s091(/ctdi/sd01) INTO return-message.

              CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
                EXPORTING
                  syst     = syst
                CHANGING
                  bapiret2 = return.
              APPEND return.
              "message in log
              PERFORM message_in_slg1 USING return gv_log_guid.
              exp_ok_code = '4'.
            ENDIF.
          ENDLOOP.
        ENDIF.

*        "mal aktivieren dies/dann deaktivieren wir wieder :-)
        "Bei GutBaugruppen drucken wir kein Label -> sag ich... Mal sehen ob das DURCHGEHT !!!
        "printing "Baugruppenlabel 'ZBGF - Bgr.
        IF sy-uname = 'X12397' AND imp_ldest IS INITIAL.
          imp_ldest = 'DM00'.
        ENDIF.
        CLEAR: ls_mblnr_q.
        LOOP AT lt_mblnr_q INTO ls_mblnr_q.
          "SEL-OPT: S_OBJKY
          CLEAR: ls_seltab.
          ls_seltab-selname = 'S_OBJKY'.
          ls_seltab-kind    = 'S'.
          ls_seltab-sign    = 'I'.
          ls_seltab-option  = 'EQ'.
          ls_seltab-low     = ls_mblnr_q-objky.
          "ls_seltab-high    =
          APPEND ls_seltab TO lt_seltab.
          "SEL-OPT: S_KSCHL
          CLEAR: ls_seltab.
          ls_seltab-selname = 'S_KSCHL'.
          ls_seltab-kind    = 'S'.
          ls_seltab-sign    = 'I'.
          ls_seltab-option  = 'EQ'.
          ls_seltab-low     = 'ZBFG'.
          "ls_seltab-high    =
          APPEND ls_seltab TO lt_seltab.

          " VORHER: RSNAST 'ZBFG' für MBLNR = & auf Drucker & .
          CLEAR: return.
          "VORHER: RSNAST 'ZBFG' für MBLNR = & auf Drucker & .
          MESSAGE i088(yhhe1) WITH ls_mblnr_q-objky  imp_ldest INTO return-message.
          CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
            EXPORTING
              syst     = syst
            CHANGING
              bapiret2 = return.
          APPEND return.
          PERFORM message_in_slg1 USING return gv_log_guid.

          SUBMIT rsnast00 WITH SELECTION-TABLE lt_seltab
                          WITH p_print = imp_ldest
                          AND RETURN.
          "EXPORTING LIST TO MEMORY.

*          REFRESH: lt_listobject.
*          CALL FUNCTION 'LIST_FROM_MEMORY'
*            TABLES
*              listobject = lt_listobject
*            EXCEPTIONS
*              not_found  = 1
*              OTHERS     = 2.
*          IF sy-subrc <> 0.
*            "BREAK-POINT.
*            "MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno
*            "WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*          ELSE.
*            " VORHER: RSNAST 'ZBFG' für MBLNR = & auf Drucker & .
*            "MESSAGE i088(yhhe1) WITH ls_mblnr_q-objky INTO return-message.
*            "PERFORM message_in_slg1 USING return gv_log_guid.
*          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.

  ASSERT ID /ctdi/va02_goodpartreturn02  CONDITION sy-uname = 'NHSENTW01'.

ENDFUNCTION.
