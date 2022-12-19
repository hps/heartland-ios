#import "HpsPayrollRecord.h"

@implementation HpsPayrollRecord

-(id)init {

	self = [super init];

    if (self) {
        
    }
    
    return self;
}

-(NSString *)toJson:(HpsPayrollEncoder*)encoder {
    
    HpsJsonDoc *doc = [[HpsJsonDoc alloc] init];
    
    [doc set:@"RecordId" withValue:[NSString stringWithFormat:@"%ld",(long)self.recordId] and:false];
    [doc set:@"ClientCode" withValue:[encoder encode:self.clientCode] and:false];
    [doc set:@"EmployeeId" withValue:[NSString stringWithFormat:@"%ld",(long)self.employeeId] and:false];
	
	if (self.payItemLaborFields != nil)
		[doc set:@"PayItemLaborFields" withValue:self.payItemLaborFields and:false];

	if (self.payItemTitle != nil)
		[doc set:@"PayItemTitle" withValue:self.payItemTitle and:false];

	if (self.hours != nil)
		[doc set:@"Hours" withValue:[NSString stringWithFormat:@"%0.2f",[self.hours doubleValue]] and:false];
	if (self.dollars != nil)
		[doc set:@"Dollars" withValue:[NSString stringWithFormat:@"%0.2f",[self.dollars doubleValue]] and:false];
	if (self.payrate != nil)
		[doc set:@"PayRate" withValue:[NSString stringWithFormat:@"%0.2f",[self.payrate doubleValue]] and:false];
    
    return [doc toString];
    
}

@end
