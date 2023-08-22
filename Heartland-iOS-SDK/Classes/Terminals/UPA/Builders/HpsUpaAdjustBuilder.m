#import "HpsUpaAdjustBuilder.h"

@implementation HpsUpaAdjustBuilder

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
    request.data.command = UPA_MSG_ID_toString[ UPA_MSG_ID_TIP_ADJUST ];
    request.data.EcrId = self.ecrId;
    if (self.referenceNumber > 0) {
        request.data.requestId = [NSString stringWithFormat:@"%d", self.referenceNumber];
    } else {
        request.data.requestId = [NSString stringWithFormat:@"%d", [device generateNumber]];
    }
    request.data.data = [[HpsUpaData alloc] init];
    
    request.data.data.params = [[HpsUpaParams alloc] init];

    request.data.data.transaction = [[HpsUpaTransaction alloc] init];
    
    if (self.gratuity != nil) {
        request.data.data.transaction.tipAmount = [self.gratuity stringValue];
    }
    
    if (self.transactionId != nil) {
        request.data.data.transaction.referenceNumber = self.transactionId;
    } else if (self.terminalRefNumber != nil) {
        request.data.data.transaction.tranNo = self.terminalRefNumber;
    }
    
    if (self.details != nil) {
        request.data.data.transaction.invoiceNbr = self.details.invoiceNumber;
    }
    
    [device processTransactionWithRequest:request withResponseBlock:^(id<IHPSDeviceResponse> response, NSString *rawJSON, NSError * error) {
        if (error != nil) {
            responseBlock(nil, error);
            return;
        }
        
        responseBlock((HpsUpaResponse*)response, nil);
    }];}

- (void) validate
{
    if (self.terminalRefNumber == nil && (self.details == nil || self.details.invoiceNumber == nil)) {
        @throw [NSException exceptionWithName:@"HpsUpaException" reason:@"terminalRefNumber, clerkId, or invoiceNumber is required." userInfo:nil];
    }

}

@end

