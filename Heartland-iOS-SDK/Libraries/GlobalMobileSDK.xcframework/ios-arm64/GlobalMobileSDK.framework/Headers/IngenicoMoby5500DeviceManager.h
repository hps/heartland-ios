//
//  IngenicoMoby5500DeviceManager.h
//  GlobalMobileSDK
//
//  Created by Renato Santos on 03/09/2024.
//  Copyright © 2024 GlobalPayments. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IngenicoEnums.h"
#import "IngenicoDeviceManager.h"

@class RUATerminalConfig;
@class Device;
@class AID;
@class TerminalTender;
@class HostTenderResponse;

@protocol IngenicoMoby5500DeviceManagerDelegate <NSObject>

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

@interface IngenicoMoby5500DeviceManager : NSObject <IngenicoMethods>

@end
