//  Copyright (c) 2016 Heartland Payment Systems. All rights reserved.

#import <Foundation/Foundation.h>
#import "HpsDeviceProtocols.h"


@interface HpsDeviceMessage : NSObject <IHPSDeviceMessage>
{
    NSData *_buffer;
}

- (NSData*) getSendBuffer;

- (id) initWithBuffer:(NSData*)buffer;
- (NSString*) toString;
@end
