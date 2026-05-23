*&---------------------------------------------------------------------*
*& Report ZFLIGHT_OCCUPANCY_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zflight_occupancy_report.

TABLES: sflight.

DATA: lt_sflight       TYPE TABLE OF sflight,
      ls_sflight       TYPE sflight,
      lv_status        TYPE c LENGTH 10,
      lv_occupancy     TYPE p DECIMALS 2,
      lv_total_flights TYPE i,
      lv_total_occ     TYPE p DECIMALS 2,
      lv_avg_occ       TYPE p DECIMALS 2.

PARAMETERS: p_carrid TYPE sflight-carrid.

SELECT-OPTIONS: s_date FOR sflight-fldate.

START-OF-SELECTION.

  SELECT * FROM sflight INTO TABLE lt_sflight WHERE carrid = p_carrid AND fldate IN s_date.

  WRITE: 'Flight Occupancy Report'.
  ULINE.

  WRITE: 'Airline',
         15 'Connection',
         30 'Date',
         45 'Price',
         60 'Currency',
         72 'Seats Max',
         85 'Seats Occ',
         100 'Occupancy %',
         120 'Status'.

  IF lt_sflight IS INITIAL.
    WRITE: 'No flights found for the selected criteria'.
  ELSE.
    LOOP AT lt_sflight INTO ls_sflight.

      CLEAR: lv_occupancy,
             lv_status.

      IF ls_sflight-seatsmax > 0.
        lv_occupancy = ( ls_sflight-seatsocc * 100 ) / ls_sflight-seatsmax.

        lv_total_flights = lv_total_flights + 1.

        lv_total_occ = lv_total_occ + lv_occupancy.
      ENDIF.


      IF lv_occupancy >= 80.
        lv_status = 'FULL'.
      ELSE.
        lv_status = 'AVAILABLE'.
      ENDIF.
      WRITE: / ls_sflight-carrid,
               15 ls_sflight-connid,
               30 ls_sflight-fldate,
               45 ls_sflight-price,
               60 ls_sflight-currency,
               72 ls_sflight-seatsmax,
               85 ls_sflight-seatsocc,
               100 lv_occupancy,
               120 lv_status.
    ENDLOOP.
  ENDIF.

  IF lv_total_flights > 0.
    lv_avg_occ = lv_total_occ / lv_total_flights.

  ENDIF.

  ULINE.

  WRITE: / 'Total Flights:', lv_total_flights.
  WRITE: / 'Average Occupancy:', lv_avg_occ.