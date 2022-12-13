#import <XCTest/XCTest.h>
#import <Heartland_iOS_SDK/HpsHpaDevice.h>
#import <Heartland_iOS_SDK/HpsConnectionConfig.h>
#import <Heartland_iOS_SDK/HpsTerminalEnums.h>
#import <Heartland_iOS_SDK/HpsHpaGiftSaleBuilder.h>
#import <Heartland_iOS_SDK/HpsHpaGiftAddValueBuilder.h>
#import <Heartland_iOS_SDK/HpsHpaGiftVoidBuilder.h>
#import <Heartland_iOS_SDK/HpsGiftCard.h>
#import <Heartland_iOS_SDK/HpsHpaGiftBalanceBuilder.h>

@interface Hps_Hpa_Gift_Test : XCTestCase

@end

@implementation Hps_Hpa_Gift_Test

- (HpsHpaDevice*) setupDevice
{
	HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
	config.ipAddress = @"10.12.220.39";
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
	builder.referenceNumber = [device generateNumber];

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
	builder.referenceNumber = [device generateNumber];

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
	builder.referenceNumber = [device generateNumber];
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
	builder.referenceNumber = [device generateNumber];

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
	builder.referenceNumber = [device generateNumber];

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
	builder.referenceNumber = [device generateNumber];
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
	builder.referenceNumber = [device generateNumber];

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
	builder.referenceNumber = [device generateNumber];
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
-(void) waitAndReset:(HpsHpaDevice *)device completion:(void(^)(BOOL success))responseBlock
{
	NSLog(@"Resetting Device ...");

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[device reset:^(id<IHPSDeviceResponse> payload, NSError *error) {
			if (payload != nil){
				if ([payload.deviceResponseCode isEqualToString:@"00"]){
					NSLog(@"Device Resetted ...");
					responseBlock(YES);
				}
			}else {
				NSLog(@"Device Not Resetted ...");
				responseBlock(NO);
			}
		}];
	});
}

- (void) test_Hpa_HTTP_Gift_Void
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_Gift_Void"];

	HpsHpaDevice *device = [self setupDevice];

	HpsHpaGiftSaleBuilder *builder = [[HpsHpaGiftSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:12.0];
	builder.referenceNumber = [device generateNumber];

	[builder execute:^(id <IHPSDeviceResponse> payload, NSError *error) {

		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);

		HpsHpaGiftVoidBuilder *vbuilder = [[HpsHpaGiftVoidBuilder alloc] initWithDevice:device];
		vbuilder.referenceNumber = [device generateNumber];
		vbuilder.transactionId = ((HpsHpaDeviceResponse*)payload).transactionId;

		[self waitAndReset:device completion:^(BOOL success) {
			if (success) {
				@try {
					[vbuilder execute:^(id <IHPSDeviceResponse> payload, NSError *error)
					 {
					 XCTAssertNil(error);
					 XCTAssertNotNil(payload);
					 XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
					 [expectation fulfill];
					 }];
				} @catch (NSException *exception) {
					NSLog(@"Gift_Void_Failed: %@", expectation);
				}
			}else {
				XCTFail(@"Gift_Void_Failed");
			}
		}];
	}];

	[self waitForExpectationsWithTimeout:120.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_Hpa_HTTP_Gift_Void_Fail_No_TransactionId
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_Gift_Void_Fail_No_TransactionId"];

	HpsHpaDevice *device = [self setupDevice];

	HpsHpaGiftVoidBuilder *builder = [[HpsHpaGiftVoidBuilder alloc] initWithDevice:device];
	builder.referenceNumber = [device generateNumber];

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
	builder.referenceNumber = [device generateNumber];

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
	builder.referenceNumber = [device generateNumber];
	//builder.currencyType = HpsCurrencyCodes_POINTS;

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
