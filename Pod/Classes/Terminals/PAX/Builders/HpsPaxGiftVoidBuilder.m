#import "HpsPaxGiftVoidBuilder.h"

@implementation HpsPaxGiftVoidBuilder

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
    
    HpsPaxAmountRequest *amounts = [[HpsPaxAmountRequest alloc] init];
    [subgroups addObject:amounts];
    
    HpsPaxAccountRequest *account = [[HpsPaxAccountRequest alloc] init];
    [subgroups addObject:account];
    
    HpsPaxTraceRequest *traceRequest = [[HpsPaxTraceRequest alloc] init];
    traceRequest.referenceNumber = [NSString stringWithFormat:@"%d", self.referenceNumber];
    
    if (_transactionNumber) {
        traceRequest.transactionNumber = @(_transactionNumber).stringValue;
    }
    
    [subgroups addObject:traceRequest];
    
    HpsPaxCashierSubGroup *cashierRequest = [[HpsPaxCashierSubGroup alloc]init];
    [subgroups addObject:cashierRequest];
    
    HpsPaxExtDataSubGroup *extData = [[HpsPaxExtDataSubGroup alloc] init];
    
    if (self.transactionId != 0) {
        [extData.collection setObject:[NSString stringWithFormat:@"%d", self.transactionId] forKey:PAX_EXT_DATA_HOST_REFERENCE_NUMBER.uppercaseString];
    }
    [subgroups addObject:extData];
    
    NSString *messageId = self.currencyType == HpsCurrencyCodes_USD ? T06_DO_GIFT : T08_DO_LOYALTY;
    
    [device doGift:messageId withTxnType:PAX_TXN_TYPE_VOID andSubGroups:subgroups withResponseBlock:^(HpsPaxGiftResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            responseBlock(response, error);
        });
    }];
}

- (void) validate
{
    if (self.currencyType < 0) {
        @throw [NSException exceptionWithName:@"HpsPaxException" reason:@"currencyType is required." userInfo:nil];
    }
    
    if (self.transactionId <= 0 && self.transactionNumber == 0) {
        @throw [NSException exceptionWithName:@"HpsPaxException" reason:@"either transactionId or transactionNumber is required." userInfo:nil];
    }
    
}

@end
