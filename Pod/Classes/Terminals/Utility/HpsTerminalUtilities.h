#import <Foundation/Foundation.h>
#import "HpsDeviceProtocols.h"
#import "HpsDeviceMessage.h"
#import "HpsTerminalEnums.h"
#import "HpaEnums.h"

@interface HpsTerminalUtilities : NSObject
{
     NSString *_version;
}

+ (HpsDeviceMessage*) buildRequest: (NSString*) messageId;
+ (HpsDeviceMessage*) buildRequest: (NSString*) messageId withElements:(NSArray*)elements;
+ (NSData *)trimHpsResponseData:(NSData *)data;
+ (id <IHPSDeviceMessage>) BuildRequest:(NSString *) message withFormat:(MessageFormat)format;

@end
