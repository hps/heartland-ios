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
#import "HpsHpaDebitSaleBuilder.h"
#import "HpsHpaDebitRefundBuilder.h"
#import "HpsHpaGiftBalanceBuilder.h"
#import "HpsHpaDeviceResponse.h"
#import "HpsHpaGiftAddValueBuilder.h"
#import "HpsHpaGiftSaleBuilder.h"
#import "HpsHpaEBTSaleBuilder.h"
#import "HpsHpaEBTRefundBuilder.h"
#import "HpsHpaEBTBalanceBuilder.h"
#import "HpsHpaEodBuilder.h"

@interface Hps_Hpa_VRF_Test : XCTestCase

@end

@implementation Hps_Hpa_VRF_Test

- (HpsHpaDevice*) setupDevice
{
    HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
    config.ipAddress = @"192.168.1.7";
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
    [recipt appendString:[NSString stringWithFormat:@"&x_cardholder_name=%@",[self getValueOfObject:response.cardholderName]]];
    
    NSLog(@"Recipt = %@", recipt);
    
    [self writeStringToFile:[NSString stringWithFormat:@"Host Reference Number: %@ \n",response.hostResponse.hostReferenceNumber]];
    [self writeStringToFile:[NSString stringWithFormat:@"Transaction ID: %@ \n",response.transactionId]];
    
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
 TEST CASE #1 – EMV Contact Sale with Offline PIN
 Objective Process an EMV contact sale with offline PIN.
 Test Card Card #1 - EMV MasterCard w Offline PIN
 Procedure Select Sale function
 Enter transaction amount $4.00.
 */

- (void) test_Case01
{
    [self writeStringToFile:@"TEST CASE #1 – EMV Contact Sale with Offline PIN\n"];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHpa Do credit fail MultiplePayments"];
    
    HpsHpaDevice *device = [self setupDevice];
    
    HpsHpaCreditSaleBuilder *builder = [[HpsHpaCreditSaleBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:4];
    builder.referenceNumber = [device generateNumber];
    
    [builder execute:^(id <IHPSDeviceResponse> payload, NSError *error){
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
        NSLog(@"Response = %@",payload.toString);
        NSLog(@"Host Reference Number = %@",((HpsTerminalResponse *)payload).transactionId);
        [self printRecipt:(HpsHpaDeviceResponse *)payload];
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        
        if(error) XCTFail(@"Request Timed out");
    }];
    
}

/*
 TEST CASE #2 - Non EMV Swiped Sale
 Objective    1. Ensure application can handle non-EMV swiped transactions.
 2. Validate partial approval support.
 Test Card    Card #5 - MSD only MasterCard
 Procedure    1. Select sale function and swipe Test Card #5 for the amount of $7.00
 2. Select sale function and swipe Test Card #5 for the amount of $155.00
 ● Receive an approved amount less than requested.
 Criteria :
 1. Transactions must be approved online.
 ● 1st Credit Sale ResponseID:
 ● 2nd Credit Sale ResponseID:
 2. For 2nd Credit Sale, provide:
 ● Approved Amount: $ 100.00
 ● Response Code: 10
 3. Receipt must conform to Mag Stripe Receipt Requirements.
 */

- (void) test_Case02a
{
    [self writeStringToFile:@"TEST CASE #2 - Non EMV Swiped Sale\n"];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHpa Do credit fail MultiplePayments"];
    
    HpsHpaDevice *device = [self setupDevice];
    
    HpsHpaCreditSaleBuilder *builder = [[HpsHpaCreditSaleBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:7];
    builder.referenceNumber = [device generateNumber];
    
    [builder execute:^(id <IHPSDeviceResponse> payload, NSError *error){
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
        NSLog(@"Response = %@",payload.toString);
        NSLog(@"Host Reference Number = %@",((HpsTerminalResponse *)payload).transactionId);
        [self printRecipt:(HpsHpaDeviceResponse *)payload];
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_Case02b
{
    [self writeStringToFile:@"TEST CASE #2 - Non EMV Swiped Sale\n"];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHpa Do credit fail MultiplePayments"];
    
    HpsHpaDevice *device = [self setupDevice];
    
    HpsHpaCreditSaleBuilder *builder = [[HpsHpaCreditSaleBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:155];
    builder.referenceNumber = [device generateNumber];
    
    [builder execute:^(id <IHPSDeviceResponse> payload, NSError *error){
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"10", payload.deviceResponseCode);
        NSLog(@"Response = %@",payload.toString);
        NSLog(@"Host Reference Number = %@",((HpsTerminalResponse *)payload).transactionId);
        [self printRecipt:(HpsHpaDeviceResponse *)payload];
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        
        if(error) XCTFail(@"Request Timed out");
    }];
}
/*
 TEST CASE #3 - Mag Stripe Online Void
 Objective    Process an online void.
 Test Card    Card #5 – MSD only MasterCard
 Procedure    1. Select sale function and swipe Test Card #5 for the amount of $8.00
 2. Select Void function to remove the previous Sale of $8.00.
 ● Enter in the TransactionID from the Credit Sale when prompted.
 ● Select Credit
 Transaction must be approved online.
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
 TEST CASE #5 – Credit Refund
 Objective   Confirm support of a Refund transaction for credit.
 Test Card    Card #4 – MSD only Visa
 Procedure  ● Select refund function for the amount of $9.00
 ● Swipe or Key Test card #4 through the MSR
 ● Select credit on the device
 */
-(void) test_Case05
{
    [self writeStringToFile:@" TEST CASE #5 – Credit Refund\n"];
    
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
        NSLog(@"Host Reference Number = %@",((HpsTerminalResponse *)payload).transactionId);
        [self printRecipt:(HpsHpaDeviceResponse *)payload];
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        
        if(error) XCTFail(@"Request Timed out");
    }];
}

/*
 TEST CASE #6 - Manually Entered Sale with AVS & CVV2/CID (If AVS is supported. Parameter “MANUAL” is enabled.)
 Objective    Process a keyed sale, with PAN & exp date, along with Address Verification and Card Security Code to confirm the application can support any or all of these.
 Test Card    Card #5 – MSD only MasterCard
 Procedure    Select sale function and manually key Test Card #5 for the amount of $118.00.
 ● Enter PAN & expiration date.
 ● Enter 321 for Card Security Code (CVV2, CID), if supporting this feature.
 ● Enter 76321 for AVS, if supporting this feature.
 */

- (void) test_Case06
{
    [self writeStringToFile:@"TEST CASE #6 - Manually Entered Sale with AVS & CVV2/CID (If AVS is supported. Parameter “MANUAL” is enabled.\n"];
    
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
        NSLog(@"Host Reference Number = %@",((HpsTerminalResponse *)payload).transactionId);
        
        [self printRecipt:(HpsHpaDeviceResponse *)payload];
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        
        if(error) XCTFail(@"Request Timed out");
    }];
}

/*
 TEST CASE #7 - Debit Sale and Debit Sale with Cash Back
 Objective    Confirm support of PIN debit sale and cash back.
 Test Card    Card #4 – MSD only Visa
 Procedure    1. Debit Sale
 ● Select Debit Sale function and swipe Test Card #4 for the amount of $10.00.
 ● When prompted for PIN, enter 1234.
 2.Debit Sale with Cash Back
 ● Select Debit Sale function and swipe Test Card #4 for the amount of $10.00.
 ● When prompted for Cash Back, enter $5.00 for the cash back amount.
 ○ Note: CASHBACK parameter must be ON to prompt for Cash Back.
 ● When prompted for PIN, enter 1234.
 */
- (void) test_Case07
{
    [self writeStringToFile:@" TEST CASE #7 - Debit Sale and Debit Sale with Cash Back\n"];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_TCP_Debit_Sale"];
    
    HpsHpaDevice *device = [self setupDevice];
    
    HpsHpaDebitSaleBuilder *builder = [[HpsHpaDebitSaleBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:10.00];
    builder.referenceNumber = [device generateNumber];
    builder.allowDuplicates = YES;
    
    [builder execute:^(id<IHPSDeviceResponse>payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
        NSLog(@"Response = %@",payload.toString);
        NSLog(@"Host Reference Number = %@",((HpsTerminalResponse *)payload).transactionId);
        [self printRecipt:(HpsHpaDeviceResponse *)payload];
        
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

/*
 TEST CASE #8 - Debit Refund
 Objective    Confirm support of Debit Refund
 Test Card    Card #4 – MSD only Visa
 Procedure    Select Debit Refund function and swipe Test Card #4 for the amount of $12.00.
 ● When prompted for PIN, enter 1234.
 */
- (void) test_Case08
{
    [self writeStringToFile:@" TEST CASE #8 - Debit Refund\n"];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_TCP_Debit_Refund"];
    
    HpsHpaDevice *device = [self setupDevice];
    
    HpsHpaDebitRefundBuilder *builder = [[HpsHpaDebitRefundBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:12.00];
    builder.referenceNumber = [device generateNumber];
    
    [builder execute:^(id<IHPSDeviceResponse> payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
        NSLog(@"Response = %@",payload.toString);
        NSLog(@"Host Reference Number = %@",((HpsTerminalResponse *)payload).transactionId);
        [self printRecipt:(HpsHpaDeviceResponse *)payload];
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:120.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

/*
 TEST CASE #9 – EBT Food Stamp
 Objective    Transactions: Food Stamp Sale, Food Stamp Refund, and Food Stamp Balance Inquiry
 Test Card    Card #4 – MSD only Visa
 */
- (void) test_Case09a
{
    [self writeStringToFile:@" TEST CASE #9a – EBT Food Stamp - sale\n"];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_TCP_EBT_Sale"];
    
    HpsHpaDevice *device = [self setupDevice];
    
    HpsHpaEBTSaleBuilder *builder = [[HpsHpaEBTSaleBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:101.01];
    builder.referenceNumber = [device generateNumber];
    
    [builder execute:^(id<IHPSDeviceResponse>payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
        NSLog(@"Response = %@",payload.toString);
        NSLog(@"Host Reference Number = %@",((HpsTerminalResponse *)payload).transactionId);
        [self printRecipt:(HpsHpaDeviceResponse *)payload];
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_Case09b
{
    [self writeStringToFile:@" TEST CASE #9b – EBT Food Stamp - refund\n"];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_TCP_EBT_Refund"];
    
    HpsHpaDevice *device = [self setupDevice];
    
    HpsHpaEBTRefundBuilder *builder = [[HpsHpaEBTRefundBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:104.01];
    builder.referenceNumber = [device generateNumber];
    
    [builder execute:^(id<IHPSDeviceResponse> payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
        NSLog(@"Response = %@",payload.toString);
        NSLog(@"Host Reference Number = %@",((HpsTerminalResponse *)payload).transactionId);
        [self printRecipt:(HpsHpaDeviceResponse *)payload];
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_Case09c
{
    [self writeStringToFile:@" TEST CASE #9c – EBT Food Stamp - Balance Inquiry\n"];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_EBT_Balance"];
    
    HpsHpaDevice *device = [self setupDevice];
    
    HpsHpaEBTBalanceBuilder *builder = [[HpsHpaEBTBalanceBuilder alloc] initWithDevice:device];
    builder.referenceNumber = [device generateNumber];
    
    [builder execute:^(id <IHPSDeviceResponse> payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
        NSLog(@"Response = %@",payload.toString);
        NSLog(@"Host Reference Number = %@",((HpsTerminalResponse *)payload).transactionId);
        [self printRecipt:(HpsHpaDeviceResponse *)payload];
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

/*
 TEST CASE #10 – EBT Cash Benefits
 Objective    Transactions: EBT Cash Benefits with Cash Back, EBT Cash Benefits Balance Inquiry and EBT Cash Benefits Withdraw
 Test Card    Card #4 – MSD only Visa
 1.Cash Benefits Sale with Cash Back:
 ● Initiate an EBT sale transaction and swipe Test Card #4
 ● Select EBT Cash Benefits if prompted.
 ● Enter $101.01 as the amount
 ● Enter $5.00 as the Cash Back amount
 ● When prompted for PIN, enter 1234.
 2.Cash Benefits Balance Inquiry:
 ● Initiate an EBT Cash Benefits Balance Inquiry and swipe Test Card #4
 ● When prompted for PIN, enter 1234.
 */

- (void) test_Case10
{
    //Get ResponseID using test_Case09a & test_Case09c
}

/*
 TEST CASE #11 – HMS Gift
 Objective    Transactions: Gift Balance Inquiry, Gift Card Add Value, Gift Sale/Redeem
 Test Card    Gift Card (Card Present/Card Swipe)
 Procedure   Test System is a Stateless Environment, the responses are Static.
 1.Gift Sale/Redeem:
 ● Initiate a Sale and swipe
 ● Enter $1.00 as the amount
 2.Gift Balance Inquiry:
 ● Should respond with a AvailableBalance of $10
 3.Gift Card Add Value:
 ● Initiate a Sale and swipe
 ● Enter $8.00 as the amount
 */
- (void) test_Case11a
{
    [self writeStringToFile:@"TEST CASE #11a – HMS Gift \n"];
    
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
        NSLog(@"Host Reference Number = %@",((HpsTerminalResponse *)payload).transactionId);
        [self printRecipt:(HpsHpaDeviceResponse *)payload];
        
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        
        if(error) XCTFail(@"Request Timed out");
    }];
}
- (void) test_Case11b
{
    [self writeStringToFile:@" TEST CASE #11b – HMS Gift \n"];
    
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
        NSLog(@"Host Reference Number = %@",((HpsTerminalResponse *)payload).transactionId);
        [self printRecipt:(HpsHpaDeviceResponse *)payload];
        
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        
        if(error) XCTFail(@"Request Timed out");
    }];
}


- (void) test_Case11c
{
    [self writeStringToFile:@"TEST CASE #11c – HMS Gift \n"];
    
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
        NSLog(@"Host Reference Number = %@",((HpsTerminalResponse *)payload).transactionId);
        [self printRecipt:(HpsHpaDeviceResponse *)payload];
        
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        
        if(error) XCTFail(@"Request Timed out");
    }];
}

/*
 TEST CASE #12 - Credit Tip Adjust
 Objective    Complete Sale with Tip Adjustment Pick One Gratuity Approach:
 ● CREDIT AUTH + CREDIT AUTH COMPLETE (Portico “CreditAddToBatch”)
 ● CREDIT SALE + CREDIT ADJUST (Portico “CreditTxnEdit”
 Test Card    Card #5 – MSD only MasterCard
 Procedure    1. Select SALE function and swipe Card #5 for the amount of $15.12
 2. Add a $3.00 tip at Settlement.
 Note: Tip adjust must occur on same device as original sale
 */

- (void) test_Case12
{
    [self writeStringToFile:@"TEST CASE #12 - Credit Tip Adjust\n"];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHpa Do credit fail MultiplePayments"];
    
    HpsHpaDevice *device = [self setupDevice];
    
    HpsHpaCreditSaleBuilder *builder = [[HpsHpaCreditSaleBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:15.12];
    builder.referenceNumber = [device generateNumber];
    
    [builder execute:^(id <IHPSDeviceResponse> payload, NSError *error){
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
        NSLog(@"Response = %@",payload.toString);
        NSLog(@"Host Reference Number = %@",((HpsTerminalResponse *)payload).transactionId);
        [self printRecipt:(HpsHpaDeviceResponse *)payload];
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        
        if(error) XCTFail(@"Request Timed out");
    }];
}

/*
 TEST CASE #13 - End of Day (Mandatory if Conditional Test Cases are ran)
 Objective    End of Day, ensuring all approved transactions (offline or online) are settled. Supported transactions: Reversal, Offline Decline, Transaction Certificate, Add Attachment, SendSAF, Batch Close, EMV PDL and Heartbeat
 Test Card    Card #5 – MSD only MasterCard
 Procedure    Initiate a End of Day command
 */

-(void)test_Case13 {
    
    [self writeStringToFile:@"TEST CASE #13 -End of day\n"];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_LineItem"];
    
    HpsHpaDevice *device = [self setupDevice];
    
    HpsHpaEodBuilder *builder= [[HpsHpaEodBuilder alloc] initWithDevice:device];
    builder.referenceNumber = [device generateNumber];
    
    [builder execute:^(HpsHpaEodResponse* payload, NSError *error) {
        
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"0", payload.responseCode);
        XCTAssertNotNil(payload.reversals);
        XCTAssertNotNil(payload.offlineDecline);
        XCTAssertNotNil(payload.transactionCertificate);
        XCTAssertNotNil(payload.addAttachment);
        XCTAssertNotNil(payload.sendSAF);
        XCTAssertNotNil(payload.batchClose);
        XCTAssertNotNil(payload.emvpdl);
        XCTAssertNotNil(payload.heartBeat);
        
        
        //Reversal
        HpsHpaDeviceResponse *deviceResponse = payload.reversalResponse;
        XCTAssertEqualObjects(@"00", deviceResponse.deviceResponseCode);
        
        //EMVOfflineDecline
        deviceResponse = payload.eMVOfflineDeclineResponse;
        XCTAssertEqualObjects(@"00", deviceResponse.deviceResponseCode);
        
        //EMVTC
        deviceResponse = payload.eMVTCResponse;
        XCTAssertEqualObjects(@"00", deviceResponse.deviceResponseCode);
        
        //Attachment
        deviceResponse = payload.attachmentResponse;
        XCTAssertEqualObjects(@"00", deviceResponse.deviceResponseCode);
        
        //BatchClose
        deviceResponse = payload.batchCloseResponse;
        XCTAssertEqualObjects(@"00", deviceResponse.deviceResponseCode);
        
        //EMVPDL
        deviceResponse = payload.eMVPDLResponse;
        XCTAssertEqualObjects(@"00", deviceResponse.deviceResponseCode);
        
        //Heartbeat
        HpsHpaHeartBeatResponse *heartBeatResponse = payload.hpsHpaHeartBeatResponse;
        XCTAssertEqualObjects(@"0", heartBeatResponse.responseCode);
        
        //SAF
        HpsHpaSafResponse * safResponse = payload.hpsHpaSafResponse;
        XCTAssertEqualObjects(@"0", safResponse.responseCode);
        
        //Batch
        HpsHpaBatchResponse * batchResponse = payload.hpsHpaBatchResponse;
        XCTAssertEqualObjects(@"0", batchResponse.responseCode);
        
        
        NSLog(@"Host Reference Number = %@",payload.transactionId);
        
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:120.0 handler:^(NSError * _Nullable error) {
        
        if(error) XCTFail(@"Request Timed out");
    }];
}


@end
