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

@protocol IngenicoMethods <NSObject>
@required
- (nonnull instancetype)initWithConfig:(nonnull RUATerminalConfig *)terminalConfig
                           autoConnect:(BOOL)autoconnect
                              delegate:(nonnull id <IngenicoDeviceManagerDelegate>)delegate;
@required
- (void)scanForDevices;
@required
- (void)cancelSearch;
@required
- (void)connect:(nonnull Device *)device;
@required
- (void)disconnect;
@required
- (void)batteryLevel;
@required
- (void)startWithTender:(nonnull TerminalTender *)tender;
@required
- (void)confirmAmount:(BOOL)confirmed;
@required
- (void)selectedAID:(nonnull AID *)aid;
@required
- (void)sendOnlineProcessingResult:(nonnull HostTenderResponse *)onlineResult;
@required
- (void)cancelTransaction;
@end

@interface IngenicoDeviceManager : NSObject <IngenicoMethods>

@end
