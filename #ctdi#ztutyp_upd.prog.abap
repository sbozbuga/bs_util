*----------------------------------------------------------------------*
* Report              /CTDI/ZTUTYP_UPD                                            *
*----------------------------------------------------------------------*
* Transaktion         ???                                              *
* Datum
*----------------------------------------------------------------------*
* Firma               CTDI GmbH Malsch Headquarter                     *
*                                                                      *
* Beschreibung:  (Funktion)                                            *
*                                                                      *
*                                                                      *
*                                                                      *
*                                                                      *
*----------------------------------------------------------------------*
* Anforderer:  ???                                                     *
* Ticket....:  ???                                                     *
* Konzept...:  ???                                                     *
* Betreuung.:  ???                                                     *
*----------------------------------------------------------------------*
* Entwickler...: User-ID    Vor- Nachname Firma/Abteilung              *
*                                                                  *
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
* xx.xx.xxxx ???         ???
*----------------------------------------------------------------------*

REPORT /CTDI/ZTUTYP_UPD.
*&--------------------------------------------------------------------*
*& Report  ZTUTYP_UPD
*&
*&--------------------------------------------------------------------*
*& New user type data
*& Release SAP_BASIS 7.XX
*&--------------------------------------------------------------------*

tables: tutypa, tutyppl, tutyp, tupl, tuplt, law_cont.


************************
tupl-pricelist = '04'.
tupl-deflt_utyp = 'CB'.
insert tupl.

tuplt-langu = 'D'.
tuplt-pricelist = '04'.
tuplt-pltext =
  'SAP Applications'.
insert tuplt.
tuplt-langu = 'E'.
insert tuplt.

************************

************************
tutypa-usertyp = '56'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '215000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = '56'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = '56'.
tutyp-utyptext =
 'SAP Business Suite ESS User'.
tutyp-utyplongtext =
  'SAP Business Suite ESS User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = '56'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = '56'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = '56'.
law_cont-containsu = '59'.
insert law_cont.
law_cont-usertyp = '56'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = '56'.
law_cont-containsu = 'BK'.
insert law_cont.
law_cont-usertyp = '56'.
law_cont-containsu = 'BN'.
insert law_cont.
law_cont-usertyp = '56'.
law_cont-containsu = 'FC'.
insert law_cont.


*************************
tutypa-usertyp = '57'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '216000'.
tutypa-charge_info = 'C'.
insert tutypa.

insert tutyppl.
tutyppl-pricelist = '02'.
tutyppl-usertyp   = '57'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = '57'.
tutyp-utyptext =
 'SAP Business Suite Expert'.
tutyp-utyplongtext =
 'SAP Business Suite Expert User'.
insert tutyp.
tutyp-langu = 'E'.
tutyp-usertyp = '57'.
tutyp-utyptext =
 'SAP BS Business Expert'.
tutyp-utyplongtext =
 'SAP Business Suite Business Expert User'.
insert tutyp.

law_cont-usertyp = '57'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = '52'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = '53'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = '54'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = '56'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = '58'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = '59'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'EA'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'EB'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'EC'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'ED'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'EF'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'EG'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'AX'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'AY'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'AZ'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'BK'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'BL'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'BM'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'BN'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'FC'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'FD'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'FE'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'FF'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'FG'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'FH'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'FI'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'FK'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'FL'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'FM'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'FN'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'FO'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'FP'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'FR'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'FS'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'FT'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'FU'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'FV'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'FW'.
insert law_cont.
law_cont-usertyp = '57'.
law_cont-containsu = 'FX'.
insert law_cont.

*************************
tutypa-usertyp = '58'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '217000'.
tutypa-charge_info = 'C'.
insert tutypa.

insert tutyppl.
tutyppl-pricelist = '02'.
tutyppl-usertyp   = '58'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = '58'.
tutyp-utyptext =
 'SAP BS Business Information'.
tutyp-utyplongtext =
 'SAP Business Suite Business Information User'.
insert tutyp.
tutyp-langu = 'E'.
tutyp-usertyp = '58'.
tutyp-utyptext =
 'SAP BS Business Information'.
tutyp-utyplongtext =
 'SAP Business Suite Business Information User'.
insert tutyp.

law_cont-usertyp = '58'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = '58'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = '58'.
law_cont-containsu = '54'.
insert law_cont.
law_cont-usertyp = '58'.
law_cont-containsu = '56'.
insert law_cont.
law_cont-usertyp = '58'.
law_cont-containsu = '59'.
insert law_cont.
law_cont-usertyp = '58'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = '58'.
law_cont-containsu = 'AZ'.
insert law_cont.
law_cont-usertyp = '58'.
law_cont-containsu = 'BK'.
insert law_cont.
law_cont-usertyp = '58'.
law_cont-containsu = 'BM'.
insert law_cont.
law_cont-usertyp = '58'.
law_cont-containsu = 'BN'.
insert law_cont.
law_cont-usertyp = '58'.
law_cont-containsu = 'EB'.
insert law_cont.
law_cont-usertyp = '58'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = '58'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = '58'.
law_cont-containsu = 'FC'.
insert law_cont.

*************************
tutypa-usertyp = '59'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '218000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = '59'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = '59'.
tutyp-utyptext =
 'SAP Business Suite ESS Core'.
tutyp-utyplongtext =
 'SAP Business Suite Employee Self-Service Core User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = '59'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = '59'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = '59'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = '59'.
law_cont-containsu = 'BN'.
insert law_cont.
************************************

************************************
tutypa-usertyp = '62'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '806000'.
tutypa-charge_info = 'F'.
insert tutypa.

tutyppl-pricelist = '01'.
tutyppl-usertyp   = '62'.
insert tutyppl.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = '62'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = '62'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = '62'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = '62'.
tutyp-utyptext = 'SAP Banking User'.
tutyp-utyplongtext =
  'SAP Banking Engine User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

************************************
tutypa-usertyp = '63'.
tutypa-sscr_allow = 'X'.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '801000'.
tutypa-charge_info = 'F'.
insert tutypa.

tutyppl-pricelist = '01'.
tutyppl-usertyp   = '63'.
insert tutyppl.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = '63'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = '63'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = '63'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = '63'.
tutyp-utyptext =
 'SAP NetWeaver Developer'.
tutyp-utyplongtext =
  'SAP NetWeaver Developer'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

************************************
tutypa-usertyp = '64'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '802000'.
tutypa-charge_info = 'F'.
insert tutypa.

tutyppl-pricelist = '01'.
tutyppl-usertyp   = '64'.
insert tutyppl.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = '64'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = '64'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = '64'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = '64'.
tutyp-utyptext =
 'SAP NetWeaver Professional'.
tutyp-utyplongtext =
 'SAP NetWeaver Professional'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

