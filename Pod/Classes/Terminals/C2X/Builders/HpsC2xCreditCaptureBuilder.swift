import Foundation

@objcMembers
public class HpsC2xCreditCaptureBuilder : HpsC2xBaseBuilder, GMSCreditCaptureBuilder {
    public var amount: NSDecimalNumber?
    public var referenceNumber: String?
    public var gratuity: NSDecimalNumber?
    public var transactionId: String?
    
    public init(device: HpsC2xDevice) {
        super.init(transactionType: .creditCapture, device: device)
    }
    
    public override func buildRequest() -> Transaction? {
        return GMSRequestHelper.buildCreditCaptureRequest(builder: self)
    }

    public override func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        return GMSResponseHelper.mapCreditCaptureResponse(data, result, response)
    }
}
