FUNCTION-POOL /ctdi/sd01.                   "MESSAGE-ID ..

* declarations 'BAPI_SALESORDER_CHANGE'

DATA:   gs_sdheader               TYPE   bapisdh1,
        gs_sdheaderx              TYPE   bapisdh1x,
        gs_sditem                 TYPE   bapisditm,
        gs_sditemx                TYPE   bapisditmx,
        gt_sditem                 TYPE TABLE OF bapisditm,
        gt_sditemx                TYPE TABLE OF bapisditmx,
        gs_schedule               TYPE bapischdl,
        gs_schedulex              TYPE bapischdlx,
        gt_schedule               TYPE TABLE OF bapischdl,
        gt_schedulex              TYPE TABLE OF bapischdlx,
        gt_return                 TYPE TABLE OF bapiret2,
        gs_return                 TYPE   bapiret2.



*** HHE 22.10.2016
DATA:   gs_log                            TYPE bal_s_log,
        gv_log_guid                       TYPE balloghndl,
        gs_message                        TYPE bal_s_msg,
        gs_log_guid                       TYPE bal_t_logh,
        gs_log_guid_line                  TYPE balloghndl.
