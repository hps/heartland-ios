#import <XCTest/XCTest.h>

#import <Heartland_iOS_SDK/hps.h>
#import <Heartland_iOS_SDK/HpsUpaDevice.h>
#import <Heartland_iOS_SDK/HpsUpaSaleBuilder.h>
#import <Heartland_iOS_SDK/HpsUpaVoidBuilder.h>
#import <Heartland_iOS_SDK/HpsUpaReturnBuilder.h>
#import <Heartland_iOS_SDK/HpsUpaAdjustBuilder.h>
#import <Heartland_iOS_SDK/HpsUpaAuthBuilder.h>
#import <Heartland_iOS_SDK/HpsUpaCaptureBuilder.h>

@interface Hps_Upa_VRF_Tests : XCTestCase

@end

@implementation Hps_Upa_VRF_Tests
- (HpsUpaDevice*) setupDevice
{
    HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
    config.ipAddress = @"192.168.86.23";
    config.port = @"8081";
    config.connectionMode = HpsConnectionModes_TCP_IP;
    HpsUpaDevice * device = [[HpsUpaDevice alloc] initWithConfig:config];
    return device;
}


/**
 * Objective    Process an EMV contact sale with offline PIN.
 * Test Card    EMV Mastercard
 * Procedure
 *      1. Select Sale function for an amount of $4.00.
 *          a. Insert Test Card and select application if prompted.
 *          b. Terminal will respond approved.
 * Pass Criteria
 *      1. Transaction must be approved. Receipt must conform to EMV Receipt Requirements
 *
 * @throws ApiException
 */
