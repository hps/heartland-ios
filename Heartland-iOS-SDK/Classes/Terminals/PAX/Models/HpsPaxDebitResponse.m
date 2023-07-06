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
            
            if (!self.hostResponse.traceNumber.length && self.traceResponse.ecrRefNumber != nil) {
                self.hostResponse.traceNumber = self.traceResponse.ecrRefNumber;
            }
        }
        
        if (self.accountResponse != nil) {
            self.paymentType = self.accountResponse.cardType;
        }
        
        if (self.amountResponse != nil) {
            NSDecimal transactionAmount = [self.transactionAmount decimalValue];
            NSDecimal adjustedTransactionAmount;
            NSDecimalMultiplyByPowerOf10(&adjustedTransactionAmount, &transactionAmount, -2, NSRoundDown);
            self.transactionAmount = [NSDecimalNumber decimalNumberWithDecimal:adjustedTransactionAmount];
            self.approvedAmount = [NSDecimalNumber decimalNumberWithString:[[NSNumber numberWithDouble:self.amountResponse.approvedAmount] stringValue]];
            self.amountDue = [NSDecimalNumber decimalNumberWithString:[[NSNumber numberWithDouble:self.amountResponse.amountDue] stringValue]];
        }
        
    } @catch (NSException *exception) {
        NSLog(@"Error on mapResponse DEBIT RESPONSE");
        
    }
}

@end
