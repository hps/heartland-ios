/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#ifndef RUAReleaseHandler_h
#define RUAReleaseHandler_h

@protocol RUAReleaseHandler <NSObject>

/**
 * Invoked when a device manager releases all the resources it acquired.
 * */
- (void)done;

@end

#endif /* RUAReleaseHandler_h */
