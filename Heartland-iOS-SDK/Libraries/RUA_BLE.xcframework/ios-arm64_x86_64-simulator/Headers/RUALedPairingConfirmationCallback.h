/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */


#ifndef RUALedPairingConfirmationCallback_h
#define RUALedPairingConfirmationCallback_h

@protocol RUALedPairingConfirmationCallback <NSObject>

/**
 * This method restarts the LED sequence on the card reader and triggers the method
 */
-(void) restartLedPairingSequence;

/**
 * Invoking this method indicates that LED pairing sequence is confirmed by the user.
 */
-(void) confirm;

/**
 * Invoking this method cancels the pairing process.
 */
-(void) cancel;

@end
#endif /* RUALedPairingConfirmationCallback_h */
