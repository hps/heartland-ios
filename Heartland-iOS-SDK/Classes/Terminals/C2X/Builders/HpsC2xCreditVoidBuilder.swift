import Foundation

@objcMembers
public class HpsC2xCreditVoidBuilder: HpsC2xBaseBuilder, GMSCreditVoidBuilder {
    public var clientTransactionId: String?
    public var referenceNumber: String?
    public var transactionId: String?
    public var allowPartialAuth: NSNumber?
    
    public init(device: HpsC2xDevice) {
        super.init(transactionType: .creditVoid, device: device)
    }

    override public func buildRequest() -> Transaction? {
        return GMSRequestHelper.buildCreditVoidRequest(builder: self)
    }

    override public func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        return GMSResponseHelper.mapCreditVoidResponse(data, result, response)
    }
}
