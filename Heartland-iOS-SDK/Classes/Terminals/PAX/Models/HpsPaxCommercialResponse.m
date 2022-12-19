#import "HpsPaxCommercialResponse.h"

@implementation HpsPaxCommercialResponse

- (id)initWithBinaryReader: (HpsBinaryDataScanner*)br {
    self = [super init];
    if (!self) return nil;
    
    NSString *values = [br readStringUntilDelimiter:HpsControlCodes_FS];
    NSArray *items = [values componentsSeparatedByString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
    
    int i = 0;
    for (NSString* value in items) {
        switch (i) {
            case 0:
                self.poNumber = value;
                break;
            case 1:
                self.customerCode = value;
                break;
            case 2:
                self.taxExept = [value boolValue];
                break;
            case 3:
                self.taxExeptId = value;
                break;
            default:
                break;
        }
        i++;
    }
    
    return self;
}

@end
