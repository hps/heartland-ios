//
//  HpsUPAStartCardTests.swift
//  Heartland-iOS-SDK-SampleAppTests
//

import Foundation
@testable import Heartland_iOS_SDK
import XCTest

class HpsUPAStartCardTests: XCTestCase {
    private func setupDevice() -> HpsUpaDevice? {
        let config = HpsConnectionConfig()
        config.username = ""
        config.password = ""
        config.licenseID = ""
        config.siteID = ""
        config.deviceID = ""
        config.ipAddress = "192.168.4.127"
        config.port = "8081"
        config.connectionMode = HpsConnectionModes.TCP_IP.rawValue
        return HpsUpaDevice(config: config)
    }

    func testStartCardExecute() {
        let expectation = XCTestExpectation(description: "Wait for execution...")
        let device = setupDevice()

        guard let device else {
            XCTFail("Device is nil")
            return
        }

        let builder = HpsUpaStartCardTransactionBuilder(with: device)

        let params = HpsUpaStartCardParams(acquisitionTypes: "Swipe",
                                           timeout: nil,
                                           header: nil,
                                           displayTotalAmount: nil,
                                           promptForManualEntryPassword: nil,
                                           brandIcon1: nil,
                                           brandIcon2: nil)

        let pi = HpsUpaStartCardProcessingIndicators(quickChip: "Y",
                                                     checkLuhn: nil,
                                                     securityCode: nil,
                                                     cardTypeFilter: nil)

        let tx = HpsUpaStartCardTransaction(totalAmount: "1.24",
                                            cashBackAmount: nil,
                                            tranDate: nil,
                                            tranTime: nil,
                                            transactionType: "Sale")

        let data = HpsUpaCommandPayload<HpsUpaStartCardDataDetails>(
            command: HpsUpaStartCardConstants.command,
            ecrId: "123", requestId: "1234",
            data: HpsUpaStartCardDataDetails(
                params: params,
                processingIndicators: pi,
                transaction: tx
            )
        )

        let request = HpsUpaStartCard(data: data)

        builder.execute(request: request) { deviceResponse, upaResponse, error in
            XCTAssertNotNil(deviceResponse)
            XCTAssertNotNil(upaResponse)
            XCTAssertNil(error)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1000)
    }
}
