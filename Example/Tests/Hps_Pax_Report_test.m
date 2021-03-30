#import <XCTest/XCTest.h>
#import "HpsPaxDevice.h"
#import "HpsPaxDebitSaleBuilder.h"
#import "HpsPaxLocalDetailReportBuilder.h"

@interface Hps_Pax_Report_test : XCTestCase
@property (nonatomic, strong) NSString *authCode;
@property (nonatomic, strong) NSString *transactionNumber;
@property (nonatomic, strong) NSString *referenceNumber;
@end

@implementation Hps_Pax_Report_test
- (HpsPaxDevice*) setupDevice
{
    HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
    config.ipAddress = @"192.168.1.12";
    config.port = @"10009";
    config.connectionMode = HpsConnectionModes_TCP_IP;
    HpsPaxDevice * device = [[HpsPaxDevice alloc] initWithConfig:config];
    return device;
}

- (void) test_PAX_HTTP_Reset
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Reset"];
    
    HpsPaxDevice *device = [self setupDevice];
    [device initialize:^(HpsPaxDeviceResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}


- (void) test_PAX_HTTP_Debit_Sale
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Debit_Sale"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxDebitSaleBuilder *builder = [[HpsPaxDebitSaleBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:12.0];
    builder.referenceNumber = 5;
    builder.allowDuplicates = YES;
    
    [builder execute:^(HpsPaxDebitResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.responseCode);
        NSLog(@"authcode : %@",payload.authorizationCode);
        NSLog(@"reference Number : %@",payload.referenceNumber);
        NSLog(@"transaction Number : %@",payload.traceResponse.transactionNunmber);
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:120.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}


- (void) test_PAX_Detail_Report_Transaction_Type
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_Detail_Report"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxLocalDetailReportBuilder *builder = [[HpsPaxLocalDetailReportBuilder alloc] initWithDevice:device];
    builder.searchCriteria = TRANSACTION_TYPE;
    builder.searchData = PAX_TXN_TYPE_SALE_REDEEM;
  
    
    [builder execute:^(HpsPaxLocalDetailResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"01", payload.transactionType);
        [expectation fulfill];
        
    }];
        [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}
- (void) test_PAX_Detail_Report_Card_Type
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_Detail_Report"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxLocalDetailReportBuilder *builder = [[HpsPaxLocalDetailReportBuilder alloc] initWithDevice:device];
    builder.searchCriteria = CARD_TYPE;
    builder.searchData = @"01";
    
    
    [builder execute:^(HpsPaxLocalDetailResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"01", payload.paymentType);
        [expectation fulfill];
        
    }];
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_PAX_Detail_Report_Record_Number
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_Detail_Report"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxLocalDetailReportBuilder *builder = [[HpsPaxLocalDetailReportBuilder alloc] initWithDevice:device];
    builder.searchCriteria = RECORD_NUMBER;
    builder.searchData = @"1";
    
    
    [builder execute:^(HpsPaxLocalDetailResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"1", payload.recordNumber);
        [expectation fulfill];
        
    }];
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_PAX_Detail_Report_Reference_Number
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_Detail_Report"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxLocalDetailReportBuilder *builder = [[HpsPaxLocalDetailReportBuilder alloc] initWithDevice:device];
    builder.searchCriteria = TERMINAL_REFERENCE_NUMBER;
    builder.searchData = @"5";
    
    
    [builder execute:^(HpsPaxLocalDetailResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"5", payload.referenceNumber);
        XCTAssertEqualObjects(@"7", payload.traceResponse.transactionNunmber);
        [expectation fulfill];
        
    }];
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_PAX_Detail_Report_Auth_Code
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_Detail_Report"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxLocalDetailReportBuilder *builder = [[HpsPaxLocalDetailReportBuilder alloc] initWithDevice:device];
    builder.searchCriteria = AUTH_CODE;
    builder.searchData = @"172062";
    
    
    [builder execute:^(HpsPaxLocalDetailResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.responseCode);
        [expectation fulfill];
        
    }];
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_PAX_Detail_Report_Terminal_Reference_Number
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_Detail_Report"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxLocalDetailReportBuilder *builder = [[HpsPaxLocalDetailReportBuilder alloc] initWithDevice:device];
    builder.searchCriteria = TERMINAL_REFERENCE_NUMBER;
    builder.searchData = @"7";
    
    
    [builder execute:^(HpsPaxLocalDetailResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"5", payload.referenceNumber);
        XCTAssertEqualObjects(@"7", payload.traceResponse.transactionNunmber);
        [expectation fulfill];
        
    }];
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_PAX_Detail_Report_Merchant_Id
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_Detail_Report"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxLocalDetailReportBuilder *builder = [[HpsPaxLocalDetailReportBuilder alloc] initWithDevice:device];
    builder.searchCriteria = MERCHANT_ID;
    builder.searchData = @"12345";
    
    
    [builder execute:^(HpsPaxLocalDetailResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.responseCode);
        [expectation fulfill];
        
    }];
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_PAX_Detail_Report_Merchant_Name
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_Detail_Report"];
    
    HpsPaxDevice *device = [self setupDevice];
    HpsPaxLocalDetailReportBuilder *builder = [[HpsPaxLocalDetailReportBuilder alloc] initWithDevice:device];
    builder.searchCriteria = MERCHANT_NAME;
    builder.searchData = @"CAS";
    
    
    [builder execute:^(HpsPaxLocalDetailResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.responseCode);
        [expectation fulfill];
        
    }];
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}




@end
