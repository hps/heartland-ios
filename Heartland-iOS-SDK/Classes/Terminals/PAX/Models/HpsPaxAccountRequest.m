#import "HpsPaxAccountRequest.h"
#import "HpsTerminalEnums.h"

@implementation HpsPaxAccountRequest

- (NSString*) getElementString
{
    NSMutableString *sb = [[NSMutableString alloc] init];
    
    if (self.accountNumber != nil && self.accountNumber.length > 0) [sb appendString:self.accountNumber];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
   
    if (self.expd != nil && self.expd.length > 0) [sb appendString:self.expd];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
   
    if (self.cvvCode != nil && self.cvvCode.length > 0) [sb appendString:self.cvvCode];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
   
    if (self.ebtType != nil && self.ebtType.length > 0) [sb appendString:self.ebtType];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
   
    if (self.voucherNumber != nil && self.voucherNumber.length > 0) [sb appendString:self.voucherNumber];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
    if (self.dupOverrideFlag != nil && self.dupOverrideFlag.length > 0) [sb appendString:self.dupOverrideFlag]; 
    
    return sb;
}

@end
