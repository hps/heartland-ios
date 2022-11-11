#import "HpsPaxAccountResponse.h"

@implementation HpsPaxAccountResponse

- (id)initWithBinaryReader: (HpsBinaryDataScanner*)br {
    self = [super init];
    if (!self) return nil;
    
    NSString *values = [br readStringUntilDelimiter:HpsControlCodes_FS];
    NSArray *items = [values componentsSeparatedByString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
    
    int i = 0;
    for (NSString* value in items) {
        switch (i) {
            case 0:
                self.accountNumber = value;
                break;
            case 1:
                self.entryMode = [value integerValue];
                break;
            case 2:
                self.expireDate = value;
                break;
            case 3:
                self.ebtType = value;
                break;
            case 4:
                self.voucherNumber = value;
                break;
            case 5:
                self.nAccountNumber = value;
                break;
            case 6:
                self.cardType = value;
                break;
            case 7:
                self.cardHolder = value;
                break;
            case 8:
                self.cvdApprovalCode = value;
                break;
            case 9:
                self.cvdMessage = value;
                break;
            case 10:
                self.cardPressent = [value boolValue];
                break;
            case 12:
                self.debitAccountType = value;
                break;
            default:
                break;
        }
        i++;
    }
    
    return self;
}

@end
