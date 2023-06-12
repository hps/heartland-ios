//
//  UpsUpaSignatureDataTests.swift
//  Heartland-iOS-SDK-SampleAppTests
//

import XCTest
@testable import Heartland_iOS_SDK

final class UpsUpaSignatureDataTests: XCTestCase {

    private func setupUPAUSADevice() -> HpsUpaDevice? {
        let config = HpsConnectionConfig()
        config.ipAddress = "192.168.31.117"
        config.port = "8081"
        config.connectionMode = HpsConnectionModes.TCP_IP.rawValue
        config.timeout = 1000
        return HpsUpaDevice(config: config)
    }
    
    func testGetSignatureData() {
        if let upaDevice = setupUPAUSADevice() {
            upaDevice.getSignatureData("1234", andRequestId: "1234") { responseSignature, error in
                if let error = error {
                    print(" Error Response: \(error)")
                    return
                }
                
                if let responseSignature = responseSignature {
                    print(" SIGNATURE DATA ")
                    print(responseSignature)
                }
            }
        }
    }
}
