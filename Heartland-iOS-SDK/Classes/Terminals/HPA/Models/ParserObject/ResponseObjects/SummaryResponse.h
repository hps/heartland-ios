#import <Foundation/Foundation.h>

@interface SummaryResponse : NSObject

@property (nonatomic,strong) NSString *authorizedAmount;
@property (nonatomic,strong) NSString *balanceDueAmount;
@property (nonatomic,strong) NSString *count;
@property (nonatomic,strong) NSString *totalAmount;
@property (nonatomic,strong) NSString *summaryType;
@property (nonatomic,strong) NSMutableArray *Records;

@end
