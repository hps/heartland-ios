//
//  HpsUpaEvent.m
//  Heartland-iOS-SDK
//
//  Created by Desimini, Wilson on 7/1/22.
//

#import "HpsUpaEvent.h"

@interface HpsUpaEvent ()

@property (nonatomic) UPA_MSG_TYPE messageType;
@property (strong, nonatomic) id<IHPSDeviceMessage> sendBody;

@end

@implementation HpsUpaEvent

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
