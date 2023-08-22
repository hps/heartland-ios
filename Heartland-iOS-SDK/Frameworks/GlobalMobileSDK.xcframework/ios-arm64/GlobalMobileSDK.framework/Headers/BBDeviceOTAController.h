//
//  BBDeviceOTAController.h
//
//  Created by Alex Wong on 2017-08-18.
//  Copyright © 2021 BBPOS International Limited. All rights reserved. All software, both binary and source code published by BBPOS International Limited (hereafter BBPOS) is copyrighted by BBPOS and ownership of all right, title and interest in and to the software remains with BBPOS.
//  RESTRICTED DOCUMENT
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSUInteger, BBDeviceOTAState) {
    BBDeviceOTAState_Idle,
    BBDeviceOTAState_Busy
};

typedef NS_ENUM (NSUInteger, BBDeviceOTAResult) {
    BBDeviceOTAResult_Success,
    BBDeviceOTAResult_SetupError, 
    BBDeviceOTAResult_BatteryLowError,
    BBDeviceOTAResult_DeviceCommError,
    BBDeviceOTAResult_ServerCommError,
    BBDeviceOTAResult_Failed,
    BBDeviceOTAResult_Stopped,
    BBDeviceOTAResult_NoUpdateRequired,
    BBDeviceOTAResult_InvalidControllerStateError,
    BBDeviceOTAResult_IncompatibleFirmwareHex,
    BBDeviceOTAResult_IncompatibleConfigHex
};

typedef NS_ENUM (NSUInteger, BBDeviceFirmwareType) {
    BBDeviceFirmwareType_MainProcessor,
    BBDeviceFirmwareType_Coprocessor
}; //For WisePad 1 only

typedef NS_ENUM (NSUInteger, BBDeviceConfigType) {
    BBDeviceConfigType_FirmwareConfig, // Complete firmware configs
    BBDeviceConfigType_CustomizedConfig  // Terminal ID (9F1C), Terminal Country Code (9F1A), Transaction Currency Code (5F2A), Merchant Name and Location (9F4E), Merchant ID (9F16)
}; //For WisePad 1 only

typedef NS_ENUM (NSUInteger, BBDeviceTargetVersionType) {
    BBDeviceTargetVersionType_Firmware,
    BBDeviceTargetVersionType_Config,
    BBDeviceTargetVersionType_KeyProfile
};

typedef NS_ENUM (NSUInteger, BBDeviceOTADebugLogType) {
    BBDeviceOTADebugLogType_Function,
    BBDeviceOTADebugLogType_Callback,
    BBDeviceOTADebugLogType_ExtraDebugMessage,
};

@protocol BBDeviceOTAControllerDelegate;

@interface BBDeviceOTAController : NSObject{
    id <BBDeviceOTAControllerDelegate> delegate;
    BOOL debugLogEnabled;
}
@property (nonatomic, weak) id <BBDeviceOTAControllerDelegate> delegate;
@property (nonatomic, getter=isDebugLogEnabled, setter=setDebugLogEnabled:) BOOL debugLogEnabled;

+ (BBDeviceOTAController *)sharedController;

- (BBDeviceOTAState)getBBDeviceOTAState;
- (BOOL)setBBDeviceController:(NSObject *)controller;
- (BOOL)setOTAServerURL:(NSURL *)url;

- (NSString *)getApiVersion;
- (NSString *)getApiBuildNumber;

- (void)startRemoteKeyInjectionWithData:(NSDictionary *)data;
- (void)startRemoteFirmwareUpdateWithData:(NSDictionary *)data;
- (void)startRemoteConfigUpdateWithData:(NSDictionary *)data;

- (void)startLocalFirmwareUpdateWithData:(NSDictionary *)data;
- (void)startLocalConfigUpdateWithData:(NSDictionary *)data;

- (void)stop;

// Get/Set Single TargetVersion
- (void)getTargetVersionWithData:(NSDictionary *)data;
- (void)setTargetVersionWithData:(NSDictionary *)data;

// Get Multiple TargetVersion
- (void)getTargetVersionListWithData:(NSDictionary *)data;

@end

@protocol BBDeviceOTAControllerDelegate <NSObject>

@optional

- (void)onReturnRemoteKeyInjectionResult:(BBDeviceOTAResult)result responseMessage:(NSString *)responseMessage;
- (void)onReturnRemoteFirmwareUpdateResult:(BBDeviceOTAResult)result responseMessage:(NSString *)responseMessage;
- (void)onReturnRemoteConfigUpdateResult:(BBDeviceOTAResult)result responseMessage:(NSString *)responseMessage;

- (void)onReturnLocalFirmwareUpdateResult:(BBDeviceOTAResult)result responseMessage:(NSString *)responseMessage;
- (void)onReturnLocalConfigUpdateResult:(BBDeviceOTAResult)result responseMessage:(NSString *)responseMessage;

// Get/Set Single TargetVersion
- (void)onReturnTargetVersionResult:(BBDeviceOTAResult)result data:(NSDictionary *)data;
- (void)onReturnSetTargetVersionResult:(BBDeviceOTAResult)result responseMessage:(NSString *)responseMessage;
// Get Multiple TargetVersion
- (void)onReturnTargetVersionListResult:(BBDeviceOTAResult)result list:(NSArray *)list responseMessage:(NSString *)responseMessage;

- (void)onReturnOTAProgress:(float)percentage;
- (void)onReturnOTADebugLog:(NSDictionary *)data;

@end