************************************
tutypa-usertyp = '65'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '803000'.
tutypa-charge_info = 'F'.
insert tutypa.

tutyppl-pricelist = '01'.
tutyppl-usertyp   = '65'.
insert tutyppl.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = '65'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = '65'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = '65'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = '65'.
tutyp-utyptext =
 'SAP NetWeaver User'.
tutyp-utyplongtext =
  'SAP NetWeaver User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

*************************
tutypa-usertyp = '66'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '807000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = '66'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = '66'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = '66'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = '66'.
tutyp-utyptext =
 'SAP NetWeaver Gateway User'.
tutyp-utyplongtext =
 'SAP NetWeaver Gateway User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

*************************
tutypa-usertyp = '67'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '808000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = '67'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = '67'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = '67'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = '67'.
tutyp-utyptext =
 'SAP B2B Sales User'.
tutyp-utyplongtext =
 'SAP B2B Sales User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

*************************
tutypa-usertyp = '80'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = 'X'.
tutypa-sort = '620000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '01'.
tutyppl-usertyp   = '80'.
insert tutyppl.
tutyppl-pricelist = '02'.
tutyppl-usertyp   = '80'.
insert tutyppl.
tutyppl-pricelist = '03'.
tutyppl-usertyp   = '80'.
insert tutyppl.
tutyppl-pricelist = '04'.
tutyppl-usertyp   = '80'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = '80'.
tutyp-utyptext =
 'Sondermodul Typ 10'.
insert tutyp.
tutyp-langu = 'E'.
tutyp-usertyp = '80'.
tutyp-utyptext =
 'Special Module Type 10'.
insert tutyp.

*************************
tutypa-usertyp = '86'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = 'X'.
tutypa-sort = '636000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '01'.
tutyppl-usertyp   = '86'.
insert tutyppl.
tutyppl-pricelist = '02'.
tutyppl-usertyp   = '86'.
insert tutyppl.
tutyppl-pricelist = '03'.
tutyppl-usertyp   = '86'.
insert tutyppl.
tutyppl-pricelist = '04'.
tutyppl-usertyp   = '86'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = '86'.
tutyp-utyptext =
 'Sondermodul Typ 16'.
insert tutyp.
tutyp-langu = 'E'.
tutyp-usertyp = '86'.
tutyp-utyptext =
 'Special Module Type 16'.
insert tutyp.

*************************
tutypa-usertyp = '87'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = 'X'.
tutypa-sort = '637000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '01'.
tutyppl-usertyp   = '87'.
insert tutyppl.
tutyppl-pricelist = '02'.
tutyppl-usertyp   = '87'.
insert tutyppl.
tutyppl-pricelist = '03'.
tutyppl-usertyp   = '87'.
insert tutyppl.
tutyppl-pricelist = '04'.
tutyppl-usertyp   = '87'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = '87'.
tutyp-utyptext =
 'Sondermodul Typ 17'.
insert tutyp.
tutyp-langu = 'E'.
tutyp-usertyp = '87'.
tutyp-utyptext =
 'Special Module Type 17'.
insert tutyp.

*************************
tutypa-usertyp = '88'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = 'X'.
tutypa-sort = '638000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '01'.
tutyppl-usertyp   = '88'.
insert tutyppl.
tutyppl-pricelist = '02'.
tutyppl-usertyp   = '88'.
insert tutyppl.
tutyppl-pricelist = '03'.
tutyppl-usertyp   = '88'.
insert tutyppl.
tutyppl-pricelist = '04'.
tutyppl-usertyp   = '88'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = '88'.
tutyp-utyptext =
 'Sondermodul Typ 18'.
insert tutyp.
tutyp-langu = 'E'.
tutyp-usertyp = '88'.
tutyp-utyptext =
 'Special Module Type 18'.
insert tutyp.

*************************
tutypa-usertyp = '89'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = 'X'.
tutypa-sort = '639000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '01'.
tutyppl-usertyp   = '89'.
insert tutyppl.
tutyppl-pricelist = '02'.
tutyppl-usertyp   = '89'.
insert tutyppl.
tutyppl-pricelist = '03'.
tutyppl-usertyp   = '89'.
insert tutyppl.
tutyppl-pricelist = '04'.
tutyppl-usertyp   = '89'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = '89'.
tutyp-utyptext =
 'Sondermodul Typ 19'.
insert tutyp.
tutyp-langu = 'E'.
tutyp-usertyp = '89'.
tutyp-utyptext =
 'Special Module Type 19'.
insert tutyp.

**************************
tutypa-usertyp = '93'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '640000'.
tutypa-charge_info = 'F'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = '93'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = '93'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = '93'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = '93'.
tutyp-utyptext =
 'B2C User'.
tutyp-utyplongtext =
  'B2C User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

**************************
tutypa-usertyp = '94'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '641000'.
tutypa-charge_info = 'F'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = '94'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = '94'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = '94'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = '94'.
tutyp-utyptext =
 'SBOP Concurrent User'.
tutyp-utyplongtext =
 'SBOP Concurrent User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.
*************************

tutypa-usertyp = '95'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '642000'.
tutypa-charge_info = 'F'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = '95'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = '95'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = '95'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = '95'.
tutyp-utyptext =
 'External candidate e-recruit.'.
tutyp-utyplongtext =
  'External candidate e-recruiting'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.
**************************

tutypa-usertyp = '96'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '643000'.
tutypa-charge_info = 'F'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = '96'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = '96'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = '96'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = '96'.
tutyp-utyptext =
 'CRM Engine User'.
tutyp-utyplongtext =
  'CRM Engine User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.
**************************
**************************
tutypa-usertyp = 'BK'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '215000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'BK'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'BK'.
tutyp-utyptext =
 'mySAP ERP ESS User'.
tutyp-utyplongtext =
  'mySAP ERP ESS User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'BK'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'BK'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'BK'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = 'BK'.
law_cont-containsu = 'BN'.
insert law_cont.
law_cont-usertyp = 'BK'.
law_cont-containsu = 'FC'.
insert law_cont.

*************************
tutypa-usertyp = 'BL'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '305000'.
tutypa-charge_info = 'C'.
insert tutypa.

insert tutyppl.
tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'BL'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'BL'.
tutyp-utyptext =
 'SAP ERP Business Expert'.
tutyp-utyplongtext =
 'SAP ERP Business Expert User'.
insert tutyp.
tutyp-langu = 'E'.
tutyp-usertyp = 'BL'.
tutyp-utyptext =
 'SAP ERP Business Expert'.
tutyp-utyplongtext =
 'SAP ERP Business Expert User'.
insert tutyp.

