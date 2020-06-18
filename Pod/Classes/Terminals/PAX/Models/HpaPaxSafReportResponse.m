
#import "HpaPaxSafReportResponse.h"

@implementation HpaPaxSafReportResponse

- (id) initWithBuffer:(NSData*)buffer{
    if((self = [super initWithMessageID:R11_RSP_SAF_SUMMARY_REPORT andBuffer:buffer]))
    {
        
        [self parseResponse];
    }
    return self;
    
}

- (HpsBinaryDataScanner*) parseResponse{
    HpsBinaryDataScanner *reader = [super parseResponse];
    if ([self.deviceResponseCode isEqualToString:@"000000"]) {
        
        self.totalCount = [reader readStringUntilDelimiter:HpsControlCodes_FS];
        self.totalAmount = [reader readStringUntilDelimiter:HpsControlCodes_FS];
        
    }
    return reader;
    
}
@end
