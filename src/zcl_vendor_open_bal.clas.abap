CLASS zcl_vendor_open_bal DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
ENDCLASS.


CLASS zcl_vendor_open_bal IMPLEMENTATION.

  METHOD if_rap_query_provider~select.

    DATA:
      lv_company_code TYPE ZCE_VENDOR_OPEN_BAL-CompanyCode,
      lv_supplier     TYPE ZCE_VENDOR_OPEN_BAL-Supplier,
      lv_start_date   TYPE ZCE_VENDOR_OPEN_BAL-StartDate,
      lv_currency     TYPE ZCE_VENDOR_OPEN_BAL-CompanyCodeCurrency,
      lt_result       TYPE STANDARD TABLE OF ZCE_VENDOR_OPEN_BAL
                        WITH EMPTY KEY.

    "Read the filters sent by Fiori.
    TRY.
        DATA(lt_filters) =
          io_request->get_filter( )->get_as_ranges( ).

      CATCH cx_rap_query_filter_no_range INTO DATA(lx_filter).
        RAISE EXCEPTION TYPE zcx_vendor_open_bal
          EXPORTING
            previous = lx_filter.
    ENDTRY.

    "This endpoint accepts exactly four single-value filters.
    IF lines( lt_filters ) <> 4.
      RAISE EXCEPTION TYPE zcx_vendor_open_bal.
    ENDIF.

    LOOP AT lt_filters INTO DATA(ls_filter).

      IF lines( ls_filter-range ) <> 1.
        RAISE EXCEPTION TYPE zcx_vendor_open_bal.
      ENDIF.

      DATA(ls_range) = ls_filter-range[ 1 ].

      IF ls_range-sign <> 'I'
         OR ls_range-option <> 'EQ'
         OR ls_range-low IS INITIAL.
        RAISE EXCEPTION TYPE zcx_vendor_open_bal.
      ENDIF.

      CASE ls_filter-name.
        WHEN 'COMPANYCODE'.
          lv_company_code = ls_range-low.

        WHEN 'SUPPLIER'.
          lv_supplier = ls_range-low.

        WHEN 'STARTDATE'.
          lv_start_date = ls_range-low.

        WHEN 'COMPANYCODECURRENCY'.
          lv_currency = ls_range-low.

        WHEN OTHERS.
          RAISE EXCEPTION TYPE zcx_vendor_open_bal.
      ENDCASE.

    ENDLOOP.

    IF lv_company_code IS INITIAL
       OR lv_supplier IS INITIAL
       OR lv_start_date IS INITIAL
       OR lv_currency IS INITIAL.
      RAISE EXCEPTION TYPE zcx_vendor_open_bal.
    ENDIF.

    "Build one opening-balance result.
    DATA(ls_result) = VALUE ZCE_VENDOR_OPEN_BAL(
      CompanyCode         = lv_company_code
      Supplier            = lv_supplier
      StartDate           = lv_start_date
      CompanyCodeCurrency = lv_currency
      OpeningBalance      = 0
    ).

    "Call your existing calculation CDS.
    SELECT SINGLE OpeningBalance
      FROM ZI_VENDOR_OPEN_BAL(
        P_CompanyCode = @lv_company_code,
        P_Supplier    = @lv_supplier,
        P_StartDate   = @lv_start_date
      )
      WHERE CompanyCodeCurrency = @lv_currency
      INTO @ls_result-OpeningBalance.

    "If no historical row exists, OpeningBalance stays zero.
    APPEND ls_result TO lt_result.

    "Count before pagination.
    IF io_request->is_total_numb_of_rec_requested( ).
      io_response->set_total_number_of_records( 1 ).
    ENDIF.

    IF io_request->is_data_requested( ).

      DATA(lv_offset) =
        io_request->get_paging( )->get_offset( ).

      DATA(lv_page_size) =
        io_request->get_paging( )->get_page_size( ).

      "There is only one result, so sorting cannot change its order.
      IF lv_offset > 0 OR lv_page_size = 0.
        CLEAR lt_result.
      ENDIF.

      io_response->set_data( lt_result ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
