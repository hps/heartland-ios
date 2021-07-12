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

@interface Hps_Pax_Credit_Tests : XCTestCase

@end

@implementation Hps_Pax_Credit_Tests
- (HpsPaxDevice*) setupDevice
{
    HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
   // config.ipAddress = @"10.12.220.113";
    //config.port = @"80";
    config.ipAddress = @"192.168.1.12";
    config.port = @"10009";
    config.connectionMode = HpsConnectionModes_TCP_IP;
    HpsPaxDevice * device = [[HpsPaxDevice alloc] initWithConfig:config];
    return device;
}

- (HpsCreditCard*) getCC
{
    HpsCreditCard *card = [[HpsCreditCard alloc] init];
    card.cardNumber = @"4005554444444460";
    card.expMonth = 12;
    card.expYear = 25;
    card.cvv = @"123";
    return card;
}


- (HpsAddress*) getAddress
{
    HpsAddress *address = [[HpsAddress alloc] init];
    address.address = @"1 Heartland Way";
    address.zip = @"95124";
    return address;
}

- (void) test_PAX_HTTP_Credit_Fail_MultiplePayments
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpPax Do credit fail MultiplePayments"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxCreditSaleBuilder *builder = [[HpsPaxCreditSaleBuilder alloc] initWithDevice:device];
    builder.referenceNumber = 1;
    builder.amount = [NSNumber numberWithDouble:11.0];
    
    builder.creditCard = [self getCC];
    
    //Too many payment methods, one or the other
    builder.token = @"sdfsdfsdfsdf";
    
    @try {
        [builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
            XCTFail(@"Request not allowed but returned");
        }];
    } @catch (NSException *exception) {
        
        [expectation fulfill];
    }
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}
- (void) test_PAX_HTTP_Credit_Fail_No_Amount
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpPax Do credit fail no amount"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxCreditSaleBuilder *builder = [[HpsPaxCreditSaleBuilder alloc] initWithDevice:device];
    builder.referenceNumber = 1;
    
    @try {
        [builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
            
            XCTFail(@"Request not allowed but returned");
        }];
    } @catch (NSException *exception) {
        [expectation fulfill];
    }
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}
- (void) test_PAX_HTTP_Auth_Fail_No_Amount
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpPax Do Auth fail no amount"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxCreditAuthBuilder *builder = [[HpsPaxCreditAuthBuilder alloc] initWithDevice:device];
    builder.referenceNumber = 1;
    builder.creditCard = [self getCC];
    
    @try {
        [builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
            
            XCTFail(@"Request not allowed but returned");
        }];
    } @catch (NSException *exception)
    {
        [expectation fulfill];
    }
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}
- (void) test_PAX_HTTP_Auth_Fail_MultiplePayments
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpPax Do auth fail MultiplePayments"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxCreditAuthBuilder *builder = [[HpsPaxCreditAuthBuilder alloc] initWithDevice:device];
    builder.referenceNumber = 1;
    builder.amount = [NSNumber numberWithDouble:11.0];
    
    builder.creditCard = [self getCC];
    
    //Too many payment methods, one or the other
    builder.token = @"sdfsdfsdfsdf";
    
    @try {
        [builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
            XCTFail(@"Request not allowed but returned");
        }];
    } @catch (NSException *exception) {
        [expectation fulfill];
    }
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}


- (void) test_PAX_HTTP_Return_Fail_MultiplePayments
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Return_Fail_MultiplePayments"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxCreditReturnBuilder *builder = [[HpsPaxCreditReturnBuilder alloc] initWithDevice:device];
    builder.referenceNumber = 1;
    builder.amount = [NSNumber numberWithDouble:11.0];
    
    builder.transactionId = @"1234567";
    
    //Too many payment methods, one or the other
    builder.token = @"sdfsdfsdfsdf";
    
    @try {
        [builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
            XCTFail(@"Request not allowed but returned");
        }];
    } @catch (NSException *exception) {
        [expectation fulfill];
    }
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_PAX_HTTP_Return_Fail_No_Amount
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Return_Fail_No_Amount"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxCreditReturnBuilder *builder = [[HpsPaxCreditReturnBuilder alloc] initWithDevice:device];
    builder.referenceNumber = 1;
    
    @try {
        [builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
            
            XCTFail(@"Request not allowed but returned");
        }];
    } @catch (NSException *exception) {
        [expectation fulfill];
    }
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}



