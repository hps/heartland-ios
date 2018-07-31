#import "HpsPaxCashierSubGroup.h"

@implementation HpsPaxCashierSubGroup

- (id)initWithBinaryReader: (HpsBinaryDataScanner*)br {
    self = [super init];
    if (!self) return nil;
    
    NSString *values = [br readStringUntilDelimiter:HpsControlCodes_FS];
    NSArray *items = [values componentsSeparatedByString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
    
    int i = 0;
    for (NSString* value in items) {
        switch (i) {
            case 0:
                self.clerkId = value;
                break;
            case 1:
                self.shiftId = value;
                break;
                
            default:
                break;
        }
        i++;
    }
    
    return self;
}

- (NSString*) getElementString
{
    NSMutableString *sb = [[NSMutableString alloc] init];
    
    if (self.clerkId != nil && self.clerkId.length > 0) [sb appendString:self.clerkId];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
   
    if (self.shiftId != nil && self.shiftId.length > 0) [sb appendString:self.shiftId];
    
    return sb;
}

@end
