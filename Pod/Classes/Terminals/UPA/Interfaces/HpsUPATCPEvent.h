//
//  HpsUPATCPEvent.h
//  Heartland-iOS-SDK
//
//  Created by Desimini, Wilson on 7/1/22.
//

#import <Foundation/Foundation.h>
#import "UpaEnums.h"

@protocol IHPSDeviceMessage;

@interface HpsUPATCPEvent : NSObject

@property (nonatomic) UPA_MSG_TYPE messageType;
@property (strong, nonatomic) id<IHPSDeviceMessage> sendBody;

- (instancetype)initWithMessageType:(UPA_MSG_TYPE)messageType;
- (instancetype)initWithMessageType:(UPA_MSG_TYPE)messageType
                           sendBody:(id<IHPSDeviceMessage>)sendBody;

@end
