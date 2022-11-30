
#import <Foundation/Foundation.h>
#import "HpsHpaResponse.h"


@interface CardSummary : NSObject
@property(nonatomic,strong) NSString *CardType;

@property(nonatomic,strong) NSString *creditCount;
@property(nonatomic,strong) NSString *creditAmount;
@property(nonatomic,strong) NSString *debitCount;
@property(nonatomic,strong) NSString *debitAmount;
@property(nonatomic,strong) NSString *saleCount;
@property(nonatomic,strong) NSString *saleAmount;
@property(nonatomic,strong) NSString *refundCount;
@property(nonatomic,strong) NSString *refundAmount;
@property(nonatomic,strong) NSString *totalCount;
@property(nonatomic,strong) NSString *totalAmount;

-(id)initWithPayload:(id <HpaResposeInterface>)response;
@end


