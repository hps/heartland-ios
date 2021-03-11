import Foundation

@objcMembers
public class HpsC2xCreditAdjustBuilder : HpsC2xBaseBuilder {
    public var amount: NSDecimalNumber?
    public var referenceNumber: String?
    public var details: HpsTransactionDetails?
    public var gratuity: NSDecimalNumber?
    public var transactionId: String?
    public var cardHolderName: String?
    public var address: HpsAddress?

    public required init() {
        super.init()
        self.transactionType = .creditAdjust
    }
    
    public override func buildRequest() -> Transaction? {
        // Create GlobalMobileSDK tranaction model
        let total: Decimal? = self.amount as Decimal?
        let tip: Decimal? = self.gratuity as Decimal?
        let posReferenceNumber: String? = self.referenceNumber
        let invoiceNumber: String? = self.details?.invoiceNumber
        let operatingUserId: String? = nil
        let transactionId: String? = self.transactionId as String?

        return TipAdjustTransaction.tipAdjust(gatewayTransactionId: transactionId ?? "",
                                              total: total,
                                              tip: tip,
                                              invoiceNumber: invoiceNumber,
                                              posReferenceNumber: posReferenceNumber,
                                              operatingUserId: operatingUserId)
    }

    public override func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        let resp = response as TipAdjustResponse
        var deviceResponseCode = result.rawValue

        if let respText = resp?.gatewayResponseText {
            deviceResponseCode = respText
        }

        data.approvalCode = resp?.authCode
        data.responseText = resp?.gatewayResponseText
        data.deviceResponseCode = deviceResponseCode

        return data
    }
}
