/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>
#import "RUATransactionManager.h"
#import "RUADevice.h"
#import "RUAParameter.h"
#import "RUACommand.h"
#import "RUADeviceManager.h"
#import "RUAResponse.h"
#import "RUASystemLanguageHelper.h"
#import "RUACardInsertionStatus.h"
#import "RUACardPresentInRFFieldStatus.h"
#import "RUAMSRFormat.h"



enum PosEntryMode{
    Unknown = 0x00,
    Manual = 0x01,
    Magstrip = 0x02,
    Barcode = 0x03,
    OCR = 0x04,
    IntegratedCircuitCardWithCCV = 0x05,
    AutoEntryViaContactlessEMV = 0x07,
    FallbackToMagneticStripe = 0x80,
    MagnetictripeAsReadFromTrack2 = 0x90,
    AutoEntryViaContactlessMagneticStrip = 0x91,
    IntegratedCircuitCardWithoutCCV = 0x95,
    SameAsOriginalTransaction = 0x99
};

enum FallbackReason{
    Normal = 0x00,
    ChipPoweredNotResponding = 0x01,
    NoMutuallySupportedApplication = 0x02,
    FailedReadChipData = 0x03,
    MandatoryWithoutData = 0x04,
    CVMCommandResponseFailed = 0x05,
    EMVCommandSetIncorrectly = 0x06,
    TerminalMalfunction = 0x07
};

@interface RUAEnumerationHelper : NSObject

/**
 Converts string to enum
 @param strVal String value of the Card Type
 @return RUACardType enumeration
 */
+ (RUACardType)RUACardType_toEnumeration:(NSString *)strVal;

/**
 Converts enum to string
 @param cardType RUACardType enumeration
 @return String value of the Card Type
 */
+ (NSString *)RUACardType_toString:(RUACardType)cardType;

/**
 Converts string to enum
 @param strVal String value of the command
 @return RUACommand enumeration
 */
+ (RUACommand)RUACommand_toEnumeration:(NSString *)strVal;

/**
 Converts enum to string
 @param command RUACommand enumeration
 @return String value of the command
 */
+ (NSString *)RUACommand_toString:(RUACommand)command;

+ (NSString *)RUADisplayPredifenedScreen_toString:(RUADisplayPredifenedScreen)screenId;

+ (NSString *)RUAPairingBluetoothMode_toString:(RUAPairingBluetoothMode)bluetoothMode;

/**
 Converts string to enum
 @param strVal String value of the device type
 @return RUADeviceType enumeration
 */
+ (RUADeviceType)RUAReaderType_toEnumeration:(NSString *)strVal;

/**
 Converts enum to string
 @param language RUASystemLanguage enum
 @return String value of the language
 */
+ (NSString *)RUASystemLanguage_toString:(RUASystemLanguage)language;

/**
 Converts string to enum
 @param String value of the language
 @return language RUASystemLanguage enum
 */
+ (RUASystemLanguage)RUASystemLanguage_toEnumeration:(NSString *)strVal;
    
/**
 Converts enum to string
 @param readerType RUADeviceType enumeration
 @return String value of the device type
 */
+ (NSString *)RUADeviceType_toString:(RUADeviceType)readerType;

/**
 Converts string to enum
 @param strVal String value of the communication interface type
 @return RUACommunicationInterface enumeration
 @see RUACommunicationInterface
 */
+ (RUACommunicationInterface)RUACommunicationInterface_toEnumeration:(NSString *)strVal;

/**
 Converts enum to string
 @param interface RUACommunicationInterface enumeration
 @return String value of the communication interface type
 @see RUACommunicationInterface
 */
+ (NSString *)RUACommunicationInterface_toString:(RUACommunicationInterface)interface;

/**
 Converts string to enum
 @param strVal String value of the response code
 @return RUAResponseCode enumeration
 @see RUAResponseCode
 */
+ (RUAResponseCode)RUAResponseCode_toEnumeration:(NSString *)strVal;

/**
 Converts enum to string
 @param code RUAResponseCode enumeration
 @return String value of the response code
 @see RUAResponseCode
 */
