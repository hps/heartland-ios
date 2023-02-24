import Foundation

@objc
public protocol GMSCreditReturnBuilder {
    var amount: NSDecimalNumber? { get set }
    var referenceNumber: String? { get set }
    var transactionId: String? { get set }
    var clientTransactionId: String? { get set }
    var allowPartialAuth: NSNumber? { get set }
    var cpcReq: NSNumber? { get set }
}
