#import "HpsUpaReturnBuilder.h"

@implementation HpsUpaReturnBuilder

- (id)initWithDevice: (HpsUpaDevice*)upaDevice{
    self = [super init];
    if (self != nil)
    {
        device = upaDevice;
    }
    return self;
}

- (void) execute:(void(^)(HpsUpaResponse*, NSError*))responseBlock{
    [self validate];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:2];

    HpsUpaRequest* request = [[HpsUpaRequest alloc] init];
    request.message = @"MSG";
    request.data = [[HpsUpaCommandData alloc] init];
    request.data.command = UPA_MSG_ID_toString[ UPA_MSG_ID_REFUND ];
    request.data.EcrId = self.ecrId;
    if (self.referenceNumber > 0) {
        request.data.requestId = [NSString stringWithFormat:@"%d", self.referenceNumber];
    } else {
        request.data.requestId = [NSString stringWithFormat:@"%d", [device generateNumber]];
    }
    request.data.data = [[HpsUpaData alloc] init];
    
    request.data.data.params = [[HpsUpaParams alloc] init];
    request.data.data.params.clerkId = self.clerkId;
    request.data.data.params.tokenValue = self.token;
    request.data.data.params.cardBrandTransId = self.cardBrandTransactionId;
    if ((self.requestMultiUseToken || self.cardBrandTransactionId != nil) && self.storedCardInitiator != HpsStoredCardInitiator_None) {
        request.data.data.params.cardOnFileIndicator = HpsStoredCardInitiator_toString[self.storedCardInitiator];
    }
    
    request.data.data.transaction = [[HpsUpaTransaction alloc] init];
    if (self.transactionId != nil) {
        request.data.data.transaction.referenceNumber = self.transactionId;
    }
    request.data.data.transaction.totalAmount = self.amount != nil ? [formatter stringFromNumber:[NSNumber numberWithDouble:[self.amount doubleValue]]] : nil;
    
    if (self.details != nil) {
        request.data.data.transaction.invoiceNbr = self.details.invoiceNumber;
    }
    
    [device processTransactionWithRequest:request withResponseBlock:^(id<IHPSDeviceResponse> response, NSString* rawJSON, NSError * error) {
        if (error != nil) {
            responseBlock(nil, error);
            return;
        }
        
        responseBlock((HpsUpaResponse*)response, nil);
    }];
}

- (void) validate
{
    //No amount
    if (self.amount == nil || self.amount <= 0) {
        @throw [NSException exceptionWithName:@"HpsUpaException" reason:@"Amount is required." userInfo:nil];
    }
    
    //Too many payment types
    int i = 0;
    if (self.token != nil && self.token.length > 0) i++;
    if (i > 1) {
        @throw [NSException exceptionWithName:@"HpsUpaException" reason:@"Only one payment method allowed." userInfo:nil];
    }
}

@end