law_cont-usertyp = 'BL'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'BL'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'BL'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = 'BL'.
law_cont-containsu = 'AX'.
insert law_cont.
law_cont-usertyp = 'BL'.
law_cont-containsu = 'AY'.
insert law_cont.
law_cont-usertyp = 'BL'.
law_cont-containsu = 'AZ'.
insert law_cont.
law_cont-usertyp = 'BL'.
law_cont-containsu = 'BK'.
insert law_cont.
law_cont-usertyp = 'BL'.
law_cont-containsu = 'BM'.
insert law_cont.
law_cont-usertyp = 'BL'.
law_cont-containsu = 'BN'.
insert law_cont.
law_cont-usertyp = 'BL'.
law_cont-containsu = 'EA'.
insert law_cont.
law_cont-usertyp = 'BL'.
law_cont-containsu = 'EB'.
insert law_cont.
law_cont-usertyp = 'BL'.
law_cont-containsu = 'EC'.
insert law_cont.
law_cont-usertyp = 'BL'.
law_cont-containsu = 'ED'.
insert law_cont.
law_cont-usertyp = 'BL'.
law_cont-containsu = 'EF'.
insert law_cont.
law_cont-usertyp = 'BL'.
law_cont-containsu = 'EG'.
insert law_cont.
law_cont-usertyp = 'BL'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = 'BL'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = 'BL'.
law_cont-containsu = 'FC'.
insert law_cont.
law_cont-usertyp = 'BL'.
law_cont-containsu = 'FM'.
insert law_cont.
law_cont-usertyp = 'BL'.
law_cont-containsu = 'FV'.
insert law_cont.
law_cont-usertyp = 'BL'.
law_cont-containsu = 'FW'.
insert law_cont.
law_cont-usertyp = 'BL'.
law_cont-containsu = 'FX'.
insert law_cont.

*************************
tutypa-usertyp = 'BM'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '306000'.
tutypa-charge_info = 'C'.
insert tutypa.

insert tutyppl.
tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'BM'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'BM'.
tutyp-utyptext =
 'SAP ERP Business Information'.
tutyp-utyplongtext =
 'SAP ERP Business Information User'.
insert tutyp.
tutyp-langu = 'E'.
tutyp-usertyp = 'BM'.
tutyp-utyptext =
 'SAP ERP Business Information'.
tutyp-utyplongtext =
 'SAP ERP Business Information User'.
insert tutyp.

law_cont-usertyp = 'BM'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'BM'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'BM'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = 'BM'.
law_cont-containsu = 'AZ'.
insert law_cont.
law_cont-usertyp = 'BM'.
law_cont-containsu = 'BK'.
insert law_cont.
law_cont-usertyp = 'BM'.
law_cont-containsu = 'BN'.
insert law_cont.
law_cont-usertyp = 'BM'.
law_cont-containsu = 'EB'.
insert law_cont.
law_cont-usertyp = 'BM'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = 'BM'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = 'BM'.
law_cont-containsu = 'FC'.
insert law_cont.

*************************
tutypa-usertyp = 'BN'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '304000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'BN'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'BN'.
tutyp-utyptext =
 'SAP ERP ESS Core User'.
tutyp-utyplongtext =
 'SAP ERP Employee Self-Service Core User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'BN'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'BN'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'BN'.
law_cont-containsu = '91'.
insert law_cont.

*************************

*************************
tutypa-usertyp = 'CA'.
tutypa-sscr_allow = 'X'.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '411000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'CA'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'CA'.
tutyp-utyptext =
 'SAP Application Developer'.
tutyp-utyplongtext =
  'SAP Application Developer'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'CA'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'CA'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'CA'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = 'CA'.
law_cont-containsu = 'CD'.
insert law_cont.
law_cont-usertyp = 'CA'.
law_cont-containsu = 'CE'.
insert law_cont.
law_cont-usertyp = 'CA'.
law_cont-containsu = 'CH'.
insert law_cont.
law_cont-usertyp = 'CA'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = 'CA'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = 'CA'.
law_cont-containsu = 'FC'.

*************************
tutypa-usertyp = 'CB'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '412000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'CB'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'CB'.
tutyp-utyptext =
 'SAP Application Professional'.
tutyp-utyplongtext =
  'SAP Application Professional'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'CB'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'CC'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'CD'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'CE'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'CG'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'CH'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'EB'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'FC'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'FD'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'FE'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'FF'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'FG'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'FH'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'FI'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'FK'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'FL'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'FM'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'FN'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'FO'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'FP'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'FR'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'FS'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'FT'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'FU'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'FV'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'FW'.
insert law_cont.
law_cont-usertyp = 'CB'.
law_cont-containsu = 'FX'.
insert law_cont.

*************************
tutypa-usertyp = 'CC'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '413000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'CC'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'CC'.
tutyp-utyptext =
 'SAP Application Limited Pro'.
tutyp-utyplongtext =
  'SAP Application Limited Professional'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'CC'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'CC'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'CC'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = 'CC'.
law_cont-containsu = 'CD'.
insert law_cont.
law_cont-usertyp = 'CC'.
law_cont-containsu = 'CE'.
insert law_cont.
law_cont-usertyp = 'CC'.
law_cont-containsu = 'CH'.
insert law_cont.
law_cont-usertyp = 'CC'.
law_cont-containsu = 'EB'.
insert law_cont.
law_cont-usertyp = 'CC'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = 'CC'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = 'CC'.
law_cont-containsu = 'FC'.
insert law_cont.
law_cont-usertyp = 'CC'.
law_cont-containsu = 'FM'.
insert law_cont.

*************************
tutypa-usertyp = 'CD'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '414000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'CD'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'CD'.
tutyp-utyptext =
 'SAP Application Employee'.
tutyp-utyplongtext =
  'SAP Application Employee'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.


law_cont-usertyp = 'CD'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'CD'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'CD'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = 'CD'.
law_cont-containsu = 'CE'.
insert law_cont.
law_cont-usertyp = 'CD'.
law_cont-containsu = 'CH'.
insert law_cont.
law_cont-usertyp = 'CD'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = 'CD'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = 'CD'.
law_cont-containsu = 'FC'.
insert law_cont.

*************************
tutypa-usertyp = 'CE'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '415000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'CE'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'CE'.
tutyp-utyptext =
 'SAP Application ESS User'.
tutyp-utyplongtext =
  'SAP Application ESS User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'CE'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'CE'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'CE'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = 'CE'.
law_cont-containsu = 'CH'.
insert law_cont.
law_cont-usertyp = 'CE'.
law_cont-containsu = 'FC'.
insert law_cont.

*************************
tutypa-usertyp = 'CF'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '416000'.
tutypa-charge_info = 'C'.
insert tutypa.

insert tutyppl.
tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'CF'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'CF'.
tutyp-utyptext =
 'SAP Appl. Business Expert'.
tutyp-utyplongtext =
 'SAP Application Business Expert User'.
