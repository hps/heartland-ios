#import "HpaPaxSafDeleteResponse.h"

@implementation HpaPaxSafDeleteResponse

- (id) initWithBuffer:(NSData*)buffer{
    if((self = [super initWithMessageID:B11_RSP_DELETE_SAF_FILE andBuffer:buffer]))
    {
        
        [self parseResponse];
    }
    return self;
    
}

- (HpsBinaryDataScanner*) parseResponse{
    HpsBinaryDataScanner *reader = [super parseResponse];
    if ([self.deviceResponseCode isEqualToString:@"000000"]) {
        
        self.safDeletedCount = [reader readStringUntilDelimiter:HpsControlCodes_FS];
        
    }
    return reader;
    
}
@end
