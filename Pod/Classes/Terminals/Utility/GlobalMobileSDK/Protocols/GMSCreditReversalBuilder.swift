import Foundation

@objc
public protocol GMSCreditReversalBuilder {
    var amount: NSDecimalNumber? { get set }
    var clientTransactionId: String? { get set }
    var reason: ReversalReasonCode { get set }
    var referenceNumber: String? { get set }
    var transactionId: String? { get set }
}
