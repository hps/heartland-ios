#import <XCTest/XCTest.h>
#import "HpsPayrollConfig.h"
#import "HpsPayrollService.h"
#import "HpsEmployeeFinder.h"
#import "HpsClientInfo.h"
#import "HpsEmployee.h"
#import "HpsPayItem.h"

@interface HpsPayRollTests : XCTestCase
@property HpsPayrollService *service;
@end

@implementation HpsPayRollTests

-(void)setUp {

	HpsPayrollConfig *config = [[HpsPayrollConfig alloc]initWithUserName:@"testapiuser.russell" withPassword:@"payroll3!" withApiKey:@"iGF9UtaLc526poWWNgUpiCoO3BckcZUKNF3nhyKul8A=" withServiceUrl:@"https://taapi.heartlandpayrollonlinetest.com" withTimeout:-1 ];
	_service = [[HpsPayrollService alloc] initWithConfig:config];

}

-(void)testGetClientInfoTest {

	XCTestExpectation *expectation = [self expectationWithDescription:@"get Client Info"];

	[_service getClientInfo:578901244 withCompletion:^(NSArray *clients, NSError *error) {
		XCTAssertNil(error);
		XCTAssertNotNil(clients);
		if ([clients count]) {
			HpsClientInfo *info = [clients objectAtIndex:0];
			XCTAssertNotNil(info);
			XCTAssertNotNil(info.clientCode);
			XCTAssertNotNil(info.clientName);
			[expectation fulfill];
		}

	}];
	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)testGetActiveEmployees {

	XCTestExpectation *expectation = [self expectationWithDescription:@"GetActiveEmployeesTest"];

	HpsEmployeeFinder *employeeFinder = [self.service getEmployees:@"0140SY42"];
	[[employeeFinder activeOnly:YES] find:^(NSMutableArray *arr) {

		XCTAssertNotNil(arr);
		if (arr.count > 0) {

			for (HpsEmployee *employee in arr) {
				XCTAssertNotNil(employee);
				XCTAssertTrue(employee.employmentStatus == Active);
			}

			[expectation fulfill];
		}

	}];

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)testGetInactiveEmployees {

	XCTestExpectation *expectation = [self expectationWithDescription:@"GetInactiveEmployeesTest"];

	HpsEmployeeFinder *employeeFinder = [self.service getEmployees:@"0140SY42"];
	[[employeeFinder activeOnly:NO] find:^(NSMutableArray *arr) {

		XCTAssertNotNil(arr);

		if (arr.count > 0) {

			for (HpsEmployee *employee in arr)  {
				XCTAssertNotNil(employee);
				XCTAssertTrue(employee.employmentStatus != Active);

			}
			[expectation fulfill];
		}
	}];

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)testGet20Employees {

	XCTestExpectation *expectation = [self expectationWithDescription:@"Get20EmployeesTest"];
HpsEmployeeFinder *employeeFinder = [self.service getEmployees:@"0140SY42"];
	[[[employeeFinder activeOnly:NO] withEmployeeCount:20] find:^(NSMutableArray *arr) {

		XCTAssertNotNil(arr);
		XCTAssertTrue(arr.count <= 20);
		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)testGetEmployeesInDateRange {

	XCTestExpectation *expectation = [self expectationWithDescription:@"get Client Info"];

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"MM/dd/yyyy";

	HpsEmployeeFinder *employeeFinder = [self.service getEmployees:@"0140SY42"];
	[employeeFinder withFromDate:[formatter dateFromString:@"01/01/2014"]];
	[employeeFinder withToDate:[formatter dateFromString:@"01/01/2015"]];
	[employeeFinder find:^(NSMutableArray *arr) {

		XCTAssertNotNil(arr);
		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)testGetHourlyEmployees {

	XCTestExpectation *expectation = [self expectationWithDescription:@"gGetHourlyEmployeesTest"];

	HpsEmployeeFinder *employeeFinder = [self.service getEmployees:@"0140SY42"];
	[[employeeFinder withPayType:Hourly] find:^(NSMutableArray *arr) {

		XCTAssertNotNil(arr);
		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)testGet1099Employees {

	XCTestExpectation *expectation = [self expectationWithDescription:@"Get1099EmployeesTest"];

	HpsEmployeeFinder *employeeFinder = [self.service getEmployees:@"0140SY42"];	[[employeeFinder withPayType:T1099] find:^(NSMutableArray *arr) {

		XCTAssertNotNil(arr);
		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)testGetSingleEmployee {

	XCTestExpectation *expectation = [self expectationWithDescription:@"GetSingleEmployeeTest"];

	HpsEmployeeFinder *employeeFinder = [self.service getEmployees:@"0140SY42"];
	[[employeeFinder withEmployeeId:284045] find:^(NSMutableArray *arr) {
		XCTAssertNotNil(arr);
		XCTAssertEqual(1, arr.count);
		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)testUpdateEmployee {

	XCTestExpectation *expectation = [self expectationWithDescription:@"UpdateEmployeeTest"];

	HpsEmployeeFinder *employeeFinder = [self.service getEmployees:@"0140SY42"];
	[[employeeFinder activeOnly:YES] find:^(NSMutableArray *arr) {

		XCTAssertNotNil(arr);

		NSInteger status = Married;

		HpsEmployee *employeeObject = [arr firstObject];

		if (employeeObject.maritalStatus == Married) {
			status = Single;
		}

		employeeObject.maritalStatus = status;

		[self.service updateEmployee:employeeObject handler:^(HpsEmployee *employee) {
			XCTAssertNotNil(employee);
			XCTAssertEqual(status, employee.maritalStatus);
			[expectation fulfill];
		}];

	}];

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)testGetTerminationReasons {

	XCTestExpectation *expectation = [self expectationWithDescription:@"GetTerminationReasonsTest"];

	[self.service getTerminationReasons:@"0140SY42" handler:^(NSMutableArray* arr){
		XCTAssertNotNil(arr);
		XCTAssertTrue(arr.count > 0);
		[expectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)testTerminateEmployee {

	XCTestExpectation *expectation = [self expectationWithDescription:@"TerminateEmployeeTest"];

	HpsEmployeeFinder *employeeFinder = [self.service getEmployees:@"0140SY42"];
	[[employeeFinder withEmployeeId:284045] find:^(NSMutableArray *arr) {

		HpsEmployee *employeeObject = [arr firstObject];
		XCTAssertNotNil(employeeObject);

		[self.service getTerminationReasons:@"0140SY42" handler:^(NSMutableArray* arr){

			XCTAssertNotNil(arr.firstObject);
			NSDate *dateNow = [NSDate date];
			HpsTerminationReason *reason = arr.firstObject;

			[self.service terminateEmployee:employeeObject date:dateNow reason:reason and:false handler:^(HpsEmployee *employee) {

				XCTAssertNotNil(employee);
				XCTAssertEqual(employee.employmentStatus, Terminated);
				NSString *dateTerminated = [self curentDateStringFromDate:dateNow withFormat:@"dd-MM-yyyy"];
				NSString *terminationDateRecieved = [self curentDateStringFromDate:employee.terminationDate withFormat:@"dd-MM-yyyy"];
				XCTAssertEqualObjects(dateTerminated, terminationDateRecieved);

				[expectation fulfill];
			}];
		}];
	}];

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)testGetWorkLocations {

	XCTestExpectation *expectation = [self expectationWithDescription:@"Get Wor Locations Test"];

	[self.service getWorkLocation:@"0140SY42" handler:^(NSMutableArray* arr){
		XCTAssertNotNil(arr);
		XCTAssertTrue(arr.count > 0);
		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)testGetLaborFields {

	XCTestExpectation *expectation = [self expectationWithDescription:@"GetLaborFieldsTest"];

	[self.service getLaborFields:@"0140SY42" handler:^(NSMutableArray* arr){
		XCTAssertNotNil(arr);
		XCTAssertTrue(arr.count == 0);
		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)testGetPayGroups {

	XCTestExpectation *expectation = [self expectationWithDescription:@"GetPayGroupsTest"];

	[self.service getPayGroups:@"0140SY42" handler:^(NSMutableArray* arr){
		XCTAssertNotNil(arr);
		XCTAssertTrue(arr.count > 0);
		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)testGetPayItems {

	XCTestExpectation *expectation = [self expectationWithDescription:@"GetPayItemsTest"];

	[self.service getPayItems:@"0140SY42" handler:^(NSMutableArray* arr){
		XCTAssertNotNil(arr);
		XCTAssertTrue(arr.count > 0);
		[expectation fulfill];
	}];

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

-(void)testPostPayData {

	XCTestExpectation *expectation = [self expectationWithDescription:@"get Client Info"];

	[self.service getPayItems:@"0140SY42" handler:^(NSMutableArray *arr) {

		HpsPayItem *payItem = [arr firstObject];
		HpsPayrollRecord *payrollRecord = [[HpsPayrollRecord alloc] init];
		payrollRecord.recordId = 1;
		payrollRecord.clientCode = @"0140SY42";
		payrollRecord.employeeId = 284045;
		payrollRecord.hours = [NSNumber numberWithDouble:80.0];
		payrollRecord.payItemTitle = payItem.descriptionString;

		NSMutableArray *arrRecord = [NSMutableArray new];
		[arrRecord addObject:payrollRecord];

		[self.service postPayrollDatas:arrRecord handler:^(BOOL isResponse) {

			XCTAssertTrue(isResponse);
			[expectation fulfill];
		}];
	}];

	[self waitForExpectationsWithTimeout:160.0 handler:^(NSError *error) {

		if(error) XCTFail(@"Request Timed out");
	}];
}

- (NSString *)curentDateStringFromDate:(NSDate *)dateTimeInLine withFormat:(NSString *)dateFormat {

	NSDateFormatter *formatter = [[NSDateFormatter alloc]init];

	[formatter setDateFormat:dateFormat];

	NSString *convertedString = [formatter stringFromDate:dateTimeInLine];

	return convertedString;
}

@end
