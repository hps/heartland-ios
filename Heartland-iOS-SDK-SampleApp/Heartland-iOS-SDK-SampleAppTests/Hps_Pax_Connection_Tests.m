#import <XCTest/XCTest.h>
#import <Heartland_iOS_SDK/hps.h>
#import <Heartland_iOS_SDK/HpsConnectionConfig.h>
#import <Heartland_iOS_SDK/HpsTerminalEnums.h>
#import <Heartland_iOS_SDK/HpsPaxDevice.h>

@interface Hps_Pax_Connection_Tests : XCTestCase

@end

@implementation Hps_Pax_Connection_Tests

- (void) test_PAX_HTTP_Initialize
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test HttpPax Connection"];
    
    HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
    config.ipAddress = @"10.12.220.172";
    config.port = @"10009";
    config.connectionMode = HpsConnectionModes_HTTP;
    HpsPaxDevice * device = [[HpsPaxDevice alloc] initWithConfig:config];
    
    [device initialize:^(HpsPaxInitializeResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_PAX_TCP_Initialize
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test HttpPax Connection"];

	HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
	config.ipAddress = @"10.12.220.172";
	config.port = @"10009";
	config.connectionMode = HpsConnectionModes_TCP_IP;
	HpsPaxDevice * device = [[HpsPaxDevice alloc] initWithConfig:config];

	[device initialize:^(HpsPaxInitializeResponse *payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

@end
