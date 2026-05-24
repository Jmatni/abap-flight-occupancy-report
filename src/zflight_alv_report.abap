*&---------------------------------------------------------------------*
*& Report zflight_alv_report
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zflight_alv_report.

TYPE-POOLS: slis.

TABLES: sflight, scarr.

TYPES: BEGIN OF ty_flight,
         carrid    TYPE sflight-carrid,
         carrname  TYPE scarr-carrname,
         connid    TYPE sflight-connid,
         fldate    TYPE sflight-fldate,
         price     TYPE sflight-price,
         currency  TYPE sflight-currency,
         seatsmax  TYPE sflight-seatsmax,
         seatsocc  TYPE sflight-seatsocc,
         occupancy TYPE p DECIMALS 2,
         status    TYPE c LENGTH 10.
TYPES: END OF ty_flight.

DATA: gt_flights TYPE TABLE OF ty_flight,
      gs_flight  TYPE ty_flight.

PARAMETERS: p_carrid TYPE sflight-carrid,
            p_filter AS CHECKBOX,
            p_minocc TYPE p DECIMALS 2 DEFAULT 80,
            p_maxocc TYPE p DECIMALS 2 DEFAULT 95.

SELECT-OPTIONS: s_date FOR sflight-fldate.

INITIALIZATION.

  s_date-sign = 'I'.
  s_date-option = 'BT'.
  s_date-low = sy-datum - 30.
  s_date-high = sy-datum.
  APPEND s_date.

START-OF-SELECTION.

  AUTHORITY-CHECK OBJECT 'S_CARRID'
   ID 'CARRID' FIELD p_carrid
   ID 'ACTVT' FIELD '03'.
  IF sy-subrc <> 0.
    MESSAGE 'No authorization for this airline' TYPE 'E'.
  ENDIF.


  PERFORM get_data.
  PERFORM process_data.

  IF gt_flights IS INITIAL.
    MESSAGE 'No flights found for selected criteria' TYPE 'I'.
    EXIT.
  ENDIF.

  PERFORM display_alv.

FORM get_data.
  SELECT a~carrid
    b~carrname
    a~connid
    a~fldate
    a~price
    a~currency
    a~seatsmax
    a~seatsocc
    INTO CORRESPONDING FIELDS OF TABLE gt_flights
    FROM sflight AS a INNER JOIN scarr AS b ON a~carrid = b~carrid
    WHERE a~carrid = p_carrid AND a~fldate IN s_date.
ENDFORM.

FORM process_data.
  LOOP AT gt_flights INTO gs_flight.

    CLEAR: gs_flight-occupancy,
           gs_flight-status.

    IF gs_flight-seatsmax > 0.
      gs_flight-occupancy = ( gs_flight-seatsocc * 100 ) / gs_flight-seatsmax.
    ENDIF.

    IF gs_flight-occupancy >= 80.
      gs_flight-status = 'FULL'.
    ELSE.
      gs_flight-status = 'AVAILABLE'.
    ENDIF.

    MODIFY gt_flights FROM gs_flight.

  ENDLOOP.

  IF p_filter = 'X'.
    DELETE gt_flights WHERE occupancy < p_minocc OR occupancy > p_maxocc.
  ENDIF.

ENDFORM.

FORM display_alv.

  DATA: gt_fieldcat TYPE slis_t_fieldcat_alv,
        gs_fieldcat TYPE slis_fieldcat_alv,
        gs_layout   TYPE slis_layout_alv.

  gs_layout-zebra = 'X'.
  gs_layout-colwidth_optimize = 'X'.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'CARRID'.
  gs_fieldcat-seltext_m = 'Airline'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'CARRNAME'.
  gs_fieldcat-seltext_m = 'Airline Name'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'CONNID'.
  gs_fieldcat-seltext_m = 'Connection'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'FLDATE'.
  gs_fieldcat-seltext_m = 'Flight Date'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'PRICE'.
  gs_fieldcat-seltext_m = 'Price'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'CURRENCY'.
  gs_fieldcat-seltext_m = 'Currency'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'SEATSMAX'.
  gs_fieldcat-seltext_m = 'Max Seats'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'SEATSOCC'.
  gs_fieldcat-seltext_m = 'Occupied Seats'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'OCCUPANCY'.
  gs_fieldcat-seltext_m = 'Occupancy %'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'STATUS'.
  gs_fieldcat-seltext_m = 'Status'.
  APPEND gs_fieldcat TO gt_fieldcat.



  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_grid_title  = 'Flight Occupancy Analysis Report'
      is_layout     = gs_layout
      it_fieldcat   = gt_fieldcat
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab      = gt_flights
    EXCEPTIONS
      program_error = 1
      OTHERS        = 2.
  IF sy-subrc <> 0.
    MESSAGE 'Error displaying ALV report' TYPE 'E'.
  ENDIF.


ENDFORM.