//
//  HpsUPACATests.swift
//  Heartland-iOS-SDK-SampleAppTests
//

import Foundation
@testable import Heartland_iOS_SDK
import XCTest

class HpsUPACATests: XCTestCase {
    
    func generateInvoiceNumber() -> String {
        let number = Int.random(in: 0001..<5000)
        return "\(number)"
    }
    
    private func setupDevice() -> HpsUpaDevice? {
        let config = HpsConnectionConfig()
        config.ipAddress = "192.168.4.127"
        config.port = "8081"
        config.connectionMode = HpsConnectionModes.TCP_IP.rawValue
        return HpsUpaDevice(config: config)
    }

    func testSaleExecute() {
        let expectation = XCTestExpectation(description: "Wait for execution...")
        let device = setupDevice()

        guard let device else {
            XCTFail("Device is nil")
            return
        }

        let builder = HpsUpaCASaleBuilder(with: device)
        builder.clerkId = "1234"
        builder.ecrId = "12"
        builder.baseAmount = "12.33"
        builder.requestId = "1234"
        builder.tipAmount = "0.00"

        builder.execute { deviceResponse, upaResponse, error in
            XCTAssertNotNil(deviceResponse)
            XCTAssertNotNil(upaResponse)
            XCTAssertNil(error)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1000)
    }
    
    func testStartVoidExecute() {
        let expectation = XCTestExpectation(description: "Wait for execution...")
        let device = setupDevice()

        guard let device else {
            XCTFail("Device is nil")
            return
        }

        let builder = HpsUpaCAVoidBuilder(with: device)
        builder.clerkId = "1234"
        builder.ecrId = "12"
        builder.requestId = "1234"
        builder.tranNo = "1234"

        builder.execute { deviceResponse, upaResponse, error in
            XCTAssertNotNil(deviceResponse)
            XCTAssertNotNil(upaResponse)
            XCTAssertNil(error)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1000)
    }
    
    func testStartRefundExecute() {
        let expectation = XCTestExpectation(description: "Wait for execution...")
        let device = setupDevice()

        guard let device else {
            XCTFail("Device is nil")
            return
        }

        let builder = HpsUpaCARefundBuilder(with: device)
        builder.clerkId = "1234"
        builder.requestId = "1234"
        builder.ecrId = "12"
        builder.invoiceNbr = "1234"

        builder.execute { deviceResponse, upaResponse, error in
            XCTAssertNotNil(deviceResponse)
            XCTAssertNotNil(upaResponse)
            XCTAssertNil(error)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1000)
    }
}
