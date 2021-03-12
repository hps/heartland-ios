import Foundation

@objc
public protocol GMSCreditCaptureBuilder {
    var amount: NSDecimalNumber? { get set }
    var referenceNumber: String? { get set }
    var gratuity: NSDecimalNumber? { get set }
    var transactionId: String? { get set }
}
