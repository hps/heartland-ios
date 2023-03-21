//
//  HpsUPALineItemDisplayTests.swift
//  Heartland-iOS-SDK-SampleAppTests
//

import Foundation
@testable import Heartland_iOS_SDK
import XCTest

class HpsUPALineItemDisplayTests: XCTestCase {
    private func setupDevice() -> HpsUpaDevice? {
        let config = HpsConnectionConfig()
        config.username = "701420636"
        config.password = "$Test1234"
        config.licenseID = "145801"
        config.siteID = "145898"
        config.deviceID = "90916202"
        config.ipAddress = "192.168.4.127"
        config.port = "8081"
        config.connectionMode = HpsConnectionModes.TCP_IP.rawValue
        return HpsUpaDevice(config: config)
    }

    func testLineItemDisplay() {
        let expectation = XCTestExpectation(description: "Wait for execution...")
        let device = setupDevice()

        guard let device else {
            XCTFail("Device is nil")
            return
        }

        let builder = HpsUpaLineItemDisplayBuilder(with: device)
        let params = HpsUpaLineItemDisplayParams(lineItemLeft: "toothpaste", lineItemRight: "$2.99")
        let data = HpsUpaLineItemData(params: params)
        let displayData = HpsUpaLineItemDisplayData(EcrId: "123", requestId: "123", data: data)
        let request = HpsUpaLineItemDisplay(data: displayData)

        builder.execute(request: request) { _, _, error in
            XCTAssertNil(error)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1000)
    }
}
