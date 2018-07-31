#import "HpsPaxEcomSubGroup.h"

@implementation HpsPaxEcomSubGroup

- (id)initWithBinaryReader: (HpsBinaryDataScanner*)br {
    self = [super init];
    if (!self) return nil;
    
    NSString *values = [br readStringUntilDelimiter:HpsControlCodes_FS];
    NSArray *items = [values componentsSeparatedByString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
    
    int i = 0;
    for (NSString* value in items) {
        switch (i) {
            case 0:
                self.ecomMode = value;
                break;
            case 1:
                self.transactionType = value;
                break;
            case 2:
                self.secureType = value;
                break;
            case 3:
                self.orderNumber = value;
                break;
            case 4:
                self.installments = [NSNumber numberWithInteger:[value integerValue]];
                break;
            case 5:
                self.currentInstallment = [NSNumber numberWithInteger:[value integerValue]];
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
    
    if (self.ecomMode != nil && self.ecomMode.length > 0) [sb appendString:self.ecomMode];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
   
    if (self.transactionType != nil && self.transactionType.length > 0) [sb appendString:self.transactionType];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
   
    if (self.secureType != nil && self.secureType.length > 0) [sb appendString:self.secureType];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
   
    if (self.orderNumber != nil && self.orderNumber.length > 0) [sb appendString:self.orderNumber];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
   
    if (self.installments != nil) [sb appendString:[self.installments stringValue]];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
    
    if (self.currentInstallment != nil) [sb appendString:[self.currentInstallment stringValue]];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
    
    return sb;
    
}

@end
