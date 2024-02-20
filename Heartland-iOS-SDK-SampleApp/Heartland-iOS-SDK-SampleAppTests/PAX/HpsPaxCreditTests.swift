//
//  HpsPaxCreditTests.swift
//  Heartland-iOS-SDK-SampleAppTests
//

import Foundation
import XCTest

@testable import Heartland_iOS_SDK

final class HpsPaxCreditTests: XCTestCase {

    var device: HpsPaxDevice?
    var deviceConnectionExpectation: XCTestExpectation = XCTestExpectation()
    var transactionExpectation: XCTestExpectation = XCTestExpectation()
    
    private func setupDevice() -> HpsPaxDevice? {
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
        return HpsPaxDevice(config: config)
    }
    
    private func getCC() -> HpsCreditCard {
        let card = HpsCreditCard()
        card.cardNumber = ""
        card.expMonth = 0
        card.expYear = 0
        card.cvv = ""
        return card;
    }
    
    private func getAddress() -> HpsAddress {
        let address = HpsAddress()
        address.address = ""
        address.zip = ""
        return address
    }

    func testPAXHTTPCreditFailMultiplePayments() throws {
        let expectation = XCTestExpectation(description: "testPAXHTTPCreditFailMultiplePayments")
        
        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        guard let builder = HpsPaxCreditSaleBuilder(device: device) else {
            XCTFail("Builder is nil")
            return
        }
        builder.referenceNumber = 1
        builder.amount = 11.0
        builder.creditCard = getCC()
        
        //Too many payment methods, one or the other
        builder.token = "sdfsdfsdfsdf"
        
        do {
            try ObjC.catchException {
                builder.execute() { response, error in
                    XCTFail("Request not allowed but returned")
                }
            }
        } catch {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1000)
    }
    
    func testPaxHttpAuthFailMultiplePayments() {
        let expectation = XCTestExpectation(description: "testPaxHttpAuthFailMultiplePayments")
        
        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        guard let builder = HpsPaxCreditAuthBuilder(device: device) else {
            XCTFail("Builder is nil")
            return
        }
        builder.referenceNumber = 1
        builder.amount = 11.0
        builder.creditCard = getCC()
        
        //Too many payment methods, one or the other
        builder.token = "sdfsdfsdfsdf"
        
        do {
            try ObjC.catchException {
                builder.execute() { response, error in
                    XCTFail("Request not allowed but returned")
                }
            }
        } catch {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1000)
    }
    
    func testPaxHttpCreditFailNoAmount() {
        let expectation = XCTestExpectation(description: "testPaxHttpCreditFailNoAmount")
        
        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        guard let builder = HpsPaxCreditSaleBuilder(device: device) else {
            XCTFail("Builder is nil")
            return
        }
        builder.referenceNumber = 1
        builder.creditCard = getCC()
        
        do {
            try ObjC.catchException {
                builder.execute() { response, error in
                    XCTFail("Request not allowed but returned")
                }
            }
        } catch {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1000)
    }
    
    func testPaxHttpAuthFailNoAmount() {
        let expectation = XCTestExpectation(description: "testPaxHttpAuthFailNoAmount")
        
        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        guard let builder = HpsPaxCreditAuthBuilder(device: device) else {
            XCTFail("Builder is nil")
            return
        }
        builder.referenceNumber = 1
        builder.creditCard = getCC()
        
        do {
            try ObjC.catchException {
                builder.execute() { response, error in
                    XCTFail("Request not allowed but returned")
                }
            }
        } catch {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1000)
    }
    
    func testPaxHttpReturnFailMultiplePayments() {
        let expectation = XCTestExpectation(description: "testPaxHttpReturnFailMultiplePayments")
        
        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        guard let builder = HpsPaxCreditReturnBuilder(device: device) else {
            XCTFail("Builder is nil")
            return
        }
        builder.referenceNumber = 1
        builder.amount = 11.0
        builder.creditCard = getCC()
        builder.transactionId = "1234567"
        
        //Too many payment methods, one or the other
        builder.token = "sdfsdfsdfsdf"
        
        do {
            try ObjC.catchException {
                builder.execute() { response, error in
                    XCTFail("Request not allowed but returned")
                }
            }
        } catch {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1000)
    }
    
    func testPaxHttpReturnFailNoAmount() {
        let expectation = XCTestExpectation(description: "testPaxHttpReturnFailNoAmount")
        
        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        guard let builder = HpsPaxCreditReturnBuilder(device: device) else {
            XCTFail("Builder is nil")
            return
        }
        builder.referenceNumber = 1
        
        do {
            try ObjC.catchException {
                builder.execute() { response, error in
                    XCTFail("Request not allowed but returned")
                }
            }
        } catch {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1000)
    }
    
