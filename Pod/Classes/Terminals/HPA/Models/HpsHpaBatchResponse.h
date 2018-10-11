#import "HpsHpaBaseResponse.h"

@interface HpsHpaBatchResponse : HpsHpaBaseResponse<IBatchCloseResponse>

@property(nonatomic,strong) NSString *sequenceNumber;
@property(nonatomic,strong) NSString *totalCount;
@property(nonatomic,strong) NSString *totalAmount;

- (id)initWithHpaBatchResponse:(NSData *)data withParameters:(NSArray *)messageIds;
- (void) mapResponse:(id <HpaResposeInterface>) response;
-(NSString *)toString;

@end
