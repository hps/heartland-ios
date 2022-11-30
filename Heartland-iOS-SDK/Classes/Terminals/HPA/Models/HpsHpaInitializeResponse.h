#import "HpsHpaBaseResponse.h"

@interface HpsHpaInitializeResponse : HpsHpaBaseResponse <IInitializeResponse>
@property (nonatomic,strong) NSString * serialNumber;

- (id)initWithHpaInitializeResponse:(NSData *)data withParameters:(NSArray *)messageIds;
- (void) mapResponse:(id <HpaResposeInterface>) response;

@end
