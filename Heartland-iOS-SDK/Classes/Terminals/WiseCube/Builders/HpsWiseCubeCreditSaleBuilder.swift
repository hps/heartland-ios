import Foundation

@objcMembers
public class HpsWiseCubeCreditSaleBuilder: HpsWiseCubeBaseBuilder, GMSCreditSaleBuilder {
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
    
    public init(device: HpsWiseCubeDevice) {
        super.init(transactionType: .creditSale, device: device)
    }

    override public func buildRequest() -> Transaction? {
        return GMSRequestHelper.buildCreditSaleRequest(builder: self)
    }

    override public func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        return GMSResponseHelper.mapCreditSaleResponse(data, result, response)
    }
}
