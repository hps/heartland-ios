#import <XCTest/XCTest.h>

#import <Heartland_iOS_SDK/hps.h>
#import <Heartland_iOS_SDK/HpsConnectionConfig.h>
#import <Heartland_iOS_SDK/HpsTerminalEnums.h>
#import <Heartland_iOS_SDK/HpsUpaDevice.h>

@interface Hps_Upa_Admin_Tests : XCTestCase

@end

@implementation Hps_Upa_Admin_Tests
- (HpsUpaDevice*) setupDevice
{
    HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
    config.username = @"701420636";
    config.password = @"$Test1234";
    config.licenseID = @"145801";
    config.siteID = @"145898";
    config.deviceID = @"90916202";
    config.ipAddress = @"192.168.1.213";
    config.port = @"8081";
    config.connectionMode = HpsConnectionModes_TCP_IP;
    HpsUpaDevice * device = [[HpsUpaDevice alloc] initWithConfig:config];
    return device;
}

- (void)tearDown {
    sleep(1);
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

- (void)test_UPA_CancelPending {
    XCTestExpectation *expectation = [self expectationWithDescription:@"cancelling a pending UPA request"];
    // try to ping device
    HpsUpaDevice *device = [self setupDevice];
    __block BOOL heardBack = NO;
    [device ping:^(id<IHPSDeviceResponse> response, NSError *error) {
        heardBack = YES;
        // assert error is cancel error
        XCTAssertNotNil(error);
        NSString *description = @"Force-closed";
        XCTAssertTrue([error.localizedDescription containsString:description]);
        [expectation fulfill];
    }];
    // wait a little while
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(2.0 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        // if haven't heard back, cancel pending
        XCTAssertFalse(heardBack);
        [device cancelPendingNetworkRequest];
    });
    // wait for expectation
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
    [device processEndOfDayWithEcrId:@"12" requestId:@"123" response:^(id<IHPSDeviceResponse> payload, NSError *error) {
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

