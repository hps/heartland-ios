import Foundation

@objc
public protocol GMSCreditAdjustBuilder {
    var amount: NSDecimalNumber? { get set }
    var referenceNumber: String? { get set }
    var details: HpsTransactionDetails? { get set }
    var gratuity: NSDecimalNumber? { get set }
    var transactionId: String? { get set }
    var cardHolderName: String? { get set }
    var address: HpsAddress? { get set }
}
