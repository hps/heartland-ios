#import "HpsHeartSipBaseResponse.h"

@interface HpsHeartSipInitializeResponse : HpsHeartSipBaseResponse <IInitializeResponse>
@property (nonatomic,strong) NSString * serialNumber;

- (id)initWithHeartSipInitializeResponse:(NSData *)data withParameters:(NSArray *)messageIds;
- (void) mapResponse:(id <SipResposeInterface>) response;

@end
