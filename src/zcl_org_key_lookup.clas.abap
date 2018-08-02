class ZCL_ORG_KEY_LOOKUP definition
  public
  final
  create public .

public section.

  methods READ
    importing
      !IT_P0001 type P0001
    exporting
      !EV_VDSK1 type VDSK1 .
protected section.
private section.

  constants C_EN type SPRAS value 'EN' ##NO_TEXT.
  constants C_PLVAR_01 type PLVAR value '01' ##NO_TEXT.
  constants C_ORG_TYPE type OTYPE value 'O' ##NO_TEXT.
ENDCLASS.



CLASS ZCL_ORG_KEY_LOOKUP IMPLEMENTATION.


  METHOD read.

    DATA: lv_orgtx TYPE orgtx,
          lt_p1000 TYPE STANDARD TABLE OF p1000,
          ls_p1000 TYPE p1000.

*    SELECT SINGLE orgtx FROM t527x INTO lv_orgtx
*      WHERE sprsl EQ c_en AND
*            orgeh EQ iv_orgeh.

    CALL FUNCTION 'RH_READ_INFTY_1000'
      EXPORTING
        plvar = c_plvar_01
        otype = c_org_type
        objid = it_p0001-orgeh
        begda = it_p0001-begda
        endda = it_p0001-endda
      TABLES
        i1000 = lt_p1000
*       OBJECTS                =
      EXCEPTIONS
        NOTHING_FOUND          = 1
        WRONG_CONDITION        = 2
        WRONG_PARAMETERS       = 3
        OTHERS                 = 4
      .

    IF sy-subrc EQ 0.
      LOOP AT lt_p1000 INTO ls_p1000 WHERE
        begda <= sy-datum AND
        endda >= sy-datum.
        EXIT.   "found entry so exit loop
      ENDLOOP.

      IF sy-subrc EQ 0. "found entry
        ev_vdsk1 = ls_p1000-short.
      ELSE. "no entry found matching loop where clause
        CLEAR ev_vdsk1.
      ENDIF.
    ELSE.
      "handle error
    ENDIF.

  ENDMETHOD.
ENDCLASS.
