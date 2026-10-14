@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface Vendor Ledger'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_VENDOR_LED
  as select from    I_OperationalAcctgDocItem as a

    left outer join I_AccountingDocumentJournal(
                    P_Language: 'E'
                    )                         as j   on  a.CompanyCode            = j.CompanyCode
                                                     and a.FiscalYear             = j.FiscalYear
                                                     and a.AccountingDocument     = j.AccountingDocument
                                                     and a.AccountingDocumentItem = j.AccountingDocumentItem
                                                     and j.Ledger                 = '0L'

    left outer join I_Withholdingtaxitem      as c   on  a.CompanyCode            = c.CompanyCode
                                                     and a.FiscalYear             = c.FiscalYear
                                                     and a.AccountingDocument     = c.AccountingDocument
                                                     and a.AccountingDocumentItem = c.AccountingDocumentItem

    left outer join I_PaymentTermsText        as PT  on  a.PaymentTerms = PT.PaymentTerms
                                                     and PT.Language    = 'E'

    left outer join I_TaxCode                 as TC  on a.TaxCode = TC.TaxCode

    left outer join I_TaxCodeText             as TT  on  TC.TaxCalculationProcedure = TT.TaxCalculationProcedure
                                                     and TC.TaxCode                 = TT.TaxCode
                                                     and TT.Language                = 'E'

    left outer join ZI_TDS_SECTION_VH         as SEC on c.GLAccount = SEC.GLAccount

{
  key a.CompanyCode,
  key a.FiscalYear,
  key a.AccountingDocument,
  key a.AccountingDocumentItem,
      a.DocumentDate,
      a.AccountingDocumentType,
      a.PostingDate,
      a.PurchasingDocument,
      a.Supplier,
      j.DocumentReferenceID,
      a.DocumentItemText,
      a.TransactionCurrency,
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      a.WithholdingTaxAmount,
      a.PaymentTerms,
      a.TaxCode,
      PT.PaymentTermsName as PaymentTermText,
      TT.TaxCodeName      as TaxCodeText,
      c.WithholdingTaxPercent,
      c.WithholdingTaxType,
      SEC.TDSSection      as TDSSection,
      j.CompanyCodeCurrency,
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      j.DebitAmountInCoCodeCrcy,
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      j.CreditAmountInCoCodeCrcy,
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      a.AmountInCompanyCodeCurrency

}
where
  a.FinancialAccountType = 'K'
