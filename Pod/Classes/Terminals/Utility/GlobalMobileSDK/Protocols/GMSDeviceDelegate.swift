import Foundation

@objc
public protocol GMSDeviceDelegate {
    func onConnected()
    func onDisconnected()
    func onError(_ deviceError: NSError)
    func onBluetoothDeviceList(_ peripherals: NSMutableArray)
}
