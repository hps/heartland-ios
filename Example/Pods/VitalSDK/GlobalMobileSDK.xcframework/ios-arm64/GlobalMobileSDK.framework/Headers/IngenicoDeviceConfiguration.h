//
//  IngenicoDeviceConfiguration.h
//  GlobalMobileSDK
//
//  Created by Govardhan Padamata on 9/23/20.
//  Copyright (c) 2020 GlobalPayments. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EMVTerminalConfiguration;

@interface IngenicoDeviceConfiguration : NSObject

- (IngenicoDeviceConfiguration * _Nonnull)initWithproductionMode:(BOOL)productionMode;

@property int currentPublicKeyIndex;
@property (nonatomic) BOOL initialized;
@property (nonnull,nonatomic) NSString *connectedDeviceSerialNumber;

@property (nonnull) NSArray *contactlessAIDsList; // FIXME: For now its not required
@property (nonnull) NSArray *publicKeyList;
@property (nonnull) NSArray *amountDOL;
@property (nonnull) NSArray *contactlessResponseDOL; // FIXME: For now its not required
@property (nonnull) NSArray *contactlessOnlineDOL; // FIXME: For now its not required
@property (nonnull) NSArray *aidsList;
@property (nonnull) NSArray *onlineDOL;
@property (nonnull) NSArray *responseDOL;

@end
