import Foundation

@objc
public protocol GMSDeviceInterface {
    func processTransactionWithRequest(_ request: GMSBaseBuilder, withTransactionType transactionType: HpsTransactionType)
}