- (void) test_UPA_Sale_EMV
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_UPA_Sale_EMV"];
    
    HpsUpaDevice *device = [self setupDevice];
    HpsUpaSaleBuilder* builder = [[HpsUpaSaleBuilder alloc] initWithDevice:device];
    builder.ecrId = @"3";
    builder.amount = [[NSDecimalNumber alloc] initWithDouble:4.00];
    builder.gratuity = [[NSDecimalNumber alloc] initWithDouble:0.00];

    [builder execute:^(HpsUpaResponse * response, NSError * error) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertTrue([response.responseCode isEqualToString:@"00"]);
        XCTAssertNotNil(response.transactionId);
        
        XCTAssertNotNil(response.transactionAmount);
        XCTAssertNotNil(response.maskedCardNumber);
        XCTAssertFalse([response.maskedCardNumber isEqualToString:@""]);
        XCTAssertNotNil(response.applicationPrefferedName);
        XCTAssertFalse([response.applicationPrefferedName isEqualToString:@""]);
        XCTAssertNotNil(response.applicationName);
        XCTAssertFalse([response.applicationName isEqualToString:@""]);
        XCTAssertNotNil(response.applicationId);
        XCTAssertFalse([response.applicationId isEqualToString:@""]);
        XCTAssertNotNil(response.applicationCrytptogram);
        XCTAssertFalse([response.applicationCrytptogram isEqualToString:@""]);
        XCTAssertNotNil(response.applicationCryptogramTypeS);
        XCTAssertFalse([response.applicationCryptogramTypeS isEqualToString:@""]);
        XCTAssertNotNil(response.entryMethod);
        XCTAssertFalse([response.entryMethod isEqualToString:@""]);
        XCTAssertNotNil(response.approvalCode);
        XCTAssertFalse([response.approvalCode isEqualToString:@""]);
        XCTAssertNotNil(response.cardholderName);
        XCTAssertFalse([response.cardholderName isEqualToString:@""]);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

/**
 * Objective    Ensure application can handle non-EMV swiped transactions.
 * Test Card    Magnetic stripe Mastercard
 * Procedure
 *      1. Select Sale function and swipe for the amount of $7.00.
 *          a. Insert Test Card and select application if prompted.
 *          b. Terminal will respond approved.
 * Pass Criteria
 *      1. Transaction must be approved. Receipt must conform to non-EMV Receipt Requirements
 *
 * @throws ApiException
 */
- (void) test_UPA_Sale_MSR
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_UPA_Sale_MSR"];
    
    HpsUpaDevice *device = [self setupDevice];
    HpsUpaSaleBuilder* builder = [[HpsUpaSaleBuilder alloc] initWithDevice:device];
    builder.ecrId = @"3";
    builder.amount = [[NSDecimalNumber alloc] initWithDouble:7.00];
    builder.gratuity = [[NSDecimalNumber alloc] initWithDouble:0.00];

    [builder execute:^(HpsUpaResponse * response, NSError * error) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertTrue([response.responseCode isEqualToString:@"00"]);
        XCTAssertNotNil(response.transactionId);
        
        XCTAssertNotNil(response.transactionAmount);
        XCTAssertNotNil(response.maskedCardNumber);
        XCTAssertFalse([response.maskedCardNumber isEqualToString:@""]);
        XCTAssertNotNil(response.transactionType);
        XCTAssertFalse([response.transactionType isEqualToString:@""]);
        XCTAssertNotNil(response.cardType);
        XCTAssertFalse([response.cardType isEqualToString:@""]);
        XCTAssertNotNil(response.entryMethod);
        XCTAssertFalse([response.entryMethod isEqualToString:@""]);
        XCTAssertNotNil(response.approvalCode);
        XCTAssertFalse([response.approvalCode isEqualToString:@""]);
        XCTAssertNotNil(response.cardholderName);
        XCTAssertFalse([response.cardholderName isEqualToString:@""]);

        /**
         * Objective    Process an online void.
         * Test Card    MSD only Mastercard
         * Procedure
         *      1. Select Void function to remove the previous Sale of $7.00.
         *          a. Retrieve the Portico Gateway Software TxnId from Credit Sale
         *             in Test Case 2.
         * Pass Criteria
         *      1. Transaction successfully returns a voided response
         *
         * @throws ApiException
         */
        HpsUpaVoidBuilder *vbuilder = [[HpsUpaVoidBuilder alloc] initWithDevice:device];
        vbuilder.ecrId = @"1";
        vbuilder.transactionId = response.transactionId;
        
        [vbuilder execute:^(HpsUpaResponse *vpayload, NSError *verror) {
            XCTAssertNil(verror);
            XCTAssertEqualObjects(@"00", vpayload.responseCode);
            XCTAssertNotNil(vpayload);
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

/**
 * Objective    Process a keyed sale, with PAN & exp date, along this Address Verification and Card
 *              Security Code to confirm the application can support any or all of these.
 * Test Card    Magnetic stripe Mastercard
 * Procedure
 *      1. Select Sale function and manually key for the amount of $118.00.
 *          a. Enter PAN & expiration date.
 *          b. Enter 321 for Card Security Code (CVV2, CID), if supporting this feature. Enter 76321
 *             for AVS, if supporting this feature
 * Pass Criteria
 *      1. Transaction must be approved online. AVS Result Code: YCVV Result Code: M
 *
 * @throws ApiException
 */
- (void) test_UPA_Sale_Keyed
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_UPA_Sale_Keyed"];
    
    HpsUpaDevice *device = [self setupDevice];
    HpsUpaSaleBuilder* builder = [[HpsUpaSaleBuilder alloc] initWithDevice:device];
    builder.ecrId = @"3";
    builder.amount = [[NSDecimalNumber alloc] initWithDouble:118.00];
    builder.gratuity = [[NSDecimalNumber alloc] initWithDouble:0.00];

    [builder execute:^(HpsUpaResponse * response, NSError * error) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertTrue([response.responseCode isEqualToString:@"00"]);
        XCTAssertNotNil(response.transactionId);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

/**
 * Objective    Ensure application can handle Partial Approval from our host.
 * Test Card    Magnetic stripe Mastercard
 * Procedure
 *      1. Select Sale function and swipe for the amount of $155.00.
 *          a. Insert Test Card and select application if prompted.
 *          b. Receive an approved amount less than requested. Finalize open ticket with remaining
 *             balance using a different card or tender.
 * Pass Criteria
 *      1. Transaction must be approved. Receipt must conform to non-EMV Receipt Requirements
 *
 * @throws ApiException
 */
- (void) test_UPA_Sale_PartialApproval
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_UPA_Sale_PartialApproval"];
    
    HpsUpaDevice *device = [self setupDevice];
    HpsUpaSaleBuilder* builder = [[HpsUpaSaleBuilder alloc] initWithDevice:device];
    builder.ecrId = @"3";
    builder.amount = [[NSDecimalNumber alloc] initWithDouble:155.00];
    builder.gratuity = [[NSDecimalNumber alloc] initWithDouble:0.00];

    [builder execute:^(HpsUpaResponse * response, NSError * error) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertTrue([response.responseCode isEqualToString:@"00"]);
        XCTAssertNotNil(response.transactionId);
        XCTAssertNotNil(response.approvedAmount);
        
        XCTAssertNotNil(response.transactionAmount);
        XCTAssertNotNil(response.maskedCardNumber);
        XCTAssertFalse([response.maskedCardNumber isEqualToString:@""]);
        XCTAssertNotNil(response.transactionType);
        XCTAssertFalse([response.transactionType isEqualToString:@""]);
        XCTAssertNotNil(response.cardType);
        XCTAssertFalse([response.cardType isEqualToString:@""]);
        XCTAssertNotNil(response.entryMethod);
        XCTAssertFalse([response.entryMethod isEqualToString:@""]);
        XCTAssertNotNil(response.approvalCode);
        XCTAssertFalse([response.approvalCode isEqualToString:@""]);
        XCTAssertNotNil(response.cardholderName);
        XCTAssertFalse([response.cardholderName isEqualToString:@""]);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

/**
 * Objective    Complete Sale request and then attempt a duplicate Sale transaction
 * Test Card    MSR credit card
 * Procedure
 *      1. Process a Credit Sale for $2.00 using any ECRRefNum
 *      2. Reprocess the Credit Sale using same amount and the same ECRRefNum
 * Pass Criteria
 *      1. Provide Debug logs showing the two Credit Sales for $2.00. Both must to be using the same
 *         ECRRefNum. The Log should reflect the Credit Sale failure due to a duplicate transaction.
 *
 * @throws ApiException
 */
- (void) test_UPA_Sale_Duplicate
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_UPA_Sale_Duplicate"];
    
    HpsUpaDevice *device = [self setupDevice];
    HpsUpaSaleBuilder* builder = [[HpsUpaSaleBuilder alloc] initWithDevice:device];
    builder.ecrId = @"3";
    builder.amount = [[NSDecimalNumber alloc] initWithDouble:2.00];
    builder.gratuity = [[NSDecimalNumber alloc] initWithDouble:0.00];
    builder.referenceNumber = 12345;

    [builder execute:^(HpsUpaResponse * response, NSError * error) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertTrue([response.responseCode isEqualToString:@"00"]);
        XCTAssertNotNil(response.transactionId);
        
        HpsUpaSaleBuilder* dupbuilder = [[HpsUpaSaleBuilder alloc] initWithDevice:device];
        dupbuilder.ecrId = @"3";
        dupbuilder.amount = [[NSDecimalNumber alloc] initWithDouble:2];
        dupbuilder.gratuity = [[NSDecimalNumber alloc] initWithDouble:0];
        dupbuilder.referenceNumber = 12345;

        [dupbuilder execute:^(HpsUpaResponse * dupresponse, NSError * error) {
            XCTAssertNil(error);
            XCTAssertNotNil(dupresponse);
            XCTAssertFalse([dupresponse.responseCode isEqualToString:@"00"]);
            XCTAssertNotNil(dupresponse.transactionId);
            
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

/**
 * Objective    Confirm support of a Return transaction for credit/debit using the gateway TxnId
 * Test Card    Magnetic stripe Visa
 * Procedure
 *      1. Select sale function for the amount of $4.00
 *      2. Swipe or key test card #4 through the MSR, record the TxnId
 *      3. Select Refund function to refund the previous sale of $4.00, use the TxnId from the previous sale
 * Pass Criteria
 *      1. Transaction must be approved using the TxnId
 *
 * @throws ApiException
 */
- (void) test_UPA_Sale_Refund
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_UPA_Sale_Refund"];
    
    HpsUpaDevice *device = [self setupDevice];
    HpsUpaSaleBuilder *builder = [[HpsUpaSaleBuilder alloc] initWithDevice:device];
    builder.amount = [[NSDecimalNumber alloc] initWithDouble:4.00];
    builder.gratuity = [[NSDecimalNumber alloc] initWithDouble:0.00];
    builder.ecrId = @"1";
    
    [builder execute:^(HpsUpaResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertEqualObjects(@"00", payload.responseCode);
        XCTAssertNotNil(payload);
        
        //Refund
        HpsUpaReturnBuilder *rbuilder = [[HpsUpaReturnBuilder alloc] initWithDevice:device];
        rbuilder.ecrId = @"1";
        rbuilder.amount = [[NSDecimalNumber alloc] initWithDouble:4.00];
        
        [rbuilder execute:^(HpsUpaResponse *rpayload, NSError *rerror) {
            XCTAssertNil(rerror);
            XCTAssertEqualObjects(@"00", rpayload.responseCode);
            XCTAssertNotNil(rpayload);
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:120.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

/**
 * Objective    Complete Token request and then use that token for a Sale transaction
 * Test Card    MSR credit card
 * Procedure
 *      1. Perform a Verify transaction
 *          a. Review the response back from our host and locate the token value that is returned.
 *             Store this within your localized token value and be able to retrieve it for the next
 *             transaction
 *      2. Perform a Sale transaction
 *          a. Use the token value that you received and process a transaction for $15.01
 * Pass Criteria
 *      1. TokenValue returned in response
 *      2. Transaction #2 receives response code of 00
 *
 * @throws ApiException
 */
- (void) test_UPA_Sale_Token
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_UPA_Sale_Token"];
    
    HpsUpaDevice *device = [self setupDevice];
    HpsUpaSaleBuilder* builder = [[HpsUpaSaleBuilder alloc] initWithDevice:device];
    builder.ecrId = @"3";
    builder.amount = [[NSDecimalNumber alloc] initWithDouble:2.00];
    builder.gratuity = [[NSDecimalNumber alloc] initWithDouble:0.00];
    builder.requestMultiUseToken = TRUE;
    builder.storedCardInitiator = HpsStoredCardInitiator_CardHolder;

    [builder execute:^(HpsUpaResponse * response, NSError * error) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertTrue([response.responseCode isEqualToString:@"00"]);
        XCTAssertNotNil(response.transactionId);
        XCTAssertNotNil(response.tokenData);
        XCTAssertNotNil(response.tokenData.tokenValue);
        XCTAssertFalse([response.tokenData.tokenValue isEqualToString:@""]);
        XCTAssertNotNil(response.cardBrandTransactionId);
        XCTAssertFalse([response.cardBrandTransactionId isEqualToString:@""]);
        
        sleep(1);
        
        HpsUpaSaleBuilder* tokenbuilder = [[HpsUpaSaleBuilder alloc] initWithDevice:device];
        tokenbuilder.ecrId = @"3";
        tokenbuilder.amount = [[NSDecimalNumber alloc] initWithDouble:15.01];
        tokenbuilder.gratuity = [[NSDecimalNumber alloc] initWithDouble:0.00];
        tokenbuilder.token = response.tokenData.tokenValue;
        tokenbuilder.storedCardInitiator = HpsStoredCardInitiator_Merchant;
        tokenbuilder.cardBrandTransactionId = response.cardBrandTransactionId;

        [tokenbuilder execute:^(HpsUpaResponse * tokenresponse, NSError * error) {
            XCTAssertNil(error);
            XCTAssertNotNil(tokenresponse);
            XCTAssertTrue([tokenresponse.responseCode isEqualToString:@"00"]);
            XCTAssertNotNil(tokenresponse.transactionId);
            
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

/**
 * Objective    Confirm support of EMV PIN Debit sale
 * Test Card    EMV PIN Debit Card (not provided by Heartland)
 * Procedure
 *      1. Select Sale function and Select Debit for the card type OR select DEBIT function. For the test
 *         amount, use $10.00
 * Pass Criteria
 *      1. Transaction must be approved online
 *
 * @throws ApiException
 */
- (void) test_UPA_DebitSale_EMV
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_UPA_DebitSale_EMV"];
    
    HpsUpaDevice *device = [self setupDevice];
    HpsUpaSaleBuilder* builder = [[HpsUpaSaleBuilder alloc] initWithDevice:device];
    builder.ecrId = @"3";
    builder.amount = [[NSDecimalNumber alloc] initWithDouble:4.00];
    builder.gratuity = [[NSDecimalNumber alloc] initWithDouble:0.00];

    [builder execute:^(HpsUpaResponse * response, NSError * error) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertTrue([response.responseCode isEqualToString:@"00"]);
        XCTAssertNotNil(response.transactionId);
        
        XCTAssertNotNil(response.transactionAmount);
        XCTAssertNotNil(response.maskedCardNumber);
        XCTAssertFalse([response.maskedCardNumber isEqualToString:@""]);
        XCTAssertNotNil(response.applicationPrefferedName);
        XCTAssertFalse([response.applicationPrefferedName isEqualToString:@""]);
        XCTAssertNotNil(response.applicationName);
        XCTAssertFalse([response.applicationName isEqualToString:@""]);
        XCTAssertNotNil(response.applicationId);
        XCTAssertFalse([response.applicationId isEqualToString:@""]);
        XCTAssertNotNil(response.applicationCrytptogram);
        XCTAssertFalse([response.applicationCrytptogram isEqualToString:@""]);
        XCTAssertNotNil(response.applicationCryptogramTypeS);
        XCTAssertFalse([response.applicationCryptogramTypeS isEqualToString:@""]);
        XCTAssertNotNil(response.entryMethod);
        XCTAssertFalse([response.entryMethod isEqualToString:@""]);
        XCTAssertNotNil(response.approvalCode);
        XCTAssertFalse([response.approvalCode isEqualToString:@""]);
        XCTAssertNotNil(response.cardholderName);
        XCTAssertFalse([response.cardholderName isEqualToString:@""]);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

/**
 * Objective    Complete Sale with Tip Adjustment
 * Pick One Gratuity Approach
 *      1. Credit Auth + Credit Capture
 *      2. Credit Sale + Tip Adjust // this one
 * Test Card    Mastercard
 * Procedure
 *      1. Select Sale function and process for the amount of $15.12
 *      2. Add a $3.00 tip at settlement
 * Pass Criteria
 *      1. Transaction must be approved.
 *
 * Tony note - Confirmed there is a bug in V1.30 regarding how the tip adjust amount is handled; that amount
 * isn't correctly added to the total transaction amount; earlier software versions did not have this bug
 *
 * @throws ApiException
 */
- (void) test_UPA_Sale_Adjust
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_UPA_Sale_Adjust"];
    
    HpsUpaDevice *device = [self setupDevice];
    HpsUpaSaleBuilder *builder = [[HpsUpaSaleBuilder alloc] initWithDevice:device];
    builder.amount = [[NSDecimalNumber alloc] initWithDouble:15.12];
    builder.gratuity = [[NSDecimalNumber alloc] initWithDouble:0.00];
    builder.ecrId = @"1";
    
    [builder execute:^(HpsUpaResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertEqualObjects(@"00", payload.responseCode);
        XCTAssertNotNil(payload);
        
        //Adjust
        HpsUpaAdjustBuilder *abuilder = [[HpsUpaAdjustBuilder alloc] initWithDevice:device];
        abuilder.ecrId = @"1";
        abuilder.gratuity = [[NSDecimalNumber alloc] initWithDouble:3.00];
        abuilder.terminalRefNumber = payload.terminalRefNumber;
        
        [abuilder execute:^(HpsUpaResponse *apayload, NSError *aerror) {
            XCTAssertNil(aerror);
            XCTAssertEqualObjects(@"00", apayload.responseCode);
            XCTAssertNotNil(apayload);
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:120.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

/**
 * Objective    Complete Sale with Tip Adjustment
 * Pick One Gratuity Approach
 *      1. Credit Auth + Credit Capture // this one
 *      2. Credit Sale + Tip Adjust
 * Test Card    Mastercard
 * Procedure
 *      1. Select Sale function and process for the amount of $15.12
 *      2. Add a $3.00 tip at settlement
 * Pass Criteria
 *      1. Transaction must be approved.
 *
 * @throws ApiException
 */
- (void) test_UPA_Auth_CaptureWithTip
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_UPA_Auth_CaptureWithTip"];
    
    HpsUpaDevice *device = [self setupDevice];
    HpsUpaAuthBuilder *builder = [[HpsUpaAuthBuilder alloc] initWithDevice:device];
    builder.amount = [[NSDecimalNumber alloc] initWithDouble:1.00];
    builder.ecrId = @"1";
    
    [builder execute:^(HpsUpaResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertEqualObjects(@"00", payload.responseCode);
        XCTAssertNotNil(payload);
        
        //Adjust
        HpsUpaCaptureBuilder *abuilder = [[HpsUpaCaptureBuilder alloc] initWithDevice:device];
        abuilder.ecrId = @"1";
        abuilder.amount = [[NSDecimalNumber alloc] initWithDouble:18.12];
        abuilder.gratuity = [[NSDecimalNumber alloc] initWithDouble:3.00];
        abuilder.transactionId = payload.transactionId;
        
        [abuilder execute:^(HpsUpaResponse *apayload, NSError *aerror) {
            XCTAssertNil(aerror);
            XCTAssertEqualObjects(@"00", apayload.responseCode);
            XCTAssertNotNil(apayload);
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:120.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

/**
 * Objective    Transactions: Gift Balance Inquiry, Gift Load, Gift Sale/Redeem, Gift Replace
 * Test Card    Heartland Test Gift Cards
 * Procedure
 *      1. Gift Balance Inquiry
 *          a. Should respond with a balance amount of $10
 *      2. Gift Add Value
 *          a. Initiate a load and swipe
 *          b. Enter $8.00 as the amount
 *      3. Gift Sale
 *          a. Initiate a Sale and swipe
 *          b. Enter $1.00 as the amount
 *      4. Gift card replace
 *          a. Initiate a gift card replace
 * Pass Criteria
 *      1. All transactions must be approved.
 *
 * @throws ApiException
 */

/**
 * Objective    Transactions: Food Stamp Purchase, Food Stamp Return, Food Stamp Balance Inquiry
 * Test Card    MSD only Visa
 * Procedure
 *      1. Food Stamp Purchase
 *          a. Initiate an EBT Sale and swipe
 *          b. Select EBT Food Stamp if prompted
 *          c. Enter $101.01 as the amount
 *      2. Food Stamp Return
 *          a. Initiate an EBT return and manually enter
 *          b. Select EBT Food Stamp if prompted
 *          c. Enter $104.01 as the amount
 *      4. Food Stamp Balance Inquiry
 *          a. Initiate an EBT balance inquiry transaction
 * Pass Criteria
 *      1. All transactions must be approved.
 *
 * @throws ApiException
 */

/**
 * Objective    Transactions: Food Stamp Purchase, Food Stamp Return, Food Stamp Balance Inquiry
 * Test Card    MSD only Visa
 * Procedure
 *      1. Food Stamp Purchase
 *          a. Initiate an EBT Sale and swipe
 *          b. Select EBT Food Stamp if prompted
 *          c. Enter $101.01 as the amount
 *      2. Food Stamp Return
 *          a. Initiate an EBT return and manually enter
 *          b. Select EBT Food Stamp if prompted
 *          c. Enter $104.01 as the amount
 *      3. Food Stamp Balance Inquiry
 *          a. Initiate an EBT balance inquiry transaction
 * Pass Criteria
 *      1. All transactions must be approved.
 *
 * @throws ApiException
 */

/**
 * Objective    Send extended healthcare (Rx, Vision, Dental, Clinical)
 * Test Card    Visa
 * Procedure
 *      1. Process a Sale for $100.00, with $50 being qualified for healthcare. Choose any of the groups
 *         (Rx, Vision, Dental, Clinical)
 * Pass Criteria
 *      1. Transaction must be approved online
 *
 * @throws ApiException
 */

/**
 * Objective    Process the 3 types of Corporate Card transactions: No Tax, Tax Amount, and Tax
 *              Exempt, including the passing of PO Number
 * Test Card    Magnetic stripe Visa
 * Procedure
 *      1. Select Sale function for the amount of $112.34
 *          a. Receive CPC Indicator of B
 *          b. Continue with CPC Edit transaction to account for Tax Type of Not Used
 *          c. Enter the PO Number of 98765432101234567 on the device
 *      2. Select Sale function for the amount of $123.45
 *          a. Receive CPC Indicator of R
 *          b. Continue with CPC Edit transaction to account for Tax Type of Sales Tax, Tax Amount for $1.00
 *      3. Select Sale function for the amount of $134.56
 *          a. Receive CPC Indicator of S
 *          b. Continue with CPC Edit transaction to account for Tax Type of Tax Exempt
 *          c. Enter the PO Number of 98765432101234567 on the device
 * Pass Criteria
 *      1. Transactions must be approved online
 *
 * Tony note - Lvl2 doesn't seem to be fully supported as of V1.30
 * @throws ApiException
 */

/**
 * Objective    Process credit sale in Store and Forward, upload transaction, close batch
 * Test Card    EMV Visa
 * Procedure
 *      1. Select Sale function for an amount of $4.00
 *          a. Response approved
 *      2. Send SAF command
 *          a. SAF Indicator = 2
 *          b. Result OK
 *      3. Initiate a Batch Close
 * Pass Criteria
 *      1. Transaction must approve in SAF and settles in a batch
 *
 * @throws ApiException
 */

/**
 * Objective    Process credit sale in Store and Forward, upload transaction, delete declined
 *              transaction from terminal
 * Procedure
 *      1. Select Sale function for an amount of $10.25
 *          a. Response approved
 *      2. Send SAF command
 *          a. SAF Indicator = 2
 *          b. Transaction will decline
 *      3. Perform delete SAF file
 *          a. SAF Indicator = 2
 * Pass Criteria
 *      1. Transaction must approve in SAF and settles in a batch
 *
 * @throws ApiException
 */

/**
 * Objective    Apply a surcharge to a transaction. You will need to make sure that you have worked with
 *              the Heartland team to set a surcharge amount for all qualifying transactions.
 * Test Card    EMV Mastercard // I used and configured EMV Amex for surcharge
 * Procedure
 *      1. Process a Credit Sale transaction for $50.00 with a 3.5% surcharge
 * Pass Criteria
 *      1. Printed receipt shows that a surcharge was added to the total amount and that the total amount
 *         processed matches the principle amount plus the surcharge
 *
 * Tony note: current device programming doesn't seem to be setup for Surcharging; I tried configuring for
 * Surcharging in the Device Manager, but it did not work     *
 *
 * @throws ApiException
 */

/**
 * Objective    Close the batch, ensuring all approved transactions (offline or online) are settled.
 *              Integrators are automatically provided accounts with auto-close enabled, so if manual batch transmission
 *              will not be performed in the production environment, it does not need to be tested.
 * Test Card    N/A
 * Procedure
 *      1. Initiate a Batch Close request
 * Pass Criteria
 *      1. Batch submission must be successful
 *
 * @throws ApiException
 */
- (void) test_UPA_EOD
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_UPA_EOD"];
    
    HpsUpaDevice *device = [self setupDevice];
    [device processEndOfDayWithEcrId:@"12" requestId:@"123" response:^(id<IHPSDeviceResponse> payload, NSError *error) {
        HpsUpaResponse* response = (HpsUpaResponse*)payload;
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertTrue([response.status isEqualToString:@"Success"]);
        XCTAssertFalse([response.batchId isEqualToString:@""]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

@end

