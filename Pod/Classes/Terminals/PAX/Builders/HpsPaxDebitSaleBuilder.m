#import "HpsPaxDebitSaleBuilder.h"

@implementation HpsPaxDebitSaleBuilder

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
    amounts.cashBackAmount = self.cashBack != nil ? [formatter stringFromNumber:[NSNumber numberWithDouble:[self.cashBack doubleValue] * 100]] : nil;
    [subgroups addObject:amounts];
    
    HpsPaxAccountRequest *account = [[HpsPaxAccountRequest alloc] init];
    if (self.allowDuplicates) {
        account.dupOverrideFlag = @"1";
    }
    [subgroups addObject:account];
    
    HpsPaxTraceRequest *traceRequest = [[HpsPaxTraceRequest alloc] init];
    traceRequest.referenceNumber = [NSString stringWithFormat:@"%d", self.referenceNumber];
    if (self.clientTransactionId != nil)
        traceRequest.clientTransactionId = self.clientTransactionId;
    if (self.details != nil) {
        traceRequest.invoiceNumber = self.details.invoiceNumber;
    }
    [subgroups addObject:traceRequest];
    
    [subgroups addObject:[[HpsPaxCashierSubGroup alloc] init]];
        
    HpsPaxExtDataSubGroup *extData = [[HpsPaxExtDataSubGroup alloc] init];
    if (self.tipRequest){
        [extData.collection setObject:@"1" forKey:PAX_EXT_DATA_TIP_REQUEST];
    }
    [subgroups addObject:extData];
    
    [device doDebit:PAX_TXN_TYPE_SALE_REDEEM andSubGroups:subgroups withResponseBlock:^(HpsPaxDebitResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            response.transactionAmount =  [NSNumber numberWithDouble:[self.amount doubleValue]];
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
