import Foundation

@objcMembers
public class HpsWiseCubeBatchCloseBuilder : HpsWiseCubeBaseBuilder, GMSBatchCloseBuilder {
    public init(device: HpsWiseCubeDevice) {
        super.init(transactionType: .batchClose, device: device)
    }
    
    public override func buildRequest() -> Transaction? {
        return GMSRequestHelper.buildBatchCloseRequest(builder: self)
    }
    
    public override func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        return GMSResponseHelper.mapBatchCloseResponse(data, result, response)
    }
}
