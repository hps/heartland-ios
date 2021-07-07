import Foundation

@objcMembers
public class HpsC2xCreditAuthBuilder : HpsC2xBaseBuilder, GMSCreditAuthBuilder {
    public var amount: NSDecimalNumber?
    public var referenceNumber: String?
    public var details: HpsTransactionDetails?
    public var gratuity: NSDecimalNumber?
    public var transactionId: String?
    public var cardHolderName: String?
    public var creditCard: HpsCreditCard?
    public var address: HpsAddress?
    
    public init(device: HpsC2xDevice) {
        super.init(transactionType: .creditAuth, device: device)
    }
    
    public override func buildRequest() -> Transaction? {
        return GMSRequestHelper.buildCreditAuthRequest(builder: self)
    }

    public override func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        return GMSResponseHelper.mapCreditAuthResponse(data, result, response)
    }
}
