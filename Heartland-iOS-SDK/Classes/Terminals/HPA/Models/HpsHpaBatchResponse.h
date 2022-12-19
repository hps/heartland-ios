#import "HpsHpaBaseResponse.h"
#import "HpsTransactionSummary.h"
#import "BatchSummary.h"
#import "CardSummary.h"


@interface HpsHpaBatchResponse : HpsHpaBaseResponse

@property(nonatomic,strong) BatchSummary *batchSummary;
@property(nonatomic,strong) CardSummary *visaCardSummary;
@property(nonatomic,strong) CardSummary *masterCardSummary;
@property(nonatomic,strong) CardSummary *AmericanExpressCardSummary;
@property(nonatomic,strong) CardSummary *discoverSummary;
@property(nonatomic,strong) CardSummary *paypalCardSummary;
@property(nonatomic,strong) NSMutableArray *transactionSummaries;
@property (nonatomic,strong) NSString *responseCode;
@property (nonatomic,strong) NSString *deviceId;

- (id)initWithHpaBatchResponse:(NSData *)data withParameters:(NSArray *)messageIds;

- (void) mapResponse:(id <HpaResposeInterface>) response;
- (void)mapBatchSummary:(id <HpaResposeInterface>) response;
- (void) mapCardSummaryData:(id <HpaResposeInterface>) response;
-(void)mapTransactionSummary:(id <HpaResposeInterface>) response;

@end
