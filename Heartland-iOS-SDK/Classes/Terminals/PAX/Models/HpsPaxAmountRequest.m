#import "HpsPaxAmountRequest.h"
#import "HpsTerminalEnums.h"

@implementation HpsPaxAmountRequest

- (NSString*) getElementString
{
    NSMutableString *sb = [[NSMutableString alloc] init];
    
    if (self.transactionAmount != nil && self.transactionAmount.length > 0) [sb appendString:self.transactionAmount];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
    
    if (self.tipAmount != nil && self.tipAmount.length > 0) [sb appendString:self.tipAmount];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
    
    if (self.cashBackAmount != nil && self.cashBackAmount.length > 0) [sb appendString:self.cashBackAmount];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
    
    if (self.merchantFee != nil && self.merchantFee.length > 0) [sb appendString:self.merchantFee];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
    
    if (self.taxAmount != nil && self.taxAmount.length > 0) [sb appendString:self.taxAmount];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
   
    if (self.fuelAmount != nil && self.fuelAmount.length > 0) [sb appendString:self.fuelAmount];
    
    return sb;
}

@end
