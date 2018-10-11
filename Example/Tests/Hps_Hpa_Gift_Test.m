#import <XCTest/XCTest.h>
#import "HpsHpaDeviceResponse.h"
#import "HpsHpaGiftSaleBuilder.h"
#import "HpsHpaGiftAddValueBuilder.h"
#import "HpsHpaGiftBalanceBuilder.h"
#import "HpsHpaGiftVoidBuilder.h"
#import "HpsTransactionDetails.h"
#import "HpsGiftCard.h"

@interface Hps_Hpa_Gift_Test : XCTestCase

@end

@implementation Hps_Hpa_Gift_Test

- (HpsHpaDevice*) setupDevice
{
	HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
	config.ipAddress = @"10.12.220.130";
	config.port = @"12345";
	config.connectionMode = HpsConnectionModes_TCP_IP;
	HpsHpaDevice * device = [[HpsHpaDevice alloc] initWithConfig:config];
	return device;
}

#pragma mark :- GiftSale
- (void) test_Hpa_HTTP_Gift_Sale
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_Gift_Sale"];

	HpsHpaDevice *device = [self setupDevice];

	HpsHpaGiftSaleBuilder *builder = [[HpsHpaGiftSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:10.0];
	builder.referenceNumber = 1;
	[builder execute:^(id<IHPSDeviceResponse> payload, NSError *error){
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
		[expectation fulfill];

	}];
	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_Hpa_HTTP_Gift_Sale_With_InvoiceNumber
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_Gift_Sale_With_InvoiceNumber"];

	HpsHpaDevice *device = [self setupDevice];

	HpsHpaGiftSaleBuilder *builder = [[HpsHpaGiftSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:8.0];
	builder.referenceNumber = 3;

	HpsTransactionDetails *details = [[HpsTransactionDetails alloc] init];
	details.invoiceNumber = @"1234";
	builder.details = details;

	[builder execute:^(id<IHPSDeviceResponse> payload, NSError *error){
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_Hpa_HTTP_Loyalty_Sale
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_Loyalty_Sale"];

	HpsHpaDevice *device = [self setupDevice];

	HpsHpaGiftSaleBuilder *builder = [[HpsHpaGiftSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:18.0];
	builder.referenceNumber = 5;
		//builder.currencyType = HpsCurrencyCodes_POINTS;

	[builder execute:^(id<IHPSDeviceResponse> payload, NSError *error){
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_Hpa_HTTP_Gift_Sale_No_Amount
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_Gift_Fail_No_Amount"];

	HpsHpaDevice *device = [self setupDevice];

	HpsHpaGiftSaleBuilder *builder = [[HpsHpaGiftSaleBuilder alloc] initWithDevice:device];
	builder.referenceNumber = 5;

	@try {
		[builder execute:^(id <IHPSDeviceResponse> payload, NSError *error) {

			XCTFail(@"Request not allowed but returned");
		}];
	} @catch (NSException *exception) {
		[expectation fulfill];
	}

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

	//- (void) test_Hpa_HTTP_Gift_Sale_No_Currency
	//{
	//	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_Gift_Fail_No_Currency"];
	//
	//	HpsHpaDevice *device = [self setupDevice];
	//
	//	HpsHpaGiftSaleBuilder *builder = [[HpsHpaGiftSaleBuilder alloc] initWithDevice:device];
	//	builder.referenceNumber = 6;
	//	builder.currencyType = -1;
	//
	//	@try {
	//		[builder execute:^(id <IHPSDeviceResponse> payload, NSError *error) {
	//
	//			XCTFail(@"Request not allowed but returned");
	//		}];
	//	} @catch (NSException *exception) {
	//		[expectation fulfill];
	//	}
	//
	//	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
	//		if(error) XCTFail(@"Request Timed out");
	//	}];
	//}

#pragma mark :- GiftAddValue
- (void) test_Hpa_HTTP_Gift_AddValue
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_Gift_AddValue"];

	HpsHpaDevice *device = [self setupDevice];

	HpsHpaGiftAddValueBuilder *builder = [[HpsHpaGiftAddValueBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:11.0];
	builder.referenceNumber = 7;

	[builder execute:^(id <IHPSDeviceResponse> payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_Hpa_HTTP_Loyalty_AddValue
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_Loyalty_AddValue"];

	HpsHpaDevice *device = [self setupDevice];

	HpsHpaGiftAddValueBuilder *builder = [[HpsHpaGiftAddValueBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:11.0];
	builder.referenceNumber = 8;
	builder.currencyType = HpsCurrencyCodes_POINTS;

	[builder execute:^(id <IHPSDeviceResponse> payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_Hpa_HTTP_Gift_AddValue_Sale_No_Amount
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_Gift_AddValue_Fail_No_Amount"];

	HpsHpaDevice *device = [self setupDevice];

	HpsHpaGiftAddValueBuilder *builder = [[HpsHpaGiftAddValueBuilder alloc] initWithDevice:device];
	builder.referenceNumber = 9;

	@try {
		[builder execute:^(id <IHPSDeviceResponse> payload, NSError *error) {

			XCTFail(@"Request not allowed but returned");
		}];
	} @catch (NSException *exception) {
		[expectation fulfill];
	}

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_Hpa_HTTP_Gift_AddValue_Sale_No_Currency
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_Gift_AddValue_Fail_No_Currency"];

	HpsHpaDevice *device = [self setupDevice];

	HpsHpaGiftAddValueBuilder *builder = [[HpsHpaGiftAddValueBuilder alloc] initWithDevice:device];
	builder.referenceNumber = 10;
	builder.currencyType = -1;

	@try {
		[builder execute:^(id <IHPSDeviceResponse> payload, NSError *error) {

			XCTFail(@"Request not allowed but returned");
		}];
	} @catch (NSException *exception) {
		[expectation fulfill];
	}

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

#pragma mark :- GiftVoid
-(void) waitAndReset:(HpsHpaDevice *)device
{
	NSLog(@"Resetting Device ...");
	[self performSelector:@selector(reset:) withObject:device afterDelay:3.0 ];
	NSLog(@"Device Resetted ...");
}

- (void) test_Hpa_HTTP_Gift_Void
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_Gift_Void"];

	HpsHpaDevice *device = [self setupDevice];

	HpsHpaGiftSaleBuilder *builder = [[HpsHpaGiftSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:12.0];
	builder.referenceNumber = 13;

	[builder execute:^(id <IHPSDeviceResponse> payload, NSError *error) {

		HpsHpaGiftVoidBuilder *vbuilder = [[HpsHpaGiftVoidBuilder alloc] initWithDevice:device];
		vbuilder.referenceNumber = 13;
		vbuilder.transactionId = ((HpsHpaDeviceResponse*)payload).transactionId;
		//[self waitAndReset:device];
		@try {
			[vbuilder execute:^(id <IHPSDeviceResponse> payload, NSError *error)
			 {
				XCTAssertNil(error);
				XCTAssertNotNil(payload);
				XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
				[expectation fulfill];
			 }];
		} @catch (NSException *exception) {
			NSLog(@"%@", expectation);
		}

	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_Hpa_HTTP_Gift_Void_Fail_No_TransactionId
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_Gift_Void_Fail_No_TransactionId"];

	HpsHpaDevice *device = [self setupDevice];

	HpsHpaGiftVoidBuilder *builder = [[HpsHpaGiftVoidBuilder alloc] initWithDevice:device];
	builder.referenceNumber = 14;

	@try {
		[builder execute:^(id <IHPSDeviceResponse> payload, NSError *error) {

			XCTFail(@"Request not allowed but returned");
		}];
	} @catch (NSException *exception) {
		[expectation fulfill];
	}

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

#pragma mark :- GiftBalance
- (void) test_Hpa_HTTP_Gift_Balance
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_Gift_Balance"];

	HpsHpaDevice *device = [self setupDevice];

	HpsHpaGiftBalanceBuilder *builder = [[HpsHpaGiftBalanceBuilder alloc] initWithDevice:device];
	builder.referenceNumber = 15;
	[builder execute:^(id <IHPSDeviceResponse> payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_Hpa_HTTP_Loyalty_Balance
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_Gift_Loyalty_Balance"];

	HpsHpaDevice *device = [self setupDevice];

	HpsHpaGiftBalanceBuilder *builder = [[HpsHpaGiftBalanceBuilder alloc] initWithDevice:device];
	builder.referenceNumber = 16;
		//	builder.currencyType = HpsCurrencyCodes_POINTS;

	[builder execute:^(id <IHPSDeviceResponse> payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

	//- (void) test_Hpa_HTTP_Gift_Balance_Fail_No_Currency
	//{
	//	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_Gift_Balance_Fail_No_Currency"];
	//
	//	HpsHpaDevice *device = [self setupDevice];
	//
	//	HpsHpaGiftBalanceBuilder *builder = [[HpsHpaGiftBalanceBuilder alloc] initWithDevice:device];
	//	builder.referenceNumber = 17;
	//	builder.currencyType = -1;
	//
	//	@try {
	//		[builder execute:^(id <IHPSDeviceResponse> payload, NSError *error) {
	//
	//			XCTFail(@"Request not allowed but returned");
	//		}];
	//	} @catch (NSException *exception) {
	//		[expectation fulfill];
	//	}
	//
	//	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
	//		if(error) XCTFail(@"Request Timed out");
	//	}];
	//}

@end
