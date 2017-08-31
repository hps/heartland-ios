//  Copyright (c) 2016 Global Payments. All rights reserved.


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

// manual entry

- (void)test_valid_card_should_return_token {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Async Test"];
    
    HpsTokenService *service = [[HpsTokenService alloc] initWithPublicKey:self.publicKey];
    
    [service getTokenWithCardNumber:@"4242424242424242"
                                cvc:@"023"
                           expMonth:@"3"
                            expYear:@"2017"
                   andResponseBlock:^(HpsTokenData *response) {
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
                   andResponseBlock:^(HpsTokenData *response) {
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
                   andResponseBlock:^(HpsTokenData *response) {
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
                   andResponseBlock:^(HpsTokenData *response) {
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
                   andResponseBlock:^(HpsTokenData *response) {
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
                   andResponseBlock:^(HpsTokenData *response) {
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
                   andResponseBlock:^(HpsTokenData *response) {
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
                   andResponseBlock:^(HpsTokenData *response) {
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

// track data

- (void)test_valid_track_data_should_return_token {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Async Test"];
    
    HpsTokenService *service = [[HpsTokenService alloc] initWithPublicKey:self.publicKey];
    
    [service getTokenWithCardTrackData:@"<E1050711%B4012001000000016^VI TEST CREDIT^251200000000000000000000?|JyoniYvJNQo4niHb8sKi2QebEY5QyEkEiVPONVa+kXwQwlYWWtP8MWVvk|+++++++MYYR6dB27|11;4012001000000016=25120000000000000000?|9h1XMRQqTB3ymeRjNoggVdMWoL9|+++++++MYYR6dB27|00|||/wECAQECAoFGAgEH1AEaSkFvYxZwb3NAc2VjdXJlZXhjaGFuZ2UubmV0NqiCK7DRQcpBKYH94V7T11tGIeQ+r5fcDhljp5YbevjEpe1ZLPaeFvLHwR93DOsGVh/6Q5UQEotRf8bw9JbwvhHprluHxDJ8xmqqZaZ28dmmutXA8ZmAe+599j8+T81P7BGBaVefReaqr3bl8SZ0alTohnVUMzvFWAktUPkuZvQAn3a+E6wlsbz0pDfHiIzCGe3pqE98KX5OnJQ55braq7y5rL96|>"
                      andResponseBlock:^(HpsTokenData *response) {
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

- (void)test_valid_parsed_track_data_should_return_token {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Async Test"];
    
    HpsTokenService *service = [[HpsTokenService alloc] initWithPublicKey:self.publicKey];
    
    [service getTokenWithCardTrackData:@"%B4012001000000016^VI TEST CREDIT^251200000000000000000000?;4012001000000016=25120000000000000000?"
                      andResponseBlock:^(HpsTokenData *response) {
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

- (void)test_valid_track_data_error_should_be_nil {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Async Test"];
    
    HpsTokenService *service = [[HpsTokenService alloc] initWithPublicKey:self.publicKey];
    
    [service getTokenWithCardTrackData:@"<E1050711%B4012001000000016^VI TEST CREDIT^251200000000000000000000?|JyoniYvJNQo4niHb8sKi2QebEY5QyEkEiVPONVa+kXwQwlYWWtP8MWVvk|+++++++MYYR6dB27|11;4012001000000016=25120000000000000000?|9h1XMRQqTB3ymeRjNoggVdMWoL9|+++++++MYYR6dB27|00|||/wECAQECAoFGAgEH1AEaSkFvYxZwb3NAc2VjdXJlZXhjaGFuZ2UubmV0NqiCK7DRQcpBKYH94V7T11tGIeQ+r5fcDhljp5YbevjEpe1ZLPaeFvLHwR93DOsGVh/6Q5UQEotRf8bw9JbwvhHprluHxDJ8xmqqZaZ28dmmutXA8ZmAe+599j8+T81P7BGBaVefReaqr3bl8SZ0alTohnVUMzvFWAktUPkuZvQAn3a+E6wlsbz0pDfHiIzCGe3pqE98KX5OnJQ55braq7y5rL96|>"
                      andResponseBlock:^(HpsTokenData *response) {
                          XCTAssertTrue([response.type isEqualToString:@"token"]);
                          XCTAssertNotNil(response.tokenValue, @"tokenValue nil");
                          XCTAssertNotNil(response.tokenType, @"tokenType nil");
                          XCTAssertNotNil(response.tokenExpire, @"tokenExpire nil");
                          XCTAssertNil(response.message, @"error message not nil");
                          [expectation fulfill];
                      }];
    
    
    [self waitForExpectationsWithTimeout:35.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void)test_invalid_track_data_should_return_error {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Async Test"];
    
    HpsTokenService *service = [[HpsTokenService alloc] initWithPublicKey:self.publicKey];
    
    [service getTokenWithCardTrackData:@"bad"
                      andResponseBlock:^(HpsTokenData *response) {
                          XCTAssertNil(response.tokenType);
                          XCTAssertNil(response.tokenValue);
                          XCTAssertTrue([response.type isEqualToString:@"error"]);
                          XCTAssertTrue([response.code isEqualToString:@"2"]);
                          XCTAssertTrue([response.param isEqualToString:@"card .track"]);
                          XCTAssertTrue([response.message isEqualToString:@"card parsing track failed."]);
                          [expectation fulfill];
                      }];
    
    
    [self waitForExpectationsWithTimeout:35.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

// encrypted track data

- (void)test_valid_encrypted_track_data_should_return_token {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Async Test"];
    
    HpsTokenService *service = [[HpsTokenService alloc] initWithPublicKey:self.publicKey];
    
    [service getTokenWithEncryptedCardTrackData:@"4012007060016=2512101EcWdTERdUpf8PbKa"
                                    trackNumber:@"02"
                                            ktb:@"/wECAQEEAoFGAgEH3wICTDT6jRZwb3NAc2VjdXJlZXhjaGFuZ2UubmV0oyixA/yDoXL0iQbtz2RQFXIJgH2p+RIggm81xBBiHOVR6Pa2aDTIc7VtTNhpK6nMLR6kvJ6yubVFTSNsobpUKQRNvwjDf+YhO3LjeUrn44ew7CSwkicqgqAAwRKbb148OFtFVrqmZWOK39aQG6O9lXO1B7tyhhIjSJu9eL26gR0AF56UD+igdXDqEDMSc+HqVIVbTC0uicp4TJQEwW7IcyH+1hdk"
                                       pinBlock:nil
                               andResponseBlock:^(HpsTokenData *response) {
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

- (void)test_valid_encrypted_track_data_error_should_be_nil {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Async Test"];
    
    HpsTokenService *service = [[HpsTokenService alloc] initWithPublicKey:self.publicKey];
    
    [service getTokenWithEncryptedCardTrackData:@"4012007060016=2512101EcWdTERdUpf8PbKa"
                                    trackNumber:@"02"
                                            ktb:@"/wECAQEEAoFGAgEH3wICTDT6jRZwb3NAc2VjdXJlZXhjaGFuZ2UubmV0oyixA/yDoXL0iQbtz2RQFXIJgH2p+RIggm81xBBiHOVR6Pa2aDTIc7VtTNhpK6nMLR6kvJ6yubVFTSNsobpUKQRNvwjDf+YhO3LjeUrn44ew7CSwkicqgqAAwRKbb148OFtFVrqmZWOK39aQG6O9lXO1B7tyhhIjSJu9eL26gR0AF56UD+igdXDqEDMSc+HqVIVbTC0uicp4TJQEwW7IcyH+1hdk"
                                       pinBlock:nil
                      andResponseBlock:^(HpsTokenData *response) {
                          XCTAssertTrue([response.type isEqualToString:@"token"]);
                          XCTAssertNotNil(response.tokenValue, @"tokenValue nil");
                          XCTAssertNotNil(response.tokenType, @"tokenType nil");
                          XCTAssertNotNil(response.tokenExpire, @"tokenExpire nil");
                          XCTAssertNil(response.message, @"error message not nil");
                          [expectation fulfill];
                      }];
    
    
    [self waitForExpectationsWithTimeout:35.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void)test_invalid_encrypted_track_data_should_return_error {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Async Test"];
    
    HpsTokenService *service = [[HpsTokenService alloc] initWithPublicKey:self.publicKey];
    
    [service getTokenWithEncryptedCardTrackData:@"9h1XMRQqTB3ymeRjNoggVdMWoL9"
                                    trackNumber:@"02"
                                            ktb:@"/wECAQECAoFGAgEH1AEaSkFvYxZwb3NAc2VjdXJlZXhjaGFuZ2UubmV0NqiCK7DRQcpBKYH94V7T11tGIeQ+r5fcDhljp5YbevjEpe1ZLPaeFvLHwR93DOsGVh/6Q5UQEotRf8bw9JbwvhHprluHxDJ8xmqqZaZ28dmmutXA8ZmAe+599j8+T81P7BGBaVefReaqr3bl8SZ0alTohnVUMzvFWAktUPkuZvQAn3a+E6wlsbz0pDfHiIzCGe3pqE98KX5OnJQ55braq7y5rL96"
                                       pinBlock:nil
                      andResponseBlock:^(HpsTokenData *response) {
                          XCTAssertNil(response.tokenType);
                          XCTAssertNil(response.tokenValue);
                          XCTAssertTrue([response.type isEqualToString:@"error"]);
                          XCTAssertTrue([response.code isEqualToString:@"2"]);
                          XCTAssertTrue([response.param isEqualToString:@"encryptedcard .track"]);
                          XCTAssertTrue([response.message isEqualToString:@"encryptedcard parsing track failed."]);
                          [expectation fulfill];
                      }];
    
    
    [self waitForExpectationsWithTimeout:35.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}


@end
