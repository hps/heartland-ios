	//  Copyright (c) 2017 Heartland Payment Systems. All rights reserved.

#import "HpsHeartSipBaseResponse.h"

@interface HpsHeartSipBatchResponse : HpsHeartSipBaseResponse<IBatchCloseResponse>

@property(nonatomic,strong) NSString *sequenceNumber;
@property(nonatomic,strong) NSString *totalCount;
@property(nonatomic,strong) NSString *totalAmount;

- (id)initWithHeartSipBatchResponse:(NSData *)data withParameters:(NSArray *)messageIds;
- (void) mapResponse:(id <SipResposeInterface>) response;
-(NSString *)toString;

@end
