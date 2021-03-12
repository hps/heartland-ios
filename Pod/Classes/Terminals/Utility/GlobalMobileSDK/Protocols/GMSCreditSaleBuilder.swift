import Foundation

@objc
public protocol GMSCreditSaleBuilder {
    var amount: NSDecimalNumber? { get set }
    var referenceNumber: String? { get set }
    var details: HpsTransactionDetails? { get set }
    var gratuity: NSDecimalNumber? { get set }
    var transactionId: String? { get set }
    var cardHolderName: String? { get set }
    var creditCard: HpsCreditCard? { get set }
    var address: HpsAddress? { get set }
}
