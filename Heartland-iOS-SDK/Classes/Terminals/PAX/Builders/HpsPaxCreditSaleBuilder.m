#import "HpsPaxCreditSaleBuilder.h"

@implementation HpsPaxCreditSaleBuilder

- (id)initWithDevice: (HpsPaxDevice*)paxDevice{
    self = [super init];
    if (self != nil)
    {
        device = paxDevice;
        _ecrTransId = [HpsPaxCreditSaleBuilder newECRTransactionId];
    }
    return self;   
}

// 16 digit unique numeric id from current time interval
+ (NSString *)newECRTransactionId {
    NSNumberFormatter *formatter = NSNumberFormatter.new;
    formatter.usesSignificantDigits = YES;
    formatter.minimumSignificantDigits = 16;
    formatter.maximumSignificantDigits = 16;
    
    NSTimeInterval now = [NSDate.new timeIntervalSince1970];
    NSString *nowNumString = [formatter stringFromNumber:@(now)];
    NSString *result = [nowNumString stringByReplacingOccurrencesOfString:formatter.decimalSeparator withString:@""];
    
    return result;
}

- (void) execute:(void(^)(HpsPaxCreditResponse*, NSError*))responseBlock{

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
        if (self.creditCard.expMonth < 10)
            account.expd = [NSString stringWithFormat:@"0%d%d", self.creditCard.expMonth, self.creditCard.expYear];
        else
            account.expd = [NSString stringWithFormat:@"%d%d", self.creditCard.expMonth, self.creditCard.expYear];
        account.cvvCode = self.creditCard.cvv;
    }
    
    if (self.allowDuplicates) {
        account.dupOverrideFlag = @"1";
    }
    [subgroups addObject:account];
    
    HpsPaxTraceRequest *traceRequest = [[HpsPaxTraceRequest alloc] init];
    traceRequest.ecrTransId = _ecrTransId;
    
    traceRequest.referenceNumber = [NSString stringWithFormat:@"%d", self.referenceNumber];
    if (self.clientTransactionId != nil)
        traceRequest.clientTransactionId = self.clientTransactionId;
    if (self.details != nil) {
        traceRequest.invoiceNumber = self.details.invoiceNumber;
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
    if (self.signatureCapture){
        [extData.collection setObject:@"1" forKey:PAX_EXT_DATA_SIGNATURE_CAPTURE];
    }
    if (self.tipRequest){
        [extData.collection setObject:@"1" forKey:PAX_EXT_DATA_TIP_REQUEST];
    }
    [subgroups addObject:extData];
    
    [device doCredit:PAX_TXN_TYPE_SALE_REDEEM andSubGroups:subgroups withResponseBlock:^(HpsPaxCreditResponse *response, NSError *error) {
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
    int i = 0;
    if (self.creditCard != nil) i++;
    if (self.token != nil && self.token.length > 0) i++;
    if (i > 1) {
        @throw [NSException exceptionWithName:@"HpsPaxException" reason:@"Only one payment method allowed." userInfo:nil];
    }

	[self.address isZipcodeValid];
}

@end
