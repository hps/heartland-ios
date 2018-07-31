#import <XCTest/XCTest.h>
#import "HpsTableService.h"
#import "HpsTableServiceConfiguration.h"
#import "HpsTicket.h"
#import "HpsServiceContainer.h"

@interface HpsTableServicesTest : XCTestCase
@end
static HpsTableService *_service;

@implementation HpsTableServicesTest

-(HpsTableServiceConfiguration *)getConfiguration{
	HpsTableServiceConfiguration *config = [[HpsTableServiceConfiguration alloc]init];
	return config;
}

-(void) setupTableService {
	HpsTableServiceConfiguration *config = [self getConfiguration];
	_service = [[HpsTableService alloc]initWithConfig:config];
}

-(void) test_ALogin {

	XCTestExpectation *expectation = [self expectationWithDescription:@"test_FreshText_Login"];
	[self setupTableService];

	[_service LoginWithUserName:@"globa10" withPassword:@"glob8859" withCompletion:^(HpsLoginResponse *response, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(response);
		XCTAssertNotNil(response.locationId);
		XCTAssertNotNil(response.sessionId);
		XCTAssertNotNil(response.token);
		XCTAssertNotNil(response.tableStatus);
		XCTAssertEqualObjects(@"00", response.responseCode);
		NSLog(@"bump status = %@",[_service BumpStatuses]);
		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)test_CAssignCheck
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_FreshText_Login"];
	[_service AssignCheckWithTableNumer:1 withCheckId:1 withCompletion:^(HpsTicket* ticket, NSError* error){
		XCTAssertNil(error);
		XCTAssertNotNil(ticket);
		XCTAssertEqualObjects(@"00", ticket.responseCode);
		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];

}

-(void)test_DOpenOrder {
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_FreshText_Open_Order"];

	HpsTicket *assignedCheck = [HpsTicket FromId:1 withTableNumber:1];

	[assignedCheck openOrderWithCompletion:^(HpsTableServiceResponse *response, NSError *error) {
		XCTAssertEqualObjects(@"00", response.responseCode);
		[expectation fulfill];

	}];
	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];

}

-(void)test_BumpStatus {
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_FreshText_BumpStatus"];
	[self setupTableService];
	HpsTicket *assignedCheck = [HpsTicket FromId:1 withTableNumber:1];
	NSLog(@"checking %@", _service.BumpStatuses);
	[assignedCheck bumpStatusWithStatus:_service.BumpStatuses[0] withComplition:^(HpsTableServiceResponse *response, NSError *error)
	 {
		XCTAssertEqualObjects(@"00", response.responseCode);
	 XCTAssertEqualObjects([NSNumber numberWithInteger:assignedCheck.bumpStatusId], [NSNumber numberWithInteger:1]);
		[expectation fulfill];
	 }];
	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];

}

