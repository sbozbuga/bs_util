FUNCTION REMOVE_IDOC.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(GS_CRETI) TYPE  /CTDI/T_CRETIM
*"     REFERENCE(GS_CREDA) TYPE  /CTDI/T_CREDA
*"     REFERENCE(GS_MESTY) TYPE  /CTDI/T_MESTYP
*"     REFERENCE(GS_MESCO) TYPE  /CTDI/T_MESCOD
*"     REFERENCE(GS_MESFC) TYPE  /CTDI/T_MESFCT
*"     REFERENCE(GS_DIREC) TYPE  /CTDI/T_DIRECT
*"     REFERENCE(GS_DOCNU) TYPE  /CTDI/T_DOCNUM
*"     REFERENCE(GS_STATU) TYPE  /CTDI/T_STATUS
*"     REFERENCE(GP_MAXCT) TYPE  SYDBCNT
*"     REFERENCE(GP_INTRF) TYPE  CHAR01
*"     REFERENCE(GP_TRFC) TYPE  CHAR01
*"     REFERENCE(GP_LOGDL) TYPE  CHAR01
*"     REFERENCE(GP_TEST) TYPE  CHAR01 OPTIONAL
*"----------------------------------------------------------------------
** 20150225rh Erstellung aus RSETESTD
************************************************************************
  CONSTANTS: gc_element_idoc TYPE swo_objtyp VALUE 'IDOC',
             gc_commit_limit TYPE sydbcnt    VALUE 1000.

  DATA: gt_edidc           TYPE STANDARD TABLE OF edidc
                               WITH NON-UNIQUE KEY docnum,
        gd_edidc           TYPE edidc,
        lcount             TYPE i,
        gt_task            TYPE STANDARD TABLE OF sww_task
                               WITH NON-UNIQUE KEY table_line,
        gd_task            TYPE sww_task,
        gt_workflow_task   TYPE STANDARD TABLE OF swd_tsklst
                               WITH NON-UNIQUE KEY object,
        gd_workflow_task   TYPE swd_tsklst,
        gd_object_type     TYPE swo_objtyp,
        gt_object_type     TYPE STANDARD TABLE OF swo_objtyp
                               WITH NON-UNIQUE KEY table_line,
        gd_relation_object TYPE borident,
        gt_relation        TYPE STANDARD TABLE OF relgraphlk
                               WITH NON-UNIQUE KEY objkey_a,
        gd_relation        TYPE relgraphlk,
        gd_relation_next   TYPE borident,
**      gd_idoc_control    TYPE edidc,
        gd_portname        TYPE edi_rcvpor,
**      gd_port_ale        TYPE edipoa,
**      gd_port_file       TYPE edipod,
**      gd_port_r2         TYPE edipo2,
**      gd_port_inet       TYPE edipoi,
**      gd_port_xml        TYPE edipox,
**      gd_port_pss        TYPE edipof,
        gd_port_type       TYPE ediport-porttyp,
        gd_objid           TYPE swotobjid,
        gt_workitem        TYPE STANDARD TABLE OF swwwihead
                               WITH NON-UNIQUE KEY wi_id,
        gd_workitem        TYPE swwwihead,
        gt_idoc_status     TYPE STANDARD TABLE OF edids
                               WITH NON-UNIQUE KEY docnum,
        gd_idoc_status     TYPE edids,
        gd_bal_logn        TYPE balognr,
        gt_bal_logn        TYPE bal_t_logn,
        gd_count_trfc      TYPE sydbcnt,
        gd_count_rel       TYPE sydbcnt,
        gd_count_wi        TYPE sydbcnt,
        gd_count_log       TYPE sydbcnt,
        gd_count_cpic      TYPE sydbcnt,
        gd_total           TYPE sydbcnt,
        gd_count           TYPE sydbcnt,
        gd_count_commit    TYPE sydbcnt,
        progress_title(60),
        gd_percent         TYPE f.

  data: lr_creda like line of gs_creda.
