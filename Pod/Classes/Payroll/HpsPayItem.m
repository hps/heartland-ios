#import "HpsPayItem.h"

@implementation HpsPayItem

-(id)init {
    
    if (self =[super init]) { }
    
    return [self init:@"PayCode" field:@"PayItemTitle"];
}

@end
