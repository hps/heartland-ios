import Foundation

@available(iOS 13.0, *)
@objcMembers
public class HpsMobyCreditCaptureBuilder: HpsMobyBaseBuilder, GMSCreditCaptureBuilder {
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
    public var preTaxAmount: NSDecimalNumber?
    
    public init(device: HpsMobyDevice) {
        super.init(transactionType: .creditCapture, device: device)
    }

    override public func buildRequest() -> Transaction? {
        return GMSRequestHelper.buildCreditCaptureRequest(builder: self)
    }

    override public func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        return GMSResponseHelper.mapCreditCaptureResponse(data, result, response)
    }
}
