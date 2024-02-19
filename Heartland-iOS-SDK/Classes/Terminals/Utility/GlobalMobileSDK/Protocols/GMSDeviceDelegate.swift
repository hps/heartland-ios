import Foundation
import GlobalMobileSDK

@objc
public protocol GMSDeviceDelegate {
    func onConnected()
    func onDisconnected()
    func onError(_ deviceError: NSError)
    func onBluetoothDeviceList(_ peripherals: NSMutableArray)
}

@objc public protocol GMSDeviceScanObserver {
    func deviceDidUpdateScanState(to isScanning: Bool)
}

@objc public protocol GMSDeviceFirmwareUpdateDelegate {
    func onTerminalVersionDetails(info: [AnyHashable: Any]?)

    func terminalOTAResult(resultType: TerminalOTAResult,
                           info: [String: AnyObject]?,
                           error: Error?)

    func listOfVersionsFor(results: [Any]?)

    func otaUpdateProgress(percentage: Float)

    func onReturnSetTargetVersion(message: String)
}
