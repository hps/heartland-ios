import Foundation

@objcMembers
public class HpsC2xCreditSaleBuilder: HpsC2xBaseBuilder, GMSCreditSaleBuilder {
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
    public var surchargeFee: NSDecimalNumber? {
        get {
            return _surchargeFee
        }
        set {
            guard let newValue = newValue else {
                _surchargeFee = nil
                return
            }
            
            var fee = Decimal(newValue.doubleValue)
            var roundedFee = Decimal()
            NSDecimalRound(&roundedFee, &fee, 2, .bankers)

            _surchargeFee = NSDecimalNumber(decimal: roundedFee)
        }
    }
    private var _surchargeFee: NSDecimalNumber?

    public var allowDuplicates: NSNumber?
    
    public init(device: HpsC2xDevice) {
        super.init(transactionType: .creditSale, device: device)
    }

    override public func buildRequest() -> Transaction? {
        return GMSRequestHelper.buildCreditSaleRequest(builder: self)
    }

    override public func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        return GMSResponseHelper.mapCreditSaleResponse(data, result, response)
    }
}
