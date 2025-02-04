import Foundation

@available(iOS 13.0, *)
@objcMembers
public class HpsMobyCreditAdjustBuilder : HpsMobyBaseBuilder, GMSCreditAdjustBuilder {
    
    public var clientTransactionId: String?
    public var amount: NSDecimalNumber?
    public var referenceNumber: String?
    public var details: HpsTransactionDetails?
    public var gratuity: NSDecimalNumber?
    public var transactionId: String?
    public var cardHolderName: String?
    public var address: HpsAddress?
    public var allowPartialAuth: NSNumber?
    public var cpcReq: NSNumber?
    public var surchargeFee: NSDecimalNumber?
    public var isSurchargeEnabled: NSNumber?

    public init(device: HpsMobyDevice) {
        super.init(transactionType: .creditAdjust, device: device)
    }

    override public func buildRequest() -> Transaction? {
        return GMSRequestHelper.buildCreditAdjustRequest(builder: self)
    }

    override public func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        return GMSResponseHelper.mapCreditAdjustResponse(data, result, response)
    }
}
