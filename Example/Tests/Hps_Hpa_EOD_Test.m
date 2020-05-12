#import <XCTest/XCTest.h>
#import "HpsHpaDevice.h"
#import "HpsHpaCreditSaleBuilder.h"
#import "HpsHpaEodBuilder.h"
@interface Hps_Hpa_EOD_Test : XCTestCase

@end

@implementation Hps_Hpa_EOD_Test
- (HpsHpaDevice*) setupDevice
{
    HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
    config.ipAddress = @"10.138.141.26";
    config.port = @"12345";
    config.connectionMode = HpsConnectionModes_TCP_IP;
    HpsHpaDevice * device = [[HpsHpaDevice alloc] initWithConfig:config];
    return device;
}

- (void) test_001_Hpa_HTTP_Reset
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_Reset"];
    
    HpsHpaDevice *device = [self setupDevice];
    
    [device reset:^(id<IHPSDeviceResponse> payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
        
        HpsHpaDeviceResponse *response = (HpsHpaDeviceResponse*)payload;
        NSLog(@"%@", [response toString]);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

-(void)test_002_LaneOpen
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_TCP_Lane_Open"];
    
    HpsHpaDevice *device = [self setupDevice];
    
    [device openLane:^(id<IHPSDeviceResponse> payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
        
        HpsHpaDeviceResponse *response = (HpsHpaDeviceResponse*)payload;
        NSLog(@"%@", [response toString]);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_003_Credit_Sale
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testHttpHpa Do credit fail MultiplePayments"];
    
    HpsHpaDevice *device = [self setupDevice];
    
    HpsHpaCreditSaleBuilder *builder = [[HpsHpaCreditSaleBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:11.52];
    builder.referenceNumber = [device generateNumber];
    
    [builder execute:^(id <IHPSDeviceResponse> payload, NSError *error){
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
        
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:120.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
    
}

- (void) test_001b_Hpa_HTTP_Reset
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_HTTP_Reset"];
    
    HpsHpaDevice *device = [self setupDevice];
    
    [device reset:^(id<IHPSDeviceResponse> payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
        
        HpsHpaDeviceResponse *response = (HpsHpaDeviceResponse*)payload;
        NSLog(@"%@", [response toString]);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}
-(void)test_004_LaneClose{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_TCP_Lane_Close"];
    
    HpsHpaDevice *device = [self setupDevice];
    
    [device closeLane:^(id<IHPSDeviceResponse>payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        HpsHpaDeviceResponse *response = (HpsHpaDeviceResponse*)payload;
        NSLog(@"%@", [response toString]);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}
-(void)test_ExecuteEOD {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_LineItem"];
    
    HpsHpaDevice *device = [self setupDevice];
    
    HpsHpaEodBuilder *builder= [[HpsHpaEodBuilder alloc] initWithDevice:device];
    builder.referenceNumber = [device generateNumber];
    
    [builder execute:^(HpsHpaEodResponse* payload, NSError *error) {
        
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"0", payload.responseCode);
        XCTAssertNotNil(payload.reversals);
        XCTAssertNotNil(payload.offlineDecline);
        XCTAssertNotNil(payload.transactionCertificate);
        XCTAssertNotNil(payload.addAttachment);
        XCTAssertNotNil(payload.sendSAF);
        XCTAssertNotNil(payload.batchClose);
        XCTAssertNotNil(payload.emvpdl);
        XCTAssertNotNil(payload.heartBeat);
        
        
        //Reversal
        HpsHpaDeviceResponse *deviceResponse = payload.reversalResponse;
        XCTAssertEqualObjects(@"00", deviceResponse.deviceResponseCode);
        
        //EMVOfflineDecline
        deviceResponse = payload.eMVOfflineDeclineResponse;
        XCTAssertEqualObjects(@"00", deviceResponse.deviceResponseCode);
        
        //EMVTC
        deviceResponse = payload.eMVTCResponse;
        XCTAssertEqualObjects(@"00", deviceResponse.deviceResponseCode);
        
        //Attachment
        deviceResponse = payload.attachmentResponse;
        XCTAssertEqualObjects(@"00", deviceResponse.deviceResponseCode);
        
        //BatchClose
        deviceResponse = payload.batchCloseResponse;
        XCTAssertEqualObjects(@"00", deviceResponse.deviceResponseCode);
        
        //EMVPDL
        deviceResponse = payload.eMVPDLResponse;
        XCTAssertEqualObjects(@"00", deviceResponse.deviceResponseCode);
        
        //Heartbeat
        HpsHpaHeartBeatResponse *heartBeatResponse = payload.hpsHpaHeartBeatResponse;
        XCTAssertEqualObjects(@"0", heartBeatResponse.responseCode);
        
        //SAF
        HpsHpaSafResponse * safResponse = payload.hpsHpaSafResponse;
        XCTAssertEqualObjects(@"0", safResponse.responseCode);
        
        //Batch
        HpsHpaBatchResponse * batchResponse = payload.hpsHpaBatchResponse;
        XCTAssertEqualObjects(@"0", batchResponse.responseCode);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:120.0 handler:^(NSError * _Nullable error) {
        
        if(error) XCTFail(@"Request Timed out");
    }];
}
@end
