/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */
#import <Foundation/Foundation.h>
#import "RUADevice.h"

#ifndef ROAMreaderUnifiedAPI_RUAReaderSearchListener_h
#define ROAMreaderUnifiedAPI_RUAReaderSearchListener_h

@protocol RUADeviceSearchListener <NSObject>

/**
 * Invoked when a reader is discovered.
 * @param reader RUA device
 * */
- (void)discoveredDevice:(RUADevice *)reader;

/**
 * Invoked when the discover process is complete.
 * */
- (void)discoveryComplete;

@optional
/**
 * Invoked when reader name or RSSI value changes.
 * @param reader RUA device
 * */
- (void)deviceInformationChanged:(RUADevice *)reader;

@end

#endif
