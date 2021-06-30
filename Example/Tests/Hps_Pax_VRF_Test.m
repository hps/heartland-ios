#import <XCTest/XCTest.h>
#import "HpsPaxDevice.h"
#import "HpsCreditCard.h"
#import "HpsAddress.h"
#import "HpsPaxCreditSaleBuilder.h"
#import "HpsPaxDeviceResponse.h"
#import "HpsPaxCreditAdjustBuilder.h"
#import "HpsPaxCreditAuthBuilder.h"
#import "HpsPaxCreditCaptureBuilder.h"
#import "HpsPaxCreditReturnBuilder.h"
#import "HpsPaxCreditVerifyBuilder.h"
#import "HpsPaxCreditVoidBuilder.h"
#import "HpsPaxDebitSaleBuilder.h"
#import "HpsPaxDeviceResponse.h"
#import "HpsPaxDebitReturnBuilder.h"
#import "HpsPaxGiftBalanceBuilder.h"
#import "HpsPaxGiftResponse.h"
#import "HpsPaxGiftSaleBuilder.h"
#import "HpsPaxGiftActivateBuilder.h"
#import "HpsPaxGiftAddValueBuilder.h"
#import "HpsPaxBaseResponse.h"

@interface Hps_Pax_VRF_Test : XCTestCase

@end

@implementation Hps_Pax_VRF_Test

- (HpsPaxDevice*) setupDevice
{
	HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
	config.ipAddress = @"10.12.220.172";
	config.port = @"10009";
	config.connectionMode = HpsConnectionModes_TCP_IP;
	HpsPaxDevice * device = [[HpsPaxDevice alloc] initWithConfig:config];
	return device;
}

#pragma mark -
#pragma mark Log Txt File
- (void)writeStringToFile:(NSString*)aString {

		// Build the path, and create if needed.
	NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString* fileName = @"test_result.txt";
	NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];

	if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
		[[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
	}

		// The main act...
	NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:fileAtPath];
	[myHandle seekToEndOfFile];
	[myHandle writeData:[aString dataUsingEncoding:NSUTF8StringEncoding]];
		//[[aString dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fileAtPath atomically:NO];
}

#pragma mark -
#pragma mark Receipt
-(id)getValueOfObject:(id)value{

	return value == NULL?(id)@"":value;
}
-(void)printRecipt:(HpsTerminalResponse *)response
{
	NSMutableString *recipt = [[NSMutableString alloc]init];

	[recipt appendString:[NSString stringWithFormat:@"x_trans_type=%@",[self getValueOfObject:response.transactionType]]] ;
	[recipt appendString:[NSString stringWithFormat:@"&x_application_label=%@",[self getValueOfObject:response.applicationName]]];
	if (response.maskedCardNumber)[recipt appendString:[NSString stringWithFormat: @"&x_masked_card=************%@",response.maskedCardNumber]];
	else [recipt appendString:[NSString stringWithFormat: @"&x_masked_card="]];
	[recipt appendString:[NSString stringWithFormat:@"&x_application_id=%@",[self getValueOfObject:response.applicationId]]];

	switch (response.applicationCryptogramType)
	{
		case TC:
		[recipt appendString:[NSString stringWithFormat:@"&x_cryptogram_type=TC"]];
		break;
		case ARQC:
		[recipt appendString:[NSString stringWithFormat:@"&x_cryptogram_type=ARQC"]];
		break;
		default:
		[recipt appendString:[NSString stringWithFormat:@"&x_cryptogram_type="]];
		break;
	}

	[recipt appendString:[NSString stringWithFormat:@"&x_application_cryptogram=%@",[self getValueOfObject:response.applicationCrytptogram]]];
	[recipt appendString:[NSString stringWithFormat:@"&x_expiration_date=%@",[self getValueOfObject:response.expirationDate]]];
	[recipt appendString:[NSString stringWithFormat:@"&x_entry_method=%@",[HpsTerminalEnums entryModeToString:response.entryMode]]];
	[recipt appendString:[NSString stringWithFormat:@"&x_approval=%@",[self getValueOfObject:response.approvalCode]]];
	[recipt appendString:[NSString stringWithFormat:@"&x_transaction_amount=%@",response.transactionAmount.stringValue]];
	[recipt appendString:[NSString stringWithFormat:@"&x_amount_due=%@",response.amountDue.stringValue]];
	[recipt appendString:[NSString stringWithFormat:@"&x_customer_verification_method=%@",[self getValueOfObject:response.cardHolderVerificationMethod]]];
	[recipt appendString:[NSString stringWithFormat:@"&x_signature_status=%@",[self getValueOfObject:response.signatureStatus]]];
	[recipt appendString:[NSString stringWithFormat:@"&x_response_text=%@",[self getValueOfObject:response.responseText]]];

	NSLog(@"Recipt = %@", recipt);

	[self writeStringToFile:[NSString stringWithFormat:@"Host Reference Number: %@ \n",response.hostResponse.hostReferenceNumber]];
	[self writeStringToFile:[NSString stringWithFormat:@"Transaction ID: %@ \n",response.transactionId]];

	[self writeStringToFile:[NSString stringWithFormat:@"Recipt : %@ \n\n",recipt]];

}

