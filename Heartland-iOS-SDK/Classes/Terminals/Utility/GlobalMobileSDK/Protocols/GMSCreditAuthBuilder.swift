import Foundation

@objc
public protocol GMSCreditAuthBuilder {
    var amount: NSDecimalNumber? { get set }
    var referenceNumber: String? { get set }
    var details: HpsTransactionDetails? { get set }
    var gratuity: NSDecimalNumber? { get set }
    var transactionId: String? { get set }
    var cardHolderName: String? { get set }
    var creditCard: HpsCreditCard? { get set }
    var address: HpsAddress? { get set }
    var clientTransactionId: String? { get set }
    var allowPartialAuth: NSNumber? { get set }
    var cpcReq: NSNumber? { get set }
    var autoSubstantiation: HpsAutoSubstantiation? { get set }
}
