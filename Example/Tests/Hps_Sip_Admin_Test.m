#import <XCTest/XCTest.h>
#import "HpsHeartSipDevice.h"

@interface Hps_Sip_Admin_Test : XCTestCase

@end

@implementation Hps_Sip_Admin_Test

- (HpsHeartSipDevice*) setupDevice
{
	HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
	config.ipAddress = @"10.12.220.130";
	config.port = @"12345";
	config.connectionMode = HpsConnectionModes_TCP_IP;
	HpsHeartSipDevice * device = [[HpsHeartSipDevice alloc] initWithConfig:config];
	return device;
}
-(void) test_Initialize {

	XCTestExpectation *expectation = [self expectationWithDescription:@"test_HeartSip_TCP_Lane_Open"];

	HpsHeartSipDevice *device = [self setupDevice];
	NSLog(@"Step 1");
	@try {
		[device initialize:^(id<IInitializeResponse> payload, NSError *error) {
			NSLog(@"Step 5 without Error");

			XCTAssertNil(error);
			XCTAssertNotNil(payload);
			HpsHeartSipInitializeResponse *response = (HpsHeartSipInitializeResponse *)payload;
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
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_HeartSip_TCP_Lane_Open"];

	HpsHeartSipDevice *device = [self setupDevice];

	[device openLane:^(id<IHPSDeviceResponse> payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);

		HpsHeartSipDeviceResponse *response = (HpsHeartSipDeviceResponse*)payload;
		NSLog(@"%@", [response toString]);
		[expectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}


-(void)test_LaneClose{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_HeartSip_TCP_Lane_Close"];

	HpsHeartSipDevice *device = [self setupDevice];

	[device closeLane:^(id<IHPSDeviceResponse>payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		HpsHeartSipDeviceResponse *response = (HpsHeartSipDeviceResponse*)payload;
		NSLog(@"%@", [response toString]);
		[expectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_HeartSip_HTTP_Reboot
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_HeartSip_HTTP_Reboot"];

	HpsHeartSipDevice *device = [self setupDevice];
	[device reboot:^(HpsHeartSipDeviceResponse *payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);

		HpsHeartSipDeviceResponse *response = (HpsHeartSipDeviceResponse*)payload;
		NSLog(@"%@", [response toString]);
		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_HeartSip_HTTP_Reset
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_HeartSip_HTTP_Reset"];

	HpsHeartSipDevice *device = [self setupDevice];

	[device reset:^(id<IHPSDeviceResponse> payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);

		HpsHeartSipDeviceResponse *response = (HpsHeartSipDeviceResponse*)payload;
		NSLog(@"%@", [response toString]);
		[expectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void) test_Batch_Close{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_HeartSip_HTTP_Reboot"];

	HpsHeartSipDevice *device = [self setupDevice];
	[device batchClose:^(id<IBatchCloseResponse>payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);

		HpsHeartSipBatchResponse *response = (HpsHeartSipBatchResponse*)payload;
		NSLog(@"%@", [response toString]);
		[expectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];

}

- (void) test_HeartSip_HTTP_Cancel
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_HeartSip_HTTP_Cancel"];

	HpsHeartSipDevice *device = [self setupDevice];
	[device cancel:^(id<IHPSDeviceResponse> payload) {
		XCTAssertNotNil(payload);
		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}


@end
