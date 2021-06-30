#import <XCTest/XCTest.h>
#import <Heartland_iOS_SDK/Heartland-iOS-SDK-umbrella.h>
#import <Heartland_iOS_SDK/Heartland_iOS_SDK-Swift.h>

@interface Hps_C2x_Credit_Test : XCTestCase<HpsC2xDeviceDelegate,HpsC2xTransactionDelegate>
{
    XCTestExpectation *deviceConnectionExpectation;
    XCTestExpectation *transactionExpectation;
}
@property HpsC2xDevice *device;
@property HpsTerminalResponse *response;
@end

@implementation Hps_C2x_Credit_Test

-(void)deviceSetUp
{
    HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
    config.versionNumber = @"3409";
    config.developerID = @"002914";
    config.username = @"701385995";
    config.password = @"$Test1234";
    config.siteID = @"142913";
    config.deviceID = @"6398417";
    config.licenseID = @"142826";
    
    self.device = [[HpsC2xDevice alloc] initWithConfig:config];
}
- (HpsCreditCard*) getCC
{
    HpsCreditCard *card = [[HpsCreditCard alloc] init];
//    card.cardNumber = @"4242424242424242";
//    card.expMonth = 12;
//    card.expYear = 2025;
//    card.cvv = @"123";
    //Master Card
//    card.cardNumber = @"5410330089604111";
//    card.expMonth = 12;
//    card.expYear = 2022;
//    card.cvv = @"4315";
    //Discover
//    card.cardNumber = @"6510000000000133";
//    card.expMonth = 12;
//    card.expYear = 2019;
//    card.cvv = @"1234";

    //visa
    card.cardNumber = @"4716739001010119";
    card.expMonth = 12;
    card.expYear = 2022;
    card.cvv = @"1234";
    return card;
}


- (HpsAddress*) getAddress
{
    HpsAddress *address = [[HpsAddress alloc] init];
    address.address = @"1 Heartland Way";
    address.zip = @"95124";
    return address;
}


-(void)test_initialize
{
    deviceConnectionExpectation = [self expectationWithDescription:@"test_C2X_Initialize"];
    [self deviceSetUp];
    [self.device scan];
    self.device.deviceDelegate = self;
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
    XCTAssert(YES, @"Device Connected");
}

-(void)test_Credit_Sale_Manual
{
    [self deviceSetUp];
    [self.device scan];
    self.device.deviceDelegate = self;
    transactionExpectation = [self expectationWithDescription:@"test_C2X_Credit_Sale_Manual"];
    HpsC2xCreditSaleBuilder *builder = [[HpsC2xCreditSaleBuilder alloc] initWithDevice:self.device];
    builder.amount = [[NSDecimalNumber alloc] initWithDouble:10.33];
    builder.gratuity = [[NSDecimalNumber alloc] initWithDouble:1.0];
    builder.creditCard = [self getCC];
    self.device.transactionDelegate = self;
    [builder execute];
    [self waitForExpectationsWithTimeout:1800.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
        XCTAssertNotNil(self.response);
        XCTAssertNotNil(self.response.clientTransactionIdUUID);
        NSLog(@"approved amount: %@", self.response.clientTransactionIdUUID);
        XCTAssertEqualObjects(@"APPROVAL", self.response.deviceResponseCode);
        NSLog(@"approved amount: %@", self.response.approvedAmount);
        NSLog(@"gratuity amount: %@", self.response.tipAmount);
        XCTAssertNotNil(self.response.approvedAmount);
        XCTAssertTrue(self.response.approvedAmount > 0);
    }];
    XCTAssert(YES, @"Device Connected");
}

