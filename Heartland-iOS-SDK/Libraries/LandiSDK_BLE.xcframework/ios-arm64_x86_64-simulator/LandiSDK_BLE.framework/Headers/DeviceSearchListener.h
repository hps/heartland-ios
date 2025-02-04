//
//  DeviceSearchListener.h
//  BLEBaseDriver
//
//  Created by Landi 联迪 - Robert on 13-8-7.
//  Copyright (c) 2013年 Landi 联迪. All rights reserved.
//

#ifndef BLEBaseDriver_DeviceSearchListener_h
#define BLEBaseDriver_DeviceSearchListener_h

#import <Foundation/Foundation.h>
#import "RDeviceInfo.h"
//@class RDeviceInfo;

@protocol DeviceSearchListener <NSObject>

-(void) discoverOneDevice:(RDeviceInfo*)devInfo;
-(void) discoverComplete;
@optional
-(void) discoverUpdatedDevice:(RDeviceInfo*)devInfo;
-(void) discoverComplete:(DeviceCommunicationChannel)channelType;

@end


#endif
