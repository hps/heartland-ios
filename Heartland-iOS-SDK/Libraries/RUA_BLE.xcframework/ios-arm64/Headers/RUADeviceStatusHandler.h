/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */
#import <Foundation/Foundation.h>

#ifndef ROAMreaderUnifiedAPI_RUAStatusHandler_h
#define ROAMreaderUnifiedAPI_RUAStatusHandler_h

@protocol  RUADeviceStatusHandler <NSObject>

/**
 * Invoked when the reader is connected.
 * */
- (void)onConnected;

/**
 * Invoked when the reader is disconnected (unplugged).
 * */
- (void)onDisconnected;

/**
 * Invoked when the reader returns an error while connecting.
 * */
- (void)onError:(NSString *)message;

@optional

- (void)onPlugged;

- (void)onDetectionStarted;

- (void)onDetectionStopped;


@end

#endif