insert tutyp.
tutyp-langu = 'E'.
tutyp-usertyp = 'CF'.
tutyp-utyptext =
 'SAP Appl. Business Expert'.
tutyp-utyplongtext =
 'SAP Application Business Expert User'.
insert tutyp.

law_cont-usertyp = 'CF'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'CB'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'CC'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'CD'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'CE'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'CG'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'CH'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'EA'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'EB'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'Ec'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'ED'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'EF'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'EG'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'FC'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'FD'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'FE'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'FF'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'FG'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'FH'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'FI'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'FK'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'FL'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'FM'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'FN'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'FO'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'FP'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'FR'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'FS'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'FT'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'FU'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'FV'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'FW'.
insert law_cont.
law_cont-usertyp = 'CF'.
law_cont-containsu = 'FX'.
insert law_cont.

*************************
tutypa-usertyp = 'CG'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '417000'.
tutypa-charge_info = 'C'.
insert tutypa.

insert tutyppl.
tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'CG'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'CG'.
tutyp-utyptext =
 'SAP Appl. Business Information'.
tutyp-utyplongtext =
 'SAP Application Business Information User'.
insert tutyp.
tutyp-langu = 'E'.
tutyp-usertyp = 'CG'.
tutyp-utyptext =
 'SAP Appl. Business Information'.
tutyp-utyplongtext =
 'SAP Application Business Information User'.
insert tutyp.

law_cont-usertyp = 'CG'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'CG'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'CG'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = 'CG'.
law_cont-containsu = 'CD'.
insert law_cont.
law_cont-usertyp = 'CG'.
law_cont-containsu = 'CE'.
insert law_cont.
law_cont-usertyp = 'CG'.
law_cont-containsu = 'CH'.
insert law_cont.
law_cont-usertyp = 'CG'.
law_cont-containsu = 'EB'.
insert law_cont.
law_cont-usertyp = 'CG'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = 'CG'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = 'CG'.
law_cont-containsu = 'FC'.
insert law_cont.

*************************
tutypa-usertyp = 'CH'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '418000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'CH'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'CH'.
tutyp-utyptext =
 'SAP Application ESS Core User'.
tutyp-utyplongtext =
 'SAP Application Employee Self-Service Core User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'CH'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'CH'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'CH'.
law_cont-containsu = '91'.
insert law_cont.
*************************

*************************
tutypa-usertyp = 'DB'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '451000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'DB'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'DB'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'DB'.
tutyp-utyptext =
 'SAP Platform Professional'.
tutyp-utyplongtext =
  'SAP Platform Professional'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

*************************
tutypa-usertyp = 'DC'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '452000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'DC'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'DC'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'DC'.
tutyp-utyptext =
 'SAP Platform Limited Pro'.
tutyp-utyplongtext =
  'SAP Platform Limited Professional'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

*************************
tutypa-usertyp = 'DD'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '453000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'DD'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'DD'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'DD'.
tutyp-utyptext =
 'SAP Platform Employee'.
tutyp-utyplongtext =
  'SAP Platform Employee'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

*************************
tutypa-usertyp = 'DE'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '454000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'DE'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'DE'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'DE'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'DE'.
tutyp-utyptext =
 'SAP Platform ESS User'.
tutyp-utyplongtext =
  'SAP Platform ESS User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

**************************
tutypa-usertyp = 'DF'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '455000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'DF'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'DF'.
tutyp-utyptext =
 'SAP Platform Advanced User'.
tutyp-utyplongtext =
 'SAP Platform Advanced User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

*************************
tutypa-usertyp = 'DG'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '456000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'DG'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'DG'.
tutyp-utyptext =
 'SAP Platform Extended User'.
tutyp-utyplongtext =
 'SAP Platform Extended User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

*************************
tutypa-usertyp = 'DH'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '457000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'DH'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'DH'.
tutyp-utyptext =
 'SAP Platform Standard User'.
tutyp-utyplongtext =
 'SAP Platform Standard User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

**************************
tutypa-usertyp = 'DI'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '458000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'DI'.
insert tutyppl.
tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'DI'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'DI'.
tutyp-utyptext =
 'SAP BS Platform Advanced User'.
tutyp-utyplongtext =
 'SAP Platform Advanced User - Business Suite'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

*************************
tutypa-usertyp = 'DK'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '459000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'DK'.
insert tutyppl.
tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'DK'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'DK'.
tutyp-utyptext =
 'SAP BS Platform Extended User'.
tutyp-utyplongtext =
 'SAP Platform Extended User - Business Suite'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

*************************
tutypa-usertyp = 'DL'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '460000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'DL'.
insert tutyppl.
tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'DL'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'DL'.
tutyp-utyptext =
 'SAP BS Platform Standard User'.
tutyp-utyplongtext =
 'SAP Platform Standard User - Business Suite'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

*************************
tutypa-usertyp = 'DM'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '461000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'DM'.
insert tutyppl.
tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'DM'.
insert tutyppl.
tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'DM'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'DM'.
tutyp-utyptext =
 'SAP Platform User'.
tutyp-utyplongtext =
 'SAP Platform User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.
**************************************************
tutypa-usertyp = 'DN'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '462000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'DN'.
insert tutyppl.
tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'DN'.
insert tutyppl.
tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'DN'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'DN'.
tutyp-utyptext =
 'SAP Platform User Prod. Apps'.
tutyp-utyplongtext =
 'SAP Platform User for Productivity Apps'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.
*************************
tutypa-usertyp = 'DO'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '463000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'DO'.
insert tutyppl.
tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'DO'.
insert tutyppl.
tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'DO'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'DO'.
tutyp-utyptext =
 'SAP NW Gateway User Prod. Apps'.
tutyp-utyplongtext =
 'SAP NetWeaver Gateway User for Productivity Apps'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.
*************************
*************************
tutypa-usertyp = 'FA'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '820000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'FA'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'FA'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'FA'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'FA'.
tutyp-utyptext =
 'SAP Learning User'.
tutyp-utyplongtext =
  'SAP Learning User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'FA'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'FA'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'FA'.
law_cont-containsu = '91'.
insert law_cont.

*************************
tutypa-usertyp = 'FB'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '821000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'FB'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'FB'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'FB'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'FB'.
tutyp-utyptext =
 'SAP E-Recruiting User'.
tutyp-utyplongtext =
 'SAP E-Recruiting User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'FB'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'FB'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'FB'.
law_cont-containsu = '91'.
insert law_cont.

*************************
tutypa-usertyp = 'FC'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '822000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'FC'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'FC'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'FC'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'FC'.
tutyp-utyptext =
 'SAP Human Capital Perf. Mgmt'.
tutyp-utyplongtext =
 'SAP Human Capital Performance Management User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'FC'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'FC'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'FC'.
