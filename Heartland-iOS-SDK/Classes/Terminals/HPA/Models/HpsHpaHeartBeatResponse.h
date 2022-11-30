

#import <Foundation/Foundation.h>
#import "HpsHpaResponse.h"

@interface HpsHpaHeartBeatResponse : NSObject

@property(nonatomic,strong) NSString *responseCode;
@property(nonatomic,strong) NSString *responseText;
@property(nonatomic,strong) NSString *transactionTime;

-(void)mapResponse:(id <HpaResposeInterface>)response;
@end

