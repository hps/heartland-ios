#import "HpsUpaVoidBuilder.h"

@implementation HpsUpaVoidBuilder
- (id)initWithDevice: (HpsUpaDevice*)upaDevice{
    self = [super init];
    if (self != nil)
    {
        device = upaDevice;
    }
    return self;
}

- (void) execute:(void(^)(HpsUpaResponse*, NSError*))responseBlock{
//    [self validate];
    
    HpsUpaRequest* request = [[HpsUpaRequest alloc] init];
    request.message = @"MSG";
    request.data = [[HpsUpaCommandData alloc] init];
    BOOL isDeletePreAuth = self.issuerRefNumber != nil;
    if (isDeletePreAuth) {
        request.data.command = UPA_MSG_ID_toString[ UPA_MSG_ID_DELETE_PREAUTH ];
    } else {
        request.data.command = UPA_MSG_ID_toString[ UPA_MSG_ID_VOID ];
    }
    request.data.EcrId = self.ecrId;
    if (self.referenceNumber > 0) {
        request.data.requestId = [NSString stringWithFormat:@"%d", self.referenceNumber];
    } else {
        request.data.requestId = [NSString stringWithFormat:@"%d", [device generateNumber]];
    }
    request.data.data = [[HpsUpaData alloc] init];
    
    if (!isDeletePreAuth) {
        request.data.data.params = [[HpsUpaParams alloc] init];
        request.data.data.params.clerkId = self.clerkId;
    }
    
    request.data.data.transaction = [[HpsUpaTransaction alloc] init];
    
    if (isDeletePreAuth) {
        request.data.data.transaction.referenceNumber = self.issuerRefNumber;
    }
    else if (self.transactionId != nil) {
        request.data.data.transaction.referenceNumber = self.transactionId;
    }
    else if (self.terminalRefNumber != nil) {
        request.data.data.transaction.tranNo = [[@"" stringByPaddingToLength:4 - [self.terminalRefNumber length] withString:@"0" startingAtIndex:0] stringByAppendingString:self.terminalRefNumber];
    }
    
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
    if (self.terminalRefNumber == nil && self.issuerRefNumber == nil) {
        @throw [NSException exceptionWithName:@"HpsUpaException" reason:@"Either terminalRefNumber or issuerRefNumber is required." userInfo:nil];
    }
}

@end
