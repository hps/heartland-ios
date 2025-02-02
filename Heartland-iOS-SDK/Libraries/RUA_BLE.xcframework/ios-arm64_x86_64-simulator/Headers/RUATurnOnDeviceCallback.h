/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */
#import <Foundation/Foundation.h>

#ifndef RUATurnOnDeviceCallback_h
#define RUATurnOnDeviceCallback_h

@protocol  RUATurnOnDeviceCallback <NSObject>
/**
 * Invoked when device is successfully turned on
 */
- (void)success;

/**
 * Invoked when device cannot be turned on
 *
 * @param errorMessage Error Message
 */
- (void)failed:(NSString *)errorMessage;

/**
 * Invoked if the selected device manager doesn't support the API
 */
- (void)notSupported;

@end
#endif /* RUATurnOnDeviceCallback_h */
