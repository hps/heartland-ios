
#import <Foundation/Foundation.h>
#import "HpsHpaResponse.h"

@interface BatchSummary : NSObject

@property(nonatomic,strong) NSString *merchantName;
@property(nonatomic,strong) NSString *siteId;
@property(nonatomic,strong) NSString *deviceId;
@property(nonatomic,strong) NSString *batchId;
@property(nonatomic,strong) NSString *batchSequenceNumber;
@property(nonatomic,strong) NSString *batchStatus;
@property(nonatomic,strong) NSDate *openTime;
@property(nonatomic,strong) NSString *transactioId;
@property(nonatomic,strong) NSString *transactionCount;
@property(nonatomic,strong) NSString *batchTransactionAmount;
@property(nonatomic,strong) NSString *creditCount;
@property(nonatomic,strong) NSString *creditAmount;
@property(nonatomic,strong) NSString *debitCount;
@property(nonatomic,strong) NSDate *debitAmount;
@property(nonatomic,strong) NSString *saleCount;
@property(nonatomic,strong) NSString *saleAmount;
@property(nonatomic,strong) NSString *returnCount;
@property(nonatomic,strong) NSString *returnAmount;

-(id)initWithPayload:(id <HpaResposeInterface>)response;
@end

