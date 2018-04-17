 //  Copyright (c) 2016 Global Payments. All rights reserved.

#import <XCTest/XCTest.h>
#import "HpsHeartSipDevice.h"
#import "HpsCreditCard.h"
#import "HpsAddress.h"
#import "HpsHeartSipCreditSaleBuilder.h"
#import "HpsHeartSipCreditAuthBuilder.h"
#import "HpsHeartSipCreditCaptureBuilder.h"
#import "HpsHeartSipCreditVerifyBuilder.h"
#import "HpsHeartSipCreditVoidBuilder.h"
#import "HpsHeartSipCreditRefundBuilder.h"

@interface Hps_Sip_Credit_Test : XCTestCase

@end

@implementation Hps_Sip_Credit_Test

 //  Copyright (c) 2016 Global Payments. All rights reserved.

- (HpsHeartSipDevice*) setupDevice
{
	HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
	config.ipAddress = @"10.12.220.130";
	config.port = @"12345";
	config.connectionMode = HpsConnectionModes_TCP_IP;
	HpsHeartSipDevice * device = [[HpsHeartSipDevice alloc] initWithConfig:config];
	return device;
}

#pragma mark :- Validate No Amount
-(void) test_Credit_Sale_No_Amount{
	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHeartSip Do credit Sale fail No Amount"];
	HpsHeartSipDevice *device = [self setupDevice];
	HpsHeartSipCreditSaleBuilder *builder = [[HpsHeartSipCreditSaleBuilder alloc] initWithDevice:device];

	@try {
		[builder execute:^(id<IHPSDeviceResponse>payload, NSError *error)
		 {
			XCTFail(@"Request not allowed but returned");

		 }];
	} @catch (NSException *exception) {
		[expectation fulfill];
	}
	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void) test_Credit_Refund_No_Amount
{

	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHeartSip CreditRefund failed No Amount"];
	HpsHeartSipDevice *device = [self setupDevice];
	HpsHeartSipCreditRefundBuilder *builder = [[HpsHeartSipCreditRefundBuilder alloc]initWithDevice:device];

	@try {
		[builder execute:^(id<IHPSDeviceResponse>payload, NSError *error)
		 {
			XCTFail(@"Request not allowed but returned");

		 }];
	} @catch (NSException *exception) {
		[expectation fulfill];
	}

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];

}

-(void) test_Credit_Auth_No_Amount
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHeartSip Do credit Auth No Amount"];
	HpsHeartSipDevice *device = [self setupDevice];

	HpsHeartSipCreditAuthBuilder *builder = [[HpsHeartSipCreditAuthBuilder alloc]initWithDevice:device];

	@try {
		[builder execute:^(id<IHPSDeviceResponse>payload, NSError *error)
		 {
			XCTFail(@"Request not allowed but returned");

		 }];
	} @catch (NSException *exception) {
		[expectation fulfill];
	}

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

#pragma mark :- Validate No TransactionId

-(void) test_Credit_Void_No_Transaction_Id
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHeartSip CreditVoid failed NoTransactionId"];
	HpsHeartSipDevice *device = [self setupDevice];
	HpsHeartSipCreditVoidBuilder *builder = [[HpsHeartSipCreditVoidBuilder alloc]initWithDevice:device];

	@try {
		[builder execute:^(id<IHPSDeviceResponse>payload, NSError *error)
		 {
			XCTFail(@"Request not allowed but returned");

		 }];
	} @catch (NSException *exception) {
		[expectation fulfill];
	}

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];

}
-(void) test_Credit_Capture_No_TransactionId
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHeartSip Do credit capture no transactionID"];
	HpsHeartSipDevice *device = [self setupDevice];
	HpsHeartSipCreditCaptureBuilder *builder = [[HpsHeartSipCreditCaptureBuilder alloc]initWithDevice:device];

	@try {
		[builder execute:^(id<IHPSDeviceResponse>payload, NSError *error)
		 {
			XCTFail(@"Request not allowed but returned");

		 }];
	} @catch (NSException *exception) {
		[expectation fulfill];
	}

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}
#pragma mark :- wait and Reset
-(void) waitAndReset:(HpsHeartSipDevice *)device
{
	NSLog(@"Resetting Device ...");
	[self performSelector:@selector(reset:) withObject:device afterDelay:3.0 ];
	NSLog(@"Device Resetted ...");
}
#pragma mark :- Other CreditTest

