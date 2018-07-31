#import "HpsHeartSipBaseResponse.h"

@interface HpsHeartSipDeviceResponse : HpsHeartSipBaseResponse<IHPSDeviceResponse>

- (id)initWithHeartSipDeviceResponse:(NSData *)data withParameters:(NSArray *)messageIds;
- (NSString*)toString;
- (void) mapResponse:(id <SipResposeInterface>) response;

@end
