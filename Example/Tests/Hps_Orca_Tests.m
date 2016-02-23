//
//  Hps_Orca_Tests.m
//  Heartland-iOS-SDK
//
//  Created by Shaunti Fondrisi on 2/16/16.
//  Copyright © 2016 Shaunti Fondrisi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "hps.h"

@interface Hps_Orca_Tests : XCTestCase
{
    
}
@property (nonatomic, strong) NSString *activationCode;
@property (nonatomic, strong) NSString *apiKey;
@end


@implementation Hps_Orca_Tests
- (void) testInOrder
{
//    [self testSendDeviceActivationRequest];
//    [self testActivateDevice];
    [self testGetDeviceApiKey];
    [self testGetDeviceParameters];
}
- (void) testSendDeviceActivationRequest
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testSendDeviceActivationRequest"];
    
    // 1.) Configure the service
    HpsServicesConfig *config = [[HpsServicesConfig alloc]init];
    
    config.userName = @"admin";
    config.password = @"password";
    config.isForTesting = YES;
    
    HpsDeviceData *device = [[HpsDeviceData alloc] init];
    device.merchantId = @"777700857994";
    device.deviceId = @"5315938";
    device.email = @"shaunti.fondrisi@e-hps.com";
    device.applicationId = @"Mobuyle Retail";
    device.hardwareTypeName = @"Heartland Mobuyle";
    
    //optional
    device.softwareVersion = @"eefvdfv";
    device.configurationName = @"dsfvdfv";
    device.peripheralName = @"dsfvdfv";
    device.peripheralSoftware = @"dfvdfvfv";
    
    // 2.) Initialize the service
    HpsOrcaService *service = [[HpsOrcaService alloc] init];
    
    // 3.) Call
    [service deviceActivationRequest:device withConfig:config andResponseBlock:^(HpsDeviceData *deviceData, NSError *error) {
        //self.activationCode = deviceData.activationCode;
        //Note, you have to get the activation code from the email sent.
        
        XCTAssertNil(error);
        XCTAssertNotNil(deviceData);
       
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:135.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) testActivateDevice
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testActivateDevice"];
    
    // 1.) Configure the service
    HpsServicesConfig *config = [[HpsServicesConfig alloc]init];
    config.isForTesting = YES;

    HpsDeviceData *device = [[HpsDeviceData alloc] init];
    device.merchantId = @"777700857994";
    device.applicationId = @"Mobuyle Retail";
    device.activationCode = @"620592";
    
    // 2.) Initialize the service
    HpsOrcaService *service = [[HpsOrcaService alloc] init];
    
    // 3.) Call
    [service activeDevice:device withConfig:config andResponseBlock:^(HpsDeviceData *deviceData, NSError *error) {
        
        if (error == nil) {
            self.apiKey = deviceData.apiKey;
        }
        XCTAssertNil(error);
        XCTAssertNotNil(device.apiKey);
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:135.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}
- (void) testGetDeviceApiKey
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetDeviceApiKey"];
    
    // 1.) Configure the service
    HpsServicesConfig *config = [[HpsServicesConfig alloc]init];
    config.siteId = @"101436";
    config.licenseId = @"101433";
    config.userName = @"admin";
    config.password = @"password";
    config.isForTesting = YES;
    config.deviceId = @"5315938";
    
    
    // 2.) Initialize the service
    HpsOrcaService *service = [[HpsOrcaService alloc] init];
    
    // 3.) Call
    [service getDeviceAPIKey:config andResponseBlock:^(NSString *apiKey, NSError *error) {
        if (error == nil) {
            self.apiKey = apiKey;
        }
        
        XCTAssertNil(error);
        XCTAssertNotNil(apiKey);
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:135.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) testGetDeviceParameters
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetDeviceParameters"];
    
    //Manual override - comment out to try and run in series.
    self.apiKey = @"skapi_cert_MTyMAQBiHVEAewvIzXVFcmUd2UcyBge_eCpaASUp0A";
    
    
    // 1.) Configure the service
    HpsServicesConfig *config = [[HpsServicesConfig alloc] init];
    config.secretApiKey = self.apiKey;
    config.isForTesting = YES;
    
    HpsDeviceData *device = [[HpsDeviceData alloc] init];
    device.deviceId = @"91149119";
    device.applicationId = @"Mobuyle Retail";
    device.hardwareTypeName = @"Heartland Mobuyle";

    // 2.) Initialize the service
    HpsOrcaService *service = [[HpsOrcaService alloc] init];
    
    // 3.) Call
    [service getDeviceParameters:device withConfig:config andResponseBlock:^(NSDictionary *payload, NSError *error) {
        
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:135.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}
@end