-(void)test_Credit_Sale_Manual_Partial_Approval
{
    [self deviceSetUp];
    [self.device scan];
    self.device.deviceDelegate = self;
    transactionExpectation = [self expectationWithDescription:@"test_C2X_Credit_Sale_Manual"];
    HpsC2xCreditSaleBuilder *builder = [[HpsC2xCreditSaleBuilder alloc] initWithDevice:self.device];
    builder.amount = [[NSDecimalNumber alloc] initWithDouble:4.28];
    builder.gratuity = [[NSDecimalNumber alloc] initWithDouble:1.28];
    builder.creditCard = [self getCC];
    self.device.transactionDelegate = self;
    [builder execute];
    [self waitForExpectationsWithTimeout:1800.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
        XCTAssertNotNil(self.response);
        XCTAssertNotNil(self.response.clientTransactionIdUUID);
        NSLog(@"approved amount: %@", self.response.clientTransactionIdUUID);
        XCTAssertEqualObjects(@"APPROVAL", self.response.deviceResponseCode);
        XCTAssertEqualObjects(@"4.28", self.response.approvedAmount.stringValue);
        XCTAssertEqualObjects(@"1.28", self.response.tipAmount.stringValue);
        NSLog(@"approved amount: %@", self.response.approvedAmount.stringValue);
        NSLog(@"gratuity amount: %@", self.response.tipAmount.stringValue);
        XCTAssertNotNil(self.response.approvedAmount);
        XCTAssertTrue(self.response.approvedAmount > 0);
    }];
    XCTAssert(YES, @"Device Connected");
}

-(void)test_Credit_Sale_Manual_No_Reply
{
    [self deviceSetUp];
    [self.device scan];
    self.device.deviceDelegate = self;
    transactionExpectation = [self expectationWithDescription:@"test_C2X_Credit_Sale_Manual"];
    HpsC2xCreditSaleBuilder *builder = [[HpsC2xCreditSaleBuilder alloc] initWithDevice:self.device];
    builder.amount = [[NSDecimalNumber alloc] initWithDouble:10.33];
    builder.gratuity = [[NSDecimalNumber alloc] initWithDouble:1.0];
    builder.creditCard = [self getCC];
    self.device.transactionDelegate = self;
    [builder execute];
    [self waitForExpectationsWithTimeout:1800.0 handler:^(NSError *error) {
//        if(error) XCTFail(@"Request Timed out");
        XCTAssertNotNil(self.response);
        XCTAssertNotNil(self.response.clientTransactionIdUUID);
        NSLog(@"approved amount: %@", self.response.clientTransactionIdUUID);
//        XCTAssertEqualObjects(@"APPROVAL", self.response.deviceResponseCode);
//        NSLog(@"approved amount: %@", self.response.approvedAmount);
//        NSLog(@"gratuity amount: %@", self.response.tipAmount);
//        XCTAssertNotNil(self.response.approvedAmount);
//        XCTAssertTrue(self.response.approvedAmount > 0);
    }];
    XCTAssert(YES, @"Device Connected");
}

-(void)test_Credit_Sale
{
    deviceConnectionExpectation = [self expectationWithDescription:@"test_C2X_DeviceConnected"];
    [self deviceSetUp];
    [self.device scan];
    self.device.deviceDelegate = self;
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
        transactionExpectation = [self expectationWithDescription:@"test_C2X_Credit_Sale"];
        HpsC2xCreditSaleBuilder *builder = [[HpsC2xCreditSaleBuilder alloc] initWithDevice:self.device];
        builder.amount = [[NSDecimalNumber alloc]initWithDouble:12.00];
        builder.gratuity = [[NSDecimalNumber alloc]initWithDouble:0.0];
        self.device.transactionDelegate = self;
        [builder execute];
        [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
            if(error) XCTFail(@"Request Timed out");
            XCTAssertNotNil(self.response);
            XCTAssertEqualObjects(@"Approved", self.response.deviceResponseCode);
        }];
    }];
    XCTAssert(YES, @"Device Connected");
}