- (void) test_PAX_HTTP_Credit_Manual_WithToken
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Credit_Manual_WithToken"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxCreditSaleBuilder *builder = [[HpsPaxCreditSaleBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:11.0];
    builder.referenceNumber = 1;
    builder.allowDuplicates = YES;
    builder.requestMultiUseToken = YES;
    
    builder.creditCard = [self getCC];
    builder.address = [self getAddress];
    
    [builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.responseCode);
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_PAX_HTTP_Credit_Manual
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Credit_Manual"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxCreditSaleBuilder *builder = [[HpsPaxCreditSaleBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:12.0];
    builder.referenceNumber = 1;
    builder.allowDuplicates = YES;
    
    builder.creditCard = [self getCC];
    builder.address = [self getAddress];
    
    [builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.responseCode);
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:90.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_PAX_HTTP_Adjust_Fail_No_Transaction_ID
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Adjust_Fail_No_Transaction_ID"];

    HpsPaxDevice *device = [self setupDevice];
    HpsPaxCreditAdjustBuilder *builder = [[HpsPaxCreditAdjustBuilder alloc] initWithDevice:device];
    builder.referenceNumber = 1;

    @try {
        [builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {

            XCTFail(@"Request not allowed but returned");
        }];
    } @catch (NSException *exception) {
        [expectation fulfill];
    }

    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_PAX_HTTP_Capture_Fail_No_Transaction_ID
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Capture_Fail_No_Transaction_ID"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxCreditCaptureBuilder *builder = [[HpsPaxCreditCaptureBuilder alloc] initWithDevice:device];
    builder.referenceNumber = 1;
    
    @try {
        [builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
            
            XCTFail(@"Request not allowed but returned");
        }];
    } @catch (NSException *exception) {
        [expectation fulfill];
    }
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}


- (void) test_PAX_HTTP_Return_By_Card
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Return_By_Card"];
    
    HpsPaxDevice *device = [self setupDevice];
	
    HpsPaxCreditReturnBuilder *builder = [[HpsPaxCreditReturnBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:12.0];
    builder.creditCard = [self getCC];
    
    [builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.responseCode);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:90.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_PAX_HTTP_Return_Fail_No_Authcode
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Return_Fail_No_Authcode"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxCreditReturnBuilder *builder = [[HpsPaxCreditReturnBuilder alloc] initWithDevice:device];
    builder.referenceNumber = 1;
    builder.amount = [NSNumber numberWithDouble:11.0];
    
    builder.transactionId = @"1234567";
    
    @try {
        [builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
            
            XCTFail(@"Request not allowed but returned");
        }];
    } @catch (NSException *exception) {
        [expectation fulfill];
    }
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}
- (void) test_PAX_HTTP_Verify_Manual
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Verify_Manual"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxCreditVerifyBuilder *builder = [[HpsPaxCreditVerifyBuilder alloc] initWithDevice:device];
    builder.referenceNumber = 1;
    
    builder.creditCard = [self getCC];
    builder.address = [self getAddress];
    
    [builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"85", payload.responseCode);
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:90.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_PAX_HTTP_Tokenize
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Tokenize"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxCreditVerifyBuilder *builder = [[HpsPaxCreditVerifyBuilder alloc] initWithDevice:device];
    builder.referenceNumber = 1;
    builder.requestMultiUseToken = YES;
    builder.creditCard = [self getCC];
    builder.address = [self getAddress];
    
    [builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"85", payload.responseCode);
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:payload.tokenData.tokenValue forKey:@"token"];
        [defaults synchronize];
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:90.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_PAX_HTTP_Sale_Adjust
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Sale_Adjust"];

    HpsPaxDevice *device = [self setupDevice];
    HpsPaxCreditSaleBuilder *builder = [[HpsPaxCreditSaleBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:27.0];
    builder.referenceNumber = 1;
    builder.allowDuplicates = YES;
    builder.creditCard = [self getCC];
    builder.address = [self getAddress];

    [builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {

        XCTAssertNil(error);
        XCTAssertEqualObjects(@"00", payload.responseCode);
        XCTAssertNotNil(payload);

        //Adjust
        HpsPaxCreditAdjustBuilder *abuilder = [[HpsPaxCreditAdjustBuilder alloc] initWithDevice:device];
        abuilder.transactionId = payload.transactionId;
        abuilder.referenceNumber = 2;
        abuilder.amount = [NSNumber numberWithDouble:15.0];

        [abuilder execute:^(HpsPaxCreditResponse *apayload, NSError *aerror) {

            XCTAssertNil(aerror);
            XCTAssertEqualObjects(@"00", apayload.responseCode);
            XCTAssertNotNil(apayload);
            [expectation fulfill];

        }];

    }];

    [self waitForExpectationsWithTimeout:56000.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_PAX_HTTP_Auth_Capture
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Auth_Capture"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxCreditAuthBuilder *builder = [[HpsPaxCreditAuthBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:27.0];
    builder.referenceNumber = 1;
    builder.allowDuplicates = YES;
    builder.creditCard = [self getCC];
    builder.address = [self getAddress];
    
    [builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
        
        XCTAssertNil(error);
        XCTAssertEqualObjects(@"00", payload.responseCode);
        XCTAssertNotNil(payload);
     
        //Capture
        HpsPaxCreditCaptureBuilder *cbuilder = [[HpsPaxCreditCaptureBuilder alloc] initWithDevice:device];
        cbuilder.transactionId = payload.transactionId;
        cbuilder.referenceNumber = 2;
        cbuilder.amount = [NSNumber numberWithDouble:15.0];
		
        [cbuilder execute:^(HpsPaxCreditResponse *cpayload, NSError *cerror) {
            
            XCTAssertNil(cerror);
            XCTAssertEqualObjects(@"00", cpayload.responseCode);
            XCTAssertNotNil(cpayload);
            [expectation fulfill];
            
        }];
        
    }];
    
    [self waitForExpectationsWithTimeout:56000.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}
- (void) test_PAX_HTTP_Return_By_TransactionId
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Return_By_TransactionId"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxCreditSaleBuilder *builder = [[HpsPaxCreditSaleBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:13.0];
    builder.referenceNumber = 1;
    builder.allowDuplicates = YES;
    
    builder.creditCard = [self getCC];
    builder.address = [self getAddress];
    
    [builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.responseCode);
                
        HpsPaxCreditReturnBuilder *rbuilder = [[HpsPaxCreditReturnBuilder alloc] initWithDevice:device];
        rbuilder.amount = [NSNumber numberWithDouble:11.0];
        rbuilder.referenceNumber = 2;
        rbuilder.transactionId = payload.transactionId;
        rbuilder.authCode = payload.authorizationCode;
        
        [rbuilder execute:^(HpsPaxCreditResponse *rpayload, NSError *rerror) {
            XCTAssertNil(rerror);
            XCTAssertNotNil(rpayload);
            XCTAssertEqualObjects(@"00", rpayload.responseCode);
            
            [expectation fulfill];
            
        }];
        
    }];
    
    [self waitForExpectationsWithTimeout:90.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}