#pragma mark -
#pragma mark Credit
- (void) test_case_01
{
	NSLog(@"TEST CASE 1 - EMV Contact Sale with Offline PIN");
	[self writeStringToFile:@"TEST CASE 1 - EMV Contact Sale with Offline PIN \n"];


	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Credit_Manual"];

	HpsPaxDevice *device = [self setupDevice];
	HpsPaxCreditSaleBuilder *builder = [[HpsPaxCreditSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:4.0];
	builder.referenceNumber = 1;
	builder.allowDuplicates = YES;

	[builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.responseCode);
		if ([payload.responseCode isEqualToString:@"00"])
			[self printRecipt:payload];
		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:90.0 handler:^(NSError *error) {
		if(error){
			[self writeStringToFile:@"Request Timed out \n"];

			XCTFail(@"Request Timed out");
		}
	}];
}
	//- (void) test_case_02
	//{
	//	NSLog(@"TEST CASE 2 - Non EMV Swiped Sale");
	//	[self writeStringToFile:@"TEST CASE 2 - Non EMV Swiped Sale \n"];
	//	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Credit_Manual"];
	//
	//	HpsPaxDevice *device = [self setupDevice];
	//	HpsPaxCreditSaleBuilder *builder = [[HpsPaxCreditSaleBuilder alloc] initWithDevice:device];
	//	builder.amount = [NSNumber numberWithDouble:4.0];
	//	builder.referenceNumber = 1;
	//	builder.allowDuplicates = YES;
	//////
	//	[builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
	//		XCTAssertNil(error);
	//		XCTAssertNotNil(payload);
	//		XCTAssertEqualObjects(@"00", payload.responseCode);
	//		if ([payload.responseCode isEqualToString:@"00"])
	//			[self printRecipt:payload];
	//		[expectation fulfill];
	//
	//	}];
	//
	//	[self waitForExpectationsWithTimeout:90.0 handler:^(NSError *error) {
	//		if(error){
	//			[self writeStringToFile:@"Request Timed out \n"];
	//
	//			XCTFail(@"Request Timed out");
	//		}
	//	}];
	//}

