/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */
#ifndef RUAFirmwareType_h
#define RUAFirmwareType_h

typedef NS_ENUM(NSInteger, RUAFirmwareType) {
    
    /**
     * Passed as parameter for setFirmwareType() and getFirmwareVersionStringForType() methods
     * to access Overall Firmware Version
     */
    RUAFirmwareTypeOverallFirmware = 0,
    
    /**
     * Passed as parameter for setFirmwareType() and getFirmwareVersionStringForType() methods
     * to access Static Software Version
     */
    RUAFirmwareTypeStaticSoftware = 1,
    
    /**
     * Passed as parameter for setFirmwareType() and getFirmwareVersionStringForType() methods
     * to access Dynamic Configuration Version
     */
    RUAFirmwareTypeDynamicConfiguration = 2,
    
    RUAFirmwareTypeUnknown = 3,
    
};

#endif /* RUAFirmwareType_h */
