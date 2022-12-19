#import <UIKit/UIKit.h>
#import "HpsPayrollEntity.h"
#import "HpsPayRollRequest.h"

typedef NS_ENUM(NSInteger, PayRollRequestType) {
    TerminationReason,
    WorkLocation,
    LaborField,
    PayGroup,
    PayItem
};

@interface HpsClientInfo : HpsPayrollEntity

@property (nonatomic,strong) NSString *clientCode;
@property (nonatomic,strong) NSString *clientName;
@property (nonatomic,assign) NSInteger federalEin;

-(void)fromJSON:(HpsJsonDoc *)doc withArgument:(HpsPayrollEncoder *)encoder;
-(HpsPayRollRequest *)getClientInfoRequest:(HpsPayrollEncoder *)encoder;
-(HpsPayRollRequest *)getCollectionRequestByType :(HpsPayrollEncoder *)encoder withType:(PayRollRequestType) request;

@end
