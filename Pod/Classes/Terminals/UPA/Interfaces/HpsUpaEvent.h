//
//  HpsUpaEvent.h
//  Heartland-iOS-SDK
//
//  Created by Desimini, Wilson on 7/1/22.
//

#import <Foundation/Foundation.h>
#import "UpaEnums.h"

@protocol IHPSDeviceMessage;

@interface HpsUpaEvent : NSObject

- (instancetype)initWithMessageType:(UPA_MSG_TYPE)messageType;
- (instancetype)initWithMessageType:(UPA_MSG_TYPE)messageType
                           sendBody:(id<IHPSDeviceMessage>)sendBody;

- (UPA_MSG_TYPE)messageType;
- (id<IHPSDeviceMessage>)sendBody;

@end
