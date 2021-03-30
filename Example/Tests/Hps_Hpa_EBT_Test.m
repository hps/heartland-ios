#import <XCTest/XCTest.h>
#import "HpsHpaDevice.h"
#import "HpsCreditCard.h"
#import "HpsHpaEBTSaleBuilder.h"
#import "HpsHpaEBTRefundBuilder.h"
#import "HpsHpaEBTBalanceBuilder.h"

@interface Hps_Hpa_EBT_Test : XCTestCase

@end

@implementation Hps_Hpa_EBT_Test

- (HpsHpaDevice*) setupDevice
{
    HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
    config.ipAddress = @"10.138.141.8";
    config.port = @"12345";
    config.connectionMode = HpsConnectionModes_TCP_IP;
    HpsHpaDevice * device = [[HpsHpaDevice alloc] initWithConfig:config];
    return device;
}

- (void) test_Hpa_HTTP_EBT_Sale
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_TCP_EBT_Sale"];
    
    HpsHpaDevice *device = [self setupDevice];
    
    HpsHpaEBTSaleBuilder *builder = [[HpsHpaEBTSaleBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:10.22];
    builder.referenceNumber = [device generateNumber];
    
    [builder execute:^(id<IHPSDeviceResponse>payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

-(void) test_EBT_Refund
{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_TCP_EBT_Refund"];
    
    HpsHpaDevice *device = [self setupDevice];
    
    HpsHpaEBTRefundBuilder *builder = [[HpsHpaEBTRefundBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:10.22];
    builder.referenceNumber = [device generateNumber];
    
    [builder execute:^(id<IHPSDeviceResponse> payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_Hpa_HTTP_EBT_Balance
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_EBT_Balance"];
    
    HpsHpaDevice *device = [self setupDevice];
    
    HpsHpaEBTBalanceBuilder *builder = [[HpsHpaEBTBalanceBuilder alloc] initWithDevice:device];
    builder.referenceNumber = [device generateNumber];
    
    [builder execute:^(id <IHPSDeviceResponse> payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}
@end
