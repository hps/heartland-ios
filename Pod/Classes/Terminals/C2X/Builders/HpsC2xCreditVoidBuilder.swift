import Foundation

@objcMembers
public class HpsC2xCreditVoidBuilder : HpsC2xBaseBuilder {
    public var referenceNumber: String?
    public var transactionId: String?
    
    public required init() {
        super.init()
        self.transactionType = .creditVoid
    }
    
    public override func buildRequest() -> Transaction? {
        // Create GlobalMobileSDK tranaction model
        let posReferenceNumber: String? = self.referenceNumber
        let transactionId: String? = self.transactionId

        return VoidTransaction.void(gatewayTransactionId: transactionId ?? "",
                                    reversalReason: ReversalReason.undefined,
                                    posReferenceNumber: posReferenceNumber,
                                    invoiceNumber: nil,
                                    operatingUserId: nil)
    }

    public override func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        let resp = response as VoidResponse
        var deviceResponseCode = result.rawValue

        if let respText = resp?.gatewayResponseText {
            deviceResponseCode = respText
        }

        data.approvalCode = resp?.authCode
        data.responseText = resp?.gatewayResponseText
        data.deviceResponseCode = deviceResponseCode
        data.terminalRefNumber = resp?.posReferenceNumber
//        data.transactionType = HpsC2xEnums.transactionTypeToString(resp?.transactionType)

        return data
    }
}
