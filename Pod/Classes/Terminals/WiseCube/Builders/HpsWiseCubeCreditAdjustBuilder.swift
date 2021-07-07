import Foundation

@objcMembers
public class HpsWiseCubeCreditAdjustBuilder : HpsWiseCubeBaseBuilder, GMSCreditAdjustBuilder {
    public var amount: NSDecimalNumber?
    public var referenceNumber: String?
    public var details: HpsTransactionDetails?
    public var gratuity: NSDecimalNumber?
    public var transactionId: String?
    public var cardHolderName: String?
    public var address: HpsAddress?

    public init(device: HpsWiseCubeDevice) {
        super.init(transactionType: .creditAdjust, device: device)
    }
    
    public override func buildRequest() -> Transaction? {
        return GMSRequestHelper.buildCreditAdjustRequest(builder: self)
    }

    public override func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        return GMSResponseHelper.mapCreditAdjustResponse(data, result, response)
    }
}
