//
//  DeviceInfo.h
//  BLEBaseDriver
//
//  Created by Landi 联迪 on 13-8-28.
//  Copyright (c) 2013年 Landi 联迪. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, DeviceCommunicationChannel){
    AUDIOJACK = 1 << 0,
    BLUETOOTH = 1 << 1,
    MFIBLUETOOTH = 1 << 2,
    MFIUSB = 1 << 3,
    ANYDEVICETYPE = 0xFFFFFFFF,
};

#define VALID_CHANNEL_TYPE_BITMAP   (AUDIOJACK | BLUETOOTH | MFIBLUETOOTH | MFIUSB)

typedef enum _enumExtendDataKeyOfDeviceInfo{
    LD_ExtendData_KEY_RSSI, // Obtain the RSSI when discover the peripheral at first time. Value: NSInteger
}LD_ExtendDataKeyOfDeviceInfo;

@interface RDeviceInfo : NSObject

-(id)initWithName:(NSString*)name identifier:(NSString*)identifier channel:(DeviceCommunicationChannel)dcc;
-(NSString*)getName;
-(NSString*)getIdentifier;
-(DeviceCommunicationChannel)getDevChannel;
-(NSDictionary*)getExtendData;

@end
