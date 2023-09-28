#import "HpsPaxCreditResponse.h"

@implementation HpsPaxCreditResponse

- (id) initWithBuffer:(NSData*)buffer{
    if((self = [super initWithMessageID:T01_RSP_DO_CREDIT andBuffer:buffer]))
    {
        
        [self parseResponse];
    }
    return self;
    
}

- (HpsBinaryDataScanner*) parseResponse{
    HpsBinaryDataScanner *reader = [super parseResponse];
    //must parse responses for duplicate error codes (100011 - Local Duplicate, 103000 Host Duplicate)
    if ([self.deviceResponseCode isEqualToString:@"000000"] || [self.deviceResponseCode isEqualToString:@"100011"]  || [self.deviceResponseCode isEqualToString:@"103000"] || [self.deviceResponseCode isEqualToString:@"000002"]) {
        
        self.hostResponse = [[HpsPaxHostResponse alloc] initWithBinaryReader:reader];
        self.transactionType = [reader readStringUntilDelimiter:HpsControlCodes_FS];
        self.amountResponse = [[HpsPaxAmountResponse alloc] initWithBinaryReader:reader];
        self.accountResponse = [[HpsPaxAccountResponse alloc] initWithBinaryReader:reader];
        self.traceResponse = [[HpsPaxTraceResponse alloc] initWithBinaryReader:reader];
        self.avsResponse = [[HpsPaxAvsResponse alloc] initWithBinaryReader:reader];
        self.commercialResponse = [[HpsPaxCommercialResponse alloc] initWithBinaryReader:reader];
        self.ecomResponse = [[HpsPaxEcomSubGroup alloc] initWithBinaryReader:reader];
        self.extDataResponse = [[HpsPaxExtDataSubGroup alloc] initWithBinaryReader:reader];
        
        [self mapResponse];
    }
    
    return reader;
    
}

- (void) mapResponse{
    [super mapResponse];
    
    @try {
        if (self.hostResponse != nil) {
            self.authorizationCode = self.hostResponse.authCode;
            
            if (!self.hostResponse.traceNumber.length && self.traceResponse.ecrRefNumber != nil) {
                self.hostResponse.traceNumber = self.traceResponse.ecrRefNumber;
            }
        }
        
        
    } @catch (NSException *exception) {
        NSLog(@"Error on mapResponse CREDIT RESPONSE");
        
    }
}

@end
