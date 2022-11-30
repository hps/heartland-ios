#import "HpsEmployee.h"

@implementation HpsEmployee

-(id)init {

	if(self =[super init]) {

	}
	return self;
}

-(void)fromJSON:(HpsJsonDoc *)doc withArgument:(HpsPayrollEncoder *)encoder {

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
	formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
	formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];

	self.clientCode = [encoder decode:[doc getValue:@"ClientCode"]];
	self.employeeId = [[doc getValue:@"EmployeeId"] integerValue];
	self.employmentStatus = [self getEmploymentStatusValue:[doc getValue:@"EmploymentStatus"]];
	self.hireDate = [formatter dateFromString:[doc getValue:@"HireDate"]];
	self.terminationDate = [doc getValue:@"TerminationDate"]?[formatter dateFromString:[doc getValue:@"TerminationDate"]]:nil;
	self.terminationReasonId = [doc getValue:@"TerminationReasonId"];
	self.employeeNumber = [doc getValue:@"EmployeeNumber"];
	self.employmentCategory = [self getEmploymentCategoryValue:[doc getValue:@"EmploymentCategory"]];
	self.timeClockId = [[doc getValue:@"TimeClockId"] integerValue];
	self.firstName = [doc getValue:@"FirstName"];
	self.lastName = [encoder decode:[doc getValue:@"LastName"]];
	self.middleName = [doc getValue:@"MiddleName"];
	self.ssn = [encoder decode:[doc getValue:@"SSN"]];
	self.address1 = [encoder decode:[doc getValue:@"Address1"]];
	self.address2 = [doc getValue:@"Address2"];
	self.city = [doc getValue:@"City"];
	self.stateCode = [doc getValue:@"StateCode"];
	self.zipCode = [encoder decode:[doc getValue:@"ZipCode"]];
	self.maritalStatus = [self getMaritalStatusValue:[doc getValue:@"MaritalStatus"]];
	self.birthDay = [doc getValue:@"BirthDay"]?[formatter dateFromString:[doc getValue:@"BirthDay"]]:nil;
	self.gender = [self getGenderValue:[doc getValue:@"Gender"]];
	self.payGroupId = [[doc getValue:@"PayGroupId"] integerValue];
	self.payTypeCode = [self getPayTypeCodeValue:[doc getValue:@"PayTypeCode"]];
	self.hourlyRate = [[encoder decode:[doc getValue:@"HourlyRate"]] floatValue];
	self.perPaySalary = [[encoder decode:[doc getValue:@"PerPaySalary"]] floatValue];
	self.workLocationId = [[doc getValue:@"WorkLocationId"] integerValue];

}

-(HpsPayRollRequest*)addEmployeeRequest:(HpsPayrollEncoder*)encoder {

	HpsJsonDoc *doc = [[HpsJsonDoc alloc] init];
	[doc set:@"ClientCode" withValue:[encoder encode:self.clientCode] and:false];
	[doc set:@"EmployeeId" withValue:[NSString stringWithFormat:@"%ld",(long)self.employeeId] and:false];
	[doc set:@"EmploymentStatus" withValue:EmploymentStatus_toString[self.employmentStatus] and:false];

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
	[doc set:@"HireDate" withValue:[formatter stringFromDate:self.hireDate] and:false];

	[doc set:@"EmploymentCategory" withValue:EmploymentCategory_toString[ self.employmentCategory] and:false];
	[doc set:@"TimeClockId" withValue:[NSString stringWithFormat:@"%ld",(long)self.timeClockId] and:false];
	[doc set:@"FirstName" withValue:self.firstName and:false];
	[doc set:@"LastName" withValue:[encoder encode:self.lastName] and:false];
	[doc set:@"MiddleName" withValue:self.middleName ? self.middleName : @"" and:false];
	[doc set:@"SSN" withValue:self.ssn ? self.ssn : @"" and:false];
	[doc set:@"Address1" withValue:[encoder encode:self.address1] and:false];
	[doc set:@"Address2" withValue:self.address2 and:false];
	[doc set:@"City" withValue:self.city and:false];
	[doc set:@"StateCode" withValue:self.stateCode and:false];
	[doc set:@"ZipCode" withValue:[encoder encode:self.zipCode] and:false];
	[doc set:@"MaritalStatus" withValue:MaritalStatus_toString[self.maritalStatus] and:false];

	NSString *bDay = [encoder encode:self.birthDay];
	[doc set:@"BirthDate" withValue:bDay ? bDay : @"" and:false];

	[doc set:@"Gender" withValue:Gender_toString[self.gender] and:false];
	[doc set:@"PayGroupId" withValue:[NSString stringWithFormat:@"%ld",(long)self.payGroupId] and:false];
	[doc set:@"PayTypeCode" withValue:PayTypeCode_toString[self.payTypeCode] and:false];
	[doc set:@"HourlyRate" withValue:[encoder encode:[NSString stringWithFormat:@"%0.2f",self.hourlyRate]] and:false];
	[doc set:@"PerPaySalary" withValue:[encoder encode:[NSString stringWithFormat:@"%0.2f",self.perPaySalary]] and:false];
	[doc set:@"WorkLocationId" withValue:[NSString stringWithFormat:@"%ld",(long)self.workLocationId] and:false];

	NSString *request = [doc toString];

	HpsPayRollRequest *payrollrequest = [[HpsPayRollRequest alloc] initWithEndPoint:@"/api/pos/employee/AddEmployee" withRequestBody:request];

	return payrollrequest;
}

