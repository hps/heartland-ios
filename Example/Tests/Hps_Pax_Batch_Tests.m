
#import <XCTest/XCTest.h>
#import "HpsPaxDevice.h"
#import "HpsPaxCreditSaleBuilder.h"
#import "HpaPaxSafUploadResponse.h"
#import "HpaPaxSafDeleteResponse.h"
#import "HpaPaxSafReportResponse.h"

@interface Hps_Pax_Batch_Tests : XCTestCase

@end

@implementation Hps_Pax_Batch_Tests

- (HpsPaxDevice*) setupDevice
{
    HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
    config.ipAddress = @"192.168.1.12";
    config.port = @"10009";
    config.connectionMode = HpsConnectionModes_TCP_IP;
    HpsPaxDevice * device = [[HpsPaxDevice alloc] initWithConfig:config];
    return device;
}

- (void) test_case_03b
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Credit_Manual"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxCreditSaleBuilder *builder = [[HpsPaxCreditSaleBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:115.45];
    builder.referenceNumber = 5;
    builder.allowDuplicates = YES;
    
    [builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:90.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}
- (void) test_PAX_HTTP_Batch_Close
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Batch_Close"];
    
    HpsPaxDevice *device = [self setupDevice];
    [device batchClose:^(HpsPaxBatchCloseResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"OK", payload.deviceResponseMessage);
        [expectation fulfill];
    }];
    
    
    [self waitForExpectationsWithTimeout:90.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_PAX_HTTP_Saf_Upload
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Saf_Upload"];
    
    HpsPaxDevice *device = [self setupDevice];
    
    [device safUpload:ALL_TRANSACTION withResponseBlock:^(HpaPaxSafUploadResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"OK", payload.deviceResponseMessage);
        [expectation fulfill];
    }];  

    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_PAX_HTTP_Saf_Delete
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Saf_Delete"];
    
    HpsPaxDevice *device = [self setupDevice];
    
    [device safDelete:NEWLY_STORED_TRANSACTION withResponseBlock:^(HpaPaxSafDeleteResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"OK", payload.deviceResponseMessage);
        [expectation fulfill];
    }];
    
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_PAX_HTTP_Saf_Report
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Saf_Report"];
    
    HpsPaxDevice *device = [self setupDevice];
    
    [device safReport:NEWLY_STORED_TRANSACTION withResponseBlock:^(HpaPaxSafReportResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"OK", payload.deviceResponseMessage);
        [expectation fulfill];
    }];
    
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

@end
