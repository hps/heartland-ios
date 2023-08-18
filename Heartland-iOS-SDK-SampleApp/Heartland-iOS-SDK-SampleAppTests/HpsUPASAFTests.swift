//
//
//  HpsUPASAFTests.swift
//  Heartland-iOS-SDK-SampleAppTests
//

import Foundation
@testable import Heartland_iOS_SDK
import XCTest

class HpsUPASAFTests: XCTestCase {
    private func setupDevice() -> HpsUpaDevice? {
        let config = HpsConnectionConfig()
        config.username = "701420636"
        config.password = "$Test1234"
        config.licenseID = "145801"
        config.siteID = "145898"
        config.deviceID = "90916202"
        config.ipAddress = "192.168.1.213"
        config.port = "8081"
        config.connectionMode = HpsConnectionModes.TCP_IP.rawValue
        return HpsUpaDevice(config: config)
    }

    func testSendSAFExecute() {
        let expectation = XCTestExpectation(description: "Wait for execution...")
        let device = setupDevice()

        guard let device else {
            XCTFail("Device is nil")
            return
        }

        let builder = HpsUpaSAFTransactionBuilder(with: device)

        let sendSAF = HpsUpaSendSaf(data: HpsUpaCommandPayloadNoData(command: HpsUpaSendSafConstants.command, requestId: "123", ecrId: "123"))

        builder.execute(request: sendSAF) { response, safResponse, error in
            XCTAssertNotNil(response)
            XCTAssertNotNil(safResponse)
            XCTAssertNil(error)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1000)
    }

    func testGetSAFExecute() {
        let expectation = XCTestExpectation(description: "Wait for execution...")
        let device = setupDevice()

        guard let device else {
            XCTFail("Device is nil")
            return
        }

        let builder = HpsUpaSAFTransactionBuilder(with: device)

        let sendSAF = HpsUpaGetSaf(data: HpsUpaCommandPayload(command: HpsUpaGetSafConstants.command, ecrId: "123", requestId: "123", data: HpsUpaGetSafData(params: HpsUpaGetSafDataReportOutput(reportOutput: "ReturnData"))))

        builder.execute(request: sendSAF) { response, safResponse, error in
            XCTAssertNotNil(response)
            XCTAssertNotNil(safResponse)
            XCTAssertNil(error)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1000)
    }
    
    func testDeleteSAFExecute() {
        let expectation = XCTestExpectation(description: "Wait for execution...")
        let device = setupDevice()

        guard let device else {
            XCTFail("Device is nil")
            return
        }
        
        let builder = HpsUpaSAFTransactionBuilder(with: device)
        
        let deleteSAF = HpsUpaDeleteSaf(data: HpsUpaCommandPayload(
            command: HpsUpaDeleteSafConstants.command,
            ecrId: "123",
            requestId: "123",
            data: HpsUpaDeleteSafData.init(transaction: HpsUpaDeleteSafTransaction.init(tranNo: "1", safReferenceNumber: "11"))
        ))
        
        builder.execute(request: deleteSAF, response: { response, deleteSafResponse, error in
            XCTAssertNotNil(response)
            XCTAssertNotNil(deleteSafResponse)
            XCTAssertNil(error)

            expectation.fulfill()  
        })
        
        wait(for: [expectation], timeout: 1000)
    }
}
