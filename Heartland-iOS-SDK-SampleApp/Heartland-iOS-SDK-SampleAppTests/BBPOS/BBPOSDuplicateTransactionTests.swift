//
//  BBPOSDuplicateTransactionTests.swift
//  Heartland-iOS-SDK-SampleAppTests
//
//  Created by Francis Legaspi on 10/24/25.
//

import Foundation
import XCTest

@testable import Heartland_iOS_SDK

final class BBPOSDuplicateTransactionTests: XCTestCase {
    private var device: HpsC2xDevice?
    private var deviceConnectionExpectation: XCTestExpectation?
    private var transactionExpectation: XCTestExpectation?
    private var deviceDisconnectionExpectation: XCTestExpectation?
    private var response: HpsTerminalResponse!

    override func setUp() {
        super.setUp()
        self.deviceSetup()
    }
    
    override func tearDown() {
        sleep(3)
        self.device = nil
        self.deviceConnectionExpectation = nil
        self.transactionExpectation = nil
        self.deviceDisconnectionExpectation = nil
        self.response = nil
        super.tearDown()
    }
    
    // MARK: - Setup
    private func deviceSetup() {
        let timeout = 120
        
        let config = HpsConnectionConfig()
        config.username = ""
        config.password = ""
        config.siteID = ""
        config.deviceID = ""
        config.licenseID = ""
        config.developerID = ""
        config.versionNumber = ""
        
        config.timeout = timeout
        
        self.device = HpsC2xDevice(config: config)
    }
    
    private func getSurchargableCreditCard() -> HpsCreditCard {
        let card = HpsCreditCard()
        card.cardNumber = "6510000000000810"
        card.expMonth = 05
        card.expYear = 2026
        card.cvv = "201"
        return card
    }
    
    // MARK: - Tests
    func testInitialize() {
        self.deviceConnectionExpectation = expectation(description: "Test_BBPOS_Connected")
        self.device?.scan()
        self.device?.deviceDelegate = self
        
        self.wait(for: [self.deviceConnectionExpectation!], timeout: 15.0)
        
        XCTAssertTrue(self.device?.isConnected() ?? false, "Device Connected")
        
        self.deviceDisconnectionExpectation = expectation(description: "Test_BBPOS_Disconnected")
        self.device?.disconnectDevice()
        
        self.wait(for: [self.deviceDisconnectionExpectation!], timeout: 15.0)
        
        XCTAssertFalse(self.device?.isConnected() ?? true, "Device Disconnected")
    }
    
    func testCreditAuthWithInvoiceNumber() {
        self.deviceConnectionExpectation = expectation(description: "Test_BBPOS_Connected")
        self.device?.scan()
        self.device?.deviceDelegate = self
        
        waitForExpectations(timeout: 60.0) { [weak self] error in
            guard let self = self else { return }
            guard let _ = self.device else { return }
            if let error = error {
                XCTFail("Error: \(error)")
            } else {
                self.transactionExpectation = expectation(description: "Test_BBPOS_Credit_Auth")
                
                let builder = HpsC2xCreditAuthBuilder(device: self.device!)
                builder.amount = NSDecimalNumber(100.0)
                builder.clientTransactionId = "02997841500"
                let gratuity = "0.00"
                builder.gratuity = NSDecimalNumber(string: gratuity)
                builder.creditCard = self.getSurchargableCreditCard()
                builder.allowDuplicates = true
                builder.isSurchargeEnabled = NSNumber(value: false)
                builder.surchargeFee = NSDecimalNumber(string: "0.00")
                self.device?.transactionDelegate = self
                
                if let cTransactionId = builder.clientTransactionId {
                    NSLog("Client Transaction Id Generated In The Client - Request  %@", cTransactionId)
                }
                
                // Adding Invoice Number in request
                let transactionDetails = HpsTransactionDetails()
                transactionDetails.invoiceNumber = "123456"
                builder.details = transactionDetails
                
                let request = builder.buildRequest()
                XCTAssertNotNil(request?.invoiceNumber, "Request should not be nil")
                XCTAssertEqual(request!.invoiceNumber!, "123456")
                
                builder.execute()
                
                self.wait(for: [self.transactionExpectation!], timeout: 30.0)
                
                XCTAssertNotNil(self.response, "Response should not be nil")
                XCTAssertEqual(self.response!.responseCode, "00")
                
                self.deviceDisconnectionExpectation = expectation(description: "Test_BBPOS_Disconnected")
                self.device?.disconnectDevice()
                
                self.wait(for: [self.deviceDisconnectionExpectation!], timeout: 15.0)
                
                XCTAssertFalse(self.device?.isConnected() ?? true, "Device Disconnected")
            }
        }
        
    }
    
