#import "HpsPaxTraceRequest.h"
#import "HpsTerminalEnums.h"

@implementation HpsPaxTraceRequest

- (NSString*) getElementString
{
    NSMutableString *sb = [[NSMutableString alloc] init];
    
    if (self.referenceNumber != nil && self.referenceNumber.length > 0) [sb appendString:self.referenceNumber];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
    
    if (self.invoiceNumber != nil && self.invoiceNumber.length > 0) [sb appendString:self.invoiceNumber];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
   
    if (self.authCode != nil && self.authCode.length > 0) [sb appendString:self.authCode];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
   
    if (self.transactionNumber != nil && self.transactionNumber.length > 0) [sb appendString:self.transactionNumber];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
    
    if (self.timeStamp != nil && self.timeStamp.length > 0) [sb appendString:self.timeStamp];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
    
    if (self.ecrTransId != nil && self.ecrTransId.length > 0) [sb appendString:self.ecrTransId];
    [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
    
    if (self.clientTransactionId != nil && self.clientTransactionId.length > 0) [sb appendString:self.clientTransactionId];
    
    return sb;
}

@end
