#import "HpsPaxCreditVerifyBuilder.h"

@implementation HpsPaxCreditVerifyBuilder

- (id)initWithDevice: (HpsPaxDevice*)paxDevice{
    self = [super init];
    if (self != nil)
    {
        device = paxDevice;
    }
    return self;
}

- (void) execute:(void(^)(HpsPaxCreditResponse*, NSError*))responseBlock{
    
    [self validate];
    
    NSMutableArray *subgroups = [[NSMutableArray alloc] init];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"0.##"];
    
    HpsPaxAmountRequest *amounts = [[HpsPaxAmountRequest alloc] init];
    [subgroups addObject:amounts];
    
    HpsPaxAccountRequest *account = [[HpsPaxAccountRequest alloc] init];
    if (self.creditCard != nil) {
        account.accountNumber = self.creditCard.cardNumber;
        if (self.creditCard.expMonth < 10)
            account.expd = [NSString stringWithFormat:@"0%d%d", self.creditCard.expMonth, self.creditCard.expYear];
        else
            account.expd = [NSString stringWithFormat:@"%d%d", self.creditCard.expMonth, self.creditCard.expYear];
       // account.cvvCode = self.creditCard.cvv;
    }  
    
    [subgroups addObject:account];
    
    HpsPaxTraceRequest *traceRequest = [[HpsPaxTraceRequest alloc] init];
    traceRequest.referenceNumber = [NSString stringWithFormat:@"%d", self.referenceNumber];
    if (self.clientTransactionId != nil)
        traceRequest.clientTransactionId = self.clientTransactionId;
    [subgroups addObject:traceRequest];
    
    HpsPaxAvsRequest *avsRequest = [[HpsPaxAvsRequest alloc] init];
    if (self.address != nil) {
        avsRequest.zipCode = self.address.zip;
        avsRequest.address = self.address.address;
    }
    [subgroups addObject:avsRequest];
    
    [subgroups addObject:[[HpsPaxCashierSubGroup alloc] init]];
    [subgroups addObject:[[HpsPaxCommercialRequest alloc] init]];
    [subgroups addObject:[[HpsPaxEcomSubGroup alloc] init]];
    
    HpsPaxExtDataSubGroup *extData = [[HpsPaxExtDataSubGroup alloc] init];
    [subgroups addObject:extData];
    
    [device doCredit:(self.requestMultiUseToken ? PAX_TXN_TYPE_TOKENIZE : PAX_TXN_TYPE_VERIFY) andSubGroups:subgroups withResponseBlock:^(HpsPaxCreditResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            responseBlock(response, error);
        });
    }];
}

- (void) validate
{
    if (self.creditCard == nil) {
        @throw [NSException exceptionWithName:@"HpsPaxException" reason:@"No payment type." userInfo:nil];
    }

	[self.address isZipcodeValid];
}

@end
