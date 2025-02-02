/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>


@interface RUAKernelVersionInfo : NSObject

/**
 * Kernel index
 **/
@property NSInteger kernelIndex;

/**
 * Kernel name
 **/
@property NSString* kernelName;

/**
 * Kernel version
 **/
@property NSString* kernelVersion;


-(instancetype)initWithIndex:(NSInteger) kernelIndex kernelName:(NSString *) kernelname kernelVersion:(NSString *) kernelVersion;


@end

