	//  Copyright (c) 2017 Heartland Payment Systems. All rights reserved.

#import "HpsTerminalResponse.h"
#import "HpsDeviceProtocols.h"
#import "HpsHeartSipRequest.h"

@interface HpsHeartSipBaseResponse : HpsTerminalResponse

@property (nonatomic,strong) NSString *response;
@property (nonatomic,strong) NSString *ecrId;
@property (nonatomic,strong) NSString *sipId;
@property id <SipResposeInterface> recievedResponse;

-(id)initWithHeartSipBaseResponse:(NSData *)data withParameters:(NSArray *)messageIds;
- (void) mapResponse:(id <SipResposeInterface>) response;
-(NSString *)NormalizeResponse:(NSString *)response;
-(NSString *)toString;

@end
