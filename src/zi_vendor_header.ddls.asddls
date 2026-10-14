@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor Report Header'
define view entity ZI_VENDOR_HEADER
  as select from I_Supplier as s

{
  key s.Supplier,

      s.SupplierFullName as SupplierName,
      s.StreetName,
      s.CityName,
      s.PostalCode,
      s.Country,
      s.TaxNumber3       as GSTIN

}
