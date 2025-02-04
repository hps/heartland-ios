/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#ifndef RUAFirmwareChecksumType_h
#define RUAFirmwareChecksumType_h

typedef NS_ENUM(NSInteger, RUAFirmwareChecksumType) {
    
    /**
     * Passed as parameter for getFirmwareChecksumForType() method
     * to access Static Software Version
     */
    RUAFirmwareChecksumTypeStaticSoftware = 0,
    
    /**
     * Passed as parameter for getFirmwareChecksumForType() method
     * to access Dynamic Configuration Version
     */
    RUAFirmwareChecksumTypeDynamicConfiguration = 1,
    
    RUAFirmwareChecksumTypeUnknown = 2,
    
};

#endif /* RUAFirmwareChecksumType_h */