    func testPaxHttpCreditManualWithToken() {
        let expectation = XCTestExpectation(description: "testPaxHttpCreditManualWithToken")
        
        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        guard let builder = HpsPaxCreditSaleBuilder(device: device) else {
            XCTFail("Builder is nil")
            return
        }
        builder.allowDuplicates = true
        builder.requestMultiUseToken = true
        builder.referenceNumber = 1
        builder.amount = 11.0
        builder.creditCard = getCC()
        builder.address = getAddress()
        
        do {
            try ObjC.catchException {
                builder.execute() { response, error in
                    XCTAssertNil(error);
                    XCTAssertNotNil(response);
                    XCTAssertEqual("00", response?.responseCode)
                }
                expectation.fulfill()
            }
        } catch {
            XCTFail("Fail on try to call execute function")
        }
        
        wait(for: [expectation], timeout: 1000)
    }
    
    func testPaxHttpCreditManual() {
        let expectation = XCTestExpectation(description: "testPaxHttpCreditManual")
        
        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        guard let builder = HpsPaxCreditSaleBuilder(device: device) else {
            XCTFail("Builder is nil")
            return
        }
        builder.allowDuplicates = true
        builder.requestMultiUseToken = true
        builder.referenceNumber = 1
        builder.amount = 17.0
        builder.creditCard = getCC()
        builder.address = getAddress()
        
        do {
            try ObjC.catchException {
                builder.execute() { response, error in
                    XCTAssertNil(error);
                    XCTAssertNotNil(response);
                    XCTAssertEqual("00", response?.responseCode)
                }
                expectation.fulfill()
            }
        } catch {
            XCTFail("Fail on try to call execute function")
        }
        
        wait(for: [expectation], timeout: 1000)
    }
    
    func testPaxHttpAdjustFailNoTransactionID() {
        let expectation = XCTestExpectation(description: "testPaxHttpAdjustFailNoTransactionID")
        
        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        guard let builder = HpsPaxCreditAdjustBuilder(device: device) else {
            XCTFail("Builder is nil")
            return
        }
        builder.referenceNumber = 1
        
        do {
            try ObjC.catchException {
                builder.execute() { response, error in
                    XCTFail("Request not allowed but returned")
                }
                
            }
        } catch {
            expectation.fulfill()
            
        }
    
        wait(for: [expectation], timeout: 1000)
    }
    
    func testPaxHttpCaptureFailNoTransactionID() {
        let expectation = XCTestExpectation(description: "testPaxHttpCaptureFailNoTransactionID")
        
        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        guard let builder = HpsPaxCreditCaptureBuilder(device: device) else {
            XCTFail("Builder is nil")
            return
        }
        builder.referenceNumber = 1
        
        do {
            try ObjC.catchException {
                builder.execute() { response, error in
                    XCTFail("Request not allowed but returned")
                }
                
            }
        } catch {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1000)
    }
    
    func testPaxHttpReturnByCard() {
        let expectation = XCTestExpectation(description: "testPaxHttpReturnByCard")
        
        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        guard let builder = HpsPaxCreditReturnBuilder(device: device) else {
            XCTFail("Builder is nil")
            return
        }
        builder.referenceNumber = 1
        builder.amount = 12.0
        builder.transactionId = "1234567"
        
        do {
            try ObjC.catchException {
                builder.execute() { response, error in
                }
                expectation.fulfill()
            }
        } catch {
            XCTFail("Fail on try to call execute function")
        }
        
        wait(for: [expectation], timeout: 1000)
    }
    
    func testPaxHttpReturnFailNoAuthcode() {
        let expectation = XCTestExpectation(description: "testPaxHttpReturnFailNoAuthcode")
        
        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        guard let builder = HpsPaxCreditReturnBuilder(device: device) else {
            XCTFail("Builder is nil")
            return
        }
        builder.referenceNumber = 1
        builder.amount = 12.0
        builder.creditCard = getCC()
        builder.transactionId = "1234567"
        
        do {
            try ObjC.catchException {
                builder.execute() { response, error in
                    XCTFail("Request not allowed but returned")
                }
                
            }
        } catch {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1000)
    }
    
