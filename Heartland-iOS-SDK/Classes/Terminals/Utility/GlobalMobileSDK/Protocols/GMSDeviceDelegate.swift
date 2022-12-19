import Foundation

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
