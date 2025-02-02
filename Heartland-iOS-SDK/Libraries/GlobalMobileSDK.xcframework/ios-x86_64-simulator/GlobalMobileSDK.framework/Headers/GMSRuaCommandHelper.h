//
//  RuaCommandHelper.h
//  GlobalMobileSDK
//
//  Created by Govardhan Padamata on 10/12/20.
//  Copyright (c) 2020 GlobalPayments. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RUADeviceManager.h>

@class TerminalTender;

@interface GMSRuaCommandHelper : NSObject

+ (NSDictionary *_Nonnull)getEMVStartTransactionParametersForRequest:(TerminalTender * _Nonnull)request
                                                          deviceType:(RUADeviceType)deviceType;

+ (NSDictionary * _Nonnull)getEMVTransactionDataParameters:(NSString * _Nonnull)aidValue
                                                   request:(TerminalTender * _Nonnull) transaction
                                                deviceType:(RUADeviceType)selectedDeviceType;

@end
