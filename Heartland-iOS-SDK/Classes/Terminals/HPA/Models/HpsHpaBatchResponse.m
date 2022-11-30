#import "HpsHpaBatchResponse.h"
#define SHARED_PARAMS [HpsHpaSharedParams getInstance]
@implementation HpsHpaBatchResponse

- (id)initWithHpaBatchResponse:(NSData *)data withParameters:(NSArray *)messageIds
{
	if (self = [super initWithHpaBaseResponse:data withParameters:messageIds]) {
        self.transactionSummaries = [NSMutableArray new];
        self.batchSummary = [[BatchSummary alloc]init];
	}
	return self;
}

- (void) mapResponse:(id <HpaResposeInterface>) response;
{
    [super mapResponse:response];
    
    NSString *Category = SHARED_PARAMS.tableCategory;
    
    if ([Category isEqualToString:@"BATCH SUMMARY"] || [Category isEqualToString:@"BATCH DETAIL"]) {
        [self mapBatchSummary:response];
    }
    else if([Category isEqualToString:@"VISA CARD SUMMARY"] || [Category isEqualToString:@"MASTERCARD CARD SUMMARY"] || [Category isEqualToString:@"AMERICAN EXPRESS CARD SUMMARY"] || [Category isEqualToString:@"DISCOVER CARD SUMMARY"] || [Category isEqualToString:@"PAYPAL CARD SUMMARY"])
    {
        [self mapCardSummaryData:response];
    }else if([Category containsString:@"TRANSACTION"] && [Category containsString:@"DETAIL"])
    {
        [self mapTransactionSummary:response];
    }
    
}
- (void)mapBatchSummary:(id <HpaResposeInterface>) response
{
    self.responseCode = response.Result;
    self.deviceId = response.DeviceId;
    self.responseText = response.ResultText;
    self.batchSummary = [self.batchSummary initWithPayload:response];
    
}
- (void)mapCardSummaryData:(id <HpaResposeInterface>) response
{
    CardSummary *cardSummaryObject = [[CardSummary alloc]initWithPayload:response];
    [self mapCardSummaryType:cardSummaryObject];
}
-(void)mapCardSummaryType:(CardSummary *)cardSummary
{
    NSString *Category = SHARED_PARAMS.tableCategory;
    if ([Category isEqualToString:@"VISA CARD SUMMARY"]) {
        _visaCardSummary = cardSummary;
    }
    else if([Category isEqualToString:@"MASTERCARD CARD SUMMARY"]){
        _masterCardSummary = cardSummary;
    }
    else if([Category isEqualToString:@"AMERICAN EXPRESS CARD SUMMARY"]){
        _AmericanExpressCardSummary = cardSummary;
    }
    else if([Category isEqualToString:@"DISCOVER CARD SUMMARY"]){
        _discoverSummary = cardSummary;
    }
    else if([Category isEqualToString:@"PAYPAL CARD SUMMARY"]){
        _paypalCardSummary = cardSummary;
    }
}

-(void)mapTransactionSummary:(id <HpaResposeInterface>) response
{
    HpsTransactionSummary *transactionSummaryObject = [[HpsTransactionSummary alloc]initWithPayload:response];
    [self.transactionSummaries addObject:transactionSummaryObject];
    
}
@end
