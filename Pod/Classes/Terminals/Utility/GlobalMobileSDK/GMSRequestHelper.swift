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
                                              total: decimalToUint(total),
                                              tip: decimalToUint(tip),
                                              invoiceNumber: invoiceNumber,
                                              posReferenceNumber: posReferenceNumber,
                                              operatingUserId: operatingUserId)
    }
    
    static func decimalToUint(_ decimalValue: Decimal?) -> UInt? {
        guard var value = decimalValue else { return nil }
        value = value * 100;
        var rounded = Decimal()
        NSDecimalRound(&rounded, &value, 0, .down)
        return UInt((rounded as NSDecimalNumber).intValue)
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
            return AuthTransaction.auth(total: decimalToUint(total),
                                        tax: decimalToUint(tax),
                                        tip: decimalToUint(tip),
                                        surcharge: decimalToUint(surcharge),
                                        taxCategory: taxCategory,
                                        posReferenceNumber: posReferenceNumber,
                                        invoiceNumber: invoiceNumber,
                                        operatingUserId: operatingUserId,
                                        cardData: cardData!,
                                        requestMultiUseToken: requestMultiUseToken ?? false)
        } else {
            return AuthTransaction.auth(total: decimalToUint(total),
                                        tax: decimalToUint(tax),
                                        tip: decimalToUint(tip),
                                        surcharge: decimalToUint(surcharge),
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
                                          total: decimalToUint(total),
                                          tax: nil,
                                          tip: decimalToUint(tip),
                                          taxCategory: nil,
                                          invoiceNumber: nil,
                                          posReferenceNumber: posReferenceNumber,
                                          operatingUserId: operatingUserId)
    }
    
    public static func buildCreditReturnRequest(builder: GMSCreditReturnBuilder) -> Transaction? {
        let total: Decimal? = builder.amount as Decimal?
        let posReferenceNumber: String? = builder.referenceNumber
        let transactionId: String? = builder.transactionId

        return ReturnTransaction.returnWithReference(total: decimalToUint(total),
                                                     tax: nil,
                                                     tip: nil,
                                                     taxCategory: nil,
                                                     gatewayTransactionId: transactionId ?? "",
                                                     posReferenceNumber: posReferenceNumber,
                                                     invoiceNumber: nil,
                                                     operatingUserId: nil)
    }
    
    public static func buildCreditReversalRequest(builder: GMSCreditReversalBuilder) -> Transaction? {
        let total: Decimal? = builder.amount as Decimal?
        let posReferenceNumber: String? = builder.referenceNumber
        let transactionId: String? = builder.transactionId
        let reversalReason: ReversalReason = HpsC2xEnums.reversalReasonCodeToReversalReason(builder.reason)

        if let clientTransactionId = builder.clientTransactionId {
            return ReversalTransaction.reversal(clientTransactionId: clientTransactionId,
                                                gatewayTransactionId: transactionId,
                                                reversalReason: reversalReason,
                                                posReferenceNumber: posReferenceNumber,
                                                amount: decimalToUint(total) ?? 0,
                                                tlv: nil)
        }

        return ReversalTransaction.reversal(clientTransactionId: UUID(),
                                            gatewayTransactionId: transactionId,
                                            reversalReason: reversalReason,
                                            posReferenceNumber: posReferenceNumber,
                                            amount: decimalToUint(total) ?? 0,
                                            tlv: nil)
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
            return SaleTransaction.sale(total: decimalToUint(total),
                                        tax: decimalToUint(tax),
                                        tip: decimalToUint(tip),
                                        surcharge: decimalToUint(surcharge),
                                        taxCategory: taxCategory,
                                        posReferenceNumber: posReferenceNumber,
                                        invoiceNumber: invoiceNumber,
                                        operatingUserId: operatingUserId,
                                        cardData: cardData!,
                                        requestMultiUseToken: requestMultiUseToken ?? false)
        } else {
            return SaleTransaction.sale(total: decimalToUint(total),
                                        tax: decimalToUint(tax),
                                        tip: decimalToUint(tip),
                                        surcharge: decimalToUint(surcharge),
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