law_cont-containsu = '91'.
insert law_cont.

*************************
tutypa-usertyp = 'FD'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '823000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'FD'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'FD'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'FD'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'FD'.
tutyp-utyptext =
 'SAP Manager Self-Service User'.
tutyp-utyplongtext =
 'SAP Manager Self-Service User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'FD'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'FD'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'FD'.
law_cont-containsu = '54'.
insert law_cont.
law_cont-usertyp = 'FD'.
law_cont-containsu = '56'.
insert law_cont.
law_cont-usertyp = 'FD'.
law_cont-containsu = '59'.
insert law_cont.
law_cont-usertyp = 'FD'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = 'FD'.
law_cont-containsu = 'AZ'.
insert law_cont.
law_cont-usertyp = 'FD'.
law_cont-containsu = 'BK'.
insert law_cont.
law_cont-usertyp = 'FD'.
law_cont-containsu = 'BN'.
insert law_cont.
law_cont-usertyp = 'FD'.
law_cont-containsu = 'CD'.
insert law_cont.
law_cont-usertyp = 'FD'.
law_cont-containsu = 'CE'.
insert law_cont.
law_cont-usertyp = 'FD'.
law_cont-containsu = 'CH'.
insert law_cont.
law_cont-usertyp = 'FD'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = 'FD'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = 'FD'.
law_cont-containsu = 'FC'.
insert law_cont.

*************************
tutypa-usertyp = 'FE'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '824000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'FE'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'FE'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'FE'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'FE'.
tutyp-utyptext =
 'SAP Retail Store User'.
tutyp-utyplongtext =
 'SAP Retail Store User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'FE'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'FE'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'FE'.
law_cont-containsu = '54'.
insert law_cont.
law_cont-usertyp = 'FE'.
law_cont-containsu = '56'.
insert law_cont.
law_cont-usertyp = 'FE'.
law_cont-containsu = '59'.
insert law_cont.
law_cont-usertyp = 'FE'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = 'FE'.
law_cont-containsu = 'AZ'.
insert law_cont.
law_cont-usertyp = 'FE'.
law_cont-containsu = 'BK'.
insert law_cont.
law_cont-usertyp = 'FE'.
law_cont-containsu = 'BN'.
insert law_cont.
law_cont-usertyp = 'FE'.
law_cont-containsu = 'CD'.
insert law_cont.
law_cont-usertyp = 'FE'.
law_cont-containsu = 'CE'.
insert law_cont.
law_cont-usertyp = 'FE'.
law_cont-containsu = 'CH'.
insert law_cont.
law_cont-usertyp = 'FE'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = 'FE'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = 'FE'.
law_cont-containsu = 'FC'.
insert law_cont.

*************************
tutypa-usertyp = 'FF'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '825000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'FF'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'FF'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'FF'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'FF'.
tutyp-utyptext =
 'SAP Shop Floor/Warehouse User'.
tutyp-utyplongtext =
 'SAP Shop Floor or Warehouse User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'FF'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'FF'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'FF'.
law_cont-containsu = '54'.
insert law_cont.
law_cont-usertyp = 'FF'.
law_cont-containsu = '56'.
insert law_cont.
law_cont-usertyp = 'FF'.
law_cont-containsu = '59'.
insert law_cont.
law_cont-usertyp = 'FF'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = 'FF'.
law_cont-containsu = 'AZ'.
insert law_cont.
law_cont-usertyp = 'FF'.
law_cont-containsu = 'BK'.
insert law_cont.
law_cont-usertyp = 'FF'.
law_cont-containsu = 'BN'.
insert law_cont.
law_cont-usertyp = 'FF'.
law_cont-containsu = 'CD'.
insert law_cont.
law_cont-usertyp = 'FF'.
law_cont-containsu = 'CE'.
insert law_cont.
law_cont-usertyp = 'FF'.
law_cont-containsu = 'CH'.
insert law_cont.
law_cont-usertyp = 'FF'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = 'FF'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = 'FF'.
law_cont-containsu = 'FC'.
insert law_cont.
law_cont-usertyp = 'FF'.
law_cont-containsu = 'FR'.
insert law_cont.

*************************
tutypa-usertyp = 'FG'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '826000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'FG'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'FG'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'FG'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'FG'.
tutyp-utyptext =
 'SAP Maintenance Worker User'.
tutyp-utyplongtext =
 'SAP Maintenance Worker User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'FG'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'FG'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'FG'.
law_cont-containsu = '54'.
insert law_cont.
law_cont-usertyp = 'FG'.
law_cont-containsu = '56'.
insert law_cont.
law_cont-usertyp = 'FG'.
law_cont-containsu = '59'.
insert law_cont.
law_cont-usertyp = 'FG'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = 'FG'.
law_cont-containsu = 'AZ'.
insert law_cont.
law_cont-usertyp = 'FG'.
law_cont-containsu = 'BK'.
insert law_cont.
law_cont-usertyp = 'FG'.
law_cont-containsu = 'BN'.
insert law_cont.
law_cont-usertyp = 'FG'.
law_cont-containsu = 'CD'.
insert law_cont.
law_cont-usertyp = 'FG'.
law_cont-containsu = 'CE'.
insert law_cont.
law_cont-usertyp = 'FG'.
law_cont-containsu = 'CH'.
insert law_cont.
law_cont-usertyp = 'FG'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = 'FG'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = 'FG'.
law_cont-containsu = 'FC'.
insert law_cont.
law_cont-usertyp = 'FG'.
law_cont-containsu = 'FR'.
insert law_cont.

*************************
tutypa-usertyp = 'FH'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '827000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'FH'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'FH'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'FH'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'FH'.
tutyp-utyptext =
 'SAP Engineering User'.
tutyp-utyplongtext =
 'SAP Engineering User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'FH'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'FH'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'FH'.
law_cont-containsu = '54'.
insert law_cont.
law_cont-usertyp = 'FH'.
law_cont-containsu = '56'.
insert law_cont.
law_cont-usertyp = 'FH'.
law_cont-containsu = '59'.
insert law_cont.
law_cont-usertyp = 'FH'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = 'FH'.
law_cont-containsu = 'AZ'.
insert law_cont.
law_cont-usertyp = 'FH'.
law_cont-containsu = 'BK'.
insert law_cont.
law_cont-usertyp = 'FH'.
law_cont-containsu = 'BN'.
insert law_cont.
law_cont-usertyp = 'FH'.
law_cont-containsu = 'CD'.
insert law_cont.
law_cont-usertyp = 'FH'.
law_cont-containsu = 'CE'.
insert law_cont.
law_cont-usertyp = 'FH'.
law_cont-containsu = 'CH'.
insert law_cont.
law_cont-usertyp = 'FH'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = 'FH'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = 'FH'.
law_cont-containsu = 'FC'.
insert law_cont.
law_cont-usertyp = 'FH'.
law_cont-containsu = 'FR'.
insert law_cont.

