#import "HpsPaxCheckResponse.h"

@implementation HpsPaxCheckResponse

- (id)initWithBinaryReader: (HpsBinaryDataScanner*)br {
    self = [super init];
    if (!self) return nil;
    
    NSString *values = [br readStringUntilDelimiter:HpsControlCodes_FS];
    NSArray *items = [values componentsSeparatedByString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
    
    int i = 0;
    for (NSString* value in items) {
        switch (i) {
            case 0:
                self.saleType = value;
                break;
            case 1:
                self.routingNumber = value;
                break;
            case 2:
                self.accountNumber = value;
                break;
            case 3:
                self.checkNumber = value;
                break;
            case 4:
                self.checkType = value;
                break;
            case 5:
                self.idType = value;
                break;
            case 6:
                self.idValue = value ;
                break;
            case 7:
                self.dob = value;
                break;
            case 8:
                self.phoneNumber = value;
                break;
            case 9:
                self.zipCode = value;
                break;
                
            default:
                break;
        }
        i++;
    }
    
    return self;
}
@end
