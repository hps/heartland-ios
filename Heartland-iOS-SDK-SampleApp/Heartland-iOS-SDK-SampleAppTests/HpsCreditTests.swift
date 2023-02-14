//
//  HpsCreditTests.swift
//  Heartland-iOS-SDK-SampleAppTests
//

import Foundation
import XCTest
@testable import Heartland_iOS_SDK

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
        config.sdkNameVersion = ".0"
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
        return card;
    }
    
    func testSDKNameVersion() {
        
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
        
        device.transactionDelegate = self;
        builder.execute()
        
        wait(for: [expectation], timeout: 3000)
    }
    
    func expectations(response: HpsTerminalResponse) {
        guard let config = self.config else {
            XCTFail("Config is nil")
            return
        }
        guard let response = self.response else {
            XCTFail("Response is nil")
            return
        }
        XCTAssertNotNil(self.response);
        XCTAssertEqual("APPROVAL", response.deviceResponseCode);
        XCTAssertNotNil(config.sdkNameVersion);
        self.expectation.fulfill()
    }
    
    func onConnected() {
        guard let _ = self.device else {
            return
        }
        XCTAssertNotNil(self.device)
    }
    
    func onDisconnected() {
    }
    
    func onError(_ deviceError: NSError) {
    }
    
    func onBluetoothDeviceList(_ peripherals: NSMutableArray) {
        for peripheral in peripherals {
            if let device = peripheral as? HpsTerminalInfo {
                self.device?.connectDevice(device)
            }
        }
    }
}

extension HpsCreditTests: GMSTransactionDelegate {
    func onStatusUpdate(_ transactionStatus: Heartland_iOS_SDK.HpsTransactionStatus) {
    }
    
    func onConfirmAmount(_ amount: Decimal) {
    }
    
    func onConfirmApplication(_ applications: Array<GlobalMobileSDK.AID>) {
    }
    
    func onTransactionComplete(_ response: HpsTerminalResponse) {
        self.response = response;
        self.expectations(response: response)
    }
    
    func onTransactionCancelled() {
    }
    
    func onTransactionError(_ error: NSError) {
    }
}