-(void)test_Credit_Auth
{
    [self deviceSetUp];
    [self.device scan];
    self.device.deviceDelegate = self;
    transactionExpectation = [self expectationWithDescription:@"test_C2X_CreditSale"];
    HpsC2xCreditAuthBuilder *builder = [[HpsC2xCreditAuthBuilder alloc] initWithDevice:self.device];
    builder.amount = [[NSDecimalNumber alloc]initWithDouble:11.00];
    builder.gratuity = [[NSDecimalNumber alloc]initWithDouble:0.0];
    builder.creditCard = [self getCC];
    self.device.transactionDelegate = self;
    [builder execute];
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
                  if(error) XCTFail(@"Request Timed out");
        XCTAssertNotNil(self.response);
        XCTAssertEqualObjects(@"APPROVAL", self.response.deviceResponseCode);
    }];
    XCTAssert(YES, @"Device Connected");
}

-(void)test_Credit_Capture
{
    [self deviceSetUp];
    [self.device scan];
    self.device.deviceDelegate = self;
    transactionExpectation = [self expectationWithDescription:@"test_C2X_Credit_Auth_Manual"];
    HpsC2xCreditAuthBuilder *builder = [[HpsC2xCreditAuthBuilder alloc] initWithDevice:self.device];
    builder.amount = [[NSDecimalNumber alloc] initWithDouble:11.00];
    builder.gratuity = [[NSDecimalNumber alloc] initWithDouble:0.0];
    builder.creditCard = [self getCC];
    self.device.transactionDelegate = self;
    [builder execute];
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
        XCTAssertNotNil(self.response);
        XCTAssertEqualObjects(@"APPROVAL", self.response.deviceResponseCode);
        transactionExpectation = [self expectationWithDescription:@"test_C2X_Credit_Capture"];
        HpsC2xCreditCaptureBuilder *builder = [[HpsC2xCreditCaptureBuilder alloc] initWithDevice:self.device];
        builder.amount = [[NSDecimalNumber alloc]initWithDouble:11.00];
        builder.transactionId = self.response.transactionId;
        builder.referenceNumber = self.response.terminalRefNumber;
        self.device.transactionDelegate = self;
        [builder execute];
        [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
            if(error) XCTFail(@"Request Timed out");
            XCTAssertNotNil(self.response);
            XCTAssertEqualObjects(@"Success", self.response.deviceResponseCode);
        }];

    }];
    XCTAssert(YES, @"Device Connected");
}

//-(void)test_Credit_Refund
//{
//    deviceConnectionExpectation = [self expectationWithDescription:@"test_C2X_DeviceConnected"];
//    [self deviceSetUp];
//    [self.device initialize];
//    self.device.deviceDelegate = self;
//    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
//               if(error) XCTFail(@"Request Timed out");
//        transactionExpectation = [self expectationWithDescription:@"test_C2X_Credit_Refund"];
//        HpsC2xCreditReturnBuilder *builder = [[HpsC2xCreditReturnBuilder alloc] init];
//        builder.device = self.device;
//        builder.amount = [[NSDecimalNumber alloc]initWithDouble:11.00];
//        builder.referenceNumber = [NSString stringWithFormat:@"%d", 6];
//        builder.creditCard = [self getCC];
//        self.device.transactionDelegate = self;
//        [builder execute];
//        [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
//                      if(error) XCTFail(@"Request Timed out");
//                        XCTAssertNotNil(self.response);
//                       XCTAssertEqualObjects(@"Approved", self.response.deviceResponseCode);
//            }];
//
//    }];
//    XCTAssert(YES, @"Device Connected");
//}