-(void)test_BumpStatusWithBadStatus {
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_FreshText_BumpStatus"];
	HpsTicket *assignedCheck = [HpsTicket FromId:1 withTableNumber:1];
	@try {
		[assignedCheck bumpStatusWithStatus:@"BadStatus" withComplition:^(HpsTableServiceResponse *response, NSError *error)
		 {
		 XCTAssertEqualObjects(@"00", response.responseCode);
		 }];
	} @catch (NSException *exception) {
		[expectation fulfill];
	}

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)test_FSettleCheck {
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_FreshText_SettleCheck"];
	HpsTicket *assignedCheck = [HpsTicket FromId:1 withTableNumber:1];
	[assignedCheck settleCheck:^(HpsTableServiceResponse *response, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(response);
		XCTAssertEqualObjects(@"00", response.responseCode);
		[expectation fulfill];

	}];

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)test_SettleCheckWithStatus {
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_FreshText_SettleCheckWithStatus"];
	HpsTicket *assignedCheck = [HpsTicket FromId:1 withTableNumber:1];
	NSArray *bumpStatuses = [_service BumpStatuses];
	[assignedCheck settleCheckWithStatus:bumpStatuses[1]  withCompletion:^(HpsTableServiceResponse *response, NSError *error) {
		XCTAssertEqualObjects(@"00", response.responseCode);
		XCTAssertEqualObjects([NSNumber numberWithInteger:assignedCheck.bumpStatusId], [NSNumber numberWithInteger:2]);
		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)test_SettleCheckWithBadStatus {
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_FreshText_SettleCheckWithBadStatus"];
	HpsTicket *assignedCheck = [HpsTicket FromId:1 withTableNumber:1];
	@try {
		[assignedCheck settleCheckWithStatus:@"BadStatus"  withCompletion:^(HpsTableServiceResponse *response, NSError *error) {
			XCTAssertEqualObjects(@"00", response.responseCode);
			XCTAssertEqualObjects([NSNumber numberWithInteger:assignedCheck.bumpStatusId], [NSNumber numberWithInteger:2]);
		}];
	} @catch (NSException *exception) {
		[expectation fulfill];
	}

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)testr_ClearTable {
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_FreshText_ClearTable"];
	HpsTicket *assignedCheck = [HpsTicket FromId:1 withTableNumber:1];
	[assignedCheck clearTableWithComplition:^(HpsTableServiceResponse *response, NSError *error) {
		XCTAssertEqualObjects(@"00", response.responseCode);
		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)test_EditTable
{
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_FreshText_EditTable"];
	HpsTicket *assignedCheck = [HpsTicket FromId:1 withTableNumber:1];
	assignedCheck.partyName = @"Party Of One";
	assignedCheck.partyNumber = 1;
	assignedCheck.section = @"Lonely Section";
	[assignedCheck updateWithComplition:^(HpsTableServiceResponse *response, NSError *error) {
		XCTAssertEqualObjects(@"00", response.responseCode);
		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];

}

-(void)test_Transfer {
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_FreshText_EditTable"];
	HpsTicket *assignedCheck = [HpsTicket FromId:1 withTableNumber:1];
	[assignedCheck transferWithTableNumber:2 withComplition:^(HpsTableServiceResponse *response, NSError *error) {
		XCTAssertEqualObjects(@"00", response.responseCode);
		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];

}

-(void)test_QueryTableStatus {
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_FreshText_Table_Status"];

	[_service QueryTableStatusWithTableNumber:1 withCompletion:^(HpsTicket *ticket, NSError *error) {
		XCTAssertNotNil(ticket);
		XCTAssertEqualObjects(@"00", ticket.responseCode);
		[expectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)test_QueryCheckStatus {
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_FreshText_QueryCheck_Status"];
	[_service QueryCheckStatusWithCheckId:1 withCompletion:^(HpsTicket *ticket, NSError *error) {
		XCTAssertNotNil(ticket);
		XCTAssertEqualObjects(@"00", ticket.responseCode);
		[expectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}



-(void)test_GetServerList {
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_FreshText_Get_ServerList"];
	[_service GetServerList:^(HpsServerListResponse *response, NSError *error) {
		XCTAssertNotNil(response);
		XCTAssertNotNil(response.servers);
		XCTAssertEqualObjects(@"00", response.responseCode);
		[expectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)test_UpdateServerList {

	XCTestExpectation *expectation = [self expectationWithDescription:@"test_FreshText_Update_Server_list"];

	NSArray *serverList = @[@"Senthil",@"Rahit",@"Saleem",@"Jeevitha",@"Anurag"];
	[_service UpdateServerList:serverList withCompletion:^(HpsServerListResponse *response, NSError *error) {
		XCTAssertNotNil(response);
		XCTAssertEqualObjects(@"00", response.responseCode);

		XCTAssertNotNil(response.servers);
		XCTAssertEqualObjects([NSNumber numberWithInteger:5], [NSNumber numberWithInteger:response.servers.count]);
		XCTAssertEqualObjects(@"Senthil,Rahit,Saleem,Jeevitha,Anurag", [response.servers componentsJoinedByString:@","]);
		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)test_GetAllServerAssignments {

	XCTestExpectation *expectation = [self expectationWithDescription:@"test_FreshText_Get_Server_Assignment"];
	[_service GetServerAssignments:^(HpsServerAssignmentResponse *response, NSError *error) {
		XCTAssertNotNil(response);
		XCTAssertEqualObjects(@"00", response.responseCode);
		XCTAssertNotNil(response.assignments);
		XCTAssertTrue([response.assignments objectForKey:@"Anurag"]);
		NSLog(@"Assignment Anurag = %@",[response.assignments objectForKey:@"Anurag"]);
		[expectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)test_GetServerAssignmentsByServer {
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_FreshText_GetServerAssignment By Server"];

	[_service GetServerAssignments:@"Anurag" withCompletion:^(HpsServerAssignmentResponse *response, NSError *error) {
		XCTAssertNotNil(response);
		XCTAssertEqualObjects(@"00", response.responseCode);
		XCTAssertTrue([response.assignments objectForKey:@"Anurag"]);

		NSLog(@"** Assignment Anurag = %@",[response.assignments objectForKey:@"Anurag"]);

		[expectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)test_GetTableAssignmentsByTable {
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_FreshText_GetServerAssignment By Server"];
	[_service getServerAssignmemntsWithTableNumber:1 withCompletion:^(HpsServerAssignmentResponse *response, NSError *error) {
		XCTAssertNotNil(response);
		XCTAssertEqualObjects(@"00", response.responseCode);
		XCTAssertNotNil(response.assignments);

		[expectation fulfill];

	}];
	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];

}


-(void)test_AssignShifts {
	XCTestExpectation *expectation = [self expectationWithDescription:@"test_FreshText_GetServerAssignment By Server"];
	NSMutableDictionary *assignments = [[NSMutableDictionary alloc]init];
	[assignments setObject:@[@1,@2,@3,@4] forKey:@"Anurag"];
	[assignments setObject:@[@200, @201, @202, @203] forKey:@"Senthil"];
	[assignments setObject:@[@304,@305,@306] forKey:@"Rahit"];
	[assignments setObject:@[@409,@408,@410] forKey:@"Saleem"];
	[assignments setObject:@[@509,@508,@510] forKey:@"Jeevitha"];

	[_service AssignShift:assignments withCompletion:^(HpsServerAssignmentResponse *response, NSError *error)
	 {
		XCTAssertNotNil(response);
		XCTAssertEqualObjects(@"00", response.responseCode);
		[expectation fulfill];

	 }];
	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {
		if(error) XCTFail(@"Request Timed out");
	}];
}
@end