* Check whether the current user has the necessary authority.
* If the user is not authorized, the program stops with an error
* message.
  AUTHORITY-CHECK OBJECT authority_obj_edi_control
      ID 'EDI_TCD' FIELD authority_tcode_rsetestd
      ID 'ACTVT'   FIELD authority_activity_delete.
  IF NOT syst-subrc = authority_ok.
* Authority check negative; message for the user and stop program.
    MESSAGE ID 'E0' TYPE 'E' NUMBER 893 WITH syst-repid.
  ENDIF.
**

  DESCRIBE TABLE gs_creda LINES lcount.
  READ TABLE gs_creda into lr_creda INDEX 1.
  IF lcount = '1' AND lr_creda-high IS NOT INITIAL.
* Read control records into internal table.
    SELECT * FROM edidc UP TO gp_maxct ROWS
        INTO TABLE gt_edidc
        WHERE   upddat <= lr_creda-high
            AND upddat >= lr_creda-low
            AND direct IN gs_direc
            AND docnum IN gs_docnu
            AND status IN gs_statu
            AND mestyp IN gs_mesty
            AND mescod IN gs_mesco
            AND mesfct IN gs_mesfc
            AND credat IN gs_creda
            AND cretim IN gs_creti.
  ELSE.
    SELECT * FROM edidc UP TO gp_maxct ROWS
        INTO TABLE gt_edidc
        WHERE direct IN gs_direc
          AND docnum IN gs_docnu
          AND status IN gs_statu
          AND mestyp IN gs_mesty
          AND mescod IN gs_mesco
          AND mesfct IN gs_mesfc
          AND credat IN gs_creda
          AND cretim IN gs_creti.
  ENDIF.
  MOVE syst-dbcnt TO gd_total.

  IF gp_intrf = on.
* Get all task entries from tables TEDE2, TEDE5, and TEDE6 for later
* processing.
    SELECT evenid FROM tede2 INTO TABLE gt_task.
    SELECT evenid FROM tede5 APPENDING TABLE gt_task.
    SELECT evenid FROM tede6 APPENDING TABLE gt_task.
    DELETE gt_task WHERE table_line = space.
    SORT gt_task.
    DELETE ADJACENT DUPLICATES FROM gt_task.

* Prepare a list with all object types occurring in the tasks.
    LOOP AT gt_task INTO gd_task.
      REFRESH gt_workflow_task.
      CALL FUNCTION 'SWD_WFD_TASKS_GET'
        EXPORTING
          task               = gd_task
          get_detail         = on
**        TASK_AS_ROOT       = off
**        WFD_KEY            =
        TABLES
          task_list          = gt_workflow_task.
      LOOP AT gt_workflow_task INTO gd_workflow_task.
        MOVE gd_workflow_task-objtype TO gd_object_type.
        INSERT gd_object_type INTO TABLE gt_object_type.
      ENDLOOP.
    ENDLOOP.
    SELECT idocobjtyp FROM tbd52 INTO gd_object_type.
      APPEND gd_object_type TO gt_object_type.
    ENDSELECT.
    DELETE gt_object_type WHERE table_line = space.
    SORT gt_object_type.
    DELETE ADJACENT DUPLICATES FROM gt_object_type.
  ENDIF.

* Look at all selected IDocs in turn.
  LOOP AT gt_edidc INTO gd_edidc.
* Read the control information of the IDoc.
    CALL FUNCTION 'EDI_DOCUMENT_OPEN_FOR_READ'
         EXPORTING
              document_number         = gd_edidc-docnum
              db_read_option          = no_db_read
**         IMPORTING
**              idoc_control            = gd_idoc_control
         EXCEPTIONS
              document_foreign_lock   = 1
              document_not_exist      = 2
              document_number_invalid = 3
              OTHERS                  = 4.
    IF NOT syst-subrc IS INITIAL.
      MESSAGE ID syst-msgid TYPE syst-msgty NUMBER syst-msgno
          WITH syst-msgv1 syst-msgv2 syst-msgv3 syst-msgv4.
      CONTINUE.
    ENDIF.

