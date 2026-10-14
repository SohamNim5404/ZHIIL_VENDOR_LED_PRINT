@EndUserText.label: 'Vendor Opening Balance Request'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_VENDOR_OPEN_BAL'
define custom entity ZCE_VENDOR_OPEN_BAL
{
  key CompanyCode : abap.char(4);
  key Supplier    : abap.char(10);
  key StartDate   : abap.dats;

      @Semantics.currencyCode: true
  key CompanyCodeCurrency : abap.cuky(5);

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      OpeningBalance : abap.curr(23,2);
}
