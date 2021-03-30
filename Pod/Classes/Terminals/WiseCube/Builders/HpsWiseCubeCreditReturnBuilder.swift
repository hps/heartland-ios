import Foundation

@objcMembers
public class HpsWiseCubeCreditReturnBuilder : HpsWiseCubeBaseBuilder, GMSCreditReturnBuilder {
    public var amount: NSDecimalNumber?
    public var referenceNumber: String?
    public var transactionId: String?
    
    public required init() {
        super.init()
        self.transactionType = .creditReturn
    }
    
    public override func buildRequest() -> Transaction? {
        return GMSRequestHelper.buildCreditReturnRequest(builder: self)
    }

    public override func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        return GMSResponseHelper.mapCreditReturnResponse(data, result, response)
    }
}
