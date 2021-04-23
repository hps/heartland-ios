import Foundation

@objcMembers
public class HpsWiseCubeCreditCaptureBuilder : HpsWiseCubeBaseBuilder, GMSCreditCaptureBuilder {
    public var amount: NSDecimalNumber?
    public var referenceNumber: String?
    public var gratuity: NSDecimalNumber?
    public var transactionId: String?
    
    public init(device: HpsWiseCubeDevice) {
        super.init(transactionType: .creditCapture, device: device)
    }
    
    public override func buildRequest() -> Transaction? {
        return GMSRequestHelper.buildCreditCaptureRequest(builder: self)
    }

    public override func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        return GMSResponseHelper.mapCreditCaptureResponse(data, result, response)
    }
}
