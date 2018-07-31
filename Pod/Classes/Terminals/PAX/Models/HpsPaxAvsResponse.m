#import "HpsPaxAvsResponse.h"

@implementation HpsPaxAvsResponse

- (id)initWithBinaryReader: (HpsBinaryDataScanner*)br {
    self = [super init];
    if (!self) return nil;
    
    NSString *values = [br readStringUntilDelimiter:HpsControlCodes_FS];
    NSArray *items = [values componentsSeparatedByString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
    
    int i = 0;
    for (NSString* value in items) {
        switch (i) {
            case 0:
                self.avsResponseCode = value;
                break;
            case 1:
                self.avsResponseMessage = value;
                break;
                
            default:
                break;
        }
        i++;
    }
    
    return self;
}

@end
