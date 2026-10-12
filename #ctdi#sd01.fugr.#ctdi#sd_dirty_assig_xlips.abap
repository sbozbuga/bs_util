FUNCTION /ctdi/sd_dirty_assig_xlips.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(KOMKBV2) TYPE  KOMKBV2 OPTIONAL
*"  EXPORTING
*"     VALUE(P_SUBRC) TYPE  SY-SUBRC
*"  TABLES
*"      LT_XXXLIPS STRUCTURE  LIPS OPTIONAL
*"----------------------------------------------------------------------
* Dirty ASSIGN FuBa für die Besorgung der XLIPS-Daten bei NAST-Bedingungen
*-------------------------------------------------------------------------
* Bei serialnummernpflichtigen Materialien, erst wenn MLE die Serialnummern zurückgemeldet hat
*     bzw. wenn die Lieferung die Serialnummer enthält. (SER01, OBJK)
* ANMERKUNG:
* hier ist Kopfebene. --> die Felder MATNR, WERKS stehen auf LIPS = Positionsebene
* 1. Es muss eine Tabelle mit Prüfung aller LIPS-Positionen erstellt werden.
* 2. Ist die Lieferung schon gespeichert? Wenn nicht muss aus dem Speicher gelesen werden!
*-------------------------------------------------------------------------
* Lieferposition + SERNR daten
  DATA: BEGIN OF ls_lps,
         posnr TYPE lips-posnr,
         matnr TYPE lips-matnr,
         werks TYPE lips-werks,
         lgmng TYPE lips-lgmng, " Lager ME verwenden ...
         sernp TYPE marc-sernp,
         sernr_anzahl TYPE i,
         ok TYPE i.
  DATA: END   OF ls_lps,
        lt_lps LIKE TABLE OF ls_lps.                        "+nta130410
** der Select auf LIPS ist nicht immer sicher: es kann Änderungen geben!
* aufbauen LPS aus speicher (attempt über SAPMV50A)
  DATA: l_xlips_tabnam(30).
* aufbauen LPS aus speicher (attempt über SAPMV50A)
  l_xlips_tabnam = '(SAPMV50A)XLIPS[]'.
  FIELD-SYMBOLS: <xlips_tab> TYPE ANY.
  ASSIGN (l_xlips_tabnam) TO <xlips_tab>.
  IF sy-subrc <> 0.
    p_subrc = 4.
    RETURN.
  ENDIF.

  REFRESH: lt_xxxlips.
  lt_xxxlips[] = <xlips_tab>.

ENDFUNCTION.
