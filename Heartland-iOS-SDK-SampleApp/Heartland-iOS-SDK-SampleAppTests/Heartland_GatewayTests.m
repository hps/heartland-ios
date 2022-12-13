#import <XCTest/XCTest.h>
#import <Heartland_iOS_SDK/hps.h>

@interface Heartland_GatewayTests : XCTestCase

@property (nonatomic, strong) NSString *publicKey;

@end

@implementation Heartland_GatewayTests

- (void) testCreditSale
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Async Test"];
    
    
    /** NOTE: Do not include your gateway credentials in your application if you plan to distribute in the AppStore.
     This data can be easily obtained by decompiling the application on a jail broke phone. */
//#warning Do not compile your SecretApiKey into the application
    
    // 1.) Configure the service
    HpsServicesConfig *config = [[HpsServicesConfig alloc]
                                 initWithSecretApiKey:@"skapi_cert_MYl2AQAowiQAbLp5JesGKh7QFkcizOP2jcX9BrEMqQ"
                                 developerId:@"123456"
                                 versionNumber:@"1234"];
    
    // 2.) Initialize the service
    HpsGatewayService *service = [[HpsGatewayService alloc] initWithConfig:config];
    
    // 3.) Initialize a Transaction to process
    HpsTransaction *transaction = [[HpsTransaction alloc] init];
    transaction.allowDuplicate = YES;
    //card holder data
    transaction.cardHolderData.firstName = @"";
    transaction.cardHolderData.lastName = @"";
    transaction.cardHolderData.address = @"";
    transaction.cardHolderData.city = @"";
    transaction.cardHolderData.state = @"";
    transaction.cardHolderData.zip = @"";
    
    //Card data as strings
    transaction.cardData.cardNumber = @"4242424242424242";
    transaction.cardData.expYear = @"2021";
    transaction.cardData.expMonth = @"6";
    
    //Do you want a re-use token returned?
    transaction.cardData.requestToken = YES;
    
    //charge details
    transaction.chargeAmount = 25.00f;
    
    //additional details (optional)
    transaction.additionalTxnFields.desc = @"Mega Sale";
    transaction.additionalTxnFields.invoiceNumber = @"12345";
    transaction.additionalTxnFields.customerID = @"4321";
    
   
    
    // 4.) Run the transaction with the service.
    [service doTransaction:transaction
         withResponseBlock:^(HpsGatewayData *gatewayResponse, NSError *error) {
             
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




- (void) testSecretKeyWithExtraSpaces
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"secret Key With Extra Spaces"];
    
    
    /** NOTE: Do not include your gateway credentials in your application if you plan to distribute in the AppStore.
     This data can be easily obtained by decompiling the application on a jail broke phone. */
#warning Do not compile your SecretApiKey into the application
    
    // 1.) Configure the service
    HpsServicesConfig *config = [[HpsServicesConfig alloc]
                                 initWithSecretApiKey:@" skapi_cert_MYl2AQAowiQAbLp5JesGKh7QFkcizOP2jcX9BrEMqQ  "
                                 developerId:@"123456"
                                 versionNumber:@"1234"];
    
    // 2.) Initialize the service
    HpsGatewayService *service = [[HpsGatewayService alloc] initWithConfig:config];
    
    // 3.) Initialize a Transaction to process
    HpsTransaction *transaction = [[HpsTransaction alloc] init];
    transaction.allowDuplicate = YES;
    //card holder data
    transaction.cardHolderData.firstName = @"";
    transaction.cardHolderData.lastName = @"";
    transaction.cardHolderData.address = @"";
    transaction.cardHolderData.city = @"";
    transaction.cardHolderData.state = @"";
    transaction.cardHolderData.zip = @"";
    
    //Card data as strings
    transaction.cardData.cardNumber = @"4242424242424242";
    transaction.cardData.expYear = @"2021";
    transaction.cardData.expMonth = @"6";
    
    //Do you want a re-use token returned?
    transaction.cardData.requestToken = YES;
    
    //charge details
    transaction.chargeAmount = 25.00f;
    
    //additional details (optional)
    transaction.additionalTxnFields.desc = @"Mega Sale";
    transaction.additionalTxnFields.invoiceNumber = @"12345";
    transaction.additionalTxnFields.customerID = @"4321";
    
    
    
    // 4.) Run the transaction with the service.
    [service doTransaction:transaction
         withResponseBlock:^(HpsGatewayData *gatewayResponse, NSError *error) {
             
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
//#warning Do not compile your SecretApiKey into the application
    
    // 1.) Configure the service
    HpsServicesConfig *config = [[HpsServicesConfig alloc]
                                 initWithSecretApiKey:@"skapi_cert_MYl2AQAowiQAbLp5JesGKh7QFkcizOP2jcX9BrEMqQ"
                                 developerId:@"123456"
                                 versionNumber:@"1234"];
    
    // 2.) Initialize the service
    HpsGatewayService *service = [[HpsGatewayService alloc] initWithConfig:config];
    
    // 3.) Initialize a Transaction to process
    HpsTransaction *transaction = [[HpsTransaction alloc] init];
    transaction.allowDuplicate = YES;
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
         withResponseBlock:^(HpsGatewayData *gatewayResponse, NSError *error) {
             
             XCTAssertNil(gatewayResponse.tokenResponse);
             
             //             XCTAssertEqualObjects(gatewayResponse.responseCode, @"00");
             //             XCTAssertNotNil(gatewayResponse.authorizationCode);
             [expectation fulfill];
         }];
    
    [self waitForExpectationsWithTimeout:35.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}




- (void) testCreditSaleWithToken
{
    self.publicKey = @"pkapi_cert_P6dRqs1LzfWJ6HgGVZ";
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Async Test"];
    
    HpsTokenService *tokenService = [[HpsTokenService alloc] initWithPublicKey:self.publicKey];
    
    [tokenService getTokenWithCardNumber:@"4242424242424242"
                                     cvc:@"023"
                                expMonth:@"3"
                                 expYear:@"2017"
                        andResponseBlock:^(HpsTokenData *tokenResponse) {
                            
                            XCTAssertTrue([tokenResponse.type isEqualToString:@"token"]);
                            XCTAssertNotNil(tokenResponse.tokenValue, @"tokenValue nil");
                            XCTAssertNotNil(tokenResponse.tokenType, @"tokenType nil");
                            XCTAssertNotNil(tokenResponse.tokenExpire, @"tokenExpire nil");
                             
                            
                            /** NOTE: Do not include your gateway credentials in your application if you plan to distribute in the AppStore.
                             This data can be easily obtained by decompiling the application on a jail broke phone. */
//#warning Do not compile your SecretApiKey into the application
                            
                            // 1.) Configure the service
                            HpsServicesConfig *config = [[HpsServicesConfig alloc]
                                                         initWithSecretApiKey:@"skapi_cert_MYl2AQAowiQAbLp5JesGKh7QFkcizOP2jcX9BrEMqQ"
                                                         developerId:@"123456"
                                                         versionNumber:@"1234"];
                            
                            // 2.) Initialize the service
                            HpsGatewayService *service = [[HpsGatewayService alloc] initWithConfig:config];
                            
                            // 3.) Initialize a Transaction to process
                            HpsTransaction *transaction = [[HpsTransaction alloc] init];
                            transaction.allowDuplicate = YES;
                                                
                            //Charge Token
                            transaction.cardData.tokenResponse = tokenResponse;
                            
                            //card holder data
                            transaction.cardHolderData.firstName = @"Jane";
                            transaction.cardHolderData.lastName = @"Doe";
                            transaction.cardHolderData.address = @"123 Someway St.";
                            transaction.cardHolderData.city = @"Anytown";
                            transaction.cardHolderData.zip = @"AZ";
                            
                            //charge details
                            transaction.chargeAmount = 24.50f;
                            
                            //additional details (optional)
                            transaction.additionalTxnFields.desc = @"Mega Sale";
                            transaction.additionalTxnFields.invoiceNumber = @"12345";
                            transaction.additionalTxnFields.customerID = @"4321";
                            
                            // 4.) Run the transaction with the service.
                            [service doTransaction:transaction
                                 withResponseBlock:^(HpsGatewayData *gatewayResponse, NSError *error) {
                                     
                                     XCTAssertEqualObjects(gatewayResponse.responseCode, @"00");
                                     XCTAssertNotNil(gatewayResponse.authorizationCode);
                                     [expectation fulfill];
                                     
                                     
                                 }];
                            
                        }];
    
    
    
    
    
    [self waitForExpectationsWithTimeout:35.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}




@end
