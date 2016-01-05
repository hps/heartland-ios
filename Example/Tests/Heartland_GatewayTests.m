//
//  Heartland_GatewayTests.m
//  Heartland-Tokenization
//
//  Created by Roberts, Jerry on 9/8/15.
//  Copyright (c) 2015 Heartland Payment Systems. All rights reserved.
//

 
#import <XCTest/XCTest.h>
#import "hps.h"

@interface Heartland_GatewayTests : XCTestCase

@end

@implementation Heartland_GatewayTests

- (void) testCreditSale
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Async Test"];
    
    
    /** NOTE: Do not include your gateway credentials in your application if you plan to distribute in the AppStore.
        This data can be easily obtained by decompiling the application on a jail broke phone. */
    #warning Do not compile your SecretApiKey into the application

    // 1.) Configure the service
    HpsServicesConfig *config = [[HpsServicesConfig alloc]
                                 initWithSecretApiKey:@"skapi_cert_MYl2AQAowiQAbLp5JesGKh7QFkcizOP2jcX9BrEMqQ"
                                 developerId:@"123456"
                                 versionNumber:@"1234"];
    
    // 2.) Initialize the service
    HpsGatewayService *service = [[HpsGatewayService alloc] initWithConfig:config];
    
    // 3.) Initialize a Transaction to process
    HpsTransaction *transaction = [[HpsTransaction alloc] init];
    
    //card holder data
    transaction.cardHolderData.firstName = @"Jane";
    transaction.cardHolderData.lastName = @"Doe";
    transaction.cardHolderData.address = @"123 Someway St.";
    transaction.cardHolderData.city = @"Anytown";
    transaction.cardHolderData.zip = @"AZ";

    //Card data as strings
    transaction.cardData.cardNumber = @"4242424242424242";
    transaction.cardData.expYear = @"2021";
    transaction.cardData.expMonth = @"6";
    
    //Do you want a re-use token returned?
    transaction.cardData.requestToken = YES;
    
    //charge details
    transaction.chargeAmount = 24.50f;
    
    //additional details (optional)
    transaction.additionalTxnFields.desc = @"Mega Sale";
    transaction.additionalTxnFields.invoiceNumber = @"12345";
    transaction.additionalTxnFields.customerID = @"4321";
    
    // 4.) Run the transaction with the service.
    [service doTransaction:transaction
         withResponseBlock:^(HpsGatewayResponse *gatewayResponse) {
             
             XCTAssertEqualObjects(gatewayResponse.tokenResponse.code, @"0");
             XCTAssertNotNil(gatewayResponse.tokenResponse.tokenValue);
             
             XCTAssertEqualObjects(gatewayResponse.responseCode, @"00");
             XCTAssertNotNil(gatewayResponse.authorizationCode);
             [expectation fulfill];

             
         }];
    
    [self waitForExpectationsWithTimeout:35.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) testCreditSale_BadCard
{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Async Test"];
    
    
    /** NOTE: Do not include your gateway credentials in your application if you plan to distribute in the AppStore.
     This data can be easily obtained by decompiling the application on a jail broke phone. */
#warning Do not compile your SecretApiKey into the application
    
    // 1.) Configure the service
    HpsServicesConfig *config = [[HpsServicesConfig alloc]
                                 initWithSecretApiKey:@"skapi_cert_MYl2AQAowiQAbLp5JesGKh7QFkcizOP2jcX9BrEMqQ"
                                 developerId:@"123456"
                                 versionNumber:@"1234"];
    
    // 2.) Initialize the service
    HpsGatewayService *service = [[HpsGatewayService alloc] initWithConfig:config];
    
    // 3.) Initialize a Transaction to process
    HpsTransaction *transaction = [[HpsTransaction alloc] init];
    
    //card holder data
    transaction.cardHolderData.firstName = @"Jane";
    transaction.cardHolderData.lastName = @"Doe";
    transaction.cardHolderData.address = @"123 Someway St.";
    transaction.cardHolderData.city = @"Anytown";
    transaction.cardHolderData.zip = @"AZ";
    
    //Card data as strings
    transaction.cardData.cardNumber = @"1234";
    transaction.cardData.expYear = @"2021";
    transaction.cardData.expMonth = @"6";
    
    //Do you want a re-use token returned?
    transaction.cardData.requestToken = YES;
    
    //charge details
    transaction.chargeAmount = 24.50f;
    
    //additional details (optional)
    transaction.additionalTxnFields.desc = @"Mega Sale";
    transaction.additionalTxnFields.invoiceNumber = @"12345";
    transaction.additionalTxnFields.customerID = @"4321";
    
    // 4.) Run the transaction with the service.
    [service doTransaction:transaction
         withResponseBlock:^(HpsGatewayResponse *gatewayResponse) {
             
             XCTAssertNil(gatewayResponse.tokenResponse);
             
//             XCTAssertEqualObjects(gatewayResponse.responseCode, @"00");
//             XCTAssertNotNil(gatewayResponse.authorizationCode);
             [expectation fulfill];
         }];
    
    [self waitForExpectationsWithTimeout:35.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}
@end