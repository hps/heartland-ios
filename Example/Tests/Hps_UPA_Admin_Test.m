#import <XCTest/XCTest.h>
#import "HpsUpaDevice.h"
#import "HpsUpaResponse.h"

@interface Hps_Upa_Admin_Tests : XCTestCase

@end

@implementation Hps_Upa_Admin_Tests
- (HpsUpaDevice*) setupDevice
{
    HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
    config.ipAddress = @"192.168.86.46";
    config.port = @"8081";
    config.connectionMode = HpsConnectionModes_TCP_IP;
    HpsUpaDevice * device = [[HpsUpaDevice alloc] initWithConfig:config];
    return device;
}


- (void) test_UPA_Ping
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_UPA_Ping"];
    
    HpsUpaDevice *device = [self setupDevice];
    [device ping:^(id<IHPSDeviceResponse> payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertTrue([payload.status isEqualToString:@"Success"]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}


- (void) test_UPA_Reset
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_UPA_Reset"];
    
    HpsUpaDevice *device = [self setupDevice];
    [device reset:^(id<IHPSDeviceResponse> payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertTrue([payload.status isEqualToString:@"Success"]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}


- (void) test_UPA_Reboot
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_UPA_Reboot"];
    
    HpsUpaDevice *device = [self setupDevice];
    [device reboot:^(id<IHPSDeviceResponse> payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertTrue([payload.status isEqualToString:@"Success"]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}


- (void) test_UPA_LineItem
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_UPA_Reset"];
    
    HpsUpaDevice *device = [self setupDevice];
    [device lineItem:@"Toothpaste" withResponseBlock:^(id<IHPSDeviceResponse> payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertTrue([payload.status isEqualToString:@"Success"]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}


- (void) test_UPA_LineItem_WithRight
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_UPA_Reset"];
    
    HpsUpaDevice *device = [self setupDevice];
    [device lineItem:@"Toothpaste" withRightText:@"12" withResponseBlock:^(id<IHPSDeviceResponse> payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertTrue([payload.status isEqualToString:@"Success"]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}


- (void) test_UPA_EOD
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_UPA_EOD"];
    
    HpsUpaDevice *device = [self setupDevice];
    [device processEndOfDay:^(id<IHPSDeviceResponse> payload, NSError *error) {
        HpsUpaResponse* response = (HpsUpaResponse*)payload;
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertTrue([response.status isEqualToString:@"Success"]);
        XCTAssertFalse([response.batchId isEqualToString:@""]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}


//- (void) test_UPA_SendSAF
//{
//    XCTestExpectation *expectation = [self expectationWithDescription:@"test_UPA_SendSAF"];
//
//    HpsUpaDevice *device = [self setupDevice];
//    [device sendStoreAndForward:^(id<IHPSDeviceResponse> payload, NSError *error) {
//        HpsUpaResponse* response = (HpsUpaResponse*)payload;
//        XCTAssertNil(error);
//        XCTAssertNotNil(response);
//        XCTAssertTrue([response.status isEqualToString:@"Success"]);
//        XCTAssertFalse([response.batchId isEqualToString:@""]);
//        [expectation fulfill];
//    }];
//
//    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
//        if(error) XCTFail(@"Request Timed out");
//    }];
//}


- (void) test_UPA_AppInfo
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_UPA_AppInfo"];
    
    HpsUpaDevice *device = [self setupDevice];
    [device getDiagnosticReport:^(id<IHPSDeviceResponse> payload, NSError *error) {
        HpsUpaResponse* response = (HpsUpaResponse*)payload;
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertTrue([response.status isEqualToString:@"Success"]);
        XCTAssertFalse([response.deviceSerialNumber isEqualToString:@""]);
        XCTAssertFalse([response.upaAppVersion isEqualToString:@""]);
        XCTAssertFalse([response.upaOsVersion isEqualToString:@""]);
        XCTAssertFalse([response.upaEmvSdkVersion isEqualToString:@""]);
        XCTAssertFalse([response.upaContactlessSdkVersion isEqualToString:@""]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}


@end

