@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor Ledger Report'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_VENDOR_LED
  as select from ZI_VENDOR_LED
{
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
  key AccountingDocumentItem,
      DocumentDate,
      AccountingDocumentType,
      @EndUserText.label: 'Posting Date'
PostingDate,
      PurchasingDocument,
      Supplier,
      DocumentReferenceID,
      DocumentItemText,


      TransactionCurrency,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      WithholdingTaxAmount,

      PaymentTerms,
      PaymentTermText,
      TaxCode,
      TaxCodeText,
      WithholdingTaxPercent,
      WithholdingTaxType,
      TDSSection,


      CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      DebitAmountInCoCodeCrcy,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      CreditAmountInCoCodeCrcy
}
