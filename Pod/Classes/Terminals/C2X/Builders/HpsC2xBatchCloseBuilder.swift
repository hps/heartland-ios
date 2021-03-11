import Foundation

@objcMembers
public class HpsC2xBatchCloseBuilder : HpsC2xBaseBuilder {
    public required init() {
        super.init()
        self.transactionType = .batchClose
    }
    
    public override func buildRequest() -> Transaction? {
        return BatchCloseTransaction.batchClose(operatingUserId: nil)
    }
    
    public override func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        let resp = response as? BatchCloseResponse
        var deviceResponseCode = result.rawValue

        if let respText = resp?.gatewayResponseText {
            deviceResponseCode = respText
        }

        data.responseText = resp?.gatewayResponseText
        data.deviceResponseCode = deviceResponseCode

        return data
    }
}