    func testPaxHttpVerifyManual() {
        let expectation = XCTestExpectation(description: "testPaxHttpVerifyManual")
        
        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        guard let builder = HpsPaxCreditVerifyBuilder(device: device) else {
            XCTFail("Builder is nil")
            return
        }
        builder.referenceNumber = 1
        builder.creditCard = getCC()
        builder.address = getAddress()
        
        do {
            try ObjC.catchException {
                builder.execute() { response, error in
                }
                expectation.fulfill()
            }
        } catch {
            XCTFail("Fail on try to call execute function")
        }
        
        wait(for: [expectation], timeout: 1000)
    }
    
    func testPaxHttpTokenize() {
        let expectation = XCTestExpectation(description: "testPaxHttpTokenize")
        
        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        guard let builder = HpsPaxCreditVerifyBuilder(device: device) else {
            XCTFail("Builder is nil")
            return
        }
        builder.referenceNumber = 1
        builder.requestMultiUseToken = true
        builder.creditCard = getCC()
        builder.address = getAddress()
        
        do {
            try ObjC.catchException {
                builder.execute() { response, error in
                }
                expectation.fulfill()
            }
        } catch {
            XCTFail("Fail on try to call execute function")
        }
        
        wait(for: [expectation], timeout: 1000)
    }
    
    func testPaxHttpSaleAdjust() {
        let expectation = XCTestExpectation(description: "testPaxHttpSaleAdjust")
        
        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        guard let builder = HpsPaxCreditSaleBuilder(device: device) else {
            XCTFail("Builder is nil")
            return
        }
        builder.amount = 12.0
        builder.referenceNumber = 1
        builder.allowDuplicates = true
        builder.creditCard = getCC()
        builder.address = getAddress()
        
        do {
            try ObjC.catchException {
                builder.execute() { response, error in
                    guard let response = response else {
                        XCTFail("Response is nil")
                        return
                    }
                    guard let abuilder = HpsPaxCreditAdjustBuilder(device: device) else {
                        XCTFail("Builder is nil")
                        return
                    }
                    abuilder.amount = 15.0
                    abuilder.transactionId = response.transactionId;
                    abuilder.referenceNumber = 2;
                    abuilder.execute { response, error in
                        expectation.fulfill()
                    }
                }
                expectation.fulfill()
            }
        } catch {
            XCTFail("Fail on try to call execute function")
        }
        
        wait(for: [expectation], timeout: 1000)
    }
    
    func testPaxHttpAuthCapture() {
        let expectation = XCTestExpectation(description: "testPaxHttpAuthCapture")
        
        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        guard let builder = HpsPaxCreditAuthBuilder(device: device) else {
            XCTFail("Builder is nil")
            return
        }
        builder.amount = 27.0
        builder.referenceNumber = 1
        builder.allowDuplicates = true
        builder.creditCard = getCC()
        builder.address = getAddress()
        
        do {
            try ObjC.catchException {
                builder.execute() { response, error in
                    guard let response = response else {
                        XCTFail("Response is nil")
                        return
                    }
                    guard let abuilder = HpsPaxCreditCaptureBuilder(device: device) else {
                        XCTFail("Builder is nil")
                        return
                    }
                    abuilder.amount = 15.0
                    abuilder.transactionId = response.transactionId;
                    abuilder.referenceNumber = 2;
                    abuilder.execute { response, error in
                        expectation.fulfill()
                    }
                }
                expectation.fulfill()
            }
        } catch {
            XCTFail("Fail on try to call execute function")
        }
        
        wait(for: [expectation], timeout: 1000)
    }
    
    func testPaxHttpReturnByTransactionId() {
        let expectation = XCTestExpectation(description: "testPaxHttpReturnByTransactionId")
        
        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        guard let builder = HpsPaxCreditSaleBuilder(device: device) else {
            XCTFail("Builder is nil")
            return
        }
        builder.amount = 13.0
        builder.referenceNumber = 1
        builder.allowDuplicates = true
        builder.creditCard = getCC()
        builder.address = getAddress()
        
        do {
            try ObjC.catchException {
                builder.execute() { response, error in
                    guard let response = response else {
                        XCTFail("Response is nil")
                        return
                    }
                    guard let abuilder = HpsPaxCreditReturnBuilder(device: device) else {
                        XCTFail("Builder is nil")
                        return
                    }
                    abuilder.amount = 11.0
                    abuilder.transactionId = response.transactionId;
                    abuilder.referenceNumber = 2;
                    abuilder.authCode = response.authorizationCode
                    abuilder.execute { response, error in
                        expectation.fulfill()
                    }
                }
                expectation.fulfill()
            }
        } catch {
            XCTFail("Fail on try to call execute function")
        }
        
        wait(for: [expectation], timeout: 1000)
    }
    
