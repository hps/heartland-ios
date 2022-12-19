#import <Foundation/Foundation.h>
#import "HpsTerminalResponse.h"
#import "NSObject+ObjectMap.h"
#import "HpsHpaSharedParams.h"
#import "HpsUpaCommandData.h"

@interface HpsUpaRequest : NSObject

@property (nonatomic,retain)NSString* message;
@property (nonatomic,retain)HpsUpaCommandData* data;

-(NSString *)toString;

@end

