#import <XCTest/XCTest.h>
#import "HpsHpaDevice.h"
#import "HpsCreditCard.h"
#import "HpsAddress.h"
#import "HpsHpaCreditSaleBuilder.h"
#import "HpsHpaCreditAuthBuilder.h"
#import "HpsHpaCreditCaptureBuilder.h"
#import "HpsHpaCreditVerifyBuilder.h"
#import "HpsHpaCreditVoidBuilder.h"
#import "HpsHpaCreditRefundBuilder.h"

@interface Hps_Hpa_Credit_Test : XCTestCase

@end

@implementation Hps_Hpa_Credit_Test

- (HpsHpaDevice*) setupDevice
{
	HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
	config.ipAddress = @"10.12.220.130";
	config.port = @"12345";
	config.connectionMode = HpsConnectionModes_TCP_IP;
	HpsHpaDevice * device = [[HpsHpaDevice alloc] initWithConfig:config];
	return device;
}

#pragma mark :- Validate No Amount
-(void) test_Credit_Sale_No_Amount{
	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHpa Do credit Sale fail No Amount"];
	HpsHpaDevice *device = [self setupDevice];
	HpsHpaCreditSaleBuilder *builder = [[HpsHpaCreditSaleBuilder alloc] initWithDevice:device];

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

	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHpa CreditRefund failed No Amount"];
	HpsHpaDevice *device = [self setupDevice];
	HpsHpaCreditRefundBuilder *builder = [[HpsHpaCreditRefundBuilder alloc]initWithDevice:device];

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
	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHpa Do credit Auth No Amount"];
	HpsHpaDevice *device = [self setupDevice];

	HpsHpaCreditAuthBuilder *builder = [[HpsHpaCreditAuthBuilder alloc]initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:11.52];

	@try {
		[builder execute:^(id<IHPSDeviceResponse>payload, NSError *error)
		 {
		 	//XCTFail(@"Request not allowed but returned");
		 XCTAssertNil(error);
		 XCTAssertNotNil(payload);
		 XCTAssertEqualObjects(@"00", payload.deviceResponseCode);

		 [expectation fulfill];

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
	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHpa CreditVoid failed NoTransactionId"];
	HpsHpaDevice *device = [self setupDevice];
	HpsHpaCreditVoidBuilder *builder = [[HpsHpaCreditVoidBuilder alloc]initWithDevice:device];

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
	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHpa Do credit capture no transactionID"];
	HpsHpaDevice *device = [self setupDevice];
	HpsHpaCreditCaptureBuilder *builder = [[HpsHpaCreditCaptureBuilder alloc]initWithDevice:device];

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
-(void) waitAndReset:(HpsHpaDevice *)device
{
	NSLog(@"Resetting Device ...");
	[self performSelector:@selector(reset:) withObject:device afterDelay:3.0 ];
	NSLog(@"Device Resetted ...");
}

#pragma mark :- Other CreditTest
- (void) test_Credit_Sale
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHpa Do credit fail MultiplePayments"];
	HpsHpaDevice *device = [self setupDevice];
	HpsHpaCreditSaleBuilder *builder = [[HpsHpaCreditSaleBuilder alloc] initWithDevice:device];
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
	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHpa Do credit Refund "];
	HpsHpaDevice *device = [self setupDevice];

	HpsHpaCreditRefundBuilder *builder = [[HpsHpaCreditRefundBuilder alloc]initWithDevice:device];
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
	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHpa Do credit void "];
	HpsHpaDevice *device = [self setupDevice];

	HpsHpaCreditSaleBuilder *builder = [[HpsHpaCreditSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:11.52];
	builder.referenceNumber = 1;
	[builder execute:^(id <IHPSDeviceResponse> payload, NSError *error){
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
		//[self waitAndReset:device];
		HpsHpaCreditVoidBuilder *voidbuilder = [[HpsHpaCreditVoidBuilder alloc]initWithDevice:device];
		voidbuilder.transactionId = [NSNumber numberWithInt:((HpsHpaDeviceResponse *)payload).transactionId];

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
	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHpa Do credit Auth"];
	HpsHpaDevice *device = [self setupDevice];
	HpsHpaCreditAuthBuilder *builder = [[HpsHpaCreditAuthBuilder alloc] initWithDevice:device];
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
	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHpa Do credit Capture"];
	HpsHpaDevice *device = [self setupDevice];
	HpsHpaCreditAuthBuilder *builder = [[HpsHpaCreditAuthBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:11.52];
	builder.referenceNumber = 1;
	[builder execute:^(id <IHPSDeviceResponse> payload, NSError *error){
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
		[self waitAndReset:device];
		HpsHpaCreditCaptureBuilder *caputureBuilder = [[HpsHpaCreditCaptureBuilder alloc]initWithDevice:device];
		caputureBuilder.transactionId = [NSNumber numberWithInteger:((HpsHpaDeviceResponse *)payload).transactionId];
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
	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHpa Do credit fail MultiplePayments"];
	HpsHpaDevice *device = [self setupDevice];
	HpsHpaCreditVerifyBuilder *builder = [[HpsHpaCreditVerifyBuilder alloc]initWithDevice:device];
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
	//	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHpa Do credit fail MultiplePayments"];
	//	HpsHpaDevice *device = [self setupDevice];
	//}

@end

