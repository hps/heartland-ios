import Foundation

@objc
public protocol GMSCreditVoidBuilder {
    var referenceNumber: String? { get set }
    var transactionId: String? { get set }
}
