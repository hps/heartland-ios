#import <XCTest/XCTest.h>
#import "HpsHpaDevice.h"

@interface Hps_Hpa_Admin_Test : XCTestCase

@end

@implementation Hps_Hpa_Admin_Test

- (HpsHpaDevice*) setupDevice
{
	HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
	config.ipAddress = @"10.138.141.26";
	config.port = @"12345";
	config.connectionMode = HpsConnectionModes_TCP_IP;
	HpsHpaDevice * device = [[HpsHpaDevice alloc] initWithConfig:config];
	return device;
}

-(void) test_Initialize {

	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_TCP_Lane_Open"];

	HpsHpaDevice *device = [self setupDevice];
	NSLog(@"Step 1");
	@try {
		[device initialize:^(id<IInitializeResponse> payload, NSError *error) {
			NSLog(@"Step 5 without Error");

			XCTAssertNil(error);
			XCTAssertNotNil(payload);
			HpsHpaInitializeResponse *response = (HpsHpaInitializeResponse *)payload;
			XCTAssertNotNil(response.serialNumber);
			XCTAssertEqualObjects(@"00", response.deviceResponseCode);
			NSLog(@"%@",[response toString]);
			[expectation fulfill];
			
		}];
	} @catch (NSException *exception) {
		NSLog(@"Step 5 with exception");
	}

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {
		NSLog(@"Step 5 timeout Error");

		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)test_LaneOpen
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_TCP_Lane_Open"];

	HpsHpaDevice *device = [self setupDevice];

	[device openLane:^(id<IHPSDeviceResponse> payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);

		HpsHpaDeviceResponse *response = (HpsHpaDeviceResponse*)payload;
		NSLog(@"%@", [response toString]);
		[expectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)test_LaneClose{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_TCP_Lane_Close"];

	HpsHpaDevice *device = [self setupDevice];

	[device closeLane:^(id<IHPSDeviceResponse>payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		HpsHpaDeviceResponse *response = (HpsHpaDeviceResponse*)payload;
		NSLog(@"%@", [response toString]);
		[expectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_Hpa_HTTP_Reboot
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_Reboot"];

	HpsHpaDevice *device = [self setupDevice];
	[device reboot:^(id<IHPSDeviceResponse>payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);

		HpsHpaDeviceResponse *response = (HpsHpaDeviceResponse*)payload;
		NSLog(@"%@", [response toString]);
		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_Hpa_HTTP_Reset
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_Reset"];

	HpsHpaDevice *device = [self setupDevice];

	[device reset:^(id<IHPSDeviceResponse> payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);

		HpsHpaDeviceResponse *response = (HpsHpaDeviceResponse*)payload;
		NSLog(@"%@", [response toString]);
		[expectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_Hpa_HTTP_Cancel
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_Cancel"];

	HpsHpaDevice *device = [self setupDevice];
	[device cancel:^(id<IHPSDeviceResponse> payload) {
		XCTAssertNotNil(payload);
		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void) test_Set_SAF_Mode_On{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_SAF_Mode_On"];
    
    HpsHpaDevice *device = [self setupDevice];
    [device setSAFMode:YES response:^(id<IHPSDeviceResponse>payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
    
}

-(void) test_Set_SAF_Mode_Off{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_SAF_Mode_Off"];
    
    HpsHpaDevice *device = [self setupDevice];
    [device setSAFMode:NO response:^(id<IHPSDeviceResponse>payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}


@end
