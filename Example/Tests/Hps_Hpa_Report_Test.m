
#import <XCTest/XCTest.h>
#import "HpsHpaDevice.h"
#import "HpsHpaDownloadBuilder.h"
#import "HpsHpaLineItemBuilder.h"
#import "HpsHpaStartCardBuilder.h"

@interface Hps_Hpa_Report_Test : XCTestCase

@end

@implementation Hps_Hpa_Report_Test

- (HpsHpaDevice*) setupDevice
{
	HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
	config.ipAddress = @"10.12.220.39";
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
	builder.cardGroup = HPA_CARD_GROUP_toString[CARD_GROUP_CREDIT];
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

@end
