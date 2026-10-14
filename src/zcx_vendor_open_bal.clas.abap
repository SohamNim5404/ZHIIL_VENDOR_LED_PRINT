CLASS zcx_vendor_open_bal DEFINITION
  PUBLIC
  INHERITING FROM cx_rap_query_provider
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS get_text REDEFINITION.
ENDCLASS.

CLASS zcx_vendor_open_bal IMPLEMENTATION.
  METHOD get_text.
    result = 'Provide one Company Code, Supplier, Start Date and company-code currency using equality filters.'.
  ENDMETHOD.
ENDCLASS.
