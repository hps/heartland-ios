#import "HpsUpaVerifyBuilder.h"

@implementation HpsUpaVerifyBuilder

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

    HpsUpaRequest* request = [[HpsUpaRequest alloc] init];
    request.message = @"MSG";
    request.data = [[HpsUpaCommandData alloc] init];
    request.data.command = UPA_MSG_ID_toString[ UPA_MSG_ID_CARD_VERIFY ];
    request.data.EcrId = self.ecrId;
    if (self.referenceNumber > 0) {
        request.data.requestId = [NSString stringWithFormat:@"%d", self.referenceNumber];
    } else {
        request.data.requestId = [NSString stringWithFormat:@"%d", [device generateNumber]];
    }
    request.data.data = [[HpsUpaData alloc] init];
    
    request.data.data.params = [[HpsUpaParams alloc] init];
    request.data.data.params.clerkId = self.clerkId;
    request.data.data.params.tokenRequest = self.requestMultiUseToken ? @"1" : @"0";
    request.data.data.params.tokenValue = self.token;
    
    [device processTransactionWithRequest:request withResponseBlock:^(id<IHPSDeviceResponse> response, NSError * error) {
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
