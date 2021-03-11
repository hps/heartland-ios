import Foundation

@objc
public protocol HpsC2xTransactionDelegate {
    func onStatusUpdate(_ transactionStatus: HpsTransactionStatus)
    func onConfirmAmount(_ amount: Decimal)
    func onConfirmApplication(_ applications: Array<AID>)
//    func onCardholderInteractionRequested(_ request: HpsCardholderInteractionRequest)
    func onTransactionComplete(_ response: HpsTerminalResponse)
    func onTransactionCancelled()
    func onError(_ error: NSError)
}


