/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */


#ifndef RUAApplicationSelectionOption_h
#define RUAApplicationSelectionOption_h

typedef NS_ENUM(NSInteger, RUAApplicationSelectionOption) {
    
    /**
     * Final application selection to be performed by the external device
     */
    RUAApplicationSelectionOptionExternal = 0,
    
    /**
     * Final application selection to be performed by the PIN-Pad (can be overridden using the "EMV Override Application Selection" command).
     */
    RUAApplicationSelectionOptionPinPad = 1,
    
    
};


#endif /* RUAApplicationSelectionOption_h */
