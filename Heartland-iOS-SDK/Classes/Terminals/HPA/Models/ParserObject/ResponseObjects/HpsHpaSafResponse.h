#import <Foundation/Foundation.h>
#import "HpsHpaBaseResponse.h"

@interface HpsHpaSafResponse : NSObject

@property (nonatomic,strong) NSMutableDictionary *approved;
@property (nonatomic,strong) NSMutableDictionary *declined;
@property (nonatomic,strong) NSMutableDictionary *pending;
@property (nonatomic,strong) NSString *responseCode;
@property (nonatomic,strong) NSString *deviceId;
@property (nonatomic,strong) NSString *transactionId;
@property (nonatomic,strong) NSString *responseText;

-(id)initWithHpaSafResponse:(NSData *)data;
-(void)mapResponse:(id <HpaResposeInterface>)response;
-(NSString *)mapSummaryType:(NSString *)Category;

@end


