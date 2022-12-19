#import "HpsPaxAvsRequest.h"
#import "HpsTerminalEnums.h"

@implementation HpsPaxAvsRequest

- (NSString*) getElementString
{
    NSMutableString *sb = [[NSMutableString alloc] init];
    
    
    if (self.zipCode != nil && self.zipCode.length > 0) [sb appendString:self.zipCode];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
    
    if (self.address != nil && self.address.length > 0) [sb appendString:self.address];
      
    return sb;
}

@end
