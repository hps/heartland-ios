#import "HpsUpaAuthBuilder.h"

@implementation HpsUpaAuthBuilder

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
    request.data.command = UPA_MSG_ID_toString[ UPA_MSG_ID_AUTH ];
    request.data.EcrId = self.ecrId;
    if (self.referenceNumber > 0) {
        request.data.requestId = [NSString stringWithFormat:@"%d", self.referenceNumber];
    } else {
        request.data.requestId = [NSString stringWithFormat:@"%d", [device generateNumber]];
    }
    request.data.data = [[HpsUpaData alloc] init];
    
    request.data.data.params = [[HpsUpaParams alloc] init];
    request.data.data.params.clerkId = self.clerkId;
    
    request.data.data.transaction = [[HpsUpaTransaction alloc] init];
    
    request.data.data.transaction.amount = self.amount != nil ? [formatter stringFromNumber:[NSNumber numberWithDouble:[self.amount doubleValue]]] : nil;
    if (self.issuerRefNumber != nil) {
        request.data.data.transaction.referenceNumber = self.issuerRefNumber;
    } else if (self.transactionId != nil) {
        request.data.data.transaction.referenceNumber = self.transactionId;
    }
    
    request.data.data.transaction.clinicAmount = self.clinicAmount != nil ? [formatter stringFromNumber:[NSNumber numberWithDouble:[self.clinicAmount doubleValue]]] : nil;
    request.data.data.transaction.prescriptionAmount = self.prescriptionAmount != nil ? [formatter stringFromNumber:[NSNumber numberWithDouble:[self.prescriptionAmount doubleValue]]] : nil;
    request.data.data.transaction.dentalAmount = self.dentalAmount != nil ? [formatter stringFromNumber:[NSNumber numberWithDouble:[self.dentalAmount doubleValue]]] : nil;
    request.data.data.transaction.visionOpticalAmount = self.visionOpticalAmount != nil ? [formatter stringFromNumber:[NSNumber numberWithDouble:[self.visionOpticalAmount doubleValue]]] : nil;
    
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
    if (self.amount == nil || self.amount <= 0) {
        @throw [NSException exceptionWithName:@"HpsUpaException" reason:@"Amount is required." userInfo:nil];
    }
    int i = 0;
    if (i > 1) {
        @throw [NSException exceptionWithName:@"HpsUpaException" reason:@"Only one payment method allowed." userInfo:nil];
    }
}

@end
