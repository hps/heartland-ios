#import "HpsUpaReversalBuilder.h"

@implementation HpsUpaReversalBuilder

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
    request.data.command = UPA_MSG_ID_toString[ UPA_MSG_ID_REVERSAL ];
    request.data.EcrId = self.ecrId;
    if (self.referenceNumber > 0) {
        request.data.requestId = [NSString stringWithFormat:@"%d", self.referenceNumber];
    } else {
        request.data.requestId = [NSString stringWithFormat:@"%d", [device generateNumber]];
    }
    request.data.data = [[HpsUpaData alloc] init];
    
    request.data.data.transaction = [[HpsUpaTransaction alloc] init];
    if (self.transactionId != nil) {
        request.data.data.transaction.referenceNumber = self.transactionId;
    } else if (self.terminalRefNumber != nil) {
        request.data.data.transaction.tranNo = self.terminalRefNumber;
    }
    request.data.data.transaction.authorizedAmount = self.authorizedAmount != nil ? [formatter stringFromNumber:[NSNumber numberWithDouble:[self.authorizedAmount doubleValue]]] : nil;
    
    [device processTransactionWithRequest:request withResponseBlock:^(id<IHPSDeviceResponse> response, NSString *json, NSError * error) {
        if (error != nil) {
            responseBlock(nil, error);
            return;
        }
        
        responseBlock((HpsUpaResponse*)response, nil);
    }];
}

- (void) validate
{
}

@end
