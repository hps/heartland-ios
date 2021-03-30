#import <XCTest/XCTest.h>
#import "HpsPaxDevice.h"
#import "HpsPaxDeviceResponse.h"
#import "HpsGiftCard.h"
#import "HpsPaxGiftResponse.h"
#import "HpsPaxGiftSaleBuilder.h"
#import "HpsPaxGiftAddValueBuilder.h"
#import "HpsPaxGiftActivateBuilder.h"
#import "HpsPaxGiftBalanceBuilder.h"
#import "HpsPaxGiftVoidBuilder.h"

@interface Hps_Pax_Gift_Tests : XCTestCase

@end

@implementation Hps_Pax_Gift_Tests
- (HpsPaxDevice*) setupDevice
{
	HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
	config.ipAddress = @"192.168.1.12";
	config.port = @"10009";
	config.connectionMode = HpsConnectionModes_TCP_IP;
	HpsPaxDevice * device = [[HpsPaxDevice alloc] initWithConfig:config];
	return device;
}
- (HpsGiftCard*) getCard
{
	HpsGiftCard *card = [[HpsGiftCard alloc] init];
	card.value = @"5022440000000000098";
	return card;
}

- (void) test_PAX_HTTP_Gift_Sale
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Gift_Sale"];

	HpsPaxDevice *device = [self setupDevice];
	HpsGiftCard *card = [self getCard];

	HpsPaxGiftSaleBuilder *builder = [[HpsPaxGiftSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:10.0];
	builder.referenceNumber = 1;
	builder.giftCard = card;
    builder.allowDuplicates = YES;

	[builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"0", payload.responseCode);
		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_PAX_HTTP_Gift_Sale_With_InvoiceNumber
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Gift_Sale_With_InvoiceNumber"];

	HpsPaxDevice *device = [self setupDevice];
	HpsGiftCard *card = [self getCard];

	HpsPaxGiftSaleBuilder *builder = [[HpsPaxGiftSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:8.0];
	builder.referenceNumber = 3;
	builder.giftCard = card;

	HpsTransactionDetails *details = [[HpsTransactionDetails alloc] init];
	details.invoiceNumber = @"1234";
	builder.details = details;

	[builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"0", payload.responseCode);
		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_PAX_HTTP_Loyalty_Sale
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Loyalty_Sale"];

	HpsPaxDevice *device = [self setupDevice];
	HpsGiftCard *card = [self getCard];

	HpsPaxGiftSaleBuilder *builder = [[HpsPaxGiftSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:18.0];
	builder.referenceNumber = 5;
	builder.giftCard = card;
	builder.currencyType = HpsCurrencyCodes_POINTS;

	[builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"0", payload.responseCode);
		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_PAX_HTTP_Gift_Fail_No_Amount
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Gift_Fail_No_Amount"];

	HpsPaxDevice *device = [self setupDevice];

	HpsPaxGiftSaleBuilder *builder = [[HpsPaxGiftSaleBuilder alloc] initWithDevice:device];
	builder.referenceNumber = 5;

	@try {
		[builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {

			XCTFail(@"Request not allowed but returned");
		}];
	} @catch (NSException *exception) {
		[expectation fulfill];
	}

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_PAX_HTTP_Gift_Fail_No_Currency
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Gift_Fail_No_Currency"];

	HpsPaxDevice *device = [self setupDevice];
	HpsGiftCard *card = [self getCard];

	HpsPaxGiftSaleBuilder *builder = [[HpsPaxGiftSaleBuilder alloc] initWithDevice:device];
	builder.referenceNumber = 6;
	builder.giftCard = card;
	builder.currencyType = -1;

	@try {
		[builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {

			XCTFail(@"Request not allowed but returned");
		}];
	} @catch (NSException *exception) {
		[expectation fulfill];
	}

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_PAX_HTTP_Gift_Activate
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Gift_Activate"];

    HpsPaxDevice *device = [self setupDevice];
    HpsGiftCard *card = [self getCard];

    HpsPaxGiftActivateBuilder *builder = [[HpsPaxGiftActivateBuilder alloc] initWithDevice:device];
    builder.amount = [NSNumber numberWithDouble:13.0];
    builder.referenceNumber = 7;
    builder.giftCard = card;

    [builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"0", payload.responseCode);
        [expectation fulfill];

    }];

    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_PAX_HTTP_Gift_AddValue
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Gift_AddValue"];

	HpsPaxDevice *device = [self setupDevice];
	HpsGiftCard *card = [self getCard];

	HpsPaxGiftAddValueBuilder *builder = [[HpsPaxGiftAddValueBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:11.0];
	builder.referenceNumber = 7;
	builder.giftCard = card;

	[builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"0", payload.responseCode);
		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_PAX_HTTP_Loyalty_AddValue
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Loyalty_AddValue"];

	HpsPaxDevice *device = [self setupDevice];
	HpsGiftCard *card = [self getCard];

	HpsPaxGiftAddValueBuilder *builder = [[HpsPaxGiftAddValueBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:11.0];
	builder.referenceNumber = 8;
	builder.giftCard = card;
	builder.currencyType = HpsCurrencyCodes_POINTS;

	[builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"0", payload.responseCode);
		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_PAX_HTTP_Gift_AddValue_Fail_No_Amount
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Gift_AddValue_Fail_No_Amount"];

	HpsPaxDevice *device = [self setupDevice];

	HpsPaxGiftAddValueBuilder *builder = [[HpsPaxGiftAddValueBuilder alloc] initWithDevice:device];
	builder.referenceNumber = 9;

	@try {
		[builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {

			XCTFail(@"Request not allowed but returned");
		}];
	} @catch (NSException *exception) {
		[expectation fulfill];
	}

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_PAX_HTTP_Gift_Activate_Fail_No_Amount
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Gift_Activate_Fail_No_Amount"];

    HpsPaxDevice *device = [self setupDevice];

    HpsPaxGiftActivateBuilder *builder = [[HpsPaxGiftActivateBuilder alloc] initWithDevice:device];
    builder.referenceNumber = 9;

    @try {
        [builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {

            XCTFail(@"Request not allowed but returned");
        }];
    } @catch (NSException *exception) {
        [expectation fulfill];
    }

    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_PAX_HTTP_Gift_AddValue_Fail_No_Currency
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Gift_AddValue_Fail_No_Currency"];

	HpsPaxDevice *device = [self setupDevice];
	HpsGiftCard *card = [self getCard];

	HpsPaxGiftAddValueBuilder *builder = [[HpsPaxGiftAddValueBuilder alloc] initWithDevice:device];
	builder.referenceNumber = 10;
	builder.giftCard = card;
	builder.currencyType = -1;

	@try {
		[builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {

			XCTFail(@"Request not allowed but returned");
		}];
	} @catch (NSException *exception) {
		[expectation fulfill];
	}

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_PAX_HTTP_Gift_Activate_Fail_No_Currency
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Gift_Activate_Fail_No_Currency"];

    HpsPaxDevice *device = [self setupDevice];
    HpsGiftCard *card = [self getCard];

    HpsPaxGiftActivateBuilder *builder = [[HpsPaxGiftActivateBuilder alloc] initWithDevice:device];
    builder.referenceNumber = 10;
    builder.giftCard = card;
    builder.currencyType = -1;

    @try {
        [builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {

            XCTFail(@"Request not allowed but returned");
        }];
    } @catch (NSException *exception) {
        [expectation fulfill];
    }

    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) XCTFail(@"Request Timed out");
    }];
}

