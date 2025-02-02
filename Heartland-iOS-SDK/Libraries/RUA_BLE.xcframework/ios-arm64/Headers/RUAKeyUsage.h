/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#ifndef RUAKeyUsage_h
#define RUAKeyUsage_h

typedef NS_ENUM(NSInteger, RUAKeyUsage) {
    
    RUAKeyUsagePinEncryption = 0,
    
    RUAKeyUsageMacEncryption = 1,
    
    RUAKeyUsageDataEncryption = 2,
    
    RUAKeyUsageUnknown = 3,
    
};

#endif /* RUAKeyUsage_h */