-(HpsPayRollRequest*)updateEmployeeRequest:(HpsPayrollEncoder*)encoder {

	HpsJsonDoc *doc = [[HpsJsonDoc alloc] init];
	[doc set:@"ClientCode" withValue:[encoder encode:self.clientCode] and:false];
	[doc set:@"EmployeeId" withValue:[NSString stringWithFormat:@"%ld",(long)self.employeeId] and:false];
	[doc set:@"EmploymentStatus" withValue:EmploymentStatus_toString[self.employmentStatus] and:false];

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
	[doc set:@"HireDate" withValue:[formatter stringFromDate:self.hireDate] and:false];

	[doc set:@"EmployeeNumber" withValue:self.employeeNumber and:false];
	[doc set:@"EmploymentCategory" withValue:EmploymentCategory_toString[ self.employmentCategory] and:false];
	[doc set:@"TimeClockId" withValue:[NSString stringWithFormat:@"%ld",(long)self.timeClockId] and:false];
	[doc set:@"FirstName" withValue:self.firstName and:false];

	[doc set:@"LastName" withValue:[encoder encode:self.lastName] and:false];
	[doc set:@"MiddleName" withValue:self.middleName ? self.middleName : @"" and:false];
	[doc set:@"SSN" withValue:self.ssn ? self.ssn : @"" and:false];
	[doc set:@"Address1" withValue:[encoder encode:self.address1] and:false];
	[doc set:@"Address2" withValue:self.address2 and:false];
	[doc set:@"City" withValue:self.city and:false];
	[doc set:@"StateCode" withValue:self.stateCode and:false];
	[doc set:@"ZipCode" withValue:[encoder encode:self.zipCode] and:false];
	[doc set:@"MaritalStatus" withValue:MaritalStatus_toString[self.maritalStatus] and:false];

	NSString *bDay = [encoder encode:self.birthDay];
	[doc set:@"BirthDate" withValue:bDay ? bDay : @"" and:false];

	[doc set:@"Gender" withValue:Gender_toString[self.gender] and:false];
	[doc set:@"PayGroupId" withValue:[NSString stringWithFormat:@"%ld",(long)self.payGroupId] and:false];
	[doc set:@"PayTypeCode" withValue:PayTypeCode_toString[self.payTypeCode] and:false];
	[doc set:@"HourlyRate" withValue:[encoder encode:[NSString stringWithFormat:@"%0.2f",self.hourlyRate]] and:false];
	[doc set:@"PerPaySalary" withValue:[encoder encode:[NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:self.perPaySalary]]] and:false];
	[doc set:@"WorkLocationId" withValue:[NSString stringWithFormat:@"%ld",(long)self.workLocationId] and:false];

	NSString *request = [doc toString];

	HpsPayRollRequest *payrollrequest = [[HpsPayRollRequest alloc] initWithEndPoint:@"/api/pos/employee/UpdateEmployee" withRequestBody:request];

	return payrollrequest;
}

-(HpsPayRollRequest*)terminateEmployeeRequest:(HpsPayrollEncoder*)encoder {

	HpsJsonDoc *doc = [[HpsJsonDoc alloc] init];
	[doc set:@"ClientCode" withValue:[encoder encode:self.clientCode] and:false];
	[doc set:@"EmployeeId" withValue:[NSString stringWithFormat:@"%ld",(long)self.employeeId] and:false];

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"MM/dd/yyyy";
	NSString *tDate = [formatter stringFromDate:self.terminationDate];

	[doc set:@"TerminationDate" withValue:tDate ? tDate : @"" and:false];

	[doc set:@"TerminationReasonId" withValue:self.terminationReasonId and:false];
	[doc set:@"InactivateDirectDepositAccounts" withValue:self.deactivateAccounts ? @"true" : @"false" and:false];

	NSString *request = [doc toString];

	HpsPayRollRequest *payrollrequest = [[HpsPayRollRequest alloc] initWithEndPoint:@"/api/pos/employee/TerminateEmployee" withRequestBody:request];

	return payrollrequest;
}

-(NSInteger)getEmploymentStatusValue:(NSString *)value {

	if ([value isEqualToString:@"A"]) {
		return 0;
	}else if ([value isEqualToString:@"I"]) {
		return 1;
	}else if ([value isEqualToString:@"T"]) {
		return 2;
	}

	return 0;
}

-(NSInteger)getEmploymentCategoryValue:(NSString *)value {

	if ([value isEqualToString:@"FT"]) {
		return 0;
	}else if ([value isEqualToString:@"PT"]) {
		return 1;
	}

	return 0;
}

-(NSInteger)getGenderValue:(NSString *)value {

	if ([value isEqualToString:@"F"]) {
		return 0;
	}else if ([value isEqualToString:@"M"]) {
		return 1;
	}

	return 0;
}

-(NSInteger)getMaritalStatusValue:(NSString *)value {

	if ([value isEqualToString:@"M"]) {
		return 0;
	}else if ([value isEqualToString:@"S"]) {
		return 1;
	}

	return 0;
}

-(NSInteger)getPayTypeCodeValue:(NSString *)value {

	if ([value isEqualToString:@"H"]) {
		return 0;
	}else if ([value isEqualToString:@"S"]) {
		return 1;
	}else if ([value isEqualToString:@"T99"]) {
		return 2;
	}else if ([value isEqualToString:@"T99H"]) {
		return 3;
	}else if ([value isEqualToString:@"C"]) {
		return 4;
	}else if ([value isEqualToString:@"Ah"]) {
		return 5;
	}else if ([value isEqualToString:@"Ms"]) {
		return 6;
	}

	return 0;
}

@end