* Read port information.
    IF gd_edidc-direct = outbound.
      MOVE gd_edidc-rcvpor TO gd_portname.
    ELSE.
      MOVE gd_edidc-sndpor TO gd_portname.
    ENDIF.
**    CLEAR: gd_port_ale,  gd_port_file, gd_port_r2,
**           gd_port_inet, gd_port_xml,  gd_port_pss.
    CLEAR gd_port_type.
    CALL FUNCTION 'EDI_PORT_READ'
      EXPORTING
        portname             = gd_portname
      IMPORTING
**        ale_port             = gd_port_ale
**        file_port            = gd_port_file
**        r2_port              = gd_port_r2
**        inet_port            = gd_port_inet
**        xml_port             = gd_port_xml
**        pss_port             = gd_port_pss
        typ                  = gd_port_type
**       VERSION              =
**       DESCRIPTION          =
      EXCEPTIONS
        port_not_exist       = 1
        OTHERS               = 2.
    IF syst-subrc > 1.
      MESSAGE ID syst-msgid TYPE syst-msgty NUMBER syst-msgno
          WITH syst-msgv1 syst-msgv2 syst-msgv3 syst-msgv4.
    ENDIF.

* workflow items.
    IF gp_intrf = on.
* Look for any related workflow workitems.
      LOOP AT gt_object_type INTO gd_object_type.
        REFRESH gt_workitem.
        MOVE: gd_object_type  TO gd_objid-objtype,
              gd_edidc-docnum TO gd_objid-objkey.
        CALL FUNCTION 'SWI_WORKITEMS_OF_OBJECT_GET'
          EXPORTING
            objtype    = gd_objid-objtype
            objkey     = gd_objid-objkey
**          IBF_OBJECT =
          TABLES
            itemlist   = gt_workitem.

* Delete the workitems, if any exist.
        LOOP AT gt_workitem INTO gd_workitem.
          IF gp_test = off.
            CALL FUNCTION 'SWW_WI_DELETE'
              EXPORTING
                wi_id               = gd_workitem-wi_id
                do_commit           = off
**              CREATE_EVENT        = off
                delete_log          = on
              EXCEPTIONS
                update_failed       = 1
              OTHERS                = 2.
            IF syst-subrc > 1.
              MESSAGE ID syst-msgid TYPE syst-msgty NUMBER syst-msgno
                  WITH syst-msgv1 syst-msgv2 syst-msgv3 syst-msgv4.
            ENDIF.
          ENDIF.
          ADD 1 TO gd_count_wi.
        ENDLOOP.
      ENDLOOP.
    ENDIF.

* Look for a relation.
    MOVE: gd_edidc-docnum TO gd_relation_object-objkey,
          gc_element_idoc TO gd_relation_object-objtype.
    SELECT SINGLE logsys FROM t000 INTO gd_relation_object-logsys
        WHERE mandt = syst-mandt.
    REFRESH gt_relation.
    CALL FUNCTION 'SREL_GET_NEXT_RELATIONS'
      EXPORTING
        object               = gd_relation_object
**       ROLETYPE             = '          '
**       RELATIONTYPE         = '    '
        max_hops             = 1
      TABLES
        links                = gt_relation
      EXCEPTIONS
        internal_error       = 1
        no_logsys            = 2
        OTHERS               = 3.
    IF NOT syst-subrc IS INITIAL.
      MESSAGE ID syst-msgid TYPE syst-msgty NUMBER syst-msgno
          WITH syst-msgv1 syst-msgv2 syst-msgv3 syst-msgv4.
    ENDIF.

* If there is an entry in the tRFC queue, delete it.
    IF gp_trfc = on.
      IF gd_edidc-direct = outbound.
