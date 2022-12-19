#import "HpsPaxInitializeResponse.h"

@implementation HpsPaxInitializeResponse
- (id) initWithBuffer:(NSData*)buffer{
    if((self = [super initWithMessageID:A01_RSP_INITIALIZE andBuffer:buffer]))
    {
        
        [self parseResponse];
    }
    return self;
    
}

- (HpsBinaryDataScanner*) parseResponse{
    HpsBinaryDataScanner *reader = [super parseResponse];
    self.serialNumber = [reader readStringUntilDelimiter:HpsControlCodes_ETX];
    return reader;
    
}

@end
