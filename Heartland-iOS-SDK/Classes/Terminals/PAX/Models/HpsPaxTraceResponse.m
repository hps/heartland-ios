#import "HpsPaxTraceResponse.h"

@implementation HpsPaxTraceResponse

- (id)initWithBinaryReader: (HpsBinaryDataScanner*)br {
    self = [super init];
    if (!self) return nil;
    
    NSString *values = [br readStringUntilDelimiter:HpsControlCodes_FS];
    NSArray *items = [values componentsSeparatedByString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
    
    int i = 0;
    for (NSString* value in items) {
        switch (i) {
            case 0:
                self.transactionNunmber = value;
                break;
            case 1:
                self.referenceNumber = value;
                break;
            case 2:
                self.timeStamp = value;
                break;
            case 6:
                self.ecrRefNumber = value;
                break;
                
            default:
                break;
        }
        i++;
    }
    
    return self;
}

@end