-(void)test_Credit_Refund_By_TransactionId
{
    [self deviceSetUp];
    [self.device scan];
    self.device.deviceDelegate = self;
    transactionExpectation = [self expectationWithDescription:@"test_C2X_Credit_Sale_Manual"];
    HpsC2xCreditSaleBuilder *builder = [[HpsC2xCreditSaleBuilder alloc] initWithDevice:self.device];
    builder.amount = [[NSDecimalNumber alloc] initWithDouble:11.00];
    builder.gratuity = [[NSDecimalNumber alloc] initWithDouble:0.0];
    builder.creditCard = [self getCC];
    self.device.transactionDelegate = self;
    [builder execute];
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
        XCTAssertNotNil(self.response);
        XCTAssertEqualObjects(@"APPROVAL", self.response.deviceResponseCode);
        transactionExpectation = [self expectationWithDescription:@"test_C2X_Credit_Refund"];
        HpsC2xCreditReturnBuilder *builder = [[HpsC2xCreditReturnBuilder alloc] initWithDevice:self.device];
        builder.amount = [[NSDecimalNumber alloc]initWithDouble:1.00];
        builder.transactionId = self.response.transactionId;
        builder.referenceNumber = self.response.terminalRefNumber;
        self.device.transactionDelegate = self;
        [builder execute];
        [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
            if(error) XCTFail(@"Request Timed out");
            XCTAssertNotNil(self.response);
            XCTAssertEqualObjects(@"APPROVAL", self.response.deviceResponseCode);
        }];

    }];
    XCTAssert(YES, @"Device Connected");
}

-(void)test_Credit_Void
{
    [self deviceSetUp];
    [self.device scan];
    self.device.deviceDelegate = self;
    transactionExpectation = [self expectationWithDescription:@"test_C2X_Credit_Auth_Manual"];
    HpsC2xCreditAuthBuilder *builder = [[HpsC2xCreditAuthBuilder alloc] initWithDevice:self.device];
    builder.amount = [[NSDecimalNumber alloc] initWithDouble:11.00];
    builder.gratuity = [[NSDecimalNumber alloc] initWithDouble:0.0];
    builder.creditCard = [self getCC];
    self.device.transactionDelegate = self;
    [builder execute];
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
        XCTAssertNotNil(self.response);
        XCTAssertEqualObjects(@"APPROVAL", self.response.deviceResponseCode);
        transactionExpectation = [self expectationWithDescription:@"test_C2X_Credit_Void"];
        HpsC2xCreditVoidBuilder *builder = [[HpsC2xCreditVoidBuilder alloc] initWithDevice:self.device];
        builder.transactionId = self.response.transactionId;
        builder.referenceNumber = self.response.terminalRefNumber;
        self.device.transactionDelegate = self;
        [builder execute];
        [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
            if(error) XCTFail(@"Request Timed out");
            XCTAssertNotNil(self.response);
            XCTAssertEqualObjects(@"Success", self.response.deviceResponseCode);
        }];

    }];
    XCTAssert(YES, @"Device Connected");
}

-(void)test_Credit_Tip_Adjust
{
    [self deviceSetUp];
    [self.device scan];
    self.device.deviceDelegate = self;
    transactionExpectation = [self expectationWithDescription:@"test_C2X_Credit_Sale_Manual"];
    HpsC2xCreditSaleBuilder *builder = [[HpsC2xCreditSaleBuilder alloc] initWithDevice:self.device];
    builder.amount = [[NSDecimalNumber alloc] initWithDouble:10.00];
    builder.gratuity = [[NSDecimalNumber alloc] initWithDouble:0.0];
    builder.creditCard = [self getCC];
    self.device.transactionDelegate = self;
    [builder execute];
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
        XCTAssertNotNil(self.response);
        XCTAssertEqualObjects(@"APPROVAL", self.response.deviceResponseCode);
        transactionExpectation = [self expectationWithDescription:@"test_C2X_Credit_Adjust"];
        HpsC2xCreditAdjustBuilder *builder = [[HpsC2xCreditAdjustBuilder alloc] initWithDevice:self.device];
        builder.amount = [[NSDecimalNumber alloc]initWithDouble: 11.00];
        builder.gratuity = [[NSDecimalNumber alloc]initWithDouble: 1.00];
        builder.transactionId = self.response.transactionId;
        builder.referenceNumber = self.response.terminalRefNumber;
        self.device.transactionDelegate = self;
        [builder execute];
        [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
            if(error) XCTFail(@"Request Timed out");
            XCTAssertNotNil(self.response);
            XCTAssertEqualObjects(@"Success", self.response.deviceResponseCode);
        }];

    }];
    XCTAssert(YES, @"Device Connected");
}


