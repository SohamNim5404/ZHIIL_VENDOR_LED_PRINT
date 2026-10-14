@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor Opening Balance'
define view entity ZI_VENDOR_OPEN_BAL
  with parameters
    P_CompanyCode : abap.char(4),
    P_Supplier    : abap.char(10),
    P_StartDate   : abap.dats

  as select from I_OperationalAcctgDocItem as a
{
  key a.CompanyCode,
  key a.Supplier,

   
  key a.CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum( a.AmountInCompanyCodeCurrency ) as OpeningBalance
}
where
      a.CompanyCode  = $parameters.P_CompanyCode
  and a.Supplier     = $parameters.P_Supplier
  and a.PostingDate < $parameters.P_StartDate

group by
  a.CompanyCode,
  a.Supplier,
  a.CompanyCodeCurrency
