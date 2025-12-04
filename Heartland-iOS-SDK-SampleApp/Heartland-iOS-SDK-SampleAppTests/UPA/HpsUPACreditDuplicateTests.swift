import XCTest
@testable import Heartland_iOS_SDK

final class HpsUPACreditTests: XCTestCase {

    var device: HpsUpaDevice!
    private var builder: HpsUpaSaleBuilder?
    private var amount: String? = "1.2"

    override func setUp() {
        device = setupDevice(ipAddress: "10.50.0.142")
        builder = HpsUpaSaleBuilder(device: self.device)
    }
    
    func setupDevice(ipAddress: String) -> HpsUpaDevice {
        let config = HpsConnectionConfig()
        config.ipAddress = ipAddress
        config.port = "8081"
        
        config.connectionMode = HpsConnectionModes.TCP_IP.rawValue
        config.timeout = 1000
        return HpsUpaDevice(config: config)
    }
    
    func testAllowDuplicateTransactions() {
        let expectation = XCTestExpectation(description: "Wait for execution...")
        
        builder?.clerkId = "1234"
        builder?.ecrId = "12"
        builder?.amount = NSDecimalNumber(string: amount)
        builder?.gratuity = 0
        
        builder?.execute { response, json, error in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertNotNil(json)
            XCTAssertEqual(response?.result, "Success")
            XCTAssertEqual(response?.responseCode, "00")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.builder?.clerkId = "1234"
                self.builder?.ecrId = "12"
                self.builder?.amount = NSDecimalNumber(string: self.amount)
                self.builder?.gratuity = 0
                
                //run a second time and verify that duplicate error is raised
                self.builder?.execute { response, json, error in
                    XCTAssertNil(error)
                    XCTAssertNotNil(response)
                    XCTAssertNotNil(json)
                    if let response = response {
                        if response.duplicateFound {
                            XCTAssertTrue(response.duplicateFound)
                            if  let duplicateRefrance = response.duplicate.duplicateReferenceNumber {
                                XCTAssertEqual("Transaction was rejected because it is a duplicate. Subject \'\(duplicateRefrance)\'.", response.gatewayRspMsg)
                            }
                        }
                    }
                    
                    //run a third time with allow duplicates flag an ensure that it runs.
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self.builder?.clerkId = "1234"
                        self.builder?.ecrId = "12"
                        self.builder?.amount = NSDecimalNumber(string: self.amount)
                        self.builder?.gratuity = 0
                        self.builder?.allowDuplicate = 1
                        
                        self.builder?.execute { response, json, error in
                            XCTAssertNil(error)
                            XCTAssertNotNil(response)
                            XCTAssertNotNil(json)
                            expectation.fulfill()
                        }
                    }
                }
            }
        }
        wait(for: [expectation], timeout: 1000.0)
    }
    
    func testAdditionalDetailsChekforDuplicateTransaction() {
        let expectation = XCTestExpectation(description: "Wait for execution...")
        
        builder?.ecrId = "12"
        builder?.amount = NSDecimalNumber(string: "2.0")
        builder?.gratuity = 0
        
        builder?.execute { response, json, error in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertNotNil(json)
            XCTAssertEqual(response?.result, "Success")
            XCTAssertEqual(response?.responseCode, "00")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.builder?.ecrId = "12"
                self.builder?.amount = NSDecimalNumber(string: "2.0")
                self.builder?.gratuity = 0
                
                //run a second time and verify that duplicate error is raised
                self.builder?.execute { response, json, error in
                    XCTAssertNil(error)
                    XCTAssertNotNil(response)
                    XCTAssertNotNil(json)
                    if let response = response {
                        if response.duplicateFound {
                            XCTAssertTrue(response.duplicateFound)
                        }
                    }
                    
                    //run a third time with allow duplicates flag an ensure that it runs.
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self.builder?.ecrId = "12"
                        self.builder?.amount = NSDecimalNumber(string: "2.0")
                        self.builder?.gratuity = 0
                        self.builder?.allowDuplicate = 1
                        
                        self.builder?.execute { response, json, error in
                            XCTAssertNil(error)
                            XCTAssertNotNil(response)
                            XCTAssertNotNil(json)
                            expectation.fulfill()
                        }
                    }
                }
            }
        }
        wait(for: [expectation], timeout: 1000.0)
    }
}

