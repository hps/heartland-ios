/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>

@interface RUAReaderVersionInfoExt : NSObject

/**
 * Contact reader application
 * */
@property NSString *contactReaderApplication;

/**
 * Contactless reader application
 **/
@property NSString *contactlessReaderApplication;;

/**
 * L1 hardware name
 **/
@property NSString *hardwareNameL1;

/**
 * L1 hardware version
 **/
@property NSString *hardwareVersionL1;

/**
 * L1 software name
 **/
@property NSString *softwareNameL1;

/**
 * L1 software version
 **/
@property NSString *softwareVersionL1;

/**
 * L2 software name
 **/
@property NSString *softwareNameL2;

/**
 * L2 software version
 **/
@property NSString *softwareVersionL2;

/**
 * Kernel Information
 * @see RUAKernelVersionInfo
 **/
@property NSArray *kernelInfo;

/**
 * PED version
 **/
@property NSString *pedVersion;

/**
 * Hardware type
 **/
@property NSString *hardwareType;

/**
 * Device type
 **/
@property NSString *deviceType;


- (instancetype) initWithData:(NSData *) data;

- (NSString *) toString;


@end
