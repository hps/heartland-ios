
#import <XCTest/XCTest.h>
#import "HpsHpaDevice.h"
#import "HpsHpaDownloadBuilder.h"
#import "HpsHpaLineItemBuilder.h"
#import "HpsHpaStartCardBuilder.h"
#import "HpsHpaDiagnosticBuilder.h"
#import "HpsHpaSafBuilder.h"
#import "HpsHpaEodBuilder.h"
#import "HpsHpaSendFileBuilder.h"

@interface Hps_Hpa_Report_Test : XCTestCase

@end

@implementation Hps_Hpa_Report_Test

- (HpsHpaDevice*) setupDevice
{
	HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
	config.ipAddress = @"10.138.141.26";
	config.port = @"12345";
	config.connectionMode = HpsConnectionModes_TCP_IP;
	HpsHpaDevice * device = [[HpsHpaDevice alloc] initWithConfig:config];
	return device;
}

-(void)test_StartDownload {

	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_StartDownload"];

	HpsHpaDevice *device = [self setupDevice];

	HpsHpaDownloadBuilder *builder = [[HpsHpaDownloadBuilder alloc] initWithDevice:device];
	builder.url = HPA_DOWNLOAD_URL_toString[TEST];
	builder.terminalId = @"EB25033M";
	builder.applicationId = @"PI8HD33M";
	builder.downloadType = HPA_DOWNLOAD_TYPE_toString[FULL];
	builder.downloadTime = HPA_DOWNLOAD_TIME_toString[NOW];
	builder.referenceNumber = [device generateNumber];

	[builder execute:^(id<IHPSDeviceResponse>payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:120.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)test_StartCard {

	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_StartCard"];

	HpsHpaDevice *device = [self setupDevice];

	HpsHpaStartCardBuilder *builder = [[HpsHpaStartCardBuilder alloc] initWithDevice:device];
	builder.cardGroup = HPA_CARD_GROUP_toString[CREDIT];
	builder.referenceNumber = [device generateNumber];

	[builder execute:^(id<IHPSDeviceResponse> payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:120.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)test_LineItem {

	XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_LineItem"];

	HpsHpaDevice *device = [self setupDevice];

	HpsHpaLineItemBuilder *builder= [[HpsHpaLineItemBuilder alloc] initWithDevice:device];
	builder.referenceNumber = [device generateNumber];
	builder.textLeft = @"Green Beans, canned";
	builder.textRight = @"$0.59";
	builder.r_textLeft = @"TOTAL";
	builder.r_textRight = @"$1.19";

	[builder execute:^(id<IHPSDeviceResponse> payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:120.0 handler:^(NSError * _Nullable error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)test_SendSAF {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_LineItem"];
    
    HpsHpaDevice *device = [self setupDevice];
    
    HpsHpaSafBuilder *builder= [[HpsHpaSafBuilder alloc] initWithDevice:device];
    builder.referenceNumber = [device generateNumber];
    
    [builder execute:^(HpsHpaSafResponse* payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"0", payload.responseCode);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:120.0 handler:^(NSError * _Nullable error) {
        
        if(error) XCTFail(@"Request Timed out");
    }];
}

-(void)test_Diagnostic_Report {
    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_Diagnostic_Report"];
    
    HpsHpaDevice *device = [self setupDevice];
    HpsHpaDiagnosticBuilder *builder= [[HpsHpaDiagnosticBuilder alloc] initWithDevice:device];
    builder.referenceNumber = [device generateNumber];
    
    [builder execute:^(HpsHpaDiagnosticResponse* payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"0", payload.responseCode);        
        NSLog(@"Reboot count : %ld",payload.rebootLogRecord.count);
      [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:120.0 handler:^(NSError * _Nullable error) {
        
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
        //XCTAssertEqualObjects(@"0", payload.responseCode);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:120.0 handler:^(NSError * _Nullable error) {
        
        if(error) XCTFail(@"Request Timed out");
    }];
}

-(void)test_SendFile {
    
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"test_Hpa_SendFile"];
    
    HpsHpaDevice *device = [self setupDevice];
    HpsHpaSendFileBuilder *builder = [[HpsHpaSendFileBuilder alloc] initWithDevice:device];
    builder.referenceNumber = [device generateNumber];
    //builder.fileName = @"BANNER.JPG";
    builder.filePath =  @"file Path here";
    
    [builder executeSendFileNameRequest:^(id<IHPSDeviceResponse> payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"00", payload.deviceResponseCode);
        if([payload.deviceResponseCode isEqualToString:@"00"]){
            builder.referenceNumber = [device generateNumber];
            [builder executeSendFileDataRequest:^(id<IHPSDeviceResponse>DuplicatePayload, NSError *error) {
                XCTAssertNil(error);
                XCTAssertNotNil(DuplicatePayload);
                XCTAssertEqualObjects(@"00", DuplicatePayload.deviceResponseCode);
                [expectation fulfill];
            }];
            
        }else {
            XCTFail(@"Hps_SendFile_Failed");
            [expectation fulfill];
        }
    }];
    
    [self waitForExpectationsWithTimeout:120.0 handler:^(NSError * _Nullable error) {
        if (error) XCTFail(@"Request Timed out");
    }];
}
@end
