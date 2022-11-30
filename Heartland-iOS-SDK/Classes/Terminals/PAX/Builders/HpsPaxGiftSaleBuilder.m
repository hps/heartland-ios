#import "HpsPaxGiftSaleBuilder.h"

@implementation HpsPaxGiftSaleBuilder

- (id)initWithDevice: (HpsPaxDevice*)paxDevice{
    self = [super init];
    if (self != nil)
    {
        device = paxDevice;
        self.currencyType = HpsCurrencyCodes_USD;
    }
    return self;
}

- (void) execute:(void(^)(HpsPaxGiftResponse*, NSError*))responseBlock{
    
    [self validate];
    
    NSMutableArray *subgroups = [[NSMutableArray alloc] init];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"0.##"];
    
    HpsPaxAmountRequest *amounts = [[HpsPaxAmountRequest alloc] init];
    amounts.transactionAmount = self.amount != nil ? [formatter stringFromNumber:[NSNumber numberWithDouble:[self.amount doubleValue] * 100]] : nil;
    amounts.tipAmount = self.gratuity != nil ? [formatter stringFromNumber:[NSNumber numberWithDouble:[self.gratuity doubleValue] * 100]] : nil;
    
    [subgroups addObject:amounts];
    
    HpsPaxAccountRequest *account = [[HpsPaxAccountRequest alloc] init];
    if (self.giftCard != nil) {
        account.accountNumber = self.giftCard.value;
    }
    if (self.allowDuplicates) {
        account.dupOverrideFlag = @"1";
    }
    [subgroups addObject:account];
    
    HpsPaxTraceRequest *traceRequest = [[HpsPaxTraceRequest alloc] init];
    traceRequest.referenceNumber = [NSString stringWithFormat:@"%d", self.referenceNumber];
    if (self.details != nil) {
        traceRequest.invoiceNumber = self.details.invoiceNumber;
    }
    [subgroups addObject:traceRequest];
    
    [subgroups addObject:[[HpsPaxCashierSubGroup alloc] init]];
    
    HpsPaxExtDataSubGroup *extData = [[HpsPaxExtDataSubGroup alloc] init];
    [subgroups addObject:extData];
    
    NSString *messageId = self.currencyType == HpsCurrencyCodes_USD ? T06_DO_GIFT : T08_DO_LOYALTY;
    
    [device doGift:messageId withTxnType:PAX_TXN_TYPE_SALE_REDEEM andSubGroups:subgroups withResponseBlock:^(HpsPaxGiftResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            responseBlock(response, error);
        });
    }];
}

- (void) validate
{
    if (self.amount == nil || self.amount <= 0) {
        @throw [NSException exceptionWithName:@"HpsPaxException" reason:@"Amount is required." userInfo:nil];
    }
    if (self.currencyType < 0) {
        @throw [NSException exceptionWithName:@"HpsPaxException" reason:@"currencyType is required." userInfo:nil];
    }
    
}

@end
