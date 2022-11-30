#import "HpsPaxBatchCloseResponse.h"

@implementation HpsPaxBatchCloseResponse

- (id) initWithBuffer:(NSData*)buffer{
    if((self = [super initWithMessageID:B01_RSP_BATCH_CLOSE andBuffer:buffer]))
    {        
        [self parseResponse];
    }
    return self;
    
}

- (HpsBinaryDataScanner*) parseResponse{
    HpsBinaryDataScanner *reader = [super parseResponse];
    if ([self.deviceResponseCode isEqualToString:@"000000"]) {
        
        self.hostResponse = [[HpsPaxHostResponse alloc] initWithBinaryReader:reader];
        self.totalCount = [reader readStringUntilDelimiter:HpsControlCodes_FS];
        self.totalAmount = [reader readStringUntilDelimiter:HpsControlCodes_FS];
        self.timeStamp = [reader readStringUntilDelimiter:HpsControlCodes_FS];
        self.tid = [reader readStringUntilDelimiter:HpsControlCodes_FS];
        self.mid = [reader readStringUntilDelimiter:HpsControlCodes_ETX];
        
    }
    
    return reader;
    
}

@end
