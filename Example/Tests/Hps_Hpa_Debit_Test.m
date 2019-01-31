#import <XCTest/XCTest.h>
#import "HpsHpaDevice.h"
#import "HpsCreditCard.h"
#import "HpsAddress.h"
#import "HpsHpaDebitSaleBuilder.h"
#import "HpsHpaDeviceResponse.h"
#import "HpsHpaDebitRefundBuilder.h"

@interface Hps_Hpa_Debit_Test : XCTestCase

@end

@implementation Hps_Hpa_Debit_Test
- (HpsHpaDevice*) setupDevice
{
	HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
	config.ipAddress = @"10.12.220.39";
	config.port = @"12345";
	config.connectionMode = HpsConnectionModes_TCP_IP;
	HpsHpaDevice * device = [[HpsHpaDevice alloc] initWithConfig:config];
	return device;
}

- (void) test_Hpa_HTTP_Debit_Sale
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_TCP_Debit_Sale"];
	
	HpsHpaDevice *device = [self setupDevice];

	HpsHpaDebitSaleBuilder *builder = [[HpsHpaDebitSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:10.22];
	builder.referenceNumber = [device generateNumber];
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
	
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_TCP_Debit_Sale_No_Amount"];
	
	HpsHpaDevice *device = [self setupDevice];

	HpsHpaDebitSaleBuilder *builder = [[HpsHpaDebitSaleBuilder alloc] initWithDevice:device];
	builder.referenceNumber = [device generateNumber];
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
	
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_TCP_Debit_Refund"];
	
	HpsHpaDevice *device = [self setupDevice];

	HpsHpaDebitRefundBuilder *builder = [[HpsHpaDebitRefundBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:10.22];
	builder.referenceNumber = [device generateNumber];

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
