#import "HpsPaxCreditAuthBuilder.h"

@implementation HpsPaxCreditAuthBuilder

- (id)initWithDevice: (HpsPaxDevice*)paxDevice{
    self = [super init];
    if (self != nil)
    {
        device = paxDevice;
    }
    return self;
}

- (void) execute:(void(^)(HpsPaxCreditResponse*, NSError*))responseBlock{
	NSLog(@"Auth builder Execute ....");
    [self validate];
    
    NSMutableArray *subgroups = [[NSMutableArray alloc] init];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"0.##"];
    
    HpsPaxAmountRequest *amounts = [[HpsPaxAmountRequest alloc] init];
    amounts.transactionAmount = self.amount != nil ? [formatter stringFromNumber:[NSNumber numberWithDouble:[self.amount doubleValue] * 100]] : nil;
    amounts.tipAmount = self.gratuity != nil ? [formatter stringFromNumber:[NSNumber numberWithDouble:[self.gratuity doubleValue] * 100]] : nil;
    
    [subgroups addObject:amounts];
    
    HpsPaxAccountRequest *account = [[HpsPaxAccountRequest alloc] init];
    if (self.creditCard != nil) {
        account.accountNumber = self.creditCard.cardNumber;
        account.expd = [NSString stringWithFormat:@"%d%d", self.creditCard.expMonth, self.creditCard.expYear];
        account.cvvCode = self.creditCard.cvv;
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
    if (self.authCode == nil || self.authCode.length == 0) {
        traceRequest.authCode = self.authCode;
    }

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
    if (self.requestMultiUseToken) {
        [extData.collection setObject:@"1" forKey:PAX_EXT_DATA_TOKEN_REQUEST];
        
    }
    if (self.token != nil && self.token.length > 0) {
        [extData.collection setObject:self.token forKey:PAX_EXT_DATA_TOKEN];
    }
    if (self.transactionId != nil && [self.transactionId length] > 0) {
        [extData.collection setObject:self.transactionId forKey:PAX_EXT_DATA_HOST_REFERENCE_NUMBER];
    }
    [subgroups addObject:extData];
    
    [device doCredit:PAX_TXN_TYPE_AUTH andSubGroups:subgroups withResponseBlock:^(HpsPaxCreditResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            responseBlock(response, error);
        });
    }];
}

- (void) validate
{
    //No amount
    if (self.amount == nil || self.amount <= 0) {
        @throw [NSException exceptionWithName:@"HpsPaxException" reason:@"Amount is required." userInfo:nil];
    }
    
    //Too many payment types
    int i = 0;
    if (self.creditCard != nil) i++;
    if (self.token != nil && self.token.length > 0) i++;
    if (i > 1) {
        @throw [NSException exceptionWithName:@"HpsPaxException" reason:@"Only one payment method allowed." userInfo:nil];
    }
    
    //Missing data
    if (self.transactionId > 0) {
        if (self.authCode == nil || self.authCode.length == 0) {
            @throw [NSException exceptionWithName:@"HpsPaxException" reason:@"Authcode is required when using a transaction id." userInfo:nil];
        }
    }

	[self.address isZipcodeValid];
}

@end
