
#import "SummaryResponse.h"

@implementation SummaryResponse


-(id)init{
    if (self =  [super init])
    {
        self.Records = [NSMutableArray new];
    }
    return self;
}
@end
