//
//  HpsUPATCPEvent.m
//  Heartland-iOS-SDK
//
//  Created by Desimini, Wilson on 7/1/22.
//

#import "HpsUPATCPEvent.h"

@implementation HpsUPATCPEvent

- (instancetype)initWithMessageType:(UPA_MSG_TYPE)messageType {
    return [self initWithMessageType:messageType sendBody:nil];
}

- (instancetype)initWithMessageType:(UPA_MSG_TYPE)messageType
                           sendBody:(id<IHPSDeviceMessage>)sendBody
{
    self = [super init];
    if (self) {
        _messageType = messageType;
        _sendBody = sendBody;
    }
    return self;
}

@end