-(void)test_Batch_close
{
    [self deviceSetUp];
    [self.device scan];
    self.device.deviceDelegate = self;
    transactionExpectation = [self expectationWithDescription:@"test_C2X_Batch_Close"];
    HpsC2xBatchCloseBuilder *builder = [[HpsC2xBatchCloseBuilder alloc] initWithDevice:self.device];
    self.device.transactionDelegate = self;
    [builder execute];
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
    XCTAssert(YES, @"Device Connected");
}


#pragma mark - Device Delegate methods
- (void)onConnected //:(HpsTerminalInfo *)terminalInfo
{
    NSLog(@"Device Connected");
    [deviceConnectionExpectation fulfill];

}
- (void)onDisconnected
{
    NSLog(@"Device Disconnected");
}
- (void)onTerminalInfoReceived:(HpsTerminalInfo *)terminalInfo
{

}
- (void)onBluetoothDeviceList:(NSMutableArray *)peripherals
{
    for (int i = 0; i < peripherals.count; i++) {
        HpsTerminalInfo *device = [peripherals objectAtIndex:i];
        NSLog(@"%@", device);
//        [self.device stopScan];
        [self.device connectDevice:device];
    }
}


#pragma mark - Transaction Delegate methods
- (void)onConfirmAmount:(NSDecimal)amount {
    [self.device confirmAmount:amount];
}

