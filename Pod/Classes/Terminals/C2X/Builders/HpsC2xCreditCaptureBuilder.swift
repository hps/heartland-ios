import Foundation

@objcMembers
public class HpsC2xCreditCaptureBuilder : HpsC2xBaseBuilder {
    public var amount: NSDecimalNumber?
    public var referenceNumber: String?
    public var gratuity: NSDecimalNumber?
    public var transactionId: String?
    
    public required init() {
        super.init()
        self.transactionType = .creditCapture
    }
    
    public override func buildRequest() -> Transaction? {
        // Create GlobalMobileSDK tranaction model
        let total: Decimal? = self.amount as Decimal?
        let tip: Decimal? = self.gratuity as Decimal?
        let posReferenceNumber: String? = self.referenceNumber
        let operatingUserId: String? = nil
        let transactionId: String? = self.transactionId as String?

        return CaptureTransaction.capture(gatewayTransactionId: transactionId ?? "",
                                          total: total,
                                          tax: nil,
                                          tip: tip,
                                          taxCategory: nil,
                                          invoiceNumber: nil,
                                          posReferenceNumber: posReferenceNumber,
                                          operatingUserId: operatingUserId)
    }

    public override func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        let resp = response as CaptureResponse
        var deviceResponseCode = result.rawValue

        if let respText = resp?.gatewayResponseText {
            deviceResponseCode = respText
        }

        data.responseText = resp?.gatewayResponseText
        data.deviceResponseCode = deviceResponseCode

        return data
    }
}
