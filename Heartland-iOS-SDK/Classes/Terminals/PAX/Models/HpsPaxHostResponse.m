#import "HpsPaxHostResponse.h"

@implementation HpsPaxHostResponse

- (id)initWithBinaryReader: (HpsBinaryDataScanner*)br {
    self = [super init];
    if (!self) return nil;
    
    NSString *values = [br readStringUntilDelimiter:HpsControlCodes_FS];
    NSArray *items = [values componentsSeparatedByString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
    
    int i = 0;
    for (NSString* value in items) {
        switch (i) {
            case 0:
                self.hostResponseCode = value;
                break;
            case 1:
                self.hostResponseMessage = value;
                break;
            case 2:
                self.authCode = value;
                break;
            case 3:
                self.hostReferenceNumber = value;
                break;
            case 4:
                self.traceNumber = value;
                break;
            case 5:
                self.batchNumber = value;
                break;
                
            default:
                break;
        }
        i++;
    }
    
    return self;
}

@end
