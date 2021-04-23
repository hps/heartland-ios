import Foundation

@objcMembers
public class HpsC2xCreditVoidBuilder : HpsC2xBaseBuilder, GMSCreditVoidBuilder {
    public var referenceNumber: String?
    public var transactionId: String?
    
    public init(device: HpsC2xDevice) {
        super.init(transactionType: .creditVoid, device: device)
    }
    
    public override func buildRequest() -> Transaction? {
        return GMSRequestHelper.buildCreditVoidRequest(builder: self)
    }

    public override func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        return GMSResponseHelper.mapCreditVoidResponse(data, result, response)
    }
}
