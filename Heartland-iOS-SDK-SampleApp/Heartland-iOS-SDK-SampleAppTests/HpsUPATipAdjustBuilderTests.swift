//
//  HpsUPATipAdjustBuilderTests.swift
//  Heartland-iOS-SDK-SampleAppTests
//

import Foundation
@testable import Heartland_iOS_SDK
import XCTest

class HpsUPATipAdjustBuilderTests: XCTestCase {
    
    private func setupDevice() -> HpsUpaDevice? {
        let config = HpsConnectionConfig()
        config.ipAddress = "192.168.31.107"
        config.port = "8081"
        config.connectionMode = HpsConnectionModes.TCP_IP.rawValue
        return HpsUpaDevice(config: config)
    }
    
    func testTipAdjust() {
        let expectation = XCTestExpectation(description: "Wait for execution...")
        let device = setupDevice()

        guard let device else {
            XCTFail("Device is nil")
            return
        }

        let builder = HpsUpaTipAdjustBuilder(with: device)
        let params = HpsUpaLineItemDisplayParams(lineItemLeft: "toothpaste", lineItemRight: "$2.99")
        let transaction = HpsUpaTipAdjustTransaction(tipAmount: "10.00", tranNo: nil,
                                                     invoiceNbr: nil, referenceNumber: "123456")
        let data = HpsUpaLineItemData(params: params, transaction: nil)
        let displayData = HpsUpaLineItemDisplayData(EcrId: "123", requestId: "123", data: data)
        let request = HpsUpaLineItemDisplay(data: displayData)

        builder.execute(request: request) { _, _, error in
            XCTAssertNil(error)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1000)
    }
}
