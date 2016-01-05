//
//  Heartland_TokenizationTests.m
//  Heartland-TokenizationTests
//
//  Created by Roberts, Jerry on 2/2/15.
//  Copyright (c) 2015 Heartland Payment Systems. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "hps.h"

@interface Heartland_TokenizationTests : XCTestCase

@property (nonatomic, strong) NSString *publicKey;

@end

@implementation Heartland_TokenizationTests

- (void)setUp {
    [super setUp];
    self.publicKey = @"pkapi_cert_P6dRqs1LzfWJ6HgGVZ";
}

- (void)tearDown {
    [super tearDown];
}

- (void) timeoutErrorHandler:(NSError *)error
{
    if (error) {
        XCTFail(@"Request Timed out");
    }
}


- (void)test_valid_card_should_return_token {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Async Test"];
    
    HpsTokenService *service = [[HpsTokenService alloc] initWithPublicKey:self.publicKey];
    
    [service getTokenWithCardNumber:@"4242424242424242"
                                cvc:@"023"
                           expMonth:@"12"
                            expYear:@"2017"
                   andResponseBlock:^(HpsTokenResponse *response) {
                       XCTAssertTrue([response.type isEqualToString:@"token"]);
                       XCTAssertNotNil(response.tokenValue, @"tokenValue nil");
                       XCTAssertNotNil(response.tokenType, @"tokenType nil");
                       XCTAssertNotNil(response.tokenExpire, @"tokenExpire nil");
                       [expectation fulfill];
                   }];
    
    
    [self waitForExpectationsWithTimeout:35.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}


- (void)test_valid_card_error_shoud_be_null {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Async Test"];
    
    HpsTokenService *service = [[HpsTokenService alloc] initWithPublicKey:self.publicKey];
    
    [service getTokenWithCardNumber:@"4242424242424242"
                                cvc:@"023"
                           expMonth:@"12"
                            expYear:@"2017"
                   andResponseBlock:^(HpsTokenResponse *response) {
                       XCTAssertFalse([response.type isEqualToString:@"error"]);
                       XCTAssertNil(response.param);
                       XCTAssertNil(response.message);
                       XCTAssertNil(response.code);
                       [expectation fulfill];
                   }];
    
    [self waitForExpectationsWithTimeout:35.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void)test_invalid_number_returns_error {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Async Test"];
    
    HpsTokenService *service = [[HpsTokenService alloc] initWithPublicKey:self.publicKey];
    
    [service getTokenWithCardNumber:@"0"
                                cvc:@"023"
                           expMonth:@"12"
                            expYear:@"2017"
                   andResponseBlock:^(HpsTokenResponse *response) {
                       XCTAssertNil(response.tokenType);
                       XCTAssertNil(response.tokenValue);
                       XCTAssertTrue([response.type isEqualToString:@"error"]);
                       XCTAssertTrue([response.code isEqualToString:@"2"]);
                       XCTAssertTrue([response.param isEqualToString:@"card.number"]);
                       XCTAssertTrue([response.message isEqualToString:@"Card number is invalid."]);
                       [expectation fulfill];
                   }];
    
    [self waitForExpectationsWithTimeout:35.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void)test_long_card_number_returns_error{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Async Test"];
    
    HpsTokenService *service = [[HpsTokenService alloc] initWithPublicKey:self.publicKey];
    
    [service getTokenWithCardNumber:@"111111111111111111"
                                cvc:@"023"
                           expMonth:@"12"
                            expYear:@"2017"
                   andResponseBlock:^(HpsTokenResponse *response) {
                       XCTAssertNil(response.tokenType);
                       XCTAssertNil(response.tokenValue);
                       XCTAssertTrue([response.type isEqualToString:@"error"]);
                       XCTAssertTrue([response.code isEqualToString:@"2"]);
                       XCTAssertTrue([response.param isEqualToString:@"card.number"]);
                       XCTAssertTrue([response.message isEqualToString:@"Card number is not a recognized brand."]);
                       [expectation fulfill];
                   }];
    
    [self waitForExpectationsWithTimeout:35.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void)test_exp_month_low_returns_error{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Async Test"];
    
    HpsTokenService *service = [[HpsTokenService alloc] initWithPublicKey:self.publicKey];
    
    [service getTokenWithCardNumber:@"4242424242424242"
                                cvc:@"023"
                           expMonth:@"0"
                            expYear:@"2017"
                   andResponseBlock:^(HpsTokenResponse *response) {
                       XCTAssertNil(response.tokenType);
                       XCTAssertNil(response.tokenValue);
                       XCTAssertTrue([response.type isEqualToString:@"error"]);
                       XCTAssertTrue([response.code isEqualToString:@"2"]);
                       XCTAssertTrue([response.param isEqualToString:@"card.exp_month"]);
                       XCTAssertTrue([response.message isEqualToString:@"Card expiration month is invalid."]);
                       [expectation fulfill];
                   }];
    
    [self waitForExpectationsWithTimeout:35.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void)test_exp_month_high_returns_error{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Async Test"];
    
    HpsTokenService *service = [[HpsTokenService alloc] initWithPublicKey:self.publicKey];
    
    [service getTokenWithCardNumber:@"4242424242424242"
                                cvc:@"023"
                           expMonth:@"13"
                            expYear:@"2017"
                   andResponseBlock:^(HpsTokenResponse *response) {
                       XCTAssertNil(response.tokenType);
                       XCTAssertNil(response.tokenValue);
                       XCTAssertTrue([response.type isEqualToString:@"error"]);
                       XCTAssertTrue([response.code isEqualToString:@"2"]);
                       XCTAssertTrue([response.param isEqualToString:@"card.exp_month"]);
                       XCTAssertTrue([response.message isEqualToString:@"Card expiration month is invalid."]);
                       [expectation fulfill];
                   }];
    
    [self waitForExpectationsWithTimeout:35.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void)test_invalid_exp_year_returns_error{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Async Test"];
    
    HpsTokenService *service = [[HpsTokenService alloc] initWithPublicKey:self.publicKey];
    
    [service getTokenWithCardNumber:@"4242424242424242"
                                cvc:@"023"
                           expMonth:@"12"
                            expYear:@"12"
                   andResponseBlock:^(HpsTokenResponse *response) {
                       XCTAssertNil(response.tokenType);
                       XCTAssertNil(response.tokenValue);
                       XCTAssertTrue([response.type isEqualToString:@"error"]);
                       XCTAssertTrue([response.code isEqualToString:@"2"]);
                       XCTAssertTrue([response.param isEqualToString:@"card.exp_year"]);
                       XCTAssertTrue([response.message isEqualToString:@"Card expiration year is invalid."]);
                       [expectation fulfill];
                   }];
    
    [self waitForExpectationsWithTimeout:35.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void)test_invalid_exp_year__under_2000_returns_error{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Async Test"];
    
    HpsTokenService *service = [[HpsTokenService alloc] initWithPublicKey:self.publicKey];
    
    [service getTokenWithCardNumber:@"4242424242424242"
                               cvc:@"023"
                          expMonth:@"12"
                           expYear:@"1999"
                   andResponseBlock:^(HpsTokenResponse *response) {
                       XCTAssertNil(response.tokenType);
                       XCTAssertNil(response.tokenValue);
                       XCTAssertTrue([response.type isEqualToString:@"error"]);
                       XCTAssertTrue([response.code isEqualToString:@"2"]);
                       XCTAssertTrue([response.param isEqualToString:@"card.exp_year"]);
                       XCTAssertTrue([response.message isEqualToString:@"Card expiration year is invalid."]);
                       [expectation fulfill];
                   }];
    
    [self waitForExpectationsWithTimeout:35.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}


@end
