#import "HpsHpaBaseResponse.h"

@interface HpsHpaDeviceResponse : HpsHpaBaseResponse<IHPSDeviceResponse>

- (id)initWithHpaDeviceResponse:(NSData *)data withParameters:(NSArray *)messageIds;
- (NSString*)toString;
- (void) mapResponse:(id <HpaResposeInterface>) response;

@end
