#import "HpsPaxAmountResponse.h"

@implementation HpsPaxAmountResponse

- (id)initWithBinaryReader: (HpsBinaryDataScanner*)br {
    self = [super init];
    if (!self) return nil;
    
    NSString *values = [br readStringUntilDelimiter:HpsControlCodes_FS];
    NSArray *items = [values componentsSeparatedByString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
    
    int i = 0;
    for (NSNumber* value in items) {
        switch (i) {
            case 0:
                self.approvedAmount = [value doubleValue]/100;
                break;
            case 1:
                self.amountDue = [value doubleValue]/100;
                break;
            case 2:
                self.tipAmount = [value doubleValue]/100;
                break;
            case 3:
                self.cashBackAmount = [value doubleValue]/100;
                break;
            case 4:
                self.merchantFee = [value doubleValue]/100;
                self.surchargeFee = [value doubleValue]/100;
                break;
            case 5:
                self.taxAmount = [value doubleValue]/100;
                break;
            case 6:
                self.balance1 = [value doubleValue]/100;
                break;
            case 7:
                self.balance2 = [value doubleValue]/100;
                break;
                
            default:
                break;
        }
        i++;
    }
    
    return self;
}

@end