- (void) test_PAX_HTTP_Gift_Void
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Gift_Void"];

	HpsPaxDevice *device = [self setupDevice];
	HpsGiftCard *card = [self getCard];

	HpsPaxGiftSaleBuilder *builder = [[HpsPaxGiftSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:12.0];
	builder.referenceNumber = 13;
	builder.giftCard = card;

	[builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {

		HpsPaxGiftVoidBuilder *vbuilder = [[HpsPaxGiftVoidBuilder alloc] initWithDevice:device];
		vbuilder.referenceNumber = 13;
		vbuilder.transactionId = payload.transactionId;

		[vbuilder execute:^(HpsPaxGiftResponse *payload, NSError *error)
		 {

		 XCTAssertNil(error);
		 XCTAssertNotNil(payload);
		 XCTAssertEqualObjects(@"0", payload.responseCode);

		 [expectation fulfill];

		 }];
	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_PAX_HTTP_Gift_Void_Fail_No_Currency
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Gift_AddValue_Fail_No_Currency"];

	HpsPaxDevice *device = [self setupDevice];

	HpsPaxGiftVoidBuilder *builder = [[HpsPaxGiftVoidBuilder alloc] initWithDevice:device];
	builder.referenceNumber = 13;
	builder.currencyType = -1;

	@try {
		[builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {

			XCTFail(@"Request not allowed but returned");
		}];
	} @catch (NSException *exception) {
		[expectation fulfill];
	}

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_PAX_HTTP_Gift_Void_Fail_No_TransactionId
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Gift_Void_Fail_No_TransactionId"];

	HpsPaxDevice *device = [self setupDevice];

	HpsPaxGiftVoidBuilder *builder = [[HpsPaxGiftVoidBuilder alloc] initWithDevice:device];
	builder.referenceNumber = 14;

	@try {
		[builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {

			XCTFail(@"Request not allowed but returned");
		}];
	} @catch (NSException *exception) {
		[expectation fulfill];
	}

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_PAX_HTTP_Gift_Balance
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Gift_Balance"];

	HpsPaxDevice *device = [self setupDevice];
	HpsGiftCard *card = [self getCard];

	HpsPaxGiftBalanceBuilder *builder = [[HpsPaxGiftBalanceBuilder alloc] initWithDevice:device];
	builder.referenceNumber = 15;
	builder.giftCard = card;
	[builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"0", payload.responseCode);
		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_PAX_HTTP_Loyalty_Balance
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Gift_Loyalty_Balance"];

	HpsPaxDevice *device = [self setupDevice];
	HpsGiftCard *card = [self getCard];

	HpsPaxGiftBalanceBuilder *builder = [[HpsPaxGiftBalanceBuilder alloc] initWithDevice:device];
	builder.referenceNumber = 16;
	builder.giftCard = card;
	builder.currencyType = HpsCurrencyCodes_POINTS;

	[builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"0", payload.responseCode);
		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

- (void) test_PAX_HTTP_Gift_Balance_Fail_No_Currency
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Gift_Balance_Fail_No_Currency"];

	HpsPaxDevice *device = [self setupDevice];

	HpsPaxGiftBalanceBuilder *builder = [[HpsPaxGiftBalanceBuilder alloc] initWithDevice:device];
	builder.referenceNumber = 17;
	builder.currencyType = -1;

	@try {
		[builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {

			XCTFail(@"Request not allowed but returned");
		}];
	} @catch (NSException *exception) {
		[expectation fulfill];
	}

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void) test_PAX_HTTP_Sale_No_Amount
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Gift_Sale_No_Amount"];

	HpsPaxDevice *device = [self setupDevice];
	HpsGiftCard *card = [self getCard];
	HpsPaxGiftSaleBuilder *builder = [[HpsPaxGiftSaleBuilder alloc] initWithDevice:device];
	builder.referenceNumber = 1;
	builder.giftCard = card;

	@try {

		[builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {
			XCTFail(@"Request not allowed but returned");
		}];

	} @catch (NSException *exception) {

		[expectation fulfill];
	}

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)test_PAX_HTTP_Sale_NO_Currency
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Gift_Sale_NO_Currency_Type"];

	HpsPaxDevice *device = [self setupDevice];
	HpsGiftCard *card = [self getCard];
	HpsPaxGiftSaleBuilder *builder = [[HpsPaxGiftSaleBuilder alloc] initWithDevice:device];
	builder.amount = [NSNumber numberWithDouble:10.0];
	builder.referenceNumber = 1;
	builder.giftCard = card;
	builder.currencyType = -1 ;

	@try {
		[builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {
			XCTFail(@"Request not allowed but returned");
		}];

	} @catch (NSException *exception) {

		[expectation fulfill];
	}

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];

}

