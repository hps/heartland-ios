import Foundation

@objcMembers
public class HpsC2xBatchCloseBuilder: HpsC2xBaseBuilder, GMSBatchCloseBuilder {
    public var clientTransactionId: String?

    public init(device: HpsC2xDevice) {
        super.init(transactionType: .batchClose, device: device)
    }

    override public func buildRequest() -> Transaction? {
        return GMSRequestHelper.buildBatchCloseRequest(builder: self)
    }

    override public func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        return GMSResponseHelper.mapBatchCloseResponse(data, result, response)
    }
}
