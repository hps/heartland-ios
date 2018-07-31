#import <XCTest/XCTest.h>
#import "HpsHeartSipDevice.h"
#import "HpsCreditCard.h"
#import "HpsAddress.h"
#import "HpsHeartSipDebitSaleBuilder.h"
#import "HpsHeartSipDeviceResponse.h"
#import "HpsHeartSipDebitRefundBuilder.h"

@interface Hps_Sip_Debit_Test : XCTestCase

@end

@implementation Hps_Sip_Debit_Test
- (HpsHeartSipDevice*) setupDevice
{
	HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
	config.ipAddress = @"10.12.220.130";
	config.port = @"12345";
	config.connectionMode = HpsConnectionModes_TCP_IP;
	HpsHeartSipDevice * device = [[HpsHeartSipDevice alloc] initWithConfig:config];
	return device;
}

- (void) test_HeartSip_HTTP_Debit_Sale
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_HeartSip_TCP_Debit_Sale"];

	HpsHeartSipDevice *device = [self setupDevice];
	HpsHeartSipDebitSaleBuilder *builder = [[HpsHeartSipDebitSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:10.22];
	builder.referenceNumber = 5;
	builder.allowDuplicates = YES;


	[builder execute:^(id<IHPSDeviceResponse>payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
		[expectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void) test_Debit_Sale_Blank_Amount{

	XCTestExpectation *expectation = [self expectationWithDescription:@"test_HeartSip_TCP_Debit_Sale_No_Amount"];

	HpsHeartSipDevice *device = [self setupDevice];
	HpsHeartSipDebitSaleBuilder *builder = [[HpsHeartSipDebitSaleBuilder alloc] initWithDevice:device];
	builder.referenceNumber = 5;
	builder.allowDuplicates = YES;

	@try {

		[builder execute:^(id<IHPSDeviceResponse>payload, NSError *error) {
			XCTFail(@"Request not allowed but returned");
		}];

	} @catch (NSException *exception) {

		[expectation fulfill];
	}
	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void) test_Debit_Refund
{

	XCTestExpectation *expectation = [self expectationWithDescription:@"test_HeartSip_TCP_Debit_Refund"];

	HpsHeartSipDevice *device = [self setupDevice];
	HpsHeartSipDebitRefundBuilder *builder = [[HpsHeartSipDebitRefundBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:10.22];
	builder.referenceNumber = 5;
	[builder execute:^(id<IHPSDeviceResponse> payload, NSError *error) {
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
