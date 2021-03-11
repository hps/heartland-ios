//
//  HpsC2xDevice.swift
//  Heartland-iOS-SDK
//
//  Created by Shane Logsdon on 2/7/21.
//

import Foundation

@objcMembers
public class HpsC2xDevice: NSObject, GMSClientAppDelegate, IC2xDeviceInterface {
    public var config: HpsConnectionConfig?
    public var gmsWrapper: GMSWrapper?
    public var deviceDelegate: HpsC2xDeviceDelegate?
    public var transactionDelegate: HpsC2xTransactionDelegate?
    public var peripherals: NSMutableArray?
    
    public required override init() {
        super.init()
        self.peripherals = NSMutableArray()
    }
    
    public static func initWithConfig(_ config: HpsConnectionConfig) -> Self {
        let result = self.init()
        result.config = config
        return result
    }
    
    public func initialize() {
        guard let config = self.config else { return }
        self.gmsWrapper = GMSWrapper(GMSConfiguration.fromHpsConnectionConfig(config), delegate:self)
        self.scan()
    }
    
    public func scan() {
        if let wrapper = self.gmsWrapper {
            wrapper.searchDevices()
        }
    }

    public func stopScan() {
        if let wrapper = self.gmsWrapper {
            wrapper.cancelSearch()
        }
    }
    public func getDeviceInfo() {}
    public func connectDevice(_ device: HpsTerminalInfo) {
        if let wrapper = self.gmsWrapper {
            wrapper.connectDevice(device)
        }
    }
    public func processTransactionWithRequest(_ builder: HpsC2xBaseBuilder, withTransactionType transactionType: HpsTransactionType) {
        if let wrapper = self.gmsWrapper {
            wrapper.startTransaction(builder, withTransactionType: transactionType)
        }
    }
    public func confirmAmount(_ amount: Decimal) {
        if let wrapper = self.gmsWrapper {
            wrapper.confirmAmount(amount: amount)
        }
    }
    public func confirmApplication(_ application: AID) {
        if let wrapper = self.gmsWrapper {
            wrapper.selectAID(aid: application)
        }
    }

    // mark: GMSClientAppDelegate

    public func deviceConnected() {
        self.deviceDelegate?.onConnected() //:(HpsTerminalInfo *)terminalInfo];
    }

    public func deviceDisconnected() {
        self.deviceDelegate?.onDisconnected()
    }

    public func searchComplete() {
        self.deviceDelegate?.onBluetoothDeviceList(self.peripherals ?? [])
    }

    public func deviceFound(_ device: NSObject) {
        if let peripherals = self.peripherals {
            peripherals.add(device)
        }
    }

    public func onStatus(_ status: HpsTransactionStatus) {
        self.transactionDelegate?.onStatusUpdate(status)
    }


    public func onTransactionCancelled() {
        self.transactionDelegate?.onTransactionCancelled()
    }


    public func onTransactionComplete(_ result: String, response: HpsTerminalResponse) {
        self.transactionDelegate?.onTransactionComplete(response)
    }


    public func requestAIDSelection(_ applications: Array<AID>) {
        self.transactionDelegate?.onConfirmAID(applications)
    }


    public func requestAmountConfirmation(_ amount: Decimal) {
        self.transactionDelegate?.onConfirmAmount(amount)
    }


    public func requestPostalCode(_ maskedPan: String, expiryDate: String, cardholderName: String) {
    }


    public func requestSaFApproval() {
    }

    public func onError(_ error: NSError) {
        self.transactionDelegate?.onError(error)
    }
}