* ab 6.30 werden keine tID-Verknüpfungen mehr geschrieben
* vh      LOOP AT gt_relation INTO gd_relation
* vh           WHERE     objtype_b  = 'TRANSID'
* vh              AND ( roletype_b = 'INTID' OR roletype_b = 'OUTTID' ).
* vh         IF gp_test = off.
* vh         SUBMIT rsarfcdl WITH tid = gd_relation-objkey_b AND RETURN.
* vh        ENDIF.
* vh         ADD 1 TO gd_count_trfc.
* vh      ENDLOOP.
* vh: für gd_edidc-docnum wird Status 03 gelesen, falls vorhanden
* vh: wenn das Feld tID gefüllt ist, dann mit dieser tID den rsarfcdl
* vh: starten, sonst doch noch in der Verknüpfungstabelle lesen
        select * from edids into edids
                          where docnum eq gd_edidc-docnum
                          and   status eq '03'.
        endselect.
        if sy-subrc eq 0." dann kann theoretisch eine tID existieren
          if edids-tid ne space.
            if gp_test = off.
              SUBMIT rsarfcdl WITH tid = edids-tid and return.
            endif.
            add 1 to gd_count_trfc.
          else. " gibt es noch eine Verknüpfung?
            loop at gt_relation into gd_relation
                  where objtype_b  = 'TRANSID'
                  and   roletype_b = 'OUTTID'.
              if gp_test = off.
                SUBMIT rsarfcdl
                     WITH tid = gd_relation-objkey_b AND RETURN.
              endif.
              add 1 to gd_count_trfc.
            endloop.
          endif.
        endif.
      ENDIF.
    ENDIF.

* If there is a relation, delete it.
    LOOP AT gt_relation INTO gd_relation.
      MOVE: gd_relation-objkey_b  TO gd_relation_next-objkey,
            gd_relation-objtype_b TO gd_relation_next-objtype,
            gd_relation-logsys_b  TO gd_relation_next-logsys.
      IF gp_test = off.
        CALL FUNCTION 'BINARY_RELATION_DELETE'
          EXPORTING
            obj_rolea          = gd_relation_object
            obj_roleb          = gd_relation_next
            relationtype       = gd_relation-reltype
            fire_events        = off
          EXCEPTIONS
            entry_not_existing = 1
            internal_error     = 2
            no_relation        = 3
            no_role            = 4
            OTHERS             = 5.
        IF syst-subrc = 2 OR syst-subrc > 4.
          MESSAGE ID syst-msgid TYPE syst-msgty NUMBER syst-msgno
              WITH syst-msgv1 syst-msgv2 syst-msgv3 syst-msgv4.
        ENDIF.
      ENDIF.
      ADD 1 TO gd_count_rel.
    ENDLOOP.

    IF gp_logdl = on.
* Prepare the deletion of application-log entries.
      REFRESH gt_idoc_status.
      CALL FUNCTION 'EDI_DOCUMENT_READ_ALL_STATUS'
        EXPORTING
          document_number        = gd_edidc-docnum
        TABLES
          int_edids              = gt_idoc_status
        EXCEPTIONS
          document_not_open      = 1
          no_status_record_found = 2
          OTHERS                 = 3.
      IF NOT syst-subrc IS INITIAL.
        MESSAGE ID syst-msgid TYPE syst-msgty NUMBER syst-msgno
          WITH syst-msgv1 syst-msgv2 syst-msgv3 syst-msgv4.
      ENDIF.
      LOOP AT gt_idoc_status INTO gd_idoc_status
          WHERE NOT appl_log IS INITIAL.
        MOVE gd_idoc_status-appl_log TO gd_bal_logn.
        INSERT gd_bal_logn INTO TABLE gt_bal_logn.
        ADD 1 TO gd_count_log.
      ENDLOOP.

* Finally, delete the IDoc completely with all records.
      CALL FUNCTION 'EDI_DOCUMENT_CLOSE_READ'
        EXPORTING
          document_number         = gd_edidc-docnum