- (void) test_Credit_Sale
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHeartSip Do credit fail MultiplePayments"];
	HpsHeartSipDevice *device = [self setupDevice];
	HpsHeartSipCreditSaleBuilder *builder = [[HpsHeartSipCreditSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:11.52];
	builder.referenceNumber = 1;
	[builder execute:^(id <IHPSDeviceResponse> payload, NSError *error){
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);

		[expectation fulfill];

	}];
	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];

}


-(void) test_Credit_Refund_By_Card
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHeartSip Do credit Refund "];
	HpsHeartSipDevice *device = [self setupDevice];

	HpsHeartSipCreditRefundBuilder *builder = [[HpsHeartSipCreditRefundBuilder alloc]initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:11.52];
	builder.referenceNumber = 1;
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

-(void) test_Credit_Void
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHeartSip Do credit void "];
	HpsHeartSipDevice *device = [self setupDevice];

	HpsHeartSipCreditSaleBuilder *builder = [[HpsHeartSipCreditSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:11.52];
	builder.referenceNumber = 1;
	[builder execute:^(id <IHPSDeviceResponse> payload, NSError *error){
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
		[self waitAndReset:device];
		HpsHeartSipCreditVoidBuilder *voidbuilder = [[HpsHeartSipCreditVoidBuilder alloc]initWithDevice:device];
		voidbuilder.transactionId = [NSNumber numberWithInt:((HpsHeartSipDeviceResponse *)payload).transactionId];

		@try {
			[voidbuilder execute:^(id<IHPSDeviceResponse>payload, NSError *error) {
				XCTAssertNil(error);
				XCTAssertNotNil(payload);
				XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
				[expectation fulfill];

			}];
		} @catch (NSException *exception) {
			XCTFail(@"%@",exception.description);
		}


	}];
	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];

}

-(void) test_Credit_Auth
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHeartSip Do credit Auth"];
	HpsHeartSipDevice *device = [self setupDevice];
	HpsHeartSipCreditAuthBuilder *builder = [[HpsHeartSipCreditAuthBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:11.52];
	builder.referenceNumber = 1;
	[builder execute:^(id <IHPSDeviceResponse> payload, NSError *error){
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
		[expectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void) test_Credit_Capture
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHeartSip Do credit Capture"];
	HpsHeartSipDevice *device = [self setupDevice];
	HpsHeartSipCreditAuthBuilder *builder = [[HpsHeartSipCreditAuthBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:11.52];
	builder.referenceNumber = 1;
	[builder execute:^(id <IHPSDeviceResponse> payload, NSError *error){
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
		[self waitAndReset:device];
		HpsHeartSipCreditCaptureBuilder *caputureBuilder = [[HpsHeartSipCreditCaptureBuilder alloc]initWithDevice:device];
		caputureBuilder.transactionId = [NSNumber numberWithInteger:((HpsHeartSipDeviceResponse *)payload).transactionId];
		[caputureBuilder execute:^(id<IHPSDeviceResponse>response, NSError *error) {
			XCTAssertNil(error);
			XCTAssertNotNil(response);
			XCTAssertEqualObjects(@"00", response.deviceResponseCode);
			[expectation fulfill];
		}];


	}];
	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];

}

-(void) test_Credit_Verify{
	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHeartSip Do credit fail MultiplePayments"];
	HpsHeartSipDevice *device = [self setupDevice];
	HpsHeartSipCreditVerifyBuilder *builder = [[HpsHeartSipCreditVerifyBuilder alloc]initWithDevice:device];
	builder.referenceNumber = 1;
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

	//-(void) test_Credit_Sale_With_Signature_Capture{
	//	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHeartSip Do credit fail MultiplePayments"];
	//	HpsHeartSipDevice *device = [self setupDevice];
	//}

@end