- (void) test_case_03a
{
	NSLog(@"TEST CASE 3 - Mag Stripe Visa");
	[self writeStringToFile:@"TEST CASE 3 - Mag Stripe Online Void \n"];
	[self writeStringToFile:@"Objective - Ensure application can handle non-EMV swiped transactions \n"];

	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Credit_Manual"];

	HpsPaxDevice *device = [self setupDevice];
	HpsPaxCreditSaleBuilder *builder = [[HpsPaxCreditSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:7.0];
	builder.referenceNumber = 3;
	builder.allowDuplicates = YES;

	[builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.responseCode);
		if ([payload.responseCode isEqualToString:@"00"])
			[self printRecipt:payload];

		HpsPaxCreditVoidBuilder *rbuilder = [[HpsPaxCreditVoidBuilder alloc] initWithDevice:device];
		rbuilder.referenceNumber = 4;
		rbuilder.transactionId = payload.transactionId;

		[rbuilder execute:^(HpsPaxCreditResponse *rpayload, NSError *rerror) {
			XCTAssertNil(rerror);
			XCTAssertNotNil(rpayload);
			XCTAssertEqualObjects(@"00", rpayload.responseCode);

			if ([payload.responseCode isEqualToString:@"00"])
				{
				[self writeStringToFile:@"After Void : \n"];

				[self printRecipt:payload];
				}
			[expectation fulfill];

		}];

	}];

	[self waitForExpectationsWithTimeout:90.0 handler:^(NSError *error) {
		if(error){
			[self writeStringToFile:@"Request Timed out \n"];

			XCTFail(@"Request Timed out");
		}
	}];
}

- (void) test_case_03b
{
	NSLog(@"TEST CASE 3 - Mag Stripe Visa");
	[self writeStringToFile:@"TEST CASE 3 - Mag Stripe Visa \n"];
	[self writeStringToFile:@"Objective - Validate partial approval support \n"];
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Credit_Manual"];

	HpsPaxDevice *device = [self setupDevice];
	HpsPaxCreditSaleBuilder *builder = [[HpsPaxCreditSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:155.0];
	builder.referenceNumber = 5;
	builder.allowDuplicates = YES;

	[builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"10", payload.responseCode); 
		XCTAssertEqualObjects(@"100", @(payload.transactionAmount.floatValue).stringValue);
		XCTAssertEqualObjects(@"55", @(payload.amountDue.floatValue).stringValue);
		if ([payload.responseCode isEqualToString:@"10"])
			[self printRecipt:payload];

		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:90.0 handler:^(NSError *error) {
		if(error){
			[self writeStringToFile:@"Request Timed out \n"];

			XCTFail(@"Request Timed out");
		}
	}];
}

- (void) test_case_04
{
	NSLog(@"Magnetic stripe MasterCard MANUALLY ENTERED");
	NSLog(@"PAN: 5599 9999 9999 9997");
	NSLog(@"EXP: 1220");
	NSLog(@"CVV: 321");
	NSLog(@"AVS: 76321");
	[self writeStringToFile:@"TEST CASE 4 - Magnetic stripe MasterCard MANUALLY ENTERED \n"];
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Credit_Manual"];

	HpsPaxDevice *device = [self setupDevice];
	HpsPaxCreditSaleBuilder *builder = [[HpsPaxCreditSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:118.0];
	builder.referenceNumber = 1;
	builder.allowDuplicates = YES;

	[builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.responseCode);
		if ([payload.responseCode isEqualToString:@"00"])
			[self printRecipt:payload];
		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:90.0 handler:^(NSError *error) {
		if(error){
			[self writeStringToFile:@"Request Timed out \n"];

			XCTFail(@"Request Timed out");
		}
	}];
}

- (void) test_case_5_6a
{
	NSLog(@"EMV Visa w/ Signature CVM");

	[self writeStringToFile:@"TEST CASE 5&6_a: EMV Visa w/ Signature CVM \n"];
	[self writeStringToFile:@"Objective - Complete Sale and receive Token \n"];
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Credit_Manual"];

	HpsPaxDevice *device = [self setupDevice];
	HpsPaxCreditSaleBuilder *builder = [[HpsPaxCreditSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:15.01];
	builder.referenceNumber = 7;
	builder.allowDuplicates = YES;
	builder.requestMultiUseToken = YES;

	HpsPaxCreditSaleBuilder *tbuilder = [[HpsPaxCreditSaleBuilder alloc] initWithDevice:device];
	tbuilder.amount = [NSNumber numberWithDouble:15.01];
	tbuilder.referenceNumber = 8;
	tbuilder.allowDuplicates = YES;

	[builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.responseCode);
		if ([payload.responseCode isEqualToString:@"00"]){
			[self writeStringToFile:[NSString stringWithFormat:@"Token Received :%@ \n",payload.tokenData.tokenValue]];
			[self printRecipt:payload];
		}

		tbuilder.token = payload.tokenData.tokenValue;
		[self writeStringToFile:@"Objective - Complete Sale using a Token on File \n"];

		[tbuilder execute:^(HpsPaxCreditResponse *tpayload, NSError *tError) {
			XCTAssertNil(tError);
			XCTAssertNotNil(tpayload);
			XCTAssertEqualObjects(@"00", tpayload.responseCode);
			if ([tpayload.responseCode isEqualToString:@"00"]){
				[self printRecipt:tpayload];
			}
			[expectation fulfill];
		}];

	}];

	[self waitForExpectationsWithTimeout:90.0 handler:^(NSError *error) {
		if(error){
			[self writeStringToFile:@"Request Timed out \n"];

			XCTFail(@"Request Timed out");
		}
	}];
}