+ (NSString *)RUAResponseCode_toString:(RUAResponseCode)code;

/**
 Converts string to enum
 @param strVal String value of the error code
 @return RUAErrorCode enumeration
 @see RUAErrorCode
 */
+ (RUAErrorCode)RUAErrorCode_toEnumeration:(NSString *)strVal;

/**
 Converts enum to string
 @param code RUAErrorCode enumeration
 @return String value of the error code
 @see RUAErrorCode
 */
+ (NSString *)RUAErrorCode_toString:(RUAErrorCode)code;

/**
 Converts string to enum
 @param strVal String value of the parameter
 @return RUAParameter parameter
 @see RUAParameter
 */
+ (RUAParameter)RUAParameter_toEnumeration:(NSString *)strVal;

/**
 Converts enum to string
 @param code RUAParameter enumeration
 @return String value of the parameter
 @see RUAParameter
 */
+ (NSString *)RUAParameter_toString:(RUAParameter)code;

/**
 Converts string to enum
 @param strVal String value of the parameter
 @return RUAResponseType parameter
 @see RUAResponseType
 */
+ (RUAResponseType)RUAResponseType_toEnumeration:(NSString *)strVal;

/**
 Converts enum to string
 @param code RUAResponseType enumeration
 @return String value of the parameter
 @see RUAResponseType
 */
+ (NSString *)RUAResponseType_toString:(RUAResponseType)code;


/**
 Converts enum to string
 @param message RUAProgressMessage enumeration
 @return String value of the parameter
 @see RUAProgressMessage
 */
+ (NSString *)RUAProgressMessage_toString:(RUAProgressMessage)message;

/**
 Converts enum to string
 @param status RUACardInsertionStatus enumeration
 @return String value of the parameter
 @see RUACardInsertionStatus
 */
+ (NSString *)RUACardInsertionStatus_toString:(RUACardInsertionStatus)status;

+ (NSString *)RUACardInsertionStatusCardType_toString:(RUACardInsertionStatusType)cardType;

/**
 Converts enum to string
 @param code RUALanguageCode enumeration
 @return String value of the ISO639 language code
 @see RUALanguageCode
 */
+ (NSString *)RUALanguageCode_toISO639LanguageCodeString:(RUALanguageCode)code;

/**
 Converts enum to string
 @param status RUACardPresentInRFFieldStatus enumeration
 @return String value of the parameter
 @see RUACardPresentInRFFieldStatus
 */
+ (NSString *)RUACardPresentInRFFieldStatus_toString:(RUACardPresentInRFFieldStatus)status;

+ (NSString *)RUALanguageCode_getSupportedLanguagesHexString:(NSOrderedSet *)supportedLanguages
                               defaultMerchantLanguage:(RUALanguageCode)defaultMerchantLanguage;

/**
 Converts enum to string
 @param mode RUAE2EEMode enumeration
 @return String value of the parameter
 @see RUAE2EEMode
 */
+ (NSString *)RUAE2EEMode_toString:(RUAE2EEMode)mode;

/**
 Converts enum to string
 @param encryptionType RUAEncryptionPANEndType enumeration
 @return String value of the parameter
 @see RUAEncryptionPANEndType
 */
+ (NSString *)RUAEncryptionPANEndType_toString:(RUAEncryptionPANEndType)encryptionType;

/**
 Converts enum to string
 @param encryptionType RUAEncryptionType enumeration
 @return String value of the parameter
 @see RUAEncryptionType
 */
+ (NSString *)RUAEncryptionType_toString:(RUAEncryptionType)encryptionType;

/**
 Converts enum to string
 @param padding RUAPaddingType enumeration
 @return String value of the parameter
 @see RUAPaddingType
 */
+ (NSString *)RUAPaddingType_toString:(RUAPaddingType)padding;

/**
 Converts enum to string
 @param format RUAMSRFormat enumeration
 @return String value of the parameter
 @see RUAMSRFormat
 */
+ (NSString *)RUAMSRFormat_toString:(RUAMSRFormat)format;

@end
