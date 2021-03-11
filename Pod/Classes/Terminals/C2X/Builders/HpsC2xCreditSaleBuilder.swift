import Foundation

@objcMembers
public class HpsC2xCreditSaleBuilder : HpsC2xBaseBuilder {
    public var amount: NSDecimalNumber?
    public var referenceNumber: String?
    public var details: HpsTransactionDetails?
    public var gratuity: NSDecimalNumber?
    public var transactionId: String?
    public var cardHolderName: String?
    public var creditCard: HpsCreditCard?
    public var address: HpsAddress?
    
    public required init() {
        super.init()
        self.transactionType = .creditSale
    }
    
    public override func buildRequest() -> Transaction? {
        // Create GlobalMobileSDK tranaction model
        let total: Decimal? = self.amount as Decimal?
        let tax: Decimal? = nil
        let tip: Decimal? = self.gratuity as Decimal?
        let surcharge: Decimal? = nil
        let taxCategory: TaxCategory? = nil
        let posReferenceNumber: String? = self.referenceNumber
        let invoiceNumber: String? = self.details?.invoiceNumber
        let operatingUserId: String? = nil
        let requestMultiUseToken: Bool? = nil
        var cardData: ManualCardData? = nil

        if let cd = self.creditCard {
            cardData = ManualCardData.cardData(cardholderName: self.cardHolderName ?? "",
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

    public override func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        let resp = response as SaleResponse
        var deviceResponseCode = result.rawValue

        if let respText = resp?.gatewayResponseText {
            deviceResponseCode = respText
        }

        data.entryMethod = HpsC2xEnums.cardDataSourceTypeToString(resp?.cardDataSourceType)
        data.approvalCode = resp?.authCode
        data.maskedCardNumber = resp?.maskedPan
        data.responseText = resp?.gatewayResponseText
        data.deviceResponseCode = deviceResponseCode
        data.terminalRefNumber = resp?.posReferenceNumber
//        data.transactionType = HpsC2xEnums.transactionTypeToString(resp?.transactionType)
        data.applicationId = resp?.aid
        data.applicationName = resp?.applicationLabel
        data.cardholderName = resp?.cardholderName
        data.applicationCrytptogram = resp?.applicationCryptogram
        data.terminalVerficationResult = resp?.tvr

        if let decimalValue = resp?.tip {
            data.tipAmount = NSNumber(nonretainedObject: decimalValue)
        }

        if let decimalValue = resp?.total {
            data.transactionAmount = NSNumber(nonretainedObject: decimalValue)
        }
        
        return data
    }
}