- (void) test_case_5_6b
{
	NSLog(@"MSD only MasterCard");

	[self writeStringToFile:@"TEST CASE 5&6_b - MSD only MasterCard \n"];
	[self writeStringToFile:@"Objective - Complete Sale and receive Token \n"];

	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Credit_Manual"];

	HpsPaxDevice *device = [self setupDevice];
	HpsPaxCreditSaleBuilder *builder = [[HpsPaxCreditSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:15.02];
	builder.referenceNumber = 9;
	builder.allowDuplicates = YES;
	builder.requestMultiUseToken = YES;

	HpsPaxCreditSaleBuilder *tbuilder = [[HpsPaxCreditSaleBuilder alloc] initWithDevice:device];
	tbuilder.amount = [NSNumber numberWithDouble:15.03];
	tbuilder.referenceNumber = 10;
	tbuilder.allowDuplicates = YES;

	[builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.responseCode);
		if ([payload.responseCode isEqualToString:@"00"]){
			[self writeStringToFile:[NSString stringWithFormat:@"Token Received :%@ \n",payload.tokenData.tokenValue]];
			[self printRecipt:payload];
		}

		tbuilder.token = payload.tokenData.tokenValue;
		tbuilder.requestMultiUseToken = YES;
		[self writeStringToFile:@"Objective - Complete Sale using a Token on File \n"];

		[tbuilder execute:^(HpsPaxCreditResponse *tpayload, NSError *tError) {
			XCTAssertNil(tError);
			XCTAssertNotNil(tpayload);
			if ([tpayload.responseCode isEqualToString:@"00"]){
				[self printRecipt:tpayload];
			}

			[expectation fulfill];
		}];

	}];

	[self waitForExpectationsWithTimeout:90.0 handler:^(NSError *error) {
		if(error){
			[self writeStringToFile:@"Request Timed out \n"];

			XCTFail(@"Request Timed out");
		}
	}];

}

