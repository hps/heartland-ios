#import <XCTest/XCTest.h>
#import "HpsPaxDevice.h"
#import "HpsCreditCard.h"
#import "HpsAddress.h"
#import "HpsPaxDebitSaleBuilder.h"
#import "HpsPaxDeviceResponse.h"
#import "HpsPaxDebitReturnBuilder.h"

@interface Hps_Pax_Debit_Tests : XCTestCase

@end

@implementation Hps_Pax_Debit_Tests

- (HpsPaxDevice*) setupDevice
{
    HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
    config.ipAddress = @"192.168.1.12";
    config.port = @"10009";
    config.connectionMode = HpsConnectionModes_TCP_IP;
    HpsPaxDevice * device = [[HpsPaxDevice alloc] initWithConfig:config];
    return device;
}

- (void) test_PAX_HTTP_Debit_Sale
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Debit_Sale"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxDebitSaleBuilder *builder = [[HpsPaxDebitSaleBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:10.0];
    builder.referenceNumber = 5;
    builder.allowDuplicates = NO;
    
    [builder execute:^(HpsPaxDebitResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.responseCode);
        
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_PAX_HTTP_Debit_Sale33_PartialAtuh22
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Debit_Sale33_PartialAtuh22"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxDebitSaleBuilder *builder = [[HpsPaxDebitSaleBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:33.0];
    builder.referenceNumber = 5;
    builder.allowDuplicates = YES;
    
    [builder execute:^(HpsPaxDebitResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"10", payload.responseCode);
       // XCTAssertEqualObjects(22f, payload.tra);
        //XCTAssertEqualObjects(@"10", payload.responseCode);
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}





-(void) test_Debit_Sale0{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Debit_Sale_0_Amount"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxDebitSaleBuilder *builder = [[HpsPaxDebitSaleBuilder alloc] initWithDevice:device];
    builder.referenceNumber = 5;
    builder.allowDuplicates = YES;
    builder.amount = [NSNumber numberWithDouble:0.0];
    
    @try {
        
        [builder execute:^(HpsPaxDebitResponse *payload, NSError *error) {
            XCTFail(@"Request not allowed but returned");
            
        }];
    } @catch (NSException *exception) {
        
        [expectation fulfill];
    }
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

-(void) test_Debit_Return{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Debit_Return"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxDebitReturnBuilder *builder = [[HpsPaxDebitReturnBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:10.0];
    builder.referenceNumber = 5;
    
    [builder execute:^(HpsPaxDebitResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.responseCode);
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

-(void) test_Debit_Return_10_By_TransactionId
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Debit_Return_By_Transaction_Id"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxDebitSaleBuilder *builder = [[HpsPaxDebitSaleBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:10.0];
    builder.referenceNumber = 5;
    builder.allowDuplicates = YES;
    
    [builder execute:^(HpsPaxDebitResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.responseCode);
        
        HpsPaxDebitReturnBuilder *builder = [[HpsPaxDebitReturnBuilder alloc] initWithDevice:device];
        builder.amount = [NSNumber numberWithDouble:10.0];
        builder.referenceNumber = 5;
        builder.transactionId = payload.transactionId;
        
        [builder execute:^(HpsPaxDebitResponse *payload, NSError *error) {
            XCTAssertNil(error);
            XCTAssertNotNil(payload);
            XCTAssertEqualObjects(@"00", payload.responseCode);
           
            [expectation fulfill];
            
        }];
        
        
}];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
    

    
}

-(void) test_Debit_Return_Blank_Amount{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Debit_Return_Blank_Amount"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxDebitReturnBuilder *builder = [[HpsPaxDebitReturnBuilder alloc] initWithDevice:device];
    builder.referenceNumber = 5;
    
    @try {
        
        [builder execute:^(HpsPaxDebitResponse *payload, NSError *error) {
            XCTFail(@"Request not allowed but returned");
            
        }];
    } @catch (NSException *exception) {
        
        [expectation fulfill];
    }
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

@end
