#import "HpaPaxSafUploadResponse.h"

@implementation HpaPaxSafUploadResponse

- (id) initWithBuffer:(NSData*)buffer{
    if((self = [super initWithMessageID:B09_RSP_SAF_UPLOAD andBuffer:buffer]))
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
        self.timeStamp = [reader readStringUntilDelimiter:HpsControlCodes_FS];
        self.safUploadedCount = [reader readStringUntilDelimiter:HpsControlCodes_FS];
        self.safUploadedAmount = [reader readStringUntilDelimiter:HpsControlCodes_FS];
        self.safFailedCount = [reader readStringUntilDelimiter:HpsControlCodes_FS];
        self.safFailedTotal = [reader readStringUntilDelimiter:HpsControlCodes_FS];
       }
    return reader;
    
}

@end
