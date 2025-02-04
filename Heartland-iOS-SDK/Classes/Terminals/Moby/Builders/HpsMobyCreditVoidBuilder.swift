import Foundation

@available(iOS 13.0, *)
@objcMembers
public class HpsMobyCreditVoidBuilder: HpsMobyBaseBuilder, GMSCreditVoidBuilder {
    public var clientTransactionId: String?
    public var referenceNumber: String?
    public var transactionId: String?
    public var allowPartialAuth: NSNumber?
    
    public init(device: HpsMobyDevice) {
        super.init(transactionType: .creditVoid, device: device)
    }

    override public func buildRequest() -> Transaction? {
        return GMSRequestHelper.buildCreditVoidRequest(builder: self)
    }

    override public func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        return GMSResponseHelper.mapCreditVoidResponse(data, result, response)
    }
}
