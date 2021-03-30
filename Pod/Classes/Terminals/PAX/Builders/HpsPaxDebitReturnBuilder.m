#import "HpsPaxDebitReturnBuilder.h"

@implementation HpsPaxDebitReturnBuilder

- (id)initWithDevice: (HpsPaxDevice*)paxDevice{
    self = [super init];
    if (self != nil)
    {
        device = paxDevice;
    }
    return self;
}

- (void) execute:(void(^)(HpsPaxDebitResponse*, NSError*))responseBlock{
    
    [self validate];
    
    NSMutableArray *subgroups = [[NSMutableArray alloc] init];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"0.##"];
    
    HpsPaxAmountRequest *amounts = [[HpsPaxAmountRequest alloc] init];
    amounts.transactionAmount = self.amount != nil ? [formatter stringFromNumber:[NSNumber numberWithDouble:[self.amount doubleValue] * 100]] : nil;
    [subgroups addObject:amounts];
    
    HpsPaxAccountRequest *account = [[HpsPaxAccountRequest alloc] init];
    [subgroups addObject:account];
    
    HpsPaxTraceRequest *traceRequest = [[HpsPaxTraceRequest alloc] init];
    traceRequest.referenceNumber = [NSString stringWithFormat:@"%d", self.referenceNumber];
    if (self.clientTransactionId != nil)
        traceRequest.clientTransactionId = self.clientTransactionId;
    [subgroups addObject:traceRequest];
    
    HpsPaxAvsRequest *avsRequest = [[HpsPaxAvsRequest alloc] init];
    [subgroups addObject:avsRequest];
    
    [subgroups addObject:[[HpsPaxCashierSubGroup alloc] init]];
    [subgroups addObject:[[HpsPaxCommercialRequest alloc] init]];
    [subgroups addObject:[[HpsPaxEcomSubGroup alloc] init]];
    
    HpsPaxExtDataSubGroup *extData = [[HpsPaxExtDataSubGroup alloc] init];
    if (self.transactionId != 0) {
        [extData.collection setObject:[NSString stringWithFormat:@"%d", self.transactionId] forKey:PAX_EXT_DATA_HOST_REFERENCE_NUMBER];
    }
    [subgroups addObject:extData];
    
    [device doDebit:PAX_TXN_TYPE_RETURN andSubGroups:subgroups withResponseBlock:^(HpsPaxDebitResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            responseBlock(response, error);
        });
    }];
}

- (void) validate
{
    //No amount
    if (self.amount == nil || self.amount.doubleValue <= 0) {
        @throw [NSException exceptionWithName:@"HpsPaxException" reason:@"Amount is required." userInfo:nil];
    }
}

@end
