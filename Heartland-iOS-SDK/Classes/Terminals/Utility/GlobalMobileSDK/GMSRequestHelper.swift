import Foundation

class GMSRequestHelper {
    public static func buildBatchCloseRequest(builder: GMSBatchCloseBuilder) -> Transaction? {
        let clientTransactionId: String? = builder.clientTransactionId
        return BatchCloseTransaction.batchClose(clientTransactionId: clientTransactionId,
                                                operatingUserId: nil)
    }

    public static func buildCreditAdjustRequest(builder: GMSCreditAdjustBuilder) -> Transaction? {
        let total: Decimal? = builder.amount as Decimal?
        let tip: Decimal? = builder.gratuity as Decimal?
        let posReferenceNumber: String? = builder.referenceNumber
        let invoiceNumber: String? = builder.details?.invoiceNumber
        let operatingUserId: String? = nil
        let transactionId: String? = builder.transactionId as String?
        let clientTransactionId: String? = builder.clientTransactionId
        let allowPartialAuth: Bool? = builder.allowPartialAuth as? Bool
        
        return TipAdjustTransaction.tipAdjust(clientTransactionId: clientTransactionId,
                                              gatewayTransactionId: transactionId ?? "",
                                              total: decimalToUint(total),
                                              tip: decimalToUint(tip),
                                              invoiceNumber: invoiceNumber,
                                              posReferenceNumber: posReferenceNumber,
                                              operatingUserId: operatingUserId,
                                              allowPartialAuth: allowPartialAuth)
    }

    static func decimalToUint(_ decimalValue: Decimal?) -> UInt? {
        guard var value = decimalValue else { return nil }
        value = value * 100
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
        var cardData: ManualCardData?
        let clientTransactionId: String? = builder.clientTransactionId
        let allowPartialAuth: Bool? = builder.allowPartialAuth as? Bool
        let cpcReq: Bool? = builder.cpcReq as? Bool
        var autoSubstantiation: GlobalMobileSDK.AutoSubstantiation? = nil
        
        if let transactionAutoSubstantiation = builder.autoSubstantiation {
            
            autoSubstantiation = transactionAutoSubstantiation.toAutoSubstantiation()
            
        }
        
        if let cd = builder.creditCard {
            cardData = ManualCardData.cardData(cardholderName: builder.cardHolderName ?? "",
                                               cardNumber: cd.cardNumber,
                                               expirationDate: "\(cd.expMonth < 10 ? "0" : "")\(cd.expMonth)\(cd.expYear)",
                                               cvv: cd.cvv,
                                               cardPresent: true,
                                               readerPresent: false,
                                               terminalType: .none)
        }

        if cardData != nil {
            return AuthTransaction.auth(clientTransactionId: clientTransactionId,
                                        total: decimalToUint(total),
                                        tax: decimalToUint(tax),
                                        tip: decimalToUint(tip),
                                        surcharge: decimalToUint(surcharge),
                                        taxCategory: taxCategory,
                                        posReferenceNumber: posReferenceNumber,
                                        invoiceNumber: invoiceNumber,
                                        operatingUserId: operatingUserId,
                                        cardData: cardData!,
                                        requestMultiUseToken: requestMultiUseToken ?? false,
                                        allowPartialAuth: allowPartialAuth,
                                        cpcReq: cpcReq,
                                        autoSubstantiation: autoSubstantiation)
        } else {
            return AuthTransaction.auth(clientTransactionId: clientTransactionId,
                                        total: decimalToUint(total),
                                        tax: decimalToUint(tax),
                                        tip: decimalToUint(tip),
                                        surcharge: decimalToUint(surcharge),
                                        taxCategory: taxCategory,
                                        posReferenceNumber: posReferenceNumber,
                                        invoiceNumber: invoiceNumber,
                                        operatingUserId: operatingUserId,
                                        requestMultiUseToken: requestMultiUseToken ?? false,
                                        allowPartialAuth: allowPartialAuth,
                                        cpcReq: cpcReq,
                                        autoSubstantiation: autoSubstantiation)
        }
    }