- (void) test_PAX_HTTP_Credit_Void
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Credit_Void"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxCreditSaleBuilder *builder = [[HpsPaxCreditSaleBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:11.0];
    builder.referenceNumber = 1;
    builder.allowDuplicates = YES;
    builder.requestMultiUseToken = YES;
    builder.creditCard = [self getCC];
    builder.address = [self getAddress];
    
    [builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.responseCode);
        
        HpsPaxCreditVoidBuilder *rbuilder = [[HpsPaxCreditVoidBuilder alloc] initWithDevice:device];
        rbuilder.referenceNumber = 1;
        rbuilder.transactionId = payload.transactionId;
        
        [rbuilder execute:^(HpsPaxCreditResponse *rpayload, NSError *rerror) {
            XCTAssertNil(rerror);
            XCTAssertNotNil(rpayload);
            XCTAssertEqualObjects(@"00", rpayload.responseCode);
            
            [expectation fulfill];
            
        }];
        
    }];
    
    [self waitForExpectationsWithTimeout:90.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

-(void) test_editNoConfiguration{


}

-(void) test_SaleWithSignatureCapture
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Credit_Sale_SignatureCaptured"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxCreditSaleBuilder *builder = [[HpsPaxCreditSaleBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:11.0];
    builder.referenceNumber = 1;
    builder.allowDuplicates = YES;
    builder.creditCard = [self getCC];
    builder.address = [self getAddress];
    builder.signatureCapture = YES;
    
    [builder execute:^(HpsPaxCreditResponse * rpayload, NSError *rerror)
    {
        XCTAssertNil(rerror);
        XCTAssertNotNil(rpayload);
        XCTAssertEqualObjects(@"00", rpayload.responseCode);
        
        [expectation fulfill];

    }];
    
    [self waitForExpectationsWithTimeout:90.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
    
}


@end
@interface Hps_Pax_Z_Return : XCTestCase

@end

@implementation Hps_Pax_Z_Return

- (HpsPaxDevice*) setupDevice
{
    HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
    // config.ipAddress = @"10.12.220.113";
    //config.port = @"80";
    config.ipAddress = @"10.12.220.172";
    config.port = @"10009";
    config.connectionMode = HpsConnectionModes_HTTP;
    HpsPaxDevice * device = [[HpsPaxDevice alloc] initWithConfig:config];
    return device;
}


- (void) test_PAX_HTTP_Return_By_Token
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Return_By_Token"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxCreditReturnBuilder *builder = [[HpsPaxCreditReturnBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:12.0];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    builder.token = [userDefault objectForKey:@"token"];
    [userDefault removeObjectForKey:@"token"];
    [userDefault synchronize];
    [builder execute:^(HpsPaxCreditResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.responseCode);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:90.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}
- (void) test_PAX_HTTP_Batch_Close
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Batch_Close"];
    
    HpsPaxDevice *device = [self setupDevice];
    [device batchClose:^(HpsPaxBatchCloseResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"OK", payload.deviceResponseMessage);
        
        [expectation fulfill];
    }];
    
    
    [self waitForExpectationsWithTimeout:90.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}


@end
