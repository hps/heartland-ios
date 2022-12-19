#import "HpsPayrollService.h"

@interface HpsPayrollService()
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) NSString* apiKey;
@property (nonatomic, strong) NSString* sessionToken;
@property (nonatomic, strong) NSString* errorMessage;
@end

@implementation HpsPayrollService

-(id)initWithConfig:(HpsPayrollConfig *)payrollConfig {

	self = [super init];

	if (self) {

		self.username = payrollConfig.userName;
		self.password =  payrollConfig.password;
		self.apiKey = payrollConfig.apiKey;
		self.serviceUrl = payrollConfig.serviceUrl;
		self.timeOut = payrollConfig.timeOut;

		self.encoder = [[HpsPayrollEncoder alloc] init];
		self.encoder.username = self.username;
		self.encoder.apiKey = self.apiKey;

		[self signIn];
	}

	return self;
}

#pragma mark - Sign In
-(void)signIn {

	HpsJsonDoc* doc = [[HpsJsonDoc alloc] init];
	[doc.dict setObject:self.username forKey:@"Username"];
	[doc.dict setObject:[self.encoder encode:self.password] forKey:@"Password"];

	HpsPayRollRequest* payrollRequest = [[HpsPayRollRequest alloc] initWithEndPoint:@"/api/pos/session/signin" withRequestBody:doc.toString];

	[self sendEncryptedRequest:payrollRequest handler:^(NSString *response, NSError *error, HpsPayrollEncoder *encoder) {

		HpsBasePayrollResponse *baseResponse = [[HpsBasePayrollResponse alloc] initWithRawResponse:response];

		HpsJsonDoc* doc = baseResponse.rawResults.firstObject;

		self.sessionToken = [doc getValue:@"SessionToken"];
		self.errorMessage = [doc getValue:@"ErrorMessage"];

		if (self.errorMessage != nil && ![self.errorMessage isKindOfClass:[NSNull class]]) {
			@throw [NSException exceptionWithName:@"" reason:@"HpsPayrollException" userInfo:@{@"errorMessage":self.errorMessage}];
		}

			// Build the basic request header
		NSString* strCredentials = [NSString stringWithFormat:@"%@|%@",self.sessionToken,self.username];
		NSString* strBase64 = [[strCredentials dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
		if (self.headers) {
			[self.headers setObject:[NSString stringWithFormat:@"Basic %@",strBase64] forKey:@"Authorization"];
		}
	}];
}

-(void)signOut {

	HpsPayRollRequest* request = [[HpsPayRollRequest alloc] init];
	request.endPoint = @"/api/pos/session/signout";

	[self sendEncryptedRequest:request handler:^(NSString *response, NSError *error, HpsPayrollEncoder *encoder) {

	}];
}

#pragma mark - Get Client Info
-(void)getClientInfo:(NSInteger)federalEin withCompletion:(void(^)(NSArray *response, NSError* error))responseBlock
{
	HpsClientInfo *request = [[HpsClientInfo alloc] init];
	request.federalEin = federalEin;

	[self sendEncryptedRequest:[request getClientInfoRequest:self.encoder] handler:^(NSString *response, NSError *error, HpsPayrollEncoder *encoder) {

		NSMutableArray *arrResults = [NSMutableArray new];
		HpsBasePayrollResponse *baseResponse = [[HpsBasePayrollResponse alloc] initWithRawResponse:response];
		for (HpsJsonDoc* result in baseResponse.rawResults) {
			HpsClientInfo* info = [[HpsClientInfo alloc] init];
			[info fromJSON:result withArgument:encoder];
			[arrResults addObject:info];
		}
		responseBlock(arrResults,error);
	}];

}

#pragma mark - GetEmployees
-(HpsEmployeeFinder*)getEmployees:(NSString*)clientCode {

	HpsEmployeeFinder *finder = [[[HpsEmployeeFinder alloc] initWith:self] withClientCode:clientCode];
	return finder;
}

#pragma mark - Add Employee
-(void)addEmployee:(HpsEmployee*)employee handler:(void(^)(HpsEmployee* employee))completionBlock {

	[self sendEncryptedRequest:[employee addEmployeeRequest:self.encoder]  handler:^(NSString *response, NSError *error, HpsPayrollEncoder *encoder) {
		HpsEmployee *employee = [[HpsEmployee alloc] init];
		HpsBasePayrollResponse *baseResponse = [[HpsBasePayrollResponse alloc] initWithRawResponse:response];
		[employee fromJSON:baseResponse.rawResults[0]  withArgument:encoder];
		completionBlock(employee);
	}];
}

#pragma mark - Update Empoylee
-(void)updateEmployee:(HpsEmployee*)employee handler:(void(^)(HpsEmployee* employee))completionBlock {

	[self sendEncryptedRequest:[employee updateEmployeeRequest:self.encoder]  handler:^(NSString *response, NSError *error, HpsPayrollEncoder *encoder) {
		HpsEmployee *employee = [[HpsEmployee alloc] init];
		HpsBasePayrollResponse *baseResponse = [[HpsBasePayrollResponse alloc] initWithRawResponse:response];
		[employee fromJSON:baseResponse.rawResults[0]  withArgument:encoder];
		completionBlock(employee);
	}];
}

#pragma mark - Terminate Employee
-(void)terminateEmployee:(HpsEmployee*)employee date:(NSDate*)terminationDate reason:(HpsTerminationReason*)terminationReason and:(BOOL)deactivateAccounts handler:(void(^)(HpsEmployee* employee))completionBlock {

	employee.terminationDate = terminationDate;
	employee.terminationReasonId = terminationReason.idValue;
	employee.deactivateAccounts = deactivateAccounts;

	[self sendEncryptedRequest:[employee terminateEmployeeRequest:self.encoder] handler:^(NSString *response, NSError *error, HpsPayrollEncoder *encoder) {
		HpsEmployeeFinder *employeeFinder = [[self getEmployees:employee.clientCode] withEmployeeId:employee.employeeId];
		[employeeFinder find:^(NSMutableArray *arr) {
			if (arr.count > 0)
				completionBlock(arr.firstObject);
			else
				completionBlock(nil);
		}];
	}];
}

#pragma mark - GetTerminationReasons
-(void)getTerminationReasons:(NSString *)clientCode handler:(void(^)(NSMutableArray* arr))completionBlock {

	HpsClientInfo *clientInfo = [[HpsClientInfo alloc] init];
	[clientInfo setClientCode:clientCode];

	[self getPayrollCollectionItem:clientInfo request:TerminationReason handler:^(NSMutableArray *arr) {
		completionBlock(arr);
	}];
}

#pragma mark - GetWorkLocations
-(void)getWorkLocation:(NSString *)clientCode handler:(void(^)(NSMutableArray* arr))completionBlock {

	HpsClientInfo *clientInfo = [[HpsClientInfo alloc] init];
	[clientInfo setClientCode:clientCode];

	[self getPayrollCollectionItem:clientInfo request:WorkLocation handler:^(NSMutableArray *arr) {
		completionBlock(arr);
	}];
}

#pragma mark - GetLaborFields
-(void)getLaborFields:(NSString *)clientCode handler:(void(^)(NSMutableArray* arr))completionBlock {

	HpsClientInfo *clientInfo = [[HpsClientInfo alloc] init];
	[clientInfo setClientCode:clientCode];

	[self getPayrollCollectionItem:clientInfo request:LaborField handler:^(NSMutableArray *arr) {
		completionBlock(arr);
	}];
}

#pragma mark - GetPayGroups
-(void)getPayGroups:(NSString *)clientCode handler:(void(^)(NSMutableArray* arr))completionBlock {

	HpsClientInfo *clientInfo = [[HpsClientInfo alloc] init];
	[clientInfo setClientCode:clientCode];

	[self getPayrollCollectionItem:clientInfo request:PayGroup handler:^(NSMutableArray *arr) {
		completionBlock(arr);
	}];
}

#pragma mark - GetPayItems
-(void)getPayItems:(NSString *)clientCode handler:(void(^)(NSMutableArray* arr))completionBlock {

	HpsClientInfo *clientInfo = [[HpsClientInfo alloc] init];
	[clientInfo setClientCode:clientCode];

	[self getPayrollCollectionItem:clientInfo request:PayItem handler:^(NSMutableArray *arr) {
		completionBlock(arr);
	}];
}

#pragma mark - PostPayData
-(void)postPayrollDatas:(NSMutableArray*)payrollRecords handler:(void(^)(BOOL isResponse))completionBlock {

	[self sendEncryptedRequest:[self postPayrollRequest:payrollRecords] handler:^(NSString *response, NSError *error, HpsPayrollEncoder *encoder) {

		completionBlock(response ? YES : NO);
	}];
}

-(void)getPayrollCollectionItem:(HpsClientInfo*)clientInfo request:(PayRollRequestType)type handler:(void(^)(NSMutableArray* arr))completionBlock {

	[self sendEncryptedRequest:[clientInfo getCollectionRequestByType:self.encoder withType:type] handler:^(NSString *response, NSError *error, HpsPayrollEncoder *encoder) {

		NSMutableArray *arrResults = [NSMutableArray new];

		HpsBasePayrollResponse *baseResponse = [[HpsBasePayrollResponse alloc] initWithRawResponse:response];

		if (type == TerminationReason) {
			for (HpsJsonDoc *doc in baseResponse.rawResults) {

				HpsTerminationReason *reason = [[HpsTerminationReason alloc] init];
				[reason fromJSON:doc withArgument:encoder];
				[arrResults addObject:reason];
			}
		}

		if (type == WorkLocation) {
			for (HpsJsonDoc *doc in baseResponse.rawResults) {

				HpsWorkLocation *work = [[HpsWorkLocation alloc] init];
				[work fromJSON:doc withArgument:encoder];
				[arrResults addObject:work];
			}
		}

		if (type == LaborField) {
			for (HpsJsonDoc *doc in baseResponse.rawResults) {

				HpsLaborField *laborField = [[HpsLaborField alloc] init];
				[laborField fromJSON:doc withArgument:encoder];
				[arrResults addObject:laborField];
			}
		}

		if (type == PayGroup) {
			for (HpsJsonDoc *doc in baseResponse.rawResults) {

				HpsPayGroup *payGroup = [[HpsPayGroup alloc] init];
				[payGroup fromJSON:doc withArgument:encoder];
				[arrResults addObject:payGroup];
			}
		}

		if (type == PayItem) {
			for (HpsJsonDoc *doc in baseResponse.rawResults) {

				HpsPayItem *payItem = [[HpsPayItem alloc] init];
				[payItem fromJSON:doc withArgument:encoder];
				[arrResults addObject:payItem];
			}
		}

		completionBlock(arrResults);
	}];

}

#pragma mark - Form Post Payroll Request
-(HpsPayRollRequest*)postPayrollRequest:(NSMutableArray*)records {

	NSString *requestBody = @"";
	NSMutableArray *arrRecord = [NSMutableArray new];
	for (HpsPayrollRecord* payrollRecord in records) {
		[arrRecord addObject:[payrollRecord toJson:self.encoder]];
	}
	requestBody = [NSString stringWithFormat:@"[%@]",[arrRecord componentsJoinedByString:@","]];

	HpsPayRollRequest *payrollRequest = [[HpsPayRollRequest alloc] initWithEndPoint:@"/api/pos/timeclock/PostPayData" withRequestBody:requestBody];

	return payrollRequest;
}

#pragma mark - Send Request
-(void)sendEncryptedRequest:(HpsPayRollRequest*)payrollRequest handler:(void(^)(NSString *response, NSError *error, HpsPayrollEncoder *encoder))responseBlock {


	[self doTransaction:@"POST" endPoint:payrollRequest.endPoint data:payrollRequest.requestBody andQueryParams:@{} handler:^(NSString *response, NSError *error) {

		responseBlock(response, error, self.encoder);
	}];

}

@end
