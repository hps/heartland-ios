//  Copyright (c) 2016 Global Payments. All rights reserved.

#import <XCTest/XCTest.h>
#import "HpsPaxDevice.h"

@interface Hps_Pax_Admin_Tests : XCTestCase
{
    
}
@end

@implementation Hps_Pax_Admin_Tests
- (HpsPaxDevice*) setupDevice
{
    HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
    config.ipAddress = @"10.12.220.172";
    config.port = @"10009";
    config.connectionMode = HpsConnectionModes_TCP_IP;
    HpsPaxDevice * device = [[HpsPaxDevice alloc] initWithConfig:config];
    return device;
}


- (void) test_PAX_HTTP_Reboot
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Reboot"];
    
    HpsPaxDevice *device = [self setupDevice];
    [device reboot:^(HpsPaxDeviceResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}
- (void) test_PAX_HTTP_Reset
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Reset"];
    
    HpsPaxDevice *device = [self setupDevice];
    [device initialize:^(HpsPaxDeviceResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}
- (void) test_PAX_HTTP_Cancel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Cancel"];
    
    //Not supported
    HpsPaxDevice *device = [self setupDevice];
    [device cancel:^(NSError *error) {
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

@end