    func testCreditSaleWithInvoiceNumber() {
        self.deviceConnectionExpectation = expectation(description: "Test_BBPOS_Connected")
        self.device?.scan()
        self.device?.deviceDelegate = self
        
        waitForExpectations(timeout: 60.0) { [weak self] error in
            guard let self = self else { return }
            guard let _ = self.device else { return }
            if let error = error {
                XCTFail("Error: \(error)")
            } else {
                self.transactionExpectation = expectation(description: "Test_BBPOS_Credit_Sale")

                let builder = HpsC2xCreditSaleBuilder(device: self.device!)
                builder.amount = NSDecimalNumber(100.0)
                builder.allowPartialAuth = NSNumber(value: false)
                builder.cpcReq = true
                builder.creditCard = self.getSurchargableCreditCard()
                builder.allowDuplicates = true
                builder.isSurchargeEnabled = NSNumber(value: false)
                builder.surchargeFee = NSDecimalNumber(string: "0.00")
                let gratuity = "0.00"
                builder.gratuity = NSDecimalNumber(string: gratuity)
                self.device?.transactionDelegate = self
                
                // Adding Invoice Number in request
                let transactionDetails = HpsTransactionDetails()
                transactionDetails.invoiceNumber = "123456"
                builder.details = transactionDetails
                
                let request = builder.buildRequest()
                XCTAssertNotNil(request?.invoiceNumber, "Request should not be nil")
                XCTAssertEqual(request!.invoiceNumber!, "123456")
                
                builder.execute()
                
                self.wait(for: [self.transactionExpectation!], timeout: 30.0)
                
                XCTAssertNotNil(self.response, "Response should not be nil")
                XCTAssertEqual(self.response!.responseCode, "00")
                
                self.deviceDisconnectionExpectation = expectation(description: "Test_BBPOS_Disconnected")
                self.device?.disconnectDevice()
                
                self.wait(for: [self.deviceDisconnectionExpectation!], timeout: 15.0)
                
                XCTAssertFalse(self.device?.isConnected() ?? true, "Device Disconnected")
            }
        }
    }
}

// MARK: - GMSDeviceDelegate
extension BBPOSDuplicateTransactionTests: GMSDeviceDelegate {
    func onConnected() {
        print("Device Connected")
        self.deviceConnectionExpectation?.fulfill()
    }
    
    func onDisconnected() {
        print("Device Disconnected")
        self.deviceDisconnectionExpectation?.fulfill()
    }
    
    func onError(_ deviceError: NSError) {}
    
    func onBluetoothDeviceList(_ peripherals: NSMutableArray, isScanning: Bool) {
        if peripherals.count == 0 {
            print("Empty device list")
            return
        }
        
        for (index, _) in peripherals.enumerated() {
            if let tInfo = peripherals[index] as? HpsTerminalInfo {
                device?.stopScan()
                device?.connectDevice(tInfo)
                break
            }
        }
    }
}

// MARK: - GMSTransactionDelegate
extension BBPOSDuplicateTransactionTests: GMSTransactionDelegate {
    func onStatusUpdate(_ transactionStatus: Heartland_iOS_SDK.HpsTransactionStatus) {
        print("GMSTransactionDelegate - onStatusUpdate")
    }
    
    func onConfirmAmount(_ amount: Decimal) {
        print("GMSTransactionDelegate - onConfirmAmount")
    }
    
    func onConfirmApplication(_ applications: [GlobalMobileSDK.AID]) {
        print("GMSTransactionDelegate - onConfirmApplication")
    }
    
    func onTransactionComplete(_ response: HpsTerminalResponse) {
        print("GMSTransactionDelegate - onTransactionComplete")
        DispatchQueue.main.async {
            self.response = response
            self.transactionExpectation?.fulfill()
        }
    }
    
    func onTransactionCancelled() {
        print("GMSTransactionDelegate - onTransactionCancelled")
        DispatchQueue.main.async {
            self.transactionExpectation?.fulfill()
        }
    }
    
    func onTransactionError(_ error: NSError) {
        print("GMSTransactionDelegate - onTransactionError")
        DispatchQueue.main.async {
            self.transactionExpectation?.fulfill()
        }
    }
    
    func onTransactionWaitingForSurchargeConfirmation(result: Heartland_iOS_SDK.HpsTransactionStatus,
                                                      response: HpsTerminalResponse) {
        print("GMSTransactionDelegate - onTransactionWaitingForSurchargeConfirmation")
    }
}

extension BBPOSDuplicateTransactionTests: HpsC2xDeviceDelegate, GMSClientAppDelegate {
    func searchComplete() {
        print("GMSClientAppDelegate - searchComplete")
    }
    
    func deviceConnected() {
        print("GMSClientAppDelegate - deviceConnected")
    }
    
    func deviceDisconnected() {
        print("GMSClientAppDelegate - deviceDisconnected")
    }
    
    func deviceFound(_ device: NSObject) {
        print("GMSClientAppDelegate - deviceFound")
    }
    
    func onStatus(_ status: Heartland_iOS_SDK.HpsTransactionStatus) {
        print("GMSClientAppDelegate - onStatus")
    }
    
    func requestAIDSelection(_ applications: [GlobalMobileSDK.AID]) {
        print("GMSClientAppDelegate - requestAIDSelection")
    }
    
    func requestAmountConfirmation(_ amount: Decimal) {
        print("GMSClientAppDelegate - requestAmountConfirmation")
    }
    
    func requestPostalCode(_ maskedPan: String, expiryDate: String, cardholderName: String) {
        print("GMSClientAppDelegate - requestPostalCode")
    }
    
    func requestSaFApproval() {
        print("GMSClientAppDelegate - requestSaFApproval")
    }
    
    func onTransactionComplete(_ result: String, response: HpsTerminalResponse) {
        print("GMSClientAppDelegate - onTransactionComplete")
    }
}