- (void) test_PAX_HTTP_Gift_AddValue_Manual
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Gift_AddValue_manual"];

	HpsPaxDevice *device = [self setupDevice];
	HpsGiftCard *card = [self getCard];
	HpsPaxGiftAddValueBuilder *builder = [[HpsPaxGiftAddValueBuilder alloc] initWithDevice:device];

	builder.amount = [NSNumber numberWithDouble:13.0];
	builder.referenceNumber = 7;
	builder.giftCard = card;
	[builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {

		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"0", payload.responseCode);
		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];

}

- (void) test_PAX_HTTP_Gift_AddValue_Manual_Loyalty
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_PAX_HTTP_Gift_AddValue"];

	HpsPaxDevice *device = [self setupDevice];
	HpsGiftCard *card = [self getCard];
	HpsPaxGiftAddValueBuilder *builder = [[HpsPaxGiftAddValueBuilder alloc] initWithDevice:device];

	builder.amount = [NSNumber numberWithDouble:14.0];
	builder.referenceNumber = 7;
	builder.giftCard = card;
	builder.currencyType = HpsCurrencyCodes_POINTS;

	[builder execute:^(HpsPaxGiftResponse *payload, NSError *error) {

		XCTAssertNil(error);
		XCTAssertNotNil(payload);
		XCTAssertEqualObjects(@"0", payload.responseCode);

		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];

}

@end
