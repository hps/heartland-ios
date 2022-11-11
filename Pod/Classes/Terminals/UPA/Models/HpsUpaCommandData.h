#import "HpsUpaData.h"

@interface HpsUpaCommandData : NSObject
@property (nonatomic,retain)NSString* command;
@property (nonatomic,retain)NSString* EcrId;
@property (nonatomic,retain)NSString* requestId;
@property (nonatomic,retain)HpsUpaData* data;
@end
