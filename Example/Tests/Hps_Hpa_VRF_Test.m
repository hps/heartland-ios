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
#import "HpsHpaGiftBalanceBuilder.h"
#import "HpsHpaDeviceResponse.h"
#import "HpsHpaGiftAddValueBuilder.h"
#import "HpsHpaGiftSaleBuilder.h"

@interface Hps_Hpa_VRF_Test : XCTestCase

@end

@implementation Hps_Hpa_VRF_Test

- (HpsHpaDevice*) setupDevice
{
	HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
	config.ipAddress = @"10.12.220.39";
	config.port = @"12345";
	config.connectionMode = HpsConnectionModes_TCP_IP;
	HpsHpaDevice * device = [[HpsHpaDevice alloc] initWithConfig:config];
	return device;
}

#pragma mark Log Txt File
- (void)writeStringToFile:(NSString*)aString {

		// Build the path, and create if needed.
	NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

	NSString* fileName = @"HpaVRF.txt";
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
	if (response.maskedCardNumber)[recipt appendString:[NSString stringWithFormat: @"&x_masked_card=%@",response.maskedCardNumber]];
	else [recipt appendString:[NSString stringWithFormat: @"&x_masked_card="]];
	[recipt appendString:[NSString stringWithFormat:@"&x_application_id=%@",[self getValueOfObject:response.applicationId]]];
	[recipt appendString:[NSString stringWithFormat:@"&x_cryptogram_type=%@",[self getValueOfObject:response.applicationCryptogramTypeS]]];
	[recipt appendString:[NSString stringWithFormat:@"&x_application_cryptogram=%@",[self getValueOfObject:response.applicationCrytptogram]]];
	[recipt appendString:[NSString stringWithFormat:@"&x_expiration_date=%@",[self getValueOfObject:response.expirationDate]]];
	[recipt appendString:[NSString stringWithFormat:@"&x_entry_method=%@",response.entryMethod]];
	[recipt appendString:[NSString stringWithFormat:@"&x_approval=%@",[self getValueOfObject:response.approvalCode]]];
	[recipt appendString:[NSString stringWithFormat:@"&x_transaction_amount=%@",response.transactionAmount]];
	[recipt appendString:[NSString stringWithFormat:@"&x_amount_due=%@",[self getValueOfObject:response.amountDue]]];
	[recipt appendString:[NSString stringWithFormat:@"&x_customer_verification_method=%@",[self getValueOfObject:response.cardHolderVerificationMethod]]];
	[recipt appendString:[NSString stringWithFormat:@"&x_signature_status=%@",[self getValueOfObject:response.signatureStatus]]];
	[recipt appendString:[NSString stringWithFormat:@"&x_response_text=%@",[self getValueOfObject:response.responseText]]];

	NSLog(@"Recipt = %@", recipt);

	[self writeStringToFile:[NSString stringWithFormat:@"Host Reference Number: %@ \n",response.hostResponse.hostReferenceNumber]];
	[self writeStringToFile:[NSString stringWithFormat:@"Transaction ID: %d \n",response.transactionId]];

	[self writeStringToFile:[NSString stringWithFormat:@"Recipt : %@ \n\n",recipt]];

}

#pragma mark -
#pragma mark :- wait and Reset
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

#pragma mark -
#pragma mark VRF UnitTest

/*
 TEST CASE #1 – Contact Chip and Signature – Offline
 Objective Process a contact transaction where the CVM’s supported are offline chip and signature
 Test Card Card #1 - MasterCard EMV
 Procedure Perform a complete transaction without error..
 Enter transaction amount $23.00.
 */

