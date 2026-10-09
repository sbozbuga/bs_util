*----------------------------------------------------------------------*
***INCLUDE /CTDI/LSD01F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  MESSAGE_IN_SLG1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_RETURN  text
*----------------------------------------------------------------------*
FORM message_in_slg1  USING    p_return STRUCTURE bapiret2
                               p_gv_log_guid.

  CLEAR: gs_message.
  gs_message-msgty    = p_return-type.
  gs_message-msgid    = p_return-id.
  gs_message-msgno    = p_return-number.
  gs_message-msgv1    = p_return-message_v1.
  gs_message-msgv2    = p_return-message_v2.
  gs_message-msgv3    = p_return-message_v3.
  gs_message-msgv4    = p_return-message_v4.

  CALL FUNCTION 'BAL_LOG_MSG_ADD'
    EXPORTING
      i_log_handle              = p_gv_log_guid
      i_s_msg                   = gs_message
*     IMPORTING
*       E_S_MSG_HANDLE            =
*       E_MSG_WAS_LOGGED          =
*       E_MSG_WAS_DISPLAYED       =
   EXCEPTIONS
     log_not_found             = 1
     msg_inconsistent          = 2
     log_is_full               = 3
     OTHERS                    = 4
            .
  IF sy-subrc <> 0.
    "MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    "WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  IF gs_log_guid IS INITIAL.
    "APPEND p_gv_log_guid TO gt_log_guid.
    INSERT p_gv_log_guid INTO TABLE gs_log_guid.
  ENDIF.

  CALL FUNCTION 'BAL_DB_SAVE'
   EXPORTING
     i_client               = sy-mandt
     i_in_update_task       = ' '
     i_save_all             = 'X'
     i_t_log_handle         = gs_log_guid
* IMPORTING
*   E_NEW_LOGNUMBERS       =
 EXCEPTIONS
   log_not_found          = 1
   save_not_allowed       = 2
   numbering_error        = 3
   OTHERS                 = 4
            .
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.



ENDFORM.                    " MESSAGE_IN_SLG1
