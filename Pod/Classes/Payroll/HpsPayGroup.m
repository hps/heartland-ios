#import "HpsPayGroup.h"

@implementation HpsPayGroup

-(id)init {
    
    if (self =[super init]) { }
    
    return [self init:@"PayGroupId" field:@"PayGroupName"];
}

-(void)fromJSON:(HpsJsonDoc *)doc withArgument:(HpsPayrollEncoder *)encoder {

	[super fromJSON:doc withArgument:encoder];
	self.frequency = 0;
}

@end
