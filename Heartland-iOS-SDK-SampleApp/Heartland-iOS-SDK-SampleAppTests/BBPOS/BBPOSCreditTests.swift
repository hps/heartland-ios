//
//  BBPOSCreditTests.swift
//  Heartland-iOS-SDK-SampleApp
//
//  Created by Francis Legaspi on 7/27/25.
//

import Foundation
import XCTest

@testable import Heartland_iOS_SDK

final class BBPOSCreditTests: XCTestCase {
    private var device: HpsC2xDevice?
    private var deviceConnectionExpectation: XCTestExpectation?
    private var transactionExpectation: XCTestExpectation?
    private var waitForSurchargeConfirmationExpectation: XCTestExpectation?
    private var deviceDisconnectionExpectation: XCTestExpectation?
    private var response: HpsTerminalResponse?
    
    override func setUp() {
        super.setUp()
        self.deviceSetup()
    }
    
    override func tearDown() {
        sleep(3)
        self.device = nil
        self.deviceConnectionExpectation = nil
        self.transactionExpectation = nil
        self.waitForSurchargeConfirmationExpectation = nil
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
    
    func testSaleSurcharge01(){
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
                self.waitForSurchargeConfirmationExpectation = expectation(
                    description: "Test_BBPOS_Wait_For_Surcharge_Confirmation"
                )
                
                /// Note in Objective-C passing `true` to NSNumber produces `1`
                /// while passing `false` produces `0`
                let builder = HpsC2xCreditSaleBuilder(device: self.device!)
                builder.amount = NSDecimalNumber(100.0)
                builder.allowPartialAuth = NSNumber(value: false)
                builder.cpcReq = true
                builder.allowDuplicates = true
                builder.isSurchargeEnabled = NSNumber(value: true)
                builder.surchargeFee = NSDecimalNumber(string: "3.00")
                builder.gratuity = NSDecimalNumber(string: "0.00")
                self.device?.transactionDelegate = self
                builder.execute()
                
                self.wait(for: [self.transactionExpectation!], timeout: 30.0)
                
                XCTAssertNotNil(self.response, "Response should not be nil")
                XCTAssertEqual(self.response!.responseCode, "00")
                
                self.wait(for: [self.waitForSurchargeConfirmationExpectation!], timeout: 15.0)
                
                XCTAssertEqual(
                    String(describing: self.response!.approvedAmount.doubleValue),
                    "103.0"
                )
                let surchargeAmount = NSDecimalNumber(string: self.response!.surchargeAmount ?? "0")
                XCTAssertEqual(
                    String(describing: surchargeAmount.doubleValue),
                    "3.0"
                )
                XCTAssertNotNil(self.response?.surchargeFee)
                XCTAssertEqual(self.response!.surchargeFee!, "3")
                
                self.deviceDisconnectionExpectation = expectation(description: "Test_BBPOS_Disconnected")
                self.device?.disconnectDevice()
                
                self.wait(for: [self.deviceDisconnectionExpectation!], timeout: 15.0)
                
                XCTAssertFalse(self.device?.isConnected() ?? true, "Device Disconnected")
            }
        }
    }
    
    func testSaleSurcharge02(){
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
                self.waitForSurchargeConfirmationExpectation = expectation(
                    description: "Test_BBPOS_Wait_For_Surcharge_Confirmation"
                )
                
                /// Note in Objective-C passing `true` to NSNumber produces `1`
                /// while passing `false` produces `0`
                let builder = HpsC2xCreditSaleBuilder(device: self.device!)
                builder.amount = NSDecimalNumber(100.0)
                builder.allowPartialAuth = NSNumber(value: false)
                builder.cpcReq = true
                builder.allowDuplicates = true
                builder.isSurchargeEnabled = NSNumber(value: true)
                builder.surchargeFee = NSDecimalNumber(string: "2.3")
                builder.gratuity = NSDecimalNumber(string: "0.00")
                self.device?.transactionDelegate = self
                builder.execute()
                
                self.wait(for: [self.transactionExpectation!], timeout: 30.0)
                
                XCTAssertNotNil(self.response, "Response should not be nil")
                XCTAssertEqual(self.response!.responseCode, "00")
                
                self.wait(for: [self.waitForSurchargeConfirmationExpectation!], timeout: 15.0)
                
                XCTAssertEqual(
                    String(describing: self.response!.approvedAmount.doubleValue),
                    "102.3"
                )
                let surchargeAmount = NSDecimalNumber(string: self.response!.surchargeAmount ?? "0")
                XCTAssertEqual(
                    String(describing: surchargeAmount.doubleValue),
                    "2.3"
                )
                XCTAssertNotNil(self.response?.surchargeFee)
                XCTAssertEqual(self.response!.surchargeFee!, "2.3")
                
                self.deviceDisconnectionExpectation = expectation(description: "Test_BBPOS_Disconnected")
                self.device?.disconnectDevice()
                
                self.wait(for: [self.deviceDisconnectionExpectation!], timeout: 15.0)
                
                XCTAssertFalse(self.device?.isConnected() ?? true, "Device Disconnected")
            }
        }
    }
    
    func testSaleSurcharge03(){
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
                self.waitForSurchargeConfirmationExpectation = expectation(
                    description: "Test_BBPOS_Wait_For_Surcharge_Confirmation"
                )
                
                /// Note in Objective-C passing `true` to NSNumber produces `1`
                /// while passing `false` produces `0`
                let builder = HpsC2xCreditSaleBuilder(device: self.device!)
                builder.amount = NSDecimalNumber(100.0)
                builder.allowPartialAuth = NSNumber(value: false)
                builder.cpcReq = true
                builder.allowDuplicates = true
                builder.isSurchargeEnabled = NSNumber(value: true)
                builder.surchargeFee = NSDecimalNumber(string: "3.00")
                builder.preTaxAmount = NSDecimalNumber(string: "2.10")
                builder.gratuity = NSDecimalNumber(string: "0.00")
                self.device?.transactionDelegate = self
                builder.execute()
                
                self.wait(for: [self.transactionExpectation!], timeout: 30.0)
                
                XCTAssertNotNil(self.response, "Response should not be nil")
                XCTAssertEqual(self.response!.responseCode, "00")
                
                self.wait(for: [self.waitForSurchargeConfirmationExpectation!], timeout: 15.0)
                
                XCTAssertNotNil(self.response?.approvedAmount, "approvedAmount should not be nil")
                
                XCTAssertEqual(
                    String(describing: self.response!.approvedAmount!),
                    "102.93"
                )
                let surchargeAmount = NSDecimalNumber(string: self.response!.surchargeAmount ?? "0")
                XCTAssertEqual(
                    String(describing: surchargeAmount.doubleValue),
                    "2.93"
                )
                XCTAssertNotNil(self.response?.surchargeFee)
                XCTAssertEqual(self.response!.surchargeFee!, "3")
                
                self.deviceDisconnectionExpectation = expectation(description: "Test_BBPOS_Disconnected")
                self.device?.disconnectDevice()
                
                self.wait(for: [self.deviceDisconnectionExpectation!], timeout: 15.0)
                
                XCTAssertFalse(self.device?.isConnected() ?? true, "Device Disconnected")
            }
        }
    }
    
    func testSaleSurcharge04(){
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
                self.waitForSurchargeConfirmationExpectation = expectation(
                    description: "Test_BBPOS_Wait_For_Surcharge_Confirmation"
                )
                
                /// Note in Objective-C passing `true` to NSNumber produces `1`
                /// while passing `false` produces `0`
                let builder = HpsC2xCreditSaleBuilder(device: self.device!)
                builder.amount = NSDecimalNumber(85.0)
                builder.allowPartialAuth = NSNumber(value: false)
                builder.cpcReq = true
                builder.allowDuplicates = true
                builder.isSurchargeEnabled = NSNumber(value: true)
                builder.surchargeFee = NSDecimalNumber(string: "2.437")
                builder.preTaxAmount = NSDecimalNumber(string: "2.00")
                builder.gratuity = NSDecimalNumber(string: "0.00")
                self.device?.transactionDelegate = self
                builder.execute()
                
                self.wait(for: [self.transactionExpectation!], timeout: 30.0)
                
                XCTAssertNotNil(self.response, "Response should not be nil")
                XCTAssertEqual(self.response!.responseCode, "00")
                
                self.wait(for: [self.waitForSurchargeConfirmationExpectation!], timeout: 15.0)
                
                XCTAssertNotNil(self.response?.approvedAmount, "approvedAmount should not be nil")
                
                XCTAssertEqual(
                    String(describing: self.response!.approvedAmount!),
                    "87.02"
                )
                let surchargeAmount = NSDecimalNumber(string: self.response!.surchargeAmount ?? "0")
                XCTAssertEqual(
                    String(describing: surchargeAmount.doubleValue),
                    "2.02"
                )
                XCTAssertNotNil(self.response?.surchargeFee)
                XCTAssertEqual(self.response!.surchargeFee!, "2.44")
                
                self.deviceDisconnectionExpectation = expectation(description: "Test_BBPOS_Disconnected")
                self.device?.disconnectDevice()
                
                self.wait(for: [self.deviceDisconnectionExpectation!], timeout: 15.0)
                
                XCTAssertFalse(self.device?.isConnected() ?? true, "Device Disconnected")
            }
        }
    }
    
    func testSaleSurcharge05(){
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
                self.waitForSurchargeConfirmationExpectation = expectation(
                    description: "Test_BBPOS_Wait_For_Surcharge_Confirmation"
                )
                
                /// Note in Objective-C passing `true` to NSNumber produces `1`
                /// while passing `false` produces `0`
                let builder = HpsC2xCreditSaleBuilder(device: self.device!)
                builder.amount = NSDecimalNumber(55.0)
                builder.allowPartialAuth = NSNumber(value: false)
                builder.cpcReq = true
                builder.allowDuplicates = true
                builder.isSurchargeEnabled = NSNumber(value: true)
                builder.surchargeFee = NSDecimalNumber(string: "2.11")
                builder.preTaxAmount = NSDecimalNumber(string: "1.50")
                builder.gratuity = NSDecimalNumber(string: "0.00")
                self.device?.transactionDelegate = self
                builder.execute()
                
                self.wait(for: [self.transactionExpectation!], timeout: 30.0)
                
                XCTAssertNotNil(self.response, "Response should not be nil")
                XCTAssertEqual(self.response!.responseCode, "00")
                
                self.wait(for: [self.waitForSurchargeConfirmationExpectation!], timeout: 15.0)
                
                XCTAssertNotNil(self.response?.approvedAmount, "approvedAmount should not be nil")
                
                XCTAssertEqual(
                    String(describing: self.response!.approvedAmount!),
                    "56.12"
                )
                let surchargeAmount = NSDecimalNumber(string: self.response!.surchargeAmount ?? "0")
                XCTAssertEqual(
                    String(describing: surchargeAmount),
                    "1.12"
                )
                XCTAssertNotNil(self.response?.surchargeFee)
                XCTAssertEqual(self.response!.surchargeFee!, "2.11")
                
                self.deviceDisconnectionExpectation = expectation(description: "Test_BBPOS_Disconnected")
                self.device?.disconnectDevice()
                
                self.wait(for: [self.deviceDisconnectionExpectation!], timeout: 15.0)
                
                XCTAssertFalse(self.device?.isConnected() ?? true, "Device Disconnected")
            }
        }
    }
    
    func testSaleSurcharge06(){
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
                self.waitForSurchargeConfirmationExpectation = expectation(
                    description: "Test_BBPOS_Wait_For_Surcharge_Confirmation"
                )
                
                /// Note in Objective-C passing `true` to NSNumber produces `1`
                /// while passing `false` produces `0`
                let builder = HpsC2xCreditSaleBuilder(device: self.device!)
                builder.amount = NSDecimalNumber(105.0)
                builder.allowPartialAuth = NSNumber(value: false)
                builder.cpcReq = true
                builder.allowDuplicates = true
                builder.isSurchargeEnabled = NSNumber(value: true)
                builder.surchargeFee = NSDecimalNumber(string: "2.937")
                builder.preTaxAmount = NSDecimalNumber(string: "3.20")
                builder.gratuity = NSDecimalNumber(string: "0.00")
                self.device?.transactionDelegate = self
                builder.execute()
                
                self.wait(for: [self.transactionExpectation!], timeout: 30.0)
                
                XCTAssertNotNil(self.response, "Response should not be nil")
                XCTAssertEqual(self.response!.responseCode, "00")
                
                self.wait(for: [self.waitForSurchargeConfirmationExpectation!], timeout: 15.0)
                
                XCTAssertNotNil(self.response?.approvedAmount, "approvedAmount should not be nil")
                
                XCTAssertEqual(
                    String(describing: self.response!.approvedAmount!),
                    "107.99"
                )
                let surchargeAmount = NSDecimalNumber(string: self.response!.surchargeAmount ?? "0")
                XCTAssertEqual(
                    String(describing: surchargeAmount),
                    "2.99"
                )
                XCTAssertNotNil(self.response?.surchargeFee)
                XCTAssertEqual(self.response!.surchargeFee!, "2.94")
                
                self.deviceDisconnectionExpectation = expectation(description: "Test_BBPOS_Disconnected")
                self.device?.disconnectDevice()
                
                self.wait(for: [self.deviceDisconnectionExpectation!], timeout: 15.0)
                
                XCTAssertFalse(self.device?.isConnected() ?? true, "Device Disconnected")
            }
        }
    }
    
    func testSaleSurcharge07(){
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
                self.waitForSurchargeConfirmationExpectation = expectation(
                    description: "Test_BBPOS_Wait_For_Surcharge_Confirmation"
                )
                
                /// Note in Objective-C passing `true` to NSNumber produces `1`
                /// while passing `false` produces `0`
                let builder = HpsC2xCreditSaleBuilder(device: self.device!)
                builder.amount = NSDecimalNumber(63.0)
                builder.allowPartialAuth = NSNumber(value: false)
                builder.cpcReq = true
                builder.allowDuplicates = true
                builder.isSurchargeEnabled = NSNumber(value: true)
                builder.surchargeFee = NSDecimalNumber(string: "3.0")
                builder.preTaxAmount = NSDecimalNumber(string: "1.30")
                builder.gratuity = NSDecimalNumber(string: "0.00")
                self.device?.transactionDelegate = self
                builder.execute()
                
                self.wait(for: [self.transactionExpectation!], timeout: 30.0)
                
                XCTAssertNotNil(self.response, "Response should not be nil")
                XCTAssertEqual(self.response!.responseCode, "00")
                
                self.wait(for: [self.waitForSurchargeConfirmationExpectation!], timeout: 15.0)
                
                XCTAssertNotNil(self.response?.approvedAmount, "approvedAmount should not be nil")
                
                XCTAssertEqual(
                    String(describing: self.response!.approvedAmount!),
                    "64.85"
                )
                let surchargeAmount = NSDecimalNumber(string: self.response!.surchargeAmount ?? "0")
                XCTAssertEqual(
                    String(describing: surchargeAmount),
                    "1.85"
                )
                XCTAssertNotNil(self.response?.surchargeFee)
                XCTAssertEqual(self.response!.surchargeFee!, "3")
                
                self.deviceDisconnectionExpectation = expectation(description: "Test_BBPOS_Disconnected")
                self.device?.disconnectDevice()
                
                self.wait(for: [self.deviceDisconnectionExpectation!], timeout: 15.0)
                
                XCTAssertFalse(self.device?.isConnected() ?? true, "Device Disconnected")
            }
        }
    }

}

// MARK: - GMSDeviceDelegate
extension BBPOSCreditTests: GMSDeviceDelegate {
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
extension BBPOSCreditTests: GMSTransactionDelegate {
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
        DispatchQueue.main.async {
            if result == .surchargeRequested, let _ = self.device {
                self.device?.confirmSurcharge(true)
                self.waitForSurchargeConfirmationExpectation?.fulfill()
            }
        }
    }
}

extension BBPOSCreditTests: HpsC2xDeviceDelegate, GMSClientAppDelegate {
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
