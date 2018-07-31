#import "HpsEmployeeFinder.h"
#import "HpsPayrollService.h"

@interface HpsEmployeeFinder()

@property (nonatomic, strong) NSString* clientCode;
@property (assign) NSInteger employeeId;
@property (assign) BOOL active;
@property (assign) NSInteger employeeOffset;
@property (assign) NSInteger employeeCount;
@property (nonatomic, strong) NSDate* fromDate;
@property (nonatomic, strong) NSDate* toDate;
@property FilterPayTypeCode payTypeCode;

@property (nonatomic, strong) HpsPayrollService* service;

@end

@implementation HpsEmployeeFinder

-(id)initWith:(HpsPayrollService *)service {
    
    if (self =[super init]) {
        
        self.service = service;
		self.payTypeCode = NONE;
    }
    
    return self;
}

-(HpsEmployeeFinder*)withClientCode:(NSString*)value {
    self.clientCode = value;
    return self;
}

-(HpsEmployeeFinder*)withEmployeeId:(NSInteger)value {
    self.employeeId = value;
    return self;
}

-(HpsEmployeeFinder*)activeOnly:(BOOL)value {
    self.active = value;
    return self;
}

-(HpsEmployeeFinder*)withEmployeeOffset:(NSInteger)value {
    self.employeeOffset = value;
    return self;
}

-(HpsEmployeeFinder*)withEmployeeCount:(NSInteger)value {
    self.employeeCount = value;
    return self;
}

-(HpsEmployeeFinder*)withFromDate:(NSDate*)value {
    self.fromDate = value;
    return self;
}

-(HpsEmployeeFinder*)withToDate:(NSDate*)value {
    self.toDate = value;
    return self;
}

-(HpsEmployeeFinder*)withPayType:(FilterPayTypeCode)value {
    self.payTypeCode = value;
    return self;
}

-(void)find:(void(^)(NSMutableArray* arr))completionBlock {
    
    [self.service sendEncryptedRequest:[self getEmployeeRequest:self.service.encoder] handler:^(NSString *response, NSError *error, HpsPayrollEncoder *encoder) {

		NSMutableArray *arrResults = [NSMutableArray new];
		HpsBasePayrollResponse *baseResponse = [[HpsBasePayrollResponse alloc] initWithRawResponse:response];

		for (HpsJsonDoc* result in baseResponse.rawResults) {
			HpsEmployee* employee = [[HpsEmployee alloc] init];
			[employee fromJSON:result withArgument:encoder];
			[arrResults addObject:employee];
		}

		completionBlock(arrResults);
    }];
}

-(HpsPayRollRequest*)getEmployeeRequest:(HpsPayrollEncoder*)encoder {

	HpsJsonDoc *doc = [[HpsJsonDoc alloc] init];
	[doc set:@"ClientCode" withValue:[encoder encode:self.clientCode] and:false];
	if (self.employeeId != 0)
		[doc set:@"EmployeeId" withValue:[NSString stringWithFormat:@"%ld",(long)self.employeeId] and:false];
	NSString *isActive = self.active ? @"true" : @"false";
	[doc set:@"ActiveEmployeeOnly" withValue:isActive and:false];
	if (self.employeeOffset != 0)
		[doc set:@"EmployeeOffset" withValue:[NSString stringWithFormat:@"%ld",(long)self.employeeOffset] and:false];
	if (self.employeeCount != 0)
		[doc set:@"EmployeeCount" withValue:[NSString stringWithFormat:@"%ld",(long)self.employeeCount] and:false];
	if (self.payTypeCode != NONE)
		[doc set:@"PayTypeCode" withValue:FilterPayTypeCode_toString[self.payTypeCode] and:false];

	NSDateFormatter *formatter = [NSDateFormatter new];
	[formatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];

	if (self.fromDate != nil)
		[doc set:@"FromDate" withValue:[formatter stringFromDate:self.fromDate] and:false];

	if (self.toDate != nil)
		[doc set:@"ToDate" withValue:[formatter stringFromDate:self.toDate] and:false];

	NSString *request = [doc toString];

	HpsPayRollRequest *payrollRequest = [[HpsPayRollRequest alloc] init];

	if (self.employeeId != 0) {
		payrollRequest.endPoint = @"/api/pos/employee/GetEmployee";
	}else {
		payrollRequest.endPoint = @"/api/pos/employee/GetEmployees";
	}

	payrollRequest.requestBody = request;

	return payrollRequest;
}

@end