- (void) test_Case01
{
	[self writeStringToFile:@"TEST CASE #1 – Contact Chip and Signature – Offline \n"];

	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHpa Do credit fail MultiplePayments"];

	HpsHpaDevice *device = [self setupDevice];

	HpsHpaCreditSaleBuilder *builder = [[HpsHpaCreditSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:23];
	builder.referenceNumber = [device generateNumber];

	[builder execute:^(id <IHPSDeviceResponse> payload, NSError *error){
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
		NSLog(@"Response = %@",payload.toString);
		NSLog(@"Host Reference Number = %d",((HpsTerminalResponse *)payload).transactionId);
		[self printRecipt:(HpsHpaDeviceResponse *)payload];
		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];

}

/*
 TEST CASE #2 - EMV Receipts
 Objective	1. Verify receipt image conforms to EMV Receipt Requirements.
 2. Verify that signature capture functionality works.
 Test Card	Any card brand – Visa, MC, Discover, AMEX.
 Procedure	Run an EMV insert sale using any card brand.
 The device should get an Approval.
 Cardholder is prompted to sign on the device.
 */

- (void) TestCase02
{
		// print receipt for TestCase01
}

/*
 TEST CASE #3 - Approved Sale with Offline PIN
 Objective	Process an EMV contact sale with offline PIN.
 Test Card	Card #1 - MasterCard EMV
 Procedure	Insert the card in the chip reader and follow the instructions on the device.
 Enter transaction amount $25.00.
 When prompted for PIN, enter 4315.
 If no PIN prompt, device could be in QPS mode with limit above transaction amount.
 */


- (void) test_Case03
{
    [self writeStringToFile:@" TEST CASE #3 - Mag Stripe Online Void\n"];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHpa Do credit void "];
    
    HpsHpaDevice *device = [self setupDevice];
    
    HpsHpaCreditSaleBuilder *builder = [[HpsHpaCreditSaleBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:8];
    builder.referenceNumber = [device generateNumber];
    
    [builder execute:^(id <IHPSDeviceResponse> payload, NSError *error){
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
        
        HpsHpaCreditVoidBuilder *voidbuilder = [[HpsHpaCreditVoidBuilder alloc]initWithDevice:device];
        voidbuilder.transactionId = ((HpsHpaDeviceResponse *)payload).transactionId;
        voidbuilder.referenceNumber = [device generateNumber];
        NSLog(@"#### transactionID = %@",((HpsHpaDeviceResponse *)payload).transactionId);
        
        [self waitAndReset:device completion:^(BOOL success) {
            if (success) {
                @try {
                    [voidbuilder execute:^(id<IHPSDeviceResponse>payload, NSError *error) {
                        XCTAssertNil(error);
                        XCTAssertNotNil(payload);
                        XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
                        NSLog(@"Response = %@",payload.toString);
                        NSLog(@"Host Reference Number = %@",((HpsTerminalResponse *)payload).transactionId);
                        //[self writeStringToFile:[NSString stringWithFormat:@"Transaction ID: %d \n",((HpsTerminalResponse *)payload).transactionId]];
                        [self printRecipt:(HpsHpaDeviceResponse *)payload];
                        
                        [expectation fulfill];
                    }];
                } @catch (NSException *exception) {
                    XCTFail(@"Credit_Void_Failed: %@",exception.description);
                }
            }else {
                XCTFail(@"Credit_Void_Failed");
            }
        }];
    }];
    
    [self waitForExpectationsWithTimeout:120.0 handler:^(NSError *error) {
        
        if(error) XCTFail(@"Request Timed out");
    }];
}

/*
 TEST CASE #4 -  Manually Entered Sale with AVS & CVV2/CID
 (If AVS is supported)
 Objective	Process a keyed sale, with PAN & exp date, along with Address Verification and Card Security Code to confirm the application can support any or all of these.
 Test Card	Card #5 – MSD only MasterCard
 Procedure	1. Select sale function and manually key Test Card #5 for the amount of $90.08.
 a.	Enter PAN & expiration date.
 b.	Enter 321 for Card Security Code (CVV2, CID), if supporting this feature.
 Enter 76321 for AVS, if supporting this feature.
 */

- (void) test_Case04
{
	[self writeStringToFile:@"TEST CASE #4 - Manually Entered Sale with AVS & CVV2/CID \n"];

	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHpa Do credit fail MultiplePayments"];

	HpsHpaDevice *device = [self setupDevice];

	HpsHpaCreditSaleBuilder *builder = [[HpsHpaCreditSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:118.00];
	builder.referenceNumber = [device generateNumber];

	[builder execute:^(id <IHPSDeviceResponse> payload, NSError *error){
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
		//XCTAssertEqualObjects(@"Y", ((HpsTerminalResponse*)payload).avsResultCode);
		//XCTAssertEqualObjects(@"M", ((HpsTerminalResponse*)payload).cvvResponseCode);

		NSLog(@"Response = %@",payload.toString);
		NSLog(@"Host Reference Number = %d",((HpsTerminalResponse *)payload).transactionId);

		[self printRecipt:(HpsHpaDeviceResponse *)payload];
		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

/*
 TEST CASE #5 - Partial Approval
 Objective	1. Ensure application can handle non-EMV swiped transactions.
 2. Validate partial approval support.
 Test Card	Card #4 – MSD only Visa
 Procedure	Run a credit sale and follow the instructions on the device to complete the transaction.
 Enter transaction amount $155.00 to receive a partial approval.
 Transaction is partially approved online with an amount due remaining.
 */

- (void) test_Case05
{
	[self writeStringToFile:@" TEST CASE #5 - Partial Approval \n"];

	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHpa Do credit fail MultiplePayments"];

	HpsHpaDevice *device = [self setupDevice];

	HpsHpaCreditSaleBuilder *builder = [[HpsHpaCreditSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:155.00];
	builder.referenceNumber = [device generateNumber];

	[builder execute:^(id <IHPSDeviceResponse> payload, NSError *error){
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"10", payload.deviceResponseCode);
		XCTAssertEqualObjects(@"55",((HpsTerminalResponse *)payload).amountDue.stringValue);

		NSLog(@"Response = %@",payload.toString);
		NSLog(@"Host Reference Number = %d",((HpsTerminalResponse *)payload).transactionId);

		[self printRecipt:(HpsHpaDeviceResponse *)payload];
		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

/*
 TEST CASE #6 - Online Void
 Objective	Process an online void.
 Test Card	Card #3 – EMV Visa w/ Signature CVM
 Procedure	Enter the Transaction ID to void.
 Transaction has been voided.
 */

- (void) test_Case06
{
	[self writeStringToFile:@" TEST CASE #6 - Online Void \n"];

	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHpa Do credit void "];

	HpsHpaDevice *device = [self setupDevice];

	HpsHpaCreditSaleBuilder *builder = [[HpsHpaCreditSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:10];
	builder.referenceNumber = [device generateNumber];

	[builder execute:^(id <IHPSDeviceResponse> payload, NSError *error){
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);

		HpsHpaCreditVoidBuilder *voidbuilder = [[HpsHpaCreditVoidBuilder alloc]initWithDevice:device];
		voidbuilder.transactionId = [NSNumber numberWithInt:((HpsHpaDeviceResponse *)payload).transactionId];
		NSLog(@"#### transactionID = %@",[NSNumber numberWithInt:((HpsHpaDeviceResponse *)payload).transactionId]);

		[self waitAndReset:device completion:^(BOOL success) {
			if (success) {
				@try {
					[voidbuilder execute:^(id<IHPSDeviceResponse>payload, NSError *error) {
						XCTAssertNil(error);
						XCTAssertNotNil(payload);
						XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
						NSLog(@"Response = %@",payload.toString);
						NSLog(@"Host Reference Number = %d",((HpsTerminalResponse *)payload).transactionId);
							//[self writeStringToFile:[NSString stringWithFormat:@"Transaction ID: %d \n",((HpsTerminalResponse *)payload).transactionId]];
						[self printRecipt:(HpsHpaDeviceResponse *)payload];

						[expectation fulfill];
					}];
				} @catch (NSException *exception) {
					XCTFail(@"Credit_Void_Failed: %@",exception.description);
				}
			}else {
				XCTFail(@"Credit_Void_Failed");
			}
		}];
	}];

	[self waitForExpectationsWithTimeout:120.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];

}

/*
 TEST CASE  #8 – Process Lane Open on Hpa
 Objective	Display line items on the Hpa.
 Test Card	NA
 Procedure	Start the process to open a lane on the POS.
 */

-(void)test_Case08
{
	[self writeStringToFile:@" TEST CASE  #8 – Process Lane Open on Hpa \n"];

	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_TCP_Lane_Open"];

	HpsHpaDevice *device = [self setupDevice];

	[device openLane:^(id<IHPSDeviceResponse> payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);

			//HpsHpaDeviceResponse *response = (HpsHpaDeviceResponse*)payload;
		[self printRecipt:(HpsHpaDeviceResponse *)payload];

		[expectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

/*
 TEST CASE #9 – Credit Return
 Objective	Confirm support of a Return transaction for credit.
 Test Card	Card #4 – MSD only Visa
 Procedure	1.	Select return function for the amount of $9.00
 2.	Swipe or Key Test card #4 through the MSR
 3.	Select credit on the device
 */

-(void) test_Case09
{
	[self writeStringToFile:@" TEST CASE #9 – Credit Return \n"];

	XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHpa Do credit Refund "];

	HpsHpaDevice *device = [self setupDevice];

	HpsHpaCreditRefundBuilder *builder = [[HpsHpaCreditRefundBuilder alloc]initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:9];
	builder.referenceNumber = [device generateNumber];

	[builder execute:^(id<IHPSDeviceResponse>payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
		NSLog(@"Response = %@",payload.toString);
		NSLog(@"Host Reference Number = %d",((HpsTerminalResponse *)payload).transactionId);
		[self printRecipt:(HpsHpaDeviceResponse *)payload];

		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

/*
 TEST CASE #10 – HMS Gift
 Objective	Transactions: Gift Balance Inquiry,  Gift Load,  Gift Sale/Redeem, Gift Replace
 Test Card	Gift Card (Card Present/Card Swipe)
 Procedure	Test System is a Stateless Environment, the responses are Static.
 1.	Gift Balance Inquiry (GiftCardBalance):
 a.	Should respond with a BalanceAmt of $10
 2.	Gift Load (GiftCardAddValue):
 a.	Initiate a Sale and swipe
 b.	Enter $8.00 as the amount
 3.	Gift Sale/Redeem (GiftCardSale):
 a.	Initiate a Sale and swipe
 b.	Enter $1.00 as the amount
 4.	Gift Card Replace (GiftCardReplace)
 a.	Initiate a Gift Card Replace
 b.	Swipe Card #1 – (Acct #: 5022440000000000098)
 c.	Manually enter  Card #2 –  (Acct #: “5022440000000000007”)
 */

- (void) test_Case10a
{
	[self writeStringToFile:@" TEST CASE #10a – HMS Gift \n"];

	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_Gift_Balance"];

	HpsHpaDevice *device = [self setupDevice];

	HpsHpaGiftBalanceBuilder *builder = [[HpsHpaGiftBalanceBuilder alloc] initWithDevice:device];
	builder.referenceNumber = [device generateNumber];

	[builder execute:^(id <IHPSDeviceResponse> payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
		double balance = ((HpsHpaDeviceResponse *)payload).balanceAmount.doubleValue;
		XCTAssertEqualObjects([NSNumber numberWithDouble:10], [NSNumber numberWithDouble:balance]);
		NSLog(@"Response = %@",payload.toString);
		NSLog(@"Host Reference Number = %d",((HpsTerminalResponse *)payload).transactionId);
		[self printRecipt:(HpsHpaDeviceResponse *)payload];

		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}


- (void) test_Case10b
{
	[self writeStringToFile:@"TEST CASE #10b – HMS Gift \n"];

	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_Gift_AddValue"];

	HpsHpaDevice *device = [self setupDevice];

	HpsHpaGiftAddValueBuilder *builder = [[HpsHpaGiftAddValueBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:8.0];
	builder.referenceNumber = [device generateNumber];

	[builder execute:^(id <IHPSDeviceResponse> payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
		NSLog(@"Response = %@",payload.toString);
		NSLog(@"Host Reference Number = %d",((HpsTerminalResponse *)payload).transactionId);
		[self printRecipt:(HpsHpaDeviceResponse *)payload];

		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_10c
{
	[self writeStringToFile:@"TEST CASE #10c – HMS Gift \n"];

	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_Loyalty_Sale"];

	HpsHpaDevice *device = [self setupDevice];

	HpsHpaGiftSaleBuilder *builder = [[HpsHpaGiftSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:1.0];
	builder.referenceNumber = [device generateNumber];

	[builder execute:^(id<IHPSDeviceResponse> payload, NSError *error){
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
		NSLog(@"Response = %@",payload.toString);
		NSLog(@"Host Reference Number = %d",((HpsTerminalResponse *)payload).transactionId);
		[self printRecipt:(HpsHpaDeviceResponse *)payload];

		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

/*
 TEST CASE #13 – Batch Close
 (Mandatory if Conditional Test Cases are ran)
 Objective	Close the batch, ensuring all approved transactions (offline or online) are settled.
 Integrators are automatically provided accounts with auto-close enabled, so if manual batch transmission will not be performed in the production environment then it does not need to be tested.
 Test Card	N/A
 Procedure	Initiate a Batch Close command
 Pass Criteria	Batch submission must be successful.
 Batch Sequence #:
 References		Hpa Specifications.
 */


-(void)test_Case13{
	[self writeStringToFile:@"TEST CASE #13 – Batch Close \n"];

	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_Batch_Close"];

	HpsHpaDevice *device = [self setupDevice];
	[device batchClose:^(id<IBatchCloseResponse>payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);

		HpsHpaBatchResponse *response = (HpsHpaBatchResponse*)payload;
		NSLog(@"%@", [response toString]);
		NSLog(@"Response = %@",payload.toString);
		[self printRecipt:(HpsHpaDeviceResponse *)payload];

		[expectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		
		if(error) XCTFail(@"Request Timed out");
	}];
}

@end
