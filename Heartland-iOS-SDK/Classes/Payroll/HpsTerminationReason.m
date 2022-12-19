#import "HpsTerminationReason.h"

@implementation HpsTerminationReason

-(id)init {
    
    if (self =[super init]) { }
    
    return [self init:@"TerminationReasonId" field:@"ReasonDescription"];
}

@end
