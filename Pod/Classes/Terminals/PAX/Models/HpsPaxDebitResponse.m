#import "HpsPaxDebitResponse.h"

@implementation HpsPaxDebitResponse

- (id) initWithBuffer:(NSData*)buffer{
    if((self = [super initWithMessageID:T03_RSP_DO_DEBIT andBuffer:buffer]))
    {
        
        [self parseResponse];
    }
    return self;
}

- (HpsBinaryDataScanner*) parseResponse{
    HpsBinaryDataScanner *reader = [super parseResponse];
    if ([self.deviceResponseCode isEqualToString:@"000000"] || [self.deviceResponseCode isEqualToString:@"100011"]) {
        
        self.hostResponse = [[HpsPaxHostResponse alloc] initWithBinaryReader:reader];
        self.transactionType = [reader readStringUntilDelimiter:HpsControlCodes_FS];
        self.amountResponse = [[HpsPaxAmountResponse alloc] initWithBinaryReader:reader];
        self.accountResponse = [[HpsPaxAccountResponse alloc] initWithBinaryReader:reader];
        self.traceResponse = [[HpsPaxTraceResponse alloc] initWithBinaryReader:reader];        
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
        }
        
        if (self.accountResponse != nil) {
            self.paymentType = self.accountResponse.cardType;
        }
        
        if (self.amountResponse != nil) {
            self.transactionAmount = [NSNumber numberWithDouble:[self.transactionAmount doubleValue]/100];
            self.approvedAmount = [NSNumber numberWithDouble:self.amountResponse.approvedAmount];
            self.amountDue = [NSNumber numberWithDouble:self.amountResponse.amountDue];
        }
        
    } @catch (NSException *exception) {
        NSLog(@"Error on mapResponse DEBIT RESPONSE");
        
    }
}

@end
