
#import "HpsHpaHeartBeatResponse.h"

@implementation HpsHpaHeartBeatResponse
-(id)init {
    
    self = [super init];
    
    return self;
}

-(void)mapResponse:(id <HpaResposeInterface>)response {
    
    self.transactionTime = response.TransactionTime;
    self.responseCode = response.Result;
    self.responseText = response.ResultText;
 
}
@end
