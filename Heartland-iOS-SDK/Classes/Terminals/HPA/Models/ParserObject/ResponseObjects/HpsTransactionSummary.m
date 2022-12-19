#import "HpsTransactionSummary.h"
#define SHARED_PARAMS [HpsHpaSharedParams getInstance]
@implementation HpsTransactionSummary

-(id)init {
    
    self = [super init];
    
    return self;
}

-(id)initWithPayload:(id <HpaResposeInterface>)response {
    
    if (!self) {  self = [super init]; }
    
    
    NSString *Category = SHARED_PARAMS.tableCategory;
    
    NSMutableDictionary *fieldValues = [SHARED_PARAMS.params objectForKey:Category];
    self.TableCategory = Category;
    self.ReferenceNumber = [fieldValues valueForKey:@"ReferenceNumber"];
    self. TransactionTime = [fieldValues valueForKey:@"TransactionTime"];
    self.TransactionStatus = [fieldValues valueForKey:@"TransactionStatus"];
    self.MaskedPAN = [fieldValues valueForKey:@"MaskedPAN"];
    self.CardType = [fieldValues valueForKey:@"CardType"];
    self.TransactionType = [fieldValues valueForKey:@"TransactionType"];
    self. CardAcquisition = [fieldValues valueForKey:@"CardAcquisition"];
    self.ApprovalCode = [fieldValues valueForKey:@"ApprovalCode"];
    self.ResponseCode = [fieldValues valueForKey:@"Responsecode"];
    self.ResponseText = [fieldValues valueForKey:@"ResponseText"];
    self.CashbackAmount = [fieldValues valueForKey:@"CashbackAmount"];
    self. TipAmount = [fieldValues valueForKey:@"TipAmount"];
    self.AuthorizedAmount = [fieldValues valueForKey:@"AuthorizedAmount"];
    self.SettleAmount = [fieldValues valueForKey:@"SettleAmount"];
    self.RequestAmount = [fieldValues valueForKey:@"RequestedAmount"];
    
    self.RequestAmount = [fieldValues valueForKey:@"RequestedAmountassd"];
    
    return self;
}


@end