*************************
tutypa-usertyp = 'FI'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '828000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'FI'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'FI'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'FI'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'FI'.
tutyp-utyptext =
 'SAP PSS/Collaborator User'.
tutyp-utyplongtext =
 'SAP Procurement Self-Service and Collaborator User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'FI'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'FI'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'FI'.
law_cont-containsu = '56'.
insert law_cont.
law_cont-usertyp = 'FI'.
law_cont-containsu = '59'.
insert law_cont.
law_cont-usertyp = 'FI'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = 'FI'.
law_cont-containsu = 'BK'.
insert law_cont.
law_cont-usertyp = 'FI'.
law_cont-containsu = 'BN'.
insert law_cont.
law_cont-usertyp = 'FI'.
law_cont-containsu = 'CE'.
insert law_cont.
law_cont-usertyp = 'FI'.
law_cont-containsu = 'CH'.
insert law_cont.
law_cont-usertyp = 'FI'.
law_cont-containsu = 'FC'.
insert law_cont.

*************************
tutypa-usertyp = 'FK'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '829000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'FK'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'FK'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'FK'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'FK'.
tutyp-utyptext =
 'SAP Partner Channel User'.
tutyp-utyplongtext =
 'SAP Partner Channel User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'FK'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'FK'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'FK'.
law_cont-containsu = '91'.
insert law_cont.

*************************
tutypa-usertyp = 'FL'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '830000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'FL'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'FL'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'FL'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'FL'.
tutyp-utyptext =
 'SAP Solution Extension Ltd.'.
tutyp-utyplongtext =
 'SAP Solution Extension Limited User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'FL'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'FL'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'FL'.
law_cont-containsu = '91'.
insert law_cont.

*************************
tutypa-usertyp = 'FM'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '831000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'FM'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'FM'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'FM'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'FM'.
tutyp-utyptext =
 'SAP CRM Rapid Dep. Edit. User'.
tutyp-utyplongtext =
 'SAP CRM Rapid Deployment Edition User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'FM'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'FM'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'FM'.
law_cont-containsu = '54'.
insert law_cont.
law_cont-usertyp = 'FM'.
law_cont-containsu = '56'.
insert law_cont.
law_cont-usertyp = 'FM'.
law_cont-containsu = '59'.
insert law_cont.
law_cont-usertyp = 'FM'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = 'FM'.
law_cont-containsu = 'AZ'.
insert law_cont.
law_cont-usertyp = 'FM'.
law_cont-containsu = 'BK'.
insert law_cont.
law_cont-usertyp = 'FM'.
law_cont-containsu = 'BN'.
insert law_cont.
law_cont-usertyp = 'FM'.
law_cont-containsu = 'CD'.
insert law_cont.
law_cont-usertyp = 'FM'.
law_cont-containsu = 'CE'.
insert law_cont.
law_cont-usertyp = 'FM'.
law_cont-containsu = 'CH'.
insert law_cont.
law_cont-usertyp = 'FM'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = 'FM'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = 'FM'.
law_cont-containsu = 'FC'.
insert law_cont.

*************************
tutypa-usertyp = 'FN'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '832000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'FN'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'FN'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'FN'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'FN'.
tutyp-utyptext =
 'SAP Logistics User'.
tutyp-utyplongtext =
 'SAP Logistics User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'FN'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'FN'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'FN'.
law_cont-containsu = '54'.
insert law_cont.
law_cont-usertyp = 'FN'.
law_cont-containsu = '56'.
insert law_cont.
law_cont-usertyp = 'FN'.
law_cont-containsu = '59'.
insert law_cont.
law_cont-usertyp = 'FN'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = 'FN'.
law_cont-containsu = 'AZ'.
insert law_cont.
law_cont-usertyp = 'FN'.
law_cont-containsu = 'BK'.
insert law_cont.
law_cont-usertyp = 'FN'.
law_cont-containsu = 'BN'.
insert law_cont.
law_cont-usertyp = 'FN'.
law_cont-containsu = 'CD'.
insert law_cont.
law_cont-usertyp = 'FN'.
law_cont-containsu = 'CE'.
insert law_cont.
law_cont-usertyp = 'FN'.
law_cont-containsu = 'CH'.
insert law_cont.
law_cont-usertyp = 'FN'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = 'FN'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = 'FN'.
law_cont-containsu = 'FC'.
insert law_cont.

*************************
tutypa-usertyp = 'FO'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '832500'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'FO'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'FO'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'FO'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'FO'.
tutyp-utyptext =
 'SAP Shop Floor User'.
tutyp-utyplongtext =
 'SAP Shop Floor User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'FO'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'FO'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'FO'.
law_cont-containsu = '54'.
insert law_cont.
law_cont-usertyp = 'FO'.
law_cont-containsu = '56'.
insert law_cont.
law_cont-usertyp = 'FO'.
law_cont-containsu = '59'.
insert law_cont.
law_cont-usertyp = 'FO'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = 'FO'.
law_cont-containsu = 'AZ'.
insert law_cont.
law_cont-usertyp = 'FO'.
law_cont-containsu = 'BK'.
insert law_cont.
law_cont-usertyp = 'FO'.
law_cont-containsu = 'BN'.
insert law_cont.
law_cont-usertyp = 'FO'.
law_cont-containsu = 'CD'.
insert law_cont.
law_cont-usertyp = 'FO'.
law_cont-containsu = 'CE'.
insert law_cont.
law_cont-usertyp = 'FO'.
law_cont-containsu = 'CH'.
insert law_cont.
law_cont-usertyp = 'FO'.
law_cont-containsu = 'FR'.
insert law_cont.

*************************
tutypa-usertyp = 'FP'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '833000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'FP'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'FP'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'FP'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'FP'.
tutyp-utyptext =
 'SAP CRM User'.
tutyp-utyplongtext =
 'SAP CRM User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'FP'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'FP'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'FP'.
law_cont-containsu = '91'.
insert law_cont.

**************************
tutypa-usertyp = 'FR'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '834000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'FR'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'FR'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'FR'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'FR'.
tutyp-utyptext =
 'SAP Appl. Visualization User'.
tutyp-utyplongtext =
 'SAP Application Visualization User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'FR'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'FR'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'FR'.
law_cont-containsu = '91'.
insert law_cont.

**************************
tutypa-usertyp = 'FS'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '835000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'FS'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'FS'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'FS'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'FS'.
tutyp-utyptext =
 'SAP Appl.SA Visualization User'.
tutyp-utyplongtext =
 'SAP Application Standalone Visualization User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'FS'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'FS'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'FS'.
