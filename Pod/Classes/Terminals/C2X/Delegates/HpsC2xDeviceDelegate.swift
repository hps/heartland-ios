import Foundation

@objc
public protocol HpsC2xDeviceDelegate {
    func onConnected()
    func onDisconnected()
    func onError(_ deviceError: NSError)
    //func onTerminalInfoReceived(_ terminalInfo: HpsTerminalInfo)
    func onBluetoothDeviceList(_ peripherals: NSMutableArray)
}
