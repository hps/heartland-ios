#import "HpsPaxLocalDetailResponse.h"

@implementation HpsPaxLocalDetailResponse

- (id) initWithBuffer:(NSData*)buffer{
    if((self = [super initWithMessageID:R03_RSP_LOCAL_DETAIL_REPORT andBuffer:buffer]))
    {
        
        [self parseResponse];
    }
    return self;
}

- (HpsBinaryDataScanner*) parseResponse{
    HpsBinaryDataScanner *reader = [super parseResponse];
    if ([self.deviceResponseCode isEqualToString:@"000000"] || [self.deviceResponseCode isEqualToString:@"100011"]) {
        self.totalRecord =[reader readStringUntilDelimiter:HpsControlCodes_FS];
        self.recordNumber =[reader readStringUntilDelimiter:HpsControlCodes_FS];
        self.hostResponse = [[HpsPaxHostResponse alloc] initWithBinaryReader:reader];
        self.edcType = [reader readStringUntilDelimiter:HpsControlCodes_FS];
        self.transactionType = [reader readStringUntilDelimiter:HpsControlCodes_FS];
        self.originalTransactionType = [reader readStringUntilDelimiter:HpsControlCodes_FS];
        self.amountResponse = [[HpsPaxAmountResponse alloc] initWithBinaryReader:reader];
        self.accountResponse = [[HpsPaxAccountResponse alloc] initWithBinaryReader:reader];
        self.traceResponse = [[HpsPaxTraceResponse alloc] initWithBinaryReader:reader];
        self.cashierResponse = [[HpsPaxCashierSubGroup alloc]initWithBinaryReader:reader];
        self.commercialResponse = [[HpsPaxCommercialResponse alloc]initWithBinaryReader:reader];
        self.checkResponse = [[HpsPaxCheckResponse alloc]initWithBinaryReader:reader];
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
        NSLog(@"Error on mapResponse LOCAL DETAIL REPORT RESPONSE");
        
    }
}


@end
