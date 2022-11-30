#import "HpsTerminalResponse.h"
#import "HpsDeviceProtocols.h"
#import "HpsHpaRequest.h"

@interface HpsHpaBaseResponse : HpsTerminalResponse

@property (nonatomic,strong) NSString *response;
@property (nonatomic,strong) NSString *ecrId;
@property (nonatomic,strong) NSString *hpaId;
@property id <HpaResposeInterface> recievedResponse;

-(id)initWithHpaBaseResponse:(NSData *)data withParameters:(NSArray *)messageIds;
- (void) mapResponse:(id <HpaResposeInterface>) response;
-(NSString *)NormalizeResponse:(NSString *)response;
-(NSString *)toString;

@end
