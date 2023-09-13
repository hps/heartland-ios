//
//  IngenicoDeviceManager.h
//  GlobalMobileSDK
//
//  Created by Govardhan Padamata on 9/18/20.
//  Copyright (c) 2020 GlobalPayments. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IngenicoEnums.h"

@class RUATerminalConfig;
@class Device;
@class AID;
@class TerminalTender;
@class HostTenderResponse;

@protocol IngenicoDeviceManagerDelegate <NSObject>

- (void)devicesFound:(nullable NSArray<Device *> *)devices;
- (void)deviceError:(nonnull NSError *)error;
- (void)deviceConnected;
- (void)deviceDisconnected;
- (void)onDeviceConfigurationProgress:(int)completed
                               total:(int)progressTotal
                             isFailed:(BOOL)isFailed;
- (void)onTranasctionStatus:(ProgressMessage)status
       withIngenicoResponse:(nullable TerminalTender *)response;
- (void)selectAid:(nonnull NSArray<AID *> *)aids;
- (void)trasactionError:(nonnull NSError *)error;

@end

@interface IngenicoDeviceManager : NSObject

- (nonnull instancetype)initWithConfig:(nonnull RUATerminalConfig *)terminalConfig
                           autoConnect:(BOOL)autoconnect
                              delegate:(nonnull id <IngenicoDeviceManagerDelegate>)delegate;

- (void)scanForDevices;
- (void)cancelSearch;
- (void)connect:(nonnull Device *)device;
- (void)disconnect;
- (void)batteryLevel;
- (void)startWithTender:(nonnull TerminalTender *)tender;
- (void)confirmAmount:(BOOL)confirmed;
- (void)selectedAID:(nonnull AID *)aid;
- (void)sendOnlineProcessingResult:(nonnull HostTenderResponse *)onlineResult;
- (void)cancelTransaction;

@end
