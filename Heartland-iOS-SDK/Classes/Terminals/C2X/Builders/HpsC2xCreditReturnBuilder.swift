import Foundation

@objcMembers
public class HpsC2xCreditReturnBuilder: HpsC2xBaseBuilder, GMSCreditReturnBuilder {
    public var clientTransactionId: String?
    public var amount: NSDecimalNumber?
    public var referenceNumber: String?
    public var transactionId: String?
    public var allowPartialAuth: NSNumber?
    public var cpcReq: NSNumber?
    
    public init(device: HpsC2xDevice) {
        super.init(transactionType: .creditReturn, device: device)
    }

    override public func buildRequest() -> Transaction? {
        return GMSRequestHelper.buildCreditReturnRequest(builder: self)
    }

    override public func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        return GMSResponseHelper.mapCreditReturnResponse(data, result, response)
    }
}