    func testPaxHttpCreditVoid() {
        let expectation = XCTestExpectation(description: "testPaxHttpCreditVoid")
        
        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        guard let builder = HpsPaxCreditSaleBuilder(device: device) else {
            XCTFail("Builder is nil")
            return
        }
        builder.amount = 11.0
        builder.referenceNumber = 1
        builder.allowDuplicates = true
        builder.requestMultiUseToken = true
        builder.creditCard = getCC()
        builder.address = getAddress()
        
        do {
            try ObjC.catchException {
                builder.execute() { response, error in
                    guard let response = response else {
                        XCTFail("Response is nil")
                        return
                    }
                    guard let abuilder = HpsPaxCreditVoidBuilder(device: device) else {
                        XCTFail("Builder is nil")
                        return
                    }
                    abuilder.transactionId = response.transactionId;
                    abuilder.referenceNumber = 2;
                    abuilder.execute { response, error in
                        expectation.fulfill()
                    }
                }
                expectation.fulfill()
            }
        } catch {
            XCTFail("Fail on try to call execute function")
        }
        
        wait(for: [expectation], timeout: 1000)
    }
    
    func testSaleWithSignatureCapture() {
        let expectation = XCTestExpectation(description: "testSaleWithSignatureCapture")
        
        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        guard let builder = HpsPaxCreditSaleBuilder(device: device) else {
            XCTFail("Builder is nil")
            return
        }
        builder.amount = 11.0
        builder.referenceNumber = 1
        builder.allowDuplicates = true
        builder.signatureCapture = true
        builder.creditCard = getCC()
        builder.address = getAddress()
        
        do {
            try ObjC.catchException {
                builder.execute() { response, error in
                    guard let _ = response else {
                        XCTFail("Response is nil")
                        return
                    }
                }
                expectation.fulfill()
            }
        } catch {
            XCTFail("Fail on try to call execute function")
        }
        
        wait(for: [expectation], timeout: 1000)
    }
    
    func testPaxHttpCreditSaleTipRequestFlag() {
        let expectation = XCTestExpectation(description: "testPaxHttpCreditSaleTipRequestFlag")
        
        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        guard let builder = HpsPaxCreditSaleBuilder(device: device) else {
            XCTFail("Builder is nil")
            return
        }
        builder.amount = 27.0
        builder.referenceNumber = 1
        builder.allowDuplicates = true
        builder.tipRequest = true
        
        do {
            try ObjC.catchException {
                builder.execute() { response, error in
                    guard let _ = response else {
                        XCTFail("Response is nil")
                        return
                    }
                }
                expectation.fulfill()
            }
        } catch {
            XCTFail("Fail on try to call execute function")
        }
        
        wait(for: [expectation], timeout: 1000)
    }
    
    func testPaxHttpBatchClose() {
        let expectation = XCTestExpectation(description: "testPaxHttpBatchClose")
        
        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        
        device.batchClose { response, error in
            guard let _ = response else {
                XCTFail("Response is nil")
                return
            }
        }
        expectation.fulfill()
    }
    
    func testPaxHttpReturnByToken() {
        let expectation = XCTestExpectation(description: "testPaxHttpCreditSaleTipRequestFlag")
        
        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        guard let builder = HpsPaxCreditReturnBuilder(device: device) else {
            XCTFail("Builder is nil")
            return
        }
        let userDefaults = UserDefaults.standard
        
        builder.amount = 15.0
        builder.token = userDefaults.object(forKey: "token") as? String
        userDefaults.removeObject(forKey: "token")
        userDefaults.synchronize()
        do {
            try ObjC.catchException {
                builder.execute() { response, error in
                    guard let _ = response else {
                        XCTFail("Response is nil")
                        return
                    }
                }
                expectation.fulfill()
            }
        } catch {
            XCTFail("Fail on try to call execute function")
        }
        
        wait(for: [expectation], timeout: 1000)
    }
    
    func testPAXTCPCreditCancelPayment() throws {
        let expectation = XCTestExpectation(description: "testPAXTCPCreditCancelPayment")
        
        device = self.setupDevice()
        guard let device = self.device else {
            XCTFail("Device is nil")
            return
        }
        guard let builder = HpsPaxCreditSaleBuilder(device: device) else {
            XCTFail("Builder is nil")
            return
        }
        builder.referenceNumber = 1
        builder.amount = 11.0
        builder.creditCard = getCC()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            device.cancel({ cancel in
                expectation.fulfill()
            })
        }
        
        builder.execute() { response, error in
            XCTFail("Request not allowed but returned")
        }
        
        
        wait(for: [expectation], timeout: 1000)
    }
}
