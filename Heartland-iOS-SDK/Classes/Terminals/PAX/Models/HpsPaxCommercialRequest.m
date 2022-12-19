#import "HpsPaxCommercialRequest.h"

@implementation HpsPaxCommercialRequest

- (NSString*) getElementString
{
    NSMutableString *sb = [[NSMutableString alloc] init];
    
    if (self.poNumber != nil && self.poNumber.length > 0) [sb appendString:self.poNumber];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
 
    if (self.customerCode != nil && self.customerCode.length > 0) [sb appendString:self.customerCode];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
 
    if (self.taxExempt != nil && self.taxExempt.length > 0) [sb appendString:self.taxExempt];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
 
    if (self.taxExemptId != nil && self.taxExemptId.length > 0) [sb appendString:self.taxExemptId];
    
    return sb;
    
}

@end
