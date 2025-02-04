/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import <UIKit/UIKit.h>
#import "RUAFileVersionInfo.h"

@interface RUAReaderVersionInfo : NSObject

/**
 * Hardware Type
 * */
@property NSString *hardwareType;

/**
 * Boot File Version
 * */
@property RUAFileVersionInfo *bootFileVersion;

/**
 * Control File Version
 * */
@property RUAFileVersionInfo *controlFileVersion;

/**
 * List User File Versions
 * */
@property NSArray *userFileVersions;

/**
 * List Parameter File Versions
 * */
@property NSArray *parameterFileVersions;

/**
 * EMV Kernel Version
 * */
@property NSString *emvKernelVersion;

/**
 * Key Version
 * */
@property NSString *keyVersion;

/**
 * PED Version
 * */
@property NSString *pedVersion;

/**
 * Font File Version String
 * */
@property NSString *fontFileVersion;

/**
 * Font File Version Major
 * */
@property NSString *fontFileVersionMajor;

/**
 * Font File Version Minor
 * */
@property NSString *fontFileVersionMinor;

/**
 * Product Serial Number
 * */
@property NSString *productSerialNumber;

/**
 * Bluetooth Mac Address
 * */
@property NSString *bluetoothMacAddress;

- (NSString *) toString;

- (RUAFileVersionInfo*) getFileVerionsInfoFor:(RUAFileVersionInfo*)info;

+ (RUAReaderVersionInfo *)fromString:(NSString *)input;

@end
