//
//  HpsC2XDeviceTests.swift
//  Heartland-iOS-SDK-SampleAppTests
//

import Foundation
import XCTest
@testable import Heartland_iOS_SDK

final class HpsC2XDeviceTests: XCTestCase, HpsC2xDeviceDelegate, HpsC2xTransactionDelegate {
    
    var device: HpsC2xDevice?
    var deviceConnectionExpectation: XCTestExpectation = XCTestExpectation()
    var transactionExpectation: XCTestExpectation = XCTestExpectation()
    
    private func setupDevice() -> HpsC2xDevice? {
        let config = HpsConnectionConfig()
        config.username = ""
        config.password = ""
        config.developerID = ""
        config.versionNumber = ""
        config.licenseID = ""
        config.siteID = ""
        config.deviceID = ""
        config.connectionMode = HpsConnectionModes.TCP_IP.rawValue
        return HpsC2xDevice(config: config)
    }
    
    private func getCC() -> HpsCreditCard {
        let card = HpsCreditCard()
        card.cardNumber = "4242424242424242"
        card.expMonth = 12
        card.expYear = 2025
        card.cvv = "123"
        return card;
    }
    
    private func getAddress() -> HpsAddress {
        let address = HpsAddress()
        address.address = "1 Heartland Way"
        address.zip = "95124"
        return address
    }
    
    func testInitialize() {
        deviceConnectionExpectation = expectation(description: "test_C2X_Initialize")
        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        
        device.deviceDelegate = self
        device.transactionDelegate = self
        device.scan()
        
        waitForExpectations(timeout: 6000) { error in
            if let _ = error {
                XCTFail("Request Timed out")
                return;
            }
            XCTAssert(true, "Device Connected")
        }
    }
    
    func onConnected() {
        print("Device Connected");
        deviceConnectionExpectation.fulfill()

    }
    
    func onDisconnected() {
        print("Device Disconnected")
    }
    
    func onError(_ deviceError: NSError) {
        print("Device Error \(deviceError)")
    }
    
    func onBluetoothDeviceList(_ peripherals: NSMutableArray) {
        print("onBluetoothDeviceList");
        for peripheral in peripherals {
            if let device = peripheral as? HpsTerminalInfo {
                self.device?.connectDevice(device)
            }
        }
    }
    
    func onStatusUpdate(_ transactionStatus: Heartland_iOS_SDK.HpsTransactionStatus) {
        print("onStatusUpdate \(transactionStatus)")
    }
    
    func onConfirmAmount(_ amount: Decimal) {
        print("onConfirmAmount \(amount)")
    }
    
    func onConfirmApplication(_ applications: Array<GlobalMobileSDK.AID>) {
        print("onConfirmApplication \(applications)")
    }
    
    func onTransactionComplete(_ response: HpsTerminalResponse) {
        print("onTransactionComplete")
        transactionExpectation.fulfill()
    }
    
    func onTransactionCancelled() {
        print("onTransactionCancelled")
    }
    
    func onTransactionError(_ error: NSError) {
        print("onTransactionError \(error)")
    }
    
}
