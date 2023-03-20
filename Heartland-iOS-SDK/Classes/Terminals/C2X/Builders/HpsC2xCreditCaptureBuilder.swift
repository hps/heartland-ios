import Foundation
import GlobalMobileSDK

@objcMembers
public class HpsC2xCreditCaptureBuilder: HpsC2xBaseBuilder, GMSCreditCaptureBuilder {
    public var clientTransactionId: String?
    public var amount: NSDecimalNumber?
    public var referenceNumber: String?
    public var gratuity: NSDecimalNumber?
    public var transactionId: String?

    public init(device: HpsC2xDevice) {
        super.init(transactionType: .creditCapture, device: device)
    }

    override public func buildRequest() -> Transaction? {
        return GMSRequestHelper.buildCreditCaptureRequest(builder: self)
    }

    override public func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        return GMSResponseHelper.mapCreditCaptureResponse(data, result, response)
    }
}
