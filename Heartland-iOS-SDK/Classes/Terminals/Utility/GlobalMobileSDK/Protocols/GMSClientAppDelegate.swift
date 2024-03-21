import Foundation
import GlobalMobileSDK

@objc
public protocol GMSClientAppDelegate {
    func searchComplete()
    func deviceConnected()
    func deviceDisconnected()
    func deviceFound(_ device: NSObject)
    func onStatus(_ status: HpsTransactionStatus)
    func requestAIDSelection(_ applications: [AID])
    func requestAmountConfirmation(_ amount: Decimal)
    func requestPostalCode(_ maskedPan: String, expiryDate: String, cardholderName: String)
    func requestSaFApproval()
    func onTransactionComplete(_ result: String, response: HpsTerminalResponse)
    func onTransactionCancelled()
    func onError(_ error: NSError)
    func onTransactionWaitingForSurchargeConfirmation(result: HpsTransactionStatus,
                                                      response: HpsTerminalResponse)
}

public protocol GMSClientTerminalOTAManagerDelegate {
    func terminalVersionDetails(info: [AnyHashable: Any]?)

    func terminalOTAResult(resultType: GlobalMobileSDK.TerminalOTAResult,
                           info: [String: AnyObject]?, error: Error?)

    func listOfVersionsFor(type: GlobalMobileSDK.TerminalOTAUpdateType, results: [Any]?)

    func otaUpdateProgress(percentage: Float)

    func onReturnSetTargetVersion(resultType: GlobalMobileSDK.TerminalOTAResult,
                                  type: GlobalMobileSDK.TerminalOTAUpdateType,
                                  message: String)
}
