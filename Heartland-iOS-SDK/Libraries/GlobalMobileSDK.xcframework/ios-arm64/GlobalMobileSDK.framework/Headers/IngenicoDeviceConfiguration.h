//
//  IngenicoDeviceConfiguration.h
//  GlobalMobileSDK
//
//  Created by Govardhan Padamata on 9/23/20.
//  Copyright (c) 2020 GlobalPayments. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  enum {
    RUAMobyDeviceTypeMOBY3000,
    RUAMobyDeviceTypeRP450c,
    RUAMobyDeviceTypeRP750x,
    RUAMobyDeviceTypeRP45BT,
    RUAMobyDeviceTypeMOBY8500,
    RUAMobyDeviceTypeMOBY6500,
    RUAMobyDeviceTypeMOBY5500,
    RUAMobyDeviceTypeUnknown
}RUAMobyDeviceType;

@class EMVTerminalConfiguration;

@interface IngenicoDeviceConfiguration : NSObject

- (IngenicoDeviceConfiguration * _Nonnull)initWithproductionMode:(BOOL)productionMode
                                         andDeviceType:(RUAMobyDeviceType)deviceType;

@property int currentPublicKeyIndex;
@property (nonatomic) BOOL initialized;
@property (nonnull,nonatomic) NSString *connectedDeviceSerialNumber;

@property (nonnull) NSArray *contactlessAIDsList; // FIXME: For now its not required
@property (nonnull) NSArray *contactlessAIDsResponseList; // FIXME: For now its not required
@property (nonnull) NSArray *publicKeyList;
@property (nonnull) NSArray *amountDOL;
@property (nonnull) NSArray *contactlessResponseDOL; // FIXME: For now its not required
@property (nonnull) NSArray *contactlessOnlineDOL; // FIXME: For now its not required
@property (nonnull) NSArray *magStripeDOLList;
@property (nonnull) NSArray *aidsList;
@property (nonnull) NSArray *onlineDOL;
@property (nonnull) NSArray *responseDOL;
@property (nonnull) BOOL *productionMode;

@end