- (void) test_case_08
{
	NSLog(@"CONDITIONAL TEST CASE 8 – Credit Return");
	[self writeStringToFile:@"CONDITIONAL TEST CASE 8 – Credit Return \n"];
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Return_By_Card"];

	HpsPaxDevice *device = [self setupDevice];

	HpsPaxCreditReturnBuilder *builder = [[HpsPaxCreditReturnBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:9.0];

	[builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.responseCode);

		if ([payload.responseCode isEqualToString:@"00"]){
			[self printRecipt:payload];
		}

		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:90.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

#pragma mark -
#pragma mark Debit
- (void) test_case_9a
{
	NSLog(@"Magnetic Stripe Visa");
	NSLog(@"PIN: 1234");

	NSLog(@"CONDITIONAL TEST CASE 9 – Debit Sale");
	[self writeStringToFile:@"CONDITIONAL TEST CASE 9 – Debit Sale \n"];
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Debit_Sale"];

	HpsPaxDevice *device = [self setupDevice];
	HpsPaxDebitSaleBuilder *builder = [[HpsPaxDebitSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:10.0];
	builder.referenceNumber = 11;
	builder.allowDuplicates = YES;

	[builder execute:^(HpsPaxDebitResponse *payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.responseCode);
		if ([payload.responseCode isEqualToString:@"00"]){
			[self printRecipt:payload];
		}
		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_case_9b
{
	NSLog(@"Magnetic Stripe Visa");
	NSLog(@"PIN: 1234");

	NSLog(@"CONDITIONAL TEST CASE 9 – Debit Sale");
	[self writeStringToFile:@"CONDITIONAL TEST CASE 9 – Debit Sale \n"];
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Debit_Sale"];

	HpsPaxDevice *device = [self setupDevice];
	HpsPaxDebitSaleBuilder *builder = [[HpsPaxDebitSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:11.0];
	builder.referenceNumber = 12;
	builder.allowDuplicates = YES;

	[builder execute:^(HpsPaxDebitResponse *payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.responseCode);
		if ([payload.responseCode isEqualToString:@"00"]){
			[self printRecipt:payload];
		}

		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_case_10
{
	NSLog(@"CONDITIONAL TEST CASE 10 – Debit Return");
	[self writeStringToFile:@"CONDITIONAL TEST CASE 10 – Debit Return \n"];
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Debit_Return"];

	HpsPaxDevice *device = [self setupDevice];
	HpsPaxDebitReturnBuilder *builder = [[HpsPaxDebitReturnBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:12.0];
	builder.referenceNumber = 13;

	[builder execute:^(HpsPaxDebitResponse *payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.responseCode);
		if ([payload.responseCode isEqualToString:@"00"]){
			[self printRecipt:payload];
		}
		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

#pragma mark -
#pragma mark Tip Adjustment using Auth Capture
- (void) test_case_11
{
	NSLog(@"CONDITIONAL TEST CASE 11 – Tip Adjustment");
	[self writeStringToFile:@"CONDITIONAL TEST CASE 11 – Tip Adjustment \n"];
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Auth_Capture"];

	HpsPaxDevice *device = [self setupDevice];
	HpsPaxCreditAuthBuilder *builder = [[HpsPaxCreditAuthBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:15.12];
	builder.referenceNumber = 14;
	builder.allowDuplicates = YES;
	[self writeStringToFile:@"Auth :-\n"];

	[builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {

		XCTAssertNil(error);
		XCTAssertEqualObjects(@"00", payload.responseCode);
		XCTAssertNotNil(payload);
		[self printRecipt:payload];
			//Capture
		HpsPaxCreditCaptureBuilder *cbuilder = [[HpsPaxCreditCaptureBuilder alloc] initWithDevice:device];
		cbuilder.transactionId = payload.transactionId;
		cbuilder.referenceNumber = 15;
		cbuilder.amount = [NSNumber numberWithDouble:18.12];
		[self writeStringToFile:@"Capture \n"];

		[cbuilder execute:^(HpsPaxCreditResponse *cpayload, NSError *cerror) {

			XCTAssertNil(cerror);
			XCTAssertEqualObjects(@"00", cpayload.responseCode);
			XCTAssertNotNil(cpayload);
			[self printRecipt:cpayload];
			[expectation fulfill];

		}];

	}];

	[self waitForExpectationsWithTimeout:56000.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];


}

#pragma mark -
#pragma mark Gift
- (void) test_case_12a
{
	NSLog(@"CONDITIONAL TEST CASE 12 – HMS Gift");
	[self writeStringToFile:@"CONDITIONAL TEST CASE 12 – HMS Gift Balance \n"];
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Gift_Balance"];

	HpsPaxDevice *device = [self setupDevice];
	HpsPaxGiftBalanceBuilder *builder = [[HpsPaxGiftBalanceBuilder alloc] initWithDevice:device];
	builder.referenceNumber = 16;
	[builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"0", payload.responseCode);
		XCTAssertEqualObjects(@"10",@(payload.amountResponse.balance1).stringValue);
		[self printRecipt:payload];

		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];

}

- (void) test_case_12b
{
	NSLog(@"CONDITIONAL TEST CASE 12 – HMS Gift");
	[self writeStringToFile:@"CONDITIONAL TEST CASE 12 – HMS Gift AddValue \n"];
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Gift_AddValue"];

	HpsPaxDevice *device = [self setupDevice];
	HpsPaxGiftAddValueBuilder *builder = [[HpsPaxGiftAddValueBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:8.0];
	builder.referenceNumber = 17;

	[builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"0", payload.responseCode);
		[self printRecipt:payload];
		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_case_12c
{
	NSLog(@"CONDITIONAL TEST CASE 12 – HMS Gift");
	[self writeStringToFile:@"CONDITIONAL TEST CASE 12 – HMS Gift Sale \n"];
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Gift_Sale"];

	HpsPaxDevice *device = [self setupDevice];

	HpsPaxGiftSaleBuilder *builder = [[HpsPaxGiftSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:1.0];
	builder.referenceNumber = 18;
	[builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"0", payload.responseCode);
		[self printRecipt:payload];
		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];

}

- (void) test_case_12d
{
    NSLog(@"CONDITIONAL TEST CASE 12 – HMS Gift");
    [self writeStringToFile:@"CONDITIONAL TEST CASE 12 – HMS Gift Activate \n"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Gift_Activate"];

    HpsPaxDevice *device = [self setupDevice];
    HpsPaxGiftActivateBuilder *builder = [[HpsPaxGiftActivateBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:8.0];
    builder.referenceNumber = 19;

    [builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"0", payload.responseCode);
        [self printRecipt:payload];
        [expectation fulfill];

    }];

    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

#pragma mark -
#pragma mark Batch Close
-(void) test_case_17
{
	NSLog(@"CONDITIONAL TEST CASE 17 – Batch Close");
	NSLog(@"(Mandatory if Conditional Test Cases are ran)");
	[self writeStringToFile:@"CONDITIONAL TEST CASE 17 – Batch Close \n"];
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Batch_Close"];

	HpsPaxDevice *device = [self setupDevice];
	[device batchClose:^(HpsPaxBatchCloseResponse *payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"OK", payload.deviceResponseMessage);

		[self writeStringToFile:[NSString stringWithFormat:@"Batch Number :%@ \n",payload.hostResponse.batchNumber]];
		
		[expectation fulfill];
	}];
	
	
	[self waitForExpectationsWithTimeout:90.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

#pragma mark -
#pragma mark Tip Adjustment using Sale Adjust
- (void) test_case_13
{
    NSLog(@"CONDITIONAL TEST CASE 13 – Tip Adjustment");
    [self writeStringToFile:@"CONDITIONAL TEST CASE 13 – Tip Adjustment \n"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Sale_Adjust"];

    HpsPaxDevice *device = [self setupDevice];
    HpsPaxCreditSaleBuilder *builder = [[HpsPaxCreditSaleBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:15.12];
    builder.referenceNumber = 19;
    builder.allowDuplicates = YES;
    [self writeStringToFile:@"Sale :-\n"];

    [builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {

        XCTAssertNil(error);
        XCTAssertEqualObjects(@"00", payload.responseCode);
        XCTAssertNotNil(payload);
        [self printRecipt:payload];
        //Adjust
        HpsPaxCreditAdjustBuilder *abuilder = [[HpsPaxCreditAdjustBuilder alloc] initWithDevice:device];
        abuilder.transactionId = payload.transactionId;
        abuilder.referenceNumber = 20;
        abuilder.amount = [NSNumber numberWithDouble:18.12];
        [self writeStringToFile:@"Adjust \n"];

        [abuilder execute:^(HpsPaxCreditResponse *apayload, NSError *aerror) {

            XCTAssertNil(aerror);
            XCTAssertEqualObjects(@"00", apayload.responseCode);
            XCTAssertNotNil(apayload);
            [self printRecipt:apayload];
            [expectation fulfill];

        }];

    }];

    [self waitForExpectationsWithTimeout:56000.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];


}

@end
