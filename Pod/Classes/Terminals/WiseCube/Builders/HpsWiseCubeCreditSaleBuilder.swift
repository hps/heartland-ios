import Foundation

@objcMembers
public class HpsWiseCubeCreditSaleBuilder : HpsWiseCubeBaseBuilder, GMSCreditSaleBuilder {
    public var amount: NSDecimalNumber?
    public var referenceNumber: String?
    public var details: HpsTransactionDetails?
    public var gratuity: NSDecimalNumber?
    public var transactionId: String?
    public var cardHolderName: String?
    public var creditCard: HpsCreditCard?
    public var address: HpsAddress?
    
    public init(device: HpsWiseCubeDevice) {
        super.init(transactionType: .creditSale, device: device)
    }
    
    public override func buildRequest() -> Transaction? {
        return GMSRequestHelper.buildCreditSaleRequest(builder: self)
    }

    public override func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        return GMSResponseHelper.mapCreditSaleResponse(data, result, response)
    }
}
