#import "HpsTransaction.h"
#import "HpsCardData.h"
#import "HpsCardHolderData.h"
#import "HpsAdditionalTxnFields.h"

@implementation HpsTransaction

- (NSObject*) init {
    self = [super init];
  
    self.cardData = [[HpsCardData alloc] init];
    self.cardHolderData = [[HpsCardHolderData alloc] init];
    self.additionalTxnFields = [[HpsAdditionalTxnFields alloc] init];
    
    return self;
}

- (NSString*) toXML
{
    NSString *requestXMLhead = @"<hps:Transaction><hps:CreditSale><hps:Block1>";
    NSString *requestXMLTail = @"</hps:Block1></hps:CreditSale></hps:Transaction>";
    
    NSString *amount = [NSString stringWithFormat:@"<hps:Amt>%f</hps:Amt>", self.chargeAmount];
    NSString *allowDuplicate = [NSString stringWithFormat:@"<hps:AllowDup>%@</hps:AllowDup>", self.allowDuplicate ? @"Y" : @"N"];
    NSString *allowPartialAuth = [NSString stringWithFormat:@"<hps:AllowPartialAuth>%@</hps:AllowPartialAuth>", self.allowPartialAuth ? @"Y" : @"N" ];
    
    NSString *xml = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",requestXMLhead, [self.cardData toXML],[self.cardHolderData toXML],
                     [self.additionalTxnFields toXML], amount, allowDuplicate, allowPartialAuth, requestXMLTail];
    return xml;
}


@end
