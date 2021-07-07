import Foundation

@objcMembers
public class HpsWiseCubeCreditVoidBuilder : HpsWiseCubeBaseBuilder, GMSCreditVoidBuilder {
    public var referenceNumber: String?
    public var transactionId: String?
    
    public init(device: HpsWiseCubeDevice) {
        super.init(transactionType: .creditVoid, device: device)
    }
    
    public override func buildRequest() -> Transaction? {
        return GMSRequestHelper.buildCreditVoidRequest(builder: self)
    }

    public override func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        return GMSResponseHelper.mapCreditVoidResponse(data, result, response)
    }
}
