import Foundation

@available(iOS 13.0, *)
@objcMembers
public class HpsMobyCreditAuthBuilder: HpsMobyBaseBuilder, GMSCreditAuthBuilder {
    public var clientTransactionId: String?
    public var amount: NSDecimalNumber?
    public var referenceNumber: String?
    public var details: HpsTransactionDetails?
    public var gratuity: NSDecimalNumber?
    public var transactionId: String?
    public var cardHolderName: String?
    public var creditCard: HpsCreditCard?
    public var address: HpsAddress?
    public var allowPartialAuth: NSNumber?
    public var cpcReq: NSNumber?
    public var autoSubstantiation: HpsAutoSubstantiation?
    public var isSurchargeEnabled: NSNumber?
    public var allowDuplicates: NSNumber?
    public var surchargeFee: NSDecimalNumber?
    
    public init(device: HpsMobyDevice) {
        super.init(transactionType: .creditAuth, device: device)
    }

    override public func buildRequest() -> Transaction? {
        return GMSRequestHelper.buildCreditAuthRequest(builder: self)
    }

    override public func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        return GMSResponseHelper.mapCreditAuthResponse(data, result, response)
    }
}
