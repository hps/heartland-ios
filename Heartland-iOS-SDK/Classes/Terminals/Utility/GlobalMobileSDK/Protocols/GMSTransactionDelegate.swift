import Foundation

@objc
public protocol GMSTransactionDelegate {
    func onStatusUpdate(_ transactionStatus: HpsTransactionStatus)
    func onConfirmAmount(_ amount: Decimal)
    func onConfirmApplication(_ applications: Array<AID>)
    func onTransactionComplete(_ response: HpsTerminalResponse)
    func onTransactionCancelled()
    func onTransactionError(_ error: NSError)
}
