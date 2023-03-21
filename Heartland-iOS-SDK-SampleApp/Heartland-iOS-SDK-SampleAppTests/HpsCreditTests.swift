//
//  HpsCreditTests.swift
//  Heartland-iOS-SDK-SampleAppTests
//

import Foundation
@testable import Heartland_iOS_SDK
import XCTest

final class HpsCreditTests: XCTestCase, GMSDeviceDelegate {
    var response: HpsTerminalResponse?
    var device: HpsC2xDevice?
    var config: HpsConnectionConfig?
    let expectation = XCTestExpectation(description: "Wait for execution...")

    private func setupDevice() -> HpsC2xDevice? {
        let config = HpsConnectionConfig()
        config.username = ""
        config.password = ""
        config.developerID = ""
        config.versionNumber = ""
        config.licenseID = ""
        config.siteID = ""
        config.deviceID = ""
        config.sdkNameVersion = ""
        config.connectionMode = HpsConnectionModes.TCP_IP.rawValue
        self.config = config
        return HpsC2xDevice(config: config)
    }

    private func getCC() -> HpsCreditCard {
        let card = HpsCreditCard()
        card.cardNumber = ""
        card.expMonth = 0
        card.expYear = 0
        card.cvv = ""
        return card
    }

    func testSDKNameVersion() {
        self.device = setupDevice()

        guard let device = device else {
            XCTFail("Device is nil")
            return
        }

        device.deviceDelegate = self
        device.scan()
        let builder = HpsC2xCreditSaleBuilder(device: device)
        builder.amount = 11.97
        builder.gratuity = 0.0
        builder.creditCard = getCC()

        device.transactionDelegate = self
        builder.execute()

        wait(for: [expectation], timeout: 3000)
    }
    
    func testCPCReqFieldSetTrue() {
        
        self.device = self.setupDevice()
        
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        
        device.deviceDelegate = self
        device.scan()
        let builder = HpsC2xCreditSaleBuilder(device: device)
        builder.amount = 11.97
        builder.gratuity = 0.0
        builder.creditCard = getCC()
        builder.cpcReq = true
        
        device.transactionDelegate = self;
        builder.execute()
        
        wait(for: [expectation], timeout: 3000)
    }
    
    func testCPCReqFieldSetFalse() {
        
        self.device = self.setupDevice()
        
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        
        device.deviceDelegate = self
        device.scan()
        let builder = HpsC2xCreditSaleBuilder(device: device)
        builder.amount = 11.97
        builder.gratuity = 0.0
        builder.creditCard = getCC()
        builder.cpcReq = false
        
        device.transactionDelegate = self;
        builder.execute()
        
        wait(for: [expectation], timeout: 3000)
    }
    
    func expectations(response: HpsTerminalResponse) {
        guard let config = self.config else {
            XCTFail("Config is nil")
            return
        }
        
        XCTAssertNotNil(self.response)
        XCTAssertEqual("APPROVAL", response.deviceResponseCode)
        XCTAssertNotNil(config.sdkNameVersion)
        expectation.fulfill()
    }

    func onConnected() {
        guard let _ = device else {
            return
        }
        XCTAssertNotNil(device)
    }

    func onDisconnected() {}

    func onError(_: NSError) {}

    func onBluetoothDeviceList(_ peripherals: NSMutableArray) {
        for peripheral in peripherals {
            if let device = peripheral as? HpsTerminalInfo {
                self.device?.connectDevice(device)
            }
        }
    }
}

extension HpsCreditTests: GMSTransactionDelegate {
    func onStatusUpdate(_: Heartland_iOS_SDK.HpsTransactionStatus) {}

    func onConfirmAmount(_: Decimal) {}

    func onConfirmApplication(_: [GlobalMobileSDK.AID]) {}

    func onTransactionComplete(_ response: HpsTerminalResponse) {
        self.response = response
        expectations(response: response)
    }

    func onTransactionCancelled() {}

    func onTransactionError(_: NSError) {}
}
