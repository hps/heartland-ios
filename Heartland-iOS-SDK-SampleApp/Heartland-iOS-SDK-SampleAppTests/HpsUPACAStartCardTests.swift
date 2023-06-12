//
//  HpsUPACAStartCardTests.swift
//  Heartland-iOS-SDK-SampleAppTests
//

import Foundation
@testable import Heartland_iOS_SDK
import XCTest

class HpsUPACAStartCardTests: XCTestCase {
    
    func generateInvoiceNumber() -> String {
        let number = Int.random(in: 0001..<5000)
        return "\(number)"
    }
    
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

        let builder = HpsUpaAppCanadaStartCardBuilder(with: device)

        let params = HpsUpaCAStartCardParams(clerkId: "1234", tokenRequest: false, tokenValue: nil,
                                                    cardOnFileIndicator: .CARDHOLDER, cardBrandTransId: nil,
                                                    directMktInvoiceNbr: nil, directMktShipMonth: nil,
                                                    directMktShipDay: nil)

        let tx = HpsUpaCAStartCardTransaction(baseAmount: "12.33", taxAmount: nil, tipAmount: nil,
                                                     taxIndicator: nil, disableTax: "false", cashBackAmount: nil,
                                                     invoiceNbr: nil, allowPartialAuth: nil, confirmAmount: nil,
                                                     disableTip: nil, processCPC: nil, cardIsHSAFSA: nil,
                                                     prescriptionAmount: nil, clinicAmount: nil, dentalAmount: nil,
                                                     visionOpticalAmount: nil)
        
        let lodGing = HpsUpaCAStartCardLodging(folioNumber: nil, stayDuration: nil, checkInDate: nil,
                                               checkOutDate: nil, dailyRate: nil, preferredCustomer: nil,
                                               cardBrandTransID: nil, extraChargeTypes: nil,
                                               extraChargeTotal: nil, advanceDepositType: nil, noShow: nil)

        let data = HpsUpaCommandPayload<HpsUpaCAStartCardDataSaleDetails>(
            command: HpsUpaCAStartCardConstants.command.rawValue,
            ecrId: "123", requestId: "1234",
            data: HpsUpaCAStartCardDataSaleDetails(
                params: params,
                transaction: tx,
                lodging: lodGing
            )
        )

        let request = HpsUpaCAStartCard(data: data)

        builder.execute(request: request) { deviceResponse, upaResponse, error in
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

        let builder = HpsUpaAppCanadaStartCardBuilder(with: device)

        let params = HpsUpaCAVoidParams(clerkID: "1234")
        
        let transaction = HpsUpaCAVoidTransaction(tranNo: "1234")

        let data = HpsUpaCommandPayload<HpsUpaCAVoid>(command: HpsUpaCAStartCardCommand.VOID.rawValue,
                                                      ecrId: "123",
                                                      requestId: "12",
                                                      data: HpsUpaCAVoid(params: params,
                                                                       transaction: transaction))

        let request = HpsUpaCAStartCard<HpsUpaCAVoid>(data: data)

        builder.execute(request: request) { deviceResponse, upaResponse, error in
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

        let builder = HpsUpaAppCanadaStartCardBuilder(with: device)

        let params = HpsUpaCAStartRefundParams(clerkID: "1234",
                                               tokenRequest: nil,
                                               tokenValue: nil)
        
        let transaction = HpsUpaCAStartRefundTransaction(totalAmount: "1.23",
                                                         invoiceNbr: "1234")

        let data = HpsUpaCommandPayload<HpsUpaCAStartRefund>(command: HpsUpaCAStartCardCommand.REFUND.rawValue,
                                                             ecrId: "123",
                                                             requestId: "12",
                                                             data: HpsUpaCAStartRefund(params: params,
                                                                                       transaction: transaction))

        let request = HpsUpaCAStartCard<HpsUpaCAStartRefund>(data: data)

        builder.execute(request: request) { deviceResponse, upaResponse, error in
            XCTAssertNotNil(deviceResponse)
            XCTAssertNotNil(upaResponse)
            XCTAssertNil(error)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1000)
    }
}