law_cont-containsu = '91'.
insert law_cont.

*************************
tutypa-usertyp = 'FT'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '836000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'FT'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'FT'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'FT'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'FT'.
tutyp-utyptext =
 'SAP Clinical System User'.
tutyp-utyplongtext =
 'SAP Clinical System User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'FT'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'FT'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'FT'.
law_cont-containsu = '91'.
insert law_cont.

*************************
tutypa-usertyp = 'FU'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '837000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'FU'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'FU'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'FU'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'FU'.
tutyp-utyptext =
 'SAP Health Care User'.
tutyp-utyplongtext =
 'SAP Health Care User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'FU'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'FU'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'FV'.
law_cont-containsu = '56'.
insert law_cont.
law_cont-usertyp = 'FU'.
law_cont-containsu = '59'.
insert law_cont.
law_cont-usertyp = 'FU'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = 'FU'.
law_cont-containsu = 'BK'.
insert law_cont.
law_cont-usertyp = 'FU'.
law_cont-containsu = 'BN'.
insert law_cont.
law_cont-usertyp = 'FU'.
law_cont-containsu = 'CE'.
insert law_cont.
law_cont-usertyp = 'FU'.
law_cont-containsu = 'CH'.
insert law_cont.
law_cont-usertyp = 'FU'.
law_cont-containsu = 'FT'.
insert law_cont.

*************************
tutypa-usertyp = 'FV'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '838000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'FV'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'FV'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'FV'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'FV'.
tutyp-utyptext =
 'SAP Industry Portfolio User'.
tutyp-utyplongtext =
 'SAP Industry Portfolio User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'FV'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'FV'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'FV'.
law_cont-containsu = '54'.
insert law_cont.
law_cont-usertyp = 'FV'.
law_cont-containsu = '56'.
insert law_cont.
law_cont-usertyp = 'FV'.
law_cont-containsu = '59'.
insert law_cont.
law_cont-usertyp = 'FV'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = 'FV'.
law_cont-containsu = 'AZ'.
insert law_cont.
law_cont-usertyp = 'FV'.
law_cont-containsu = 'BK'.
insert law_cont.
law_cont-usertyp = 'FV'.
law_cont-containsu = 'BN'.
insert law_cont.
law_cont-usertyp = 'FV'.
law_cont-containsu = 'CD'.
insert law_cont.
law_cont-usertyp = 'FV'.
law_cont-containsu = 'CE'.
insert law_cont.
law_cont-usertyp = 'FV'.
law_cont-containsu = 'CH'.
insert law_cont.
law_cont-usertyp = 'FV'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = 'FV'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = 'FV'.
law_cont-containsu = 'FC'.
insert law_cont.

*************************
tutypa-usertyp = 'FW'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '839000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'FW'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'FW'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'FW'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'FW'.
tutyp-utyptext =
 'SAP Project User'.
tutyp-utyplongtext =
 'SAP Project User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'FW'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'FW'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'FW'.
law_cont-containsu = '54'.
insert law_cont.
law_cont-usertyp = 'FW'.
law_cont-containsu = '56'.
insert law_cont.
law_cont-usertyp = 'FW'.
law_cont-containsu = '59'.
insert law_cont.
law_cont-usertyp = 'FW'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = 'FW'.
law_cont-containsu = 'AZ'.
insert law_cont.
law_cont-usertyp = 'FW'.
law_cont-containsu = 'BK'.
insert law_cont.
law_cont-usertyp = 'FW'.
law_cont-containsu = 'BN'.
insert law_cont.
law_cont-usertyp = 'FW'.
law_cont-containsu = 'CD'.
insert law_cont.
law_cont-usertyp = 'FW'.
law_cont-containsu = 'CE'.
insert law_cont.
law_cont-usertyp = 'FW'.
law_cont-containsu = 'CH'.
insert law_cont.
law_cont-usertyp = 'FW'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = 'FW'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = 'FW'.
law_cont-containsu = 'FC'.
insert law_cont.
law_cont-usertyp = 'FW'.
law_cont-containsu = 'FD'.
insert law_cont.

*************************
tutypa-usertyp = 'FX'.
tutypa-sscr_allow = ' '.
tutypa-active = ' '.
tutypa-sondervers = ' '.
tutypa-country = ' '.
tutypa-sort = '840000'.
tutypa-charge_info = 'C'.
insert tutypa.

tutyppl-pricelist = '02'.
tutyppl-usertyp   = 'FX'.
insert tutyppl.

tutyppl-pricelist = '03'.
tutyppl-usertyp   = 'FX'.
insert tutyppl.

tutyppl-pricelist = '04'.
tutyppl-usertyp   = 'FX'.
insert tutyppl.

tutyp-langu = 'D'.
tutyp-usertyp = 'FX'.
tutyp-utyptext =
 'SAP Worker User'.
tutyp-utyplongtext =
 'SAP Worker User'.
insert tutyp.
tutyp-langu = 'E'.
insert tutyp.

law_cont-usertyp = 'FX'.
law_cont-containsu = '04'.
insert law_cont.
law_cont-usertyp = 'FX'.
law_cont-containsu = '11'.
insert law_cont.
law_cont-usertyp = 'FX'.
law_cont-containsu = '54'.
insert law_cont.
law_cont-usertyp = 'FX'.
law_cont-containsu = '56'.
insert law_cont.
law_cont-usertyp = 'FX'.
law_cont-containsu = '59'.
insert law_cont.
law_cont-usertyp = 'FX'.
law_cont-containsu = '91'.
insert law_cont.
law_cont-usertyp = 'FX'.
law_cont-containsu = 'AZ'.
insert law_cont.
law_cont-usertyp = 'FX'.
law_cont-containsu = 'BK'.
insert law_cont.
law_cont-usertyp = 'FX'.
law_cont-containsu = 'BN'.
insert law_cont.
law_cont-usertyp = 'FX'.
law_cont-containsu = 'CD'.
insert law_cont.
law_cont-usertyp = 'FX'.
law_cont-containsu = 'CE'.
insert law_cont.
law_cont-usertyp = 'FX'.
law_cont-containsu = 'CH'.
insert law_cont.
law_cont-usertyp = 'FX'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = 'FX'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = 'FX'.
law_cont-containsu = 'FC'.
insert law_cont.