- (void)onStatusUpdate:(HpsTransactionStatus)transactionStatus
{
        NSLog(@"Status: %lu", (unsigned long)transactionStatus);

    switch (transactionStatus)
       {
           case HpsTransactionStatusWaitingForConfiguration:
               NSLog(@"%@", @".waitingForConfiguration");
               break;
           case HpsTransactionStatusConfiguringTerminal:
               NSLog(@"%@", @".configuringTerminal");
               break;
           case HpsTransactionStatusConfigurationFailedTryAgain:
               NSLog(@"%@", @".configurationFailedTryAgain");
               break;
           case HpsTransactionStatusReady:
               NSLog(@"%@", @".ready");
               break;
           case HpsTransactionStatusStarted:
               NSLog(@"%@", @".started");
               break;
           case HpsTransactionStatusWaitingForCard:
               NSLog(@"%@", @".waitingForCard");
               break;
           case HpsTransactionStatusInsertCard:
               NSLog(@"%@", @".insertCard");
               break;
           case HpsTransactionStatusRemoveCard:
               NSLog(@"%@", @".removeCard");
               break;
           case HpsTransactionStatusCardRemoved:
               NSLog(@"%@", @".cardRemoved");
               break;
           case HpsTransactionStatusPleaseWait:
               NSLog(@"%@", @".pleaseWait");
               break;
           case HpsTransactionStatusPleaseSeePhone:
               NSLog(@"%@", @".pleaseSeePhone");
               break;
           case HpsTransactionStatusUseMagstripe:
               NSLog(@"%@", @".useMagstripe");
               break;
           case HpsTransactionStatusTryAgain:
               NSLog(@"%@", @".tryAgain");
               break;
           case HpsTransactionStatusSwipeErrorReSwipe:
               NSLog(@"%@", @".swipeErrorReSwipe");
               break;
           case HpsTransactionStatusNoEmvApps:
               NSLog(@"%@", @".noEmvApps");
               break;
           case HpsTransactionStatusApplicationExpired:
               NSLog(@"%@", @".applicationExpired");
               break;
           case HpsTransactionStatusCardReadError:
               NSLog(@"%@", @".cardReadError");
               break;
           case HpsTransactionStatusProcessing:
               NSLog(@"%@", @".processing");
               break;
           case HpsTransactionStatusProcessingDoNotRemoveCard:
               NSLog(@"%@", @".processingDoNotRemoveCard");
               break;
           case HpsTransactionStatusPresentCard:
               NSLog(@"%@", @".presentCard");
               break;
           case HpsTransactionStatusPresentCardAgain:
               NSLog(@"%@", @".presentCardAgain");
               break;
           case HpsTransactionStatusInsertSwipeOrTryAnotherCard:
               NSLog(@"%@", @".insertSwipeOrTryAnotherCard");
               break;
           case HpsTransactionStatusInsertOrSwipeCard:
               NSLog(@"%@", @".insertOrSwipeCard");
               break;
           case HpsTransactionStatusMultipleCardDetected:
               NSLog(@"%@", @".multipleCardDetected");
               break;
           case HpsTransactionStatusContactlessCardStillInField:
               NSLog(@"%@", @".contactlessCardStillInField");
               break;
           case HpsTransactionStatusTransactionTerminated:
               NSLog(@"%@", @".transactionTerminated");
               break;
           case HpsTransactionStatusWaitingForTerminal:
               NSLog(@"%@", @".waitingForTerminal");
               break;
           case HpsTransactionStatusCardDetected:
               NSLog(@"%@", @".cardDetected");
               break;
           case HpsTransactionStatusCardBlocked:
               NSLog(@"%@", @".cardBlocked");
               break;
           case HpsTransactionStatusNotAuthorized:
               NSLog(@"%@", @".notAuthorized");
               break;
           case HpsTransactionStatusNotAcceptedRemoveCard:
               NSLog(@"%@", @".notAcceptedRemoveCard");
               break;
           case HpsTransactionStatusFallbackToMSR:
               NSLog(@"%@", @".fallbackToMSR");
               break;
           case HpsTransactionStatusFallbackToChip:
               NSLog(@"%@", @".fallbackToChip");
               break;
           case HpsTransactionStatusWaitingForAmountConfirmation:
               NSLog(@"%@", @".waitingForAmountConfirmation");
               break;
           case HpsTransactionStatusWaitingForAidSelection:
               NSLog(@"%@", @".waitingForAidSelection");
               break;
           case HpsTransactionStatusWaitingForPostalCode:
               NSLog(@"%@", @".waitingForPostalCode");
               break;
           case HpsTransactionStatusWaitingForSafApproval:
               NSLog(@"%@", @".waitingForSafApproval");
               break;
           case HpsTransactionStatusCardHolderBypassedPIN:
               NSLog(@"%@", @".cardHolderBypassedPIN");
               break;
           case HpsTransactionStatusProcessingSaf:
               NSLog(@"%@", @".processingSaf");
               break;
           case HpsTransactionStatusRequestingOnlineProcessing:
               NSLog(@"%@", @".requestingOnlineProcessing");
               break;
           case HpsTransactionStatusReversal:
               NSLog(@"%@", @".reversal");
               break;
           case HpsTransactionStatusReversalInProgress:
               NSLog(@"%@", @".reversalInProgress");
               break;
           case HpsTransactionStatusComplete:
               NSLog(@"%@", @".complete");
               break;
           case HpsTransactionStatusCancel:
               NSLog(@"%@", @".cancel");
               break;
           case HpsTransactionStatusCancelling:
               NSLog(@"%@", @".cancelling");
               break;
           case HpsTransactionStatusCancelled:
               NSLog(@"%@", @".cancelled");
               break;
           case HpsTransactionStatusError:
               NSLog(@"%@", @".error");
               break;
           case HpsTransactionStatusUnknown:
               NSLog(@"%@", @".unknown");
               break;
       }
}
- (void)onConfirmApplication:(NSArray<AID *> *)applications {
    [self.device confirmApplication:[applications objectAtIndex:0]];
}
- (void)onTransactionComplete:(HpsTerminalResponse *)response
{
    NSLog(@"Transaction completed");
    NSLog(@"TransactionId %@", response.transactionId);
    self.response = response;
    [transactionExpectation fulfill];
    transactionExpectation = nil;
}
- (void)onTransactionCancelled {
    NSLog(@"Transaction cancelled");
}
- (void)onError:(NSError *)emvError
{
    NSLog(@"Error code: %d", (int)emvError.code);
    NSLog(@"Error domain: %@",emvError.domain);
    [transactionExpectation fulfill];
    transactionExpectation = nil;
}



@end