    public static func buildCreditCaptureRequest(builder: GMSCreditCaptureBuilder) -> Transaction? {
        let total: Decimal? = builder.amount as Decimal?
        let tip: Decimal? = builder.gratuity as Decimal?
        let posReferenceNumber: String? = builder.referenceNumber
        let operatingUserId: String? = nil
        let transactionId: String? = builder.transactionId as String?
        let clientTransactionId: String? = builder.clientTransactionId

        return CaptureTransaction.capture(clientTransactionId: clientTransactionId,
                                          gatewayTransactionId: transactionId ?? "",
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
        let clientTransactionId: String? = builder.clientTransactionId
        let allowPartialAuth: Bool? = builder.allowPartialAuth as? Bool
        
        return ReturnTransaction.returnWithReference(clientTransactionId: clientTransactionId,
                                                     total: decimalToUint(total),
                                                     tax: nil,
                                                     tip: nil,
                                                     taxCategory: nil,
                                                     gatewayTransactionId: transactionId ?? "",
                                                     posReferenceNumber: posReferenceNumber,
                                                     invoiceNumber: nil,
                                                     operatingUserId: nil,
                                                     allowPartialAuth: allowPartialAuth)
    }

    public static func buildCreditReversalRequest(builder: GMSCreditReversalBuilder) -> Transaction? {
        let total: Decimal? = builder.amount as Decimal?
        let posReferenceNumber: String? = builder.referenceNumber
        let transactionId: String? = builder.transactionId
        let reversalReason: ReversalReason = HpsC2xEnums.reversalReasonCodeToReversalReason(builder.reason)
        let allowPartialAuth: Bool? = builder.allowPartialAuth as? Bool

        if let clientTransactionId = builder.clientTransactionId {
            return ReversalTransaction.reversal(clientTransactionId: clientTransactionId,
                                                gatewayTransactionId: transactionId,
                                                reversalReason: reversalReason,
                                                posReferenceNumber: posReferenceNumber,
                                                amount: decimalToUint(total) ?? 0,
                                                tlv: nil,
                                                allowPartialAuth: allowPartialAuth)
        }

        return ReversalTransaction.reversal(clientTransactionId: nil,
                                            gatewayTransactionId: transactionId,
                                            reversalReason: reversalReason,
                                            posReferenceNumber: posReferenceNumber,
                                            amount: decimalToUint(total) ?? 0,
                                            tlv: nil,
                                            allowPartialAuth: allowPartialAuth)
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
        var cardData: ManualCardData?
        let clientTransactionId: String? = builder.clientTransactionId
        let allowPartialAuth: Bool? = builder.allowPartialAuth as? Bool
        let cpcReq: Bool? = builder.cpcReq as? Bool
        var autoSubstantiation: GlobalMobileSDK.AutoSubstantiation? = nil
        
        if let transactionAutoSubstantiation = builder.autoSubstantiation {
            
            autoSubstantiation = transactionAutoSubstantiation.toAutoSubstantiation()
            
        }
        
        if let cd = builder.creditCard {
            cardData = ManualCardData.cardData(cardholderName: builder.cardHolderName ?? "",
                                               cardNumber: cd.cardNumber,
                                               expirationDate: "\(cd.expMonth < 10 ? "0" : "")\(cd.expMonth)\(cd.expYear)",
                                               cvv: cd.cvv,
                                               cardPresent: true,
                                               readerPresent: false,
                                               terminalType: .none)
        }

        if cardData != nil {
            return SaleTransaction.sale(clientTransactionId: clientTransactionId,
                                        total: decimalToUint(total),
                                        tax: decimalToUint(tax),
                                        tip: decimalToUint(tip),
                                        surcharge: decimalToUint(surcharge),
                                        taxCategory: taxCategory,
                                        posReferenceNumber: posReferenceNumber,
                                        invoiceNumber: invoiceNumber,
                                        operatingUserId: operatingUserId,
                                        cardData: cardData!,
                                        requestMultiUseToken: requestMultiUseToken ?? false,
                                        allowPartialAuth: allowPartialAuth,
                                        cpcReq: cpcReq,
                                        autoSubstantiation: autoSubstantiation)
        } else {
            return SaleTransaction.sale(clientTransactionId: clientTransactionId,
                                        total: decimalToUint(total),
                                        tax: decimalToUint(tax),
                                        tip: decimalToUint(tip),
                                        surcharge: decimalToUint(surcharge),
                                        taxCategory: taxCategory,
                                        posReferenceNumber: posReferenceNumber,
                                        invoiceNumber: invoiceNumber,
                                        operatingUserId: operatingUserId,
                                        requestMultiUseToken: requestMultiUseToken ?? false,
                                        allowPartialAuth: allowPartialAuth,
                                        cpcReq: cpcReq,
                                        autoSubstantiation: autoSubstantiation)
        }
    }

    public static func buildCreditVoidRequest(builder: GMSCreditVoidBuilder) -> Transaction? {
        let posReferenceNumber: String? = builder.referenceNumber
        let transactionId: String? = builder.transactionId
        let clientTransactionId: String? = builder.clientTransactionId
        let allowPartialAuth: Bool? = builder.allowPartialAuth as? Bool

        return VoidTransaction.void(clientTransactionId: clientTransactionId,
                                    gatewayTransactionId: transactionId ?? "",
                                    reversalReason: ReversalReason.undefined,
                                    posReferenceNumber: posReferenceNumber,
                                    invoiceNumber: nil,
                                    operatingUserId: nil,
                                    allowPartialAuth: allowPartialAuth)
    }
}
