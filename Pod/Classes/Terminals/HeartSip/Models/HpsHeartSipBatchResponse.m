#import "HpsHeartSipBatchResponse.h"

@implementation HpsHeartSipBatchResponse

- (id)initWithHeartSipBatchResponse:(NSData *)data withParameters:(NSArray *)messageIds
{
	if (self = [super initWithHeartSipBaseResponse:data withParameters:messageIds]) {

	}
	return self;
}

- (void) mapResponse:(id <SipResposeInterface>) response;
{
	[super mapResponse:response];
	self.sequenceNumber = response.BatchSeqNbr;
	self.totalAmount = response.BatchSeqNbr;
	self.totalCount = response.BatchTxnAmt;
}

-(NSString *)toString{

	return [NSString stringWithFormat:@"toString = \n sequence Number = %@ TOTAL COUNT = %@ TOTAL AMOUNT = %@ DeviceResponseCode = %@",self.sequenceNumber,self.totalCount,self.totalAmount,self.deviceResponseCode];
}

@end
