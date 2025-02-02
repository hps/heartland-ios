import Foundation

@objc
public protocol IMobyDeviceInterface: GMSDeviceInterface {}

@objcMembers
public class HpsMobyBaseBuilder: GMSBaseBuilder {}

@objc
public protocol HpsMobyDeviceDelegate: GMSDeviceDelegate {}

@objc
public protocol HpsMobyTransactionDelegate: GMSTransactionDelegate {}
