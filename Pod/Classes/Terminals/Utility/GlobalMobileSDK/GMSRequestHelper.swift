import Foundation

class GMSRequestHelper {
    public static func buildBatchCloseRequest(builder: GMSBatchCloseBuilder) -> Transaction? {
        return BatchCloseTransaction.batchClose(operatingUserId: nil)
    }
    
    public static func buildCreditAdjustRequest(builder: GMSCreditAdjustBuilder) -> Transaction? {
        let total: Decimal? = builder.amount as Decimal?
        let tip: Decimal? = builder.gratuity as Decimal?
        let posReferenceNumber: String? = builder.referenceNumber
        let invoiceNumber: String? = builder.details?.invoiceNumber
        let operatingUserId: String? = nil
        let transactionId: String? = builder.transactionId as String?

        return TipAdjustTransaction.tipAdjust(gatewayTransactionId: transactionId ?? "",
                                              total: total,
                                              tip: tip,
                                              invoiceNumber: invoiceNumber,
                                              posReferenceNumber: posReferenceNumber,
                                              operatingUserId: operatingUserId)
    }
    
    public static func buildCreditAuthRequest(builder: GMSCreditAuthBuilder) -> Transaction? {
        let total: Decimal? = builder.amount as Decimal?
        let tax: Decimal? = nil
        let tip: Decimal? = builder.gratuity as Decimal?
        let surcharge: Decimal? = nil
        let taxCategory: TaxCategory? = nil
        let posReferenceNumber: String? = builder.referenceNumber
        let invoiceNumber: String? = builder.details?.invoiceNumber
        let operatingUserId: String? = nil
        let requestMultiUseToken: Bool? = nil
        var cardData: ManualCardData? = nil

        if let cd = builder.creditCard {
            cardData = ManualCardData.cardData(cardholderName: builder.cardHolderName ?? "",
                                               cardNumber: cd.cardNumber,
                                               expirationDate: "\(cd.expMonth)\(cd.expYear)",
                                               cvv: cd.cvv,
                                               cardPresent: true,
                                               readerPresent: false,
                                               terminalType: .none)
        }

        if cardData != nil {
            return AuthTransaction.auth(total: total,
                                        tax: tax,
                                        tip: tip,
                                        surcharge: surcharge,
                                        taxCategory: taxCategory,
                                        posReferenceNumber: posReferenceNumber,
                                        invoiceNumber: invoiceNumber,
                                        operatingUserId: operatingUserId,
                                        cardData: cardData!,
                                        requestMultiUseToken: requestMultiUseToken ?? false)
        } else {
            return AuthTransaction.auth(total: total,
                                        tax: tax,
                                        tip: tip,
                                        surcharge: surcharge,
                                        taxCategory: taxCategory,
                                        posReferenceNumber: posReferenceNumber,
                                        invoiceNumber: invoiceNumber,
                                        operatingUserId: operatingUserId,
                                        requestMultiUseToken: requestMultiUseToken ?? false)
        }
    }
    
    public static func buildCreditCaptureRequest(builder: GMSCreditCaptureBuilder) -> Transaction? {
        let total: Decimal? = builder.amount as Decimal?
        let tip: Decimal? = builder.gratuity as Decimal?
        let posReferenceNumber: String? = builder.referenceNumber
        let operatingUserId: String? = nil
        let transactionId: String? = builder.transactionId as String?

        return CaptureTransaction.capture(gatewayTransactionId: transactionId ?? "",
                                          total: total,
                                          tax: nil,
                                          tip: tip,
                                          taxCategory: nil,
                                          invoiceNumber: nil,
                                          posReferenceNumber: posReferenceNumber,
                                          operatingUserId: operatingUserId)
    }
    
    public static func buildCreditReturnRequest(builder: GMSCreditReturnBuilder) -> Transaction? {
        let total: Decimal? = builder.amount as Decimal?
        let posReferenceNumber: String? = builder.referenceNumber
        let transactionId: String? = builder.transactionId

        return ReturnTransaction.returnWithReference(total: total,
                                                     tax: nil,
                                                     tip: nil,
                                                     taxCategory: nil,
                                                     gatewayTransactionId: transactionId ?? "",
                                                     posReferenceNumber: posReferenceNumber,
                                                     invoiceNumber: nil,
                                                     operatingUserId: nil)
    }
    
    public static func buildCreditSaleRequest(builder: GMSCreditSaleBuilder) -> Transaction? {
        let total: Decimal? = builder.amount as Decimal?
        let tax: Decimal? = nil
        let tip: Decimal? = builder.gratuity as Decimal?
        let surcharge: Decimal? = nil
        let taxCategory: TaxCategory? = nil
        let posReferenceNumber: String? = builder.referenceNumber
        let invoiceNumber: String? = builder.details?.invoiceNumber
        let operatingUserId: String? = nil
        let requestMultiUseToken: Bool? = nil
        var cardData: ManualCardData? = nil

        if let cd = builder.creditCard {
            cardData = ManualCardData.cardData(cardholderName: builder.cardHolderName ?? "",
                                               cardNumber: cd.cardNumber,
                                               expirationDate: "\(cd.expMonth)\(cd.expYear)",
                                               cvv: cd.cvv,
                                               cardPresent: true,
                                               readerPresent: false,
                                               terminalType: .none)
        }

        if cardData != nil {
            return SaleTransaction.sale(total: total,
                                        tax: tax,
                                        tip: tip,
                                        surcharge: surcharge,
                                        taxCategory: taxCategory,
                                        posReferenceNumber: posReferenceNumber,
                                        invoiceNumber: invoiceNumber,
                                        operatingUserId: operatingUserId,
                                        cardData: cardData!,
                                        requestMultiUseToken: requestMultiUseToken ?? false)
        } else {
            return SaleTransaction.sale(total: total,
                                        tax: tax,
                                        tip: tip,
                                        surcharge: surcharge,
                                        taxCategory: taxCategory,
                                        posReferenceNumber: posReferenceNumber,
                                        invoiceNumber: invoiceNumber,
                                        operatingUserId: operatingUserId,
                                        requestMultiUseToken: requestMultiUseToken ?? false)
        }
    }
    
    public static func buildCreditVoidRequest(builder: GMSCreditVoidBuilder) -> Transaction? {
        let posReferenceNumber: String? = builder.referenceNumber
        let transactionId: String? = builder.transactionId

        return VoidTransaction.void(gatewayTransactionId: transactionId ?? "",
                                    reversalReason: ReversalReason.undefined,
                                    posReferenceNumber: posReferenceNumber,
                                    invoiceNumber: nil,
                                    operatingUserId: nil)
    }
}