*************************
*************************
law_cont-usertyp = '51'.
law_cont-containsu = '55'.
law_cont-usertyp = '51'.
law_cont-containsu = '56'.
law_cont-usertyp = '51'.
law_cont-containsu = '57'.
law_cont-usertyp = '51'.
law_cont-containsu = '58'.
law_cont-usertyp = '51'.
law_cont-containsu = '59'.
law_cont-usertyp = '51'.
law_cont-containsu = 'AA'.
law_cont-usertyp = '51'.
law_cont-containsu = 'AB'.
law_cont-usertyp = '51'.
law_cont-containsu = 'AC'.
law_cont-usertyp = '51'.
law_cont-containsu = 'AD'.
law_cont-usertyp = '51'.
law_cont-containsu = 'AE'.
law_cont-usertyp = '51'.
law_cont-containsu = 'AF'.
law_cont-usertyp = '51'.
law_cont-containsu = 'AG'.
law_cont-usertyp = '51'.
law_cont-containsu = 'AH'.
law_cont-usertyp = '51'.
law_cont-containsu = 'AI'.
law_cont-usertyp = '51'.
law_cont-containsu = 'AK'.
law_cont-usertyp = '51'.
law_cont-containsu = 'AL'.
law_cont-usertyp = '51'.
law_cont-containsu = 'AM'.
law_cont-usertyp = '51'.
law_cont-containsu = 'AN'.
law_cont-usertyp = '51'.
law_cont-containsu = 'AO'.
law_cont-usertyp = '51'.
law_cont-containsu = 'AP'.
law_cont-usertyp = '51'.
law_cont-containsu = 'AR'.
law_cont-usertyp = '51'.
law_cont-containsu = 'AV'.
law_cont-usertyp = '51'.
law_cont-containsu = 'AW'.
law_cont-usertyp = '51'.
law_cont-containsu = 'AX'.
law_cont-usertyp = '51'.
law_cont-containsu = 'AY'.
law_cont-usertyp = '51'.
law_cont-containsu = 'AZ'.
law_cont-usertyp = '51'.
law_cont-containsu = 'BK'.
law_cont-usertyp = '52'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = '52'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = '52'.
law_cont-containsu = 'FC'.
insert law_cont.
law_cont-usertyp = '52'.
law_cont-containsu = 'FD'.
insert law_cont.
law_cont-usertyp = '52'.
law_cont-containsu = 'FE'.
insert law_cont.
law_cont-usertyp = '52'.
law_cont-containsu = 'FF'.
insert law_cont.
law_cont-usertyp = '52'.
law_cont-containsu = 'FG'.
insert law_cont.
law_cont-usertyp = '52'.
law_cont-containsu = 'FH'.
insert law_cont.
law_cont-usertyp = '52'.
law_cont-containsu = 'FI'.
insert law_cont.
law_cont-usertyp = '52'.
law_cont-containsu = 'FK'.
insert law_cont.
law_cont-usertyp = '52'.
law_cont-containsu = 'FL'.
insert law_cont.
law_cont-usertyp = '52'.
law_cont-containsu = 'FM'.
insert law_cont.
law_cont-usertyp = '52'.
law_cont-containsu = 'FN'.
insert law_cont.
law_cont-usertyp = '52'.
law_cont-containsu = 'FO'.
insert law_cont.
law_cont-usertyp = '52'.
law_cont-containsu = 'FP'.
insert law_cont.
law_cont-usertyp = '52'.
law_cont-containsu = 'FR'.
insert law_cont.
law_cont-usertyp = '52'.
law_cont-containsu = 'FS'.
insert law_cont.
law_cont-usertyp = '52'.
law_cont-containsu = 'FT'.
insert law_cont.
law_cont-usertyp = '52'.
law_cont-containsu = 'FU'.
insert law_cont.
law_cont-usertyp = '52'.
law_cont-containsu = 'FV'.
insert law_cont.
law_cont-usertyp = '52'.
law_cont-containsu = 'FW'.
insert law_cont.
law_cont-usertyp = '52'.
law_cont-containsu = 'FX'.
insert law_cont.
law_cont-usertyp = '53'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = '53'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = '53'.
law_cont-containsu = 'FC'.
insert law_cont.
law_cont-usertyp = '53'.
law_cont-containsu = 'FM'.
insert law_cont.
law_cont-usertyp = '54'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = '54'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = '54'.
law_cont-containsu = 'FC'.
insert law_cont.
law_cont-usertyp = '55'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = '55'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = '55'.
law_cont-containsu = 'FC'.
law_cont-usertyp = 'AX'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = 'AX'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = 'AX'.
law_cont-containsu = 'FC'.
insert law_cont.
law_cont-usertyp = 'AX'.
law_cont-containsu = 'FM'.
insert law_cont.
law_cont-usertyp = 'AY'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = 'AY'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = 'AY'.
law_cont-containsu = 'FC'.
insert law_cont.
law_cont-usertyp = 'AY'.
law_cont-containsu = 'FM'.
insert law_cont.
law_cont-usertyp = 'AZ'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = 'AZ'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = 'AZ'.
law_cont-containsu = 'FC'.
insert law_cont.
law_cont-usertyp = 'BA'.
law_cont-containsu = 'FA'.
insert law_cont.
law_cont-usertyp = 'BA'.
law_cont-containsu = 'FB'.
insert law_cont.
law_cont-usertyp = 'BA'.
law_cont-containsu = 'FC'.


*************************
tutyppl-pricelist = '04'.
tutyppl-usertyp   = '04'.
insert tutyppl.
*************************
tutyppl-pricelist = '04'.
tutyppl-usertyp   = '11'.
insert tutyppl.
*************************
tutyppl-pricelist = '04'.
tutyppl-usertyp   = '91'.
insert tutyppl.
*************************
tutyppl-pricelist = '04'.
tutyppl-usertyp   = '71'.
insert tutyppl.
*************************
tutyppl-pricelist = '04'.
tutyppl-usertyp   = '72'.
insert tutyppl.
*************************
tutyppl-pricelist = '04'.
tutyppl-usertyp   = '73'.
insert tutyppl.
*************************
tutyppl-pricelist = '04'.
tutyppl-usertyp   = '74'.
insert tutyppl.
*************************
tutyppl-pricelist = '04'.
tutyppl-usertyp   = '75'.
insert tutyppl.
*************************
tutyppl-pricelist = '04'.
tutyppl-usertyp   = '76'.
insert tutyppl.
*************************
tutyppl-pricelist = '04'.
tutyppl-usertyp   = '77'.
insert tutyppl.
*************************
tutyppl-pricelist = '04'.
tutyppl-usertyp   = '78'.
insert tutyppl.
*************************
tutyppl-pricelist = '04'.
tutyppl-usertyp   = '79'.
insert tutyppl.
*************************
update tutypa set sort = '640000' where usertyp = '93'.

update tutyp set utyptext = 'SAP BS Business Expert' where usertyp = '57'.
update tutyp set utyplongtext = 'SAP Business Suite Business Expert User' where usertyp = '57'.
update tutyp set utyptext = 'SAP Banking User' where usertyp = '62'.
update tutyp set utyplongtext = 'SAP Banking User' where usertyp = '62'.
