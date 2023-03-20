import Foundation

@objcMembers
public class HpsWiseCubeBatchCloseBuilder: HpsWiseCubeBaseBuilder, GMSBatchCloseBuilder {
    public var clientTransactionId: String?

    public init(device: HpsWiseCubeDevice) {
        super.init(transactionType: .batchClose, device: device)
    }

    override public func buildRequest() -> Transaction? {
        return GMSRequestHelper.buildBatchCloseRequest(builder: self)
    }

    override public func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        return GMSResponseHelper.mapBatchCloseResponse(data, result, response)
    }
}
