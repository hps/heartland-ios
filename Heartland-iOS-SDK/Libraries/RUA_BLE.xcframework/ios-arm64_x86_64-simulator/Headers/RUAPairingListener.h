/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>
#import "RUALedPairingConfirmationCallback.h"

/**
 * Interface definition for callback methods to be invoked
 * during the process of pairing a Bluetooth card reader via audio jack or USB. <br>
 * Currently only supported by the RP450c device manager (audiojack), MOBY8500 device manager (USB) and MOBY5500 device manager (BT LED).
 */


#ifndef ROAMreaderUnifiedAPI_RUAPairingListener_h
#define ROAMreaderUnifiedAPI_RUAPairingListener_h

@protocol RUAPairingListener <NSObject>

/**
 * Called to indicate that the pairing process has successfully completed.
 */

- (void)onPairSucceeded;

/**
 * Called to indicate that the device manager does not support audio jack or USB pairing.
 */
- (void) onPairNotSupported;

/**
 * Called to indicate that the pairing process failed.
 */
- (void) onPairFailed;

@optional

/**
 * Called during the pairing process to let the application display
 * the reader and mobile passkeys.
 */

- (void)onPairConfirmation:(NSString *)readerPasskey mobileKey:(NSString *) mobilePasskey;

/**
 * Called during the pairing process to let the application display
 * the reader and mobile passkeys along with RUADevice Object.
 */
- (void)onPairConfirmation:(NSString *)readerPasskey mobileKey:(NSString *) mobilePasskey device:(RUADevice*)device;

/**
 * Called to indicate that the pairing process has successfully completed.
 */

- (void)onPairSucceeded:(RUADevice*)device;


/**
 * Called during the pairing process to let the application display the LED Sequence to the user for confirmation.
 * <br>
 * The application should resume the pairing process by calling [confirmationCallback confirm] once the user confirm whether or not the LED sequence matches with that shown on the card reader.
 */
-(void)onLedPairSequenceConfirmation:(NSArray *)ledSequence confirmationCallback:(id<RUALedPairingConfirmationCallback>)confirmationCallback;

/**
 * Called to indicate that the pairing process is canceled.
 */

-(void)onPairCancelled;

@end

#endif


