import Foundation

@objcMembers
public class HpsC2xCreditReturnBuilder : HpsC2xBaseBuilder, GMSCreditReturnBuilder {
    public var amount: NSDecimalNumber?
    public var referenceNumber: String?
    public var transactionId: String?
    
    public init(device: HpsC2xDevice) {
        super.init(transactionType: .creditReturn, device: device)
    }
    
    public override func buildRequest() -> Transaction? {
        return GMSRequestHelper.buildCreditReturnRequest(builder: self)
    }

    public override func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        return GMSResponseHelper.mapCreditReturnResponse(data, result, response)
    }
}
