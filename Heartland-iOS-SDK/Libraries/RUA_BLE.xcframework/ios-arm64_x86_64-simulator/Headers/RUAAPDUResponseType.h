/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */
#ifndef RUAAPDUResponseType_h
#define RUAAPDUResponseType_h

typedef NS_ENUM(NSInteger, RUAAPDUResponseType) {
    
    /**
     * APDU answer will be returned in clear
     */
    RUAAPDUResponseTypeClear = 0,
    
    /**
     * APDU answer encrypted with ROAM Encryption
     */
    RUAAPDUResponseTypeRoamEncryption = 1,
    
    /**
     * APDU answer encrytped with OnGuard
     */
    RUAAPDUResponseTypeOnGuardEncryption = 2,
    
};

#endif /* RUAAPDUResponseType_h */