**      IMPORTING
**        IDOC_CONTROL            =
        EXCEPTIONS
          document_not_open       = 1
          parameter_error         = 2
          OTHERS                  = 3.
      IF NOT syst-subrc IS INITIAL.
        MESSAGE ID syst-msgid TYPE syst-msgty NUMBER syst-msgno
          WITH syst-msgv1 syst-msgv2 syst-msgv3 syst-msgv4.
      ENDIF.
    ENDIF.

    IF gp_test = off.
      CALL FUNCTION 'EDI_DOCUMENT_DELETE'
        EXPORTING
          document_number        = gd_edidc-docnum
        EXCEPTIONS
          idoc_does_not_exist    = 1
          document_foreign_lock  = 2
          idoc_cannot_be_deleted = 3
          not_all_tables_deleted = 4
          OTHERS                 = 5.
      IF NOT syst-subrc IS INITIAL.
        MESSAGE ID syst-msgid TYPE syst-msgty NUMBER syst-msgno
            WITH syst-msgv1 syst-msgv2 syst-msgv3 syst-msgv4.
      ENDIF.
    ENDIF.

* Do a COMMIT WORK if the specified number of IDocs is reached.
* Immediately before the COMMIT WORK, all remembered application-
* log entries are deleted.
    ADD 1 TO: gd_count, gd_count_commit.
    IF gd_count_commit >= gc_commit_limit.
      IF gp_test = off.
        IF gp_logdl = on AND NOT gt_bal_logn IS INITIAL.
          CALL FUNCTION 'BAL_DB_DELETE'
            EXPORTING
**            I_T_LOGS_TO_DELETE       =
**            I_T_LOG_HANDLE           =
              i_t_lognumber            = gt_bal_logn
**            I_CLIENT                 = SYST-MANDT
              i_in_update_task         = off
              i_with_commit_work       = off
            EXCEPTIONS
              no_logs_specified        = 1
              OTHERS                   = 2.
*         sy-subrc = 1 is no error, it means ballog already deleted
          IF sy-subrc = 2.
            MESSAGE ID syst-msgid TYPE syst-msgty NUMBER syst-msgno
                WITH syst-msgv1 syst-msgv2 syst-msgv3 syst-msgv4.
          ENDIF.
        ENDIF.
        COMMIT WORK.
      ENDIF.
      REFRESH gt_bal_logn.
      CLEAR gd_count_commit.
* The progress is shown to the user.
      IF gp_test = off.
        progress_title = text-020.
      ELSE.
        progress_title = text-021.
      ENDIF.
      COMPUTE gd_percent = ( gd_count / gd_total ) * 100.
      CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
        EXPORTING
          percentage = gd_percent
          text       = progress_title.
    ENDIF.
  ENDLOOP.

* At the end, delete the remaining application-log entries.
  IF gp_test = off.
    IF gp_logdl = on AND NOT gt_bal_logn IS INITIAL.
      CALL FUNCTION 'BAL_DB_DELETE'
        EXPORTING
**          I_T_LOGS_TO_DELETE       =
**          I_T_LOG_HANDLE           =
          i_t_lognumber            = gt_bal_logn
**          I_CLIENT                 = SYST-MANDT
        i_in_update_task         = off
        i_with_commit_work       = off
      EXCEPTIONS
        no_logs_specified        = 1
        OTHERS                   = 2.
*       sy-subrc = 1 is no error, it means ballog already deleted
      IF sy-subrc = 2.
        MESSAGE ID syst-msgid TYPE syst-msgty NUMBER syst-msgno
            WITH syst-msgv1 syst-msgv2 syst-msgv3 syst-msgv4.
      ENDIF.
    ENDIF.
    COMMIT WORK.   " perform all open deletions
  ENDIF.

* Finally, print a list with the result summary.
  WRITE: gd_total, gd_count_rel, gd_count_wi, gd_count_log,
         gd_count_cpic, gd_count_trfc.
  WRITE /.
  IF gp_test = on.
    WRITE / text-011.
  ELSE.
    WRITE / text-012.
    " Systemlog - # IDocs deleted
    CALL FUNCTION 'RSLG_WRITE_SYSLOG_ENTRY'
      EXPORTING
        DATA_WORD1       = 'RSETESTD'
        DATA_WORD2       = gd_total
        DATA_WORD3       = text-023
        DATA_WORD4       = text-024
        SL_MESSAGE_AREA  = 'C4'
        SL_MESSAGE_SUBID = '1'
      EXCEPTIONS
        OTHERS           = 0.
  ENDIF.
ENDFUNCTION.
