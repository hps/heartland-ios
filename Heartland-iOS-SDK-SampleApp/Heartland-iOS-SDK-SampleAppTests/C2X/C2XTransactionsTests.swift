//
//  C2XTransactionsTests.swift
//  Heartland-iOS-SDK-SampleAppTests
//

import XCTest
@testable import Heartland_iOS_SDK

final class C2XTransactionsTests: XCTestCase {

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
        card.cardNumber = ""
        card.expMonth = 0
        card.expYear = 0
        card.cvv = ""
        return card;
    }
    
    private func getAutoSubstantiation() -> HpsAutoSubstantiation {
        let autoSubs = HpsAutoSubstantiation()
        autoSubs.setClinicSubTotal(NSDecimalNumber(string: "12.00"))
        
        return autoSubs
    }

    
    func testReversalTimeout() {
        let expectation = XCTestExpectation(description: "testReversalTimeout")

        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        
        device.deviceDelegate = self
        device.transactionDelegate = self
        device.scan()
        
        let builder: HpsC2xCreditAuthBuilder = HpsC2xCreditAuthBuilder(device: device)
        builder.amount = 11.0
        builder.clientTransactionId = "02997841500"
        builder.gratuity = 0.00
        builder.creditCard = getCC()
        builder.execute()
        
        let builderCapture: HpsC2xCreditCaptureBuilder = HpsC2xCreditCaptureBuilder(device: device)
        builderCapture.amount = 11.0
        builderCapture.clientTransactionId = "02997841500"
        builderCapture.referenceNumber = "987654321"
        builderCapture.transactionId = "123456789"
        builderCapture.execute()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
           /// Forcing the timeout in order to test the reversal
            let builderReversal: HpsC2xCreditReversalBuilder = HpsC2xCreditReversalBuilder(device: device)
            builderReversal.amount = 11.0
            builderReversal.clientTransactionId = "02997841500"
            builderReversal.execute()
            
            self.waitForExpectations(timeout: 600) { error in
                
                XCTAssertTrue(builder.clientTransactionId == builderCapture.clientTransactionId)
                XCTAssertTrue(builderCapture.clientTransactionId == builderReversal.clientTransactionId)
                XCTAssertTrue(builder.clientTransactionId == builderReversal.clientTransactionId)
                
                expectation.fulfill()
            }
        }
    }
    
    
    func testAutoSubstantiation() {
        let expectation = XCTestExpectation(description: "testAutoSubstantiation")

        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        
        device.deviceDelegate = self
        device.transactionDelegate = self
        device.scan()
        
        let builder: HpsC2xCreditAuthBuilder = HpsC2xCreditAuthBuilder(device: device)
        builder.amount = 30.0
        builder.clientTransactionId = "02997841500"
        builder.gratuity = 0.00
        builder.creditCard = getCC()
        builder.autoSubstantiation = getAutoSubstantiation()
        
        builder.execute()
        
        let builderCapture: HpsC2xCreditCaptureBuilder = HpsC2xCreditCaptureBuilder(device: device)
        builderCapture.amount = 30.0
        builderCapture.clientTransactionId = "02997841500"
        builderCapture.referenceNumber = "987654321"
        builderCapture.transactionId = "123456789"
        builderCapture.execute()
        
        self.waitForExpectations(timeout: 600) { error in
    
            XCTAssertNotNil(builder.autoSubstantiation)
        
            expectation.fulfill()
        }
    }
}

extension C2XTransactionsTests: HpsC2xDeviceDelegate, HpsC2xTransactionDelegate {
    
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
