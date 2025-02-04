/*
//////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
//
//////////////////////////////////////////////////////////////////////////////
*/

#ifndef RUAVASResponseCode_h
#define RUAVASResponseCode_h

/** @enum RUAVASResponseCode
 Enumeration of the VAS response code
 */
typedef NS_ENUM (NSInteger, RUAVASResponseCode) {
    /* Success returned by set parameter API like VAS_SetMode*/
    RUAVASResponseCodeSuccess = 0,
    
    /* Error encountered when trying to open contactless driver */
    RUAVASResponseCodeNFCError = 1,
    
    /* Error bad value passed as parameter to API */
    RUAVASResponseCodeBadValue = 2,
    
    /* Error bad length of parameter passed to API */
    RUAVASResponseCodeBadLength = 3,
    
    /* Error encountered when trying to generate the UN via SEC module */
    RUAVASResponseCodeSECError = 4,
    
    /* Timeout reached without detecting any smartphone */
    RUAVASResponseCodeNFCTimeout = 5,
    
    /* Error more than one NFC field are detected */
    RUAVASResponseCodeNFCTooManyCards = 6,
    
    /* Error when making selection (application not found) */
    RUAVASResponseCodeNFCSelectErr = 7,
    
    /* operation canceled by user */
    RUAVASResponseCodeCanceled = 8,
    
    /* Max Mechants Number reached*/
    RUAVASResponseCodeMaxMerchantsNumberReachedErr = 9,
    
    // Success messages
    
    /* Success of the operation get_VAS_data */
    RUAVASResponseCodeSuccessEndOfVAS = 10,
    
    /* Success of the operation get_VAS_data and payment must be performed */
    RUAVASResponseCodeSuccessPayMustBePerformed = 11,
    
    /* Success of the operation get_VAS_data and a user intervention is required on the smartphone */
    RUAVASResponseCodeSuccessUserInterventionRequired = 12,
    
    /* Success of the operation get_VAS_data in mode sign up (the merchant url is correctly sent to the smartphone) */
    RUAVASResponseCodeSuccessSignUpComplete = 13,
    
    /* communication is done, but the mobile capability has a bad value */
    RUAVASResponseCodeErrorBadMobileCapability = 14,
    
    /* the VAS data is not activated on the smartphone */
    RUAVASResponseCodeSuccessVASDataNotActivated = 15,
    
    // Error encountered in selection step
    
    /* Error encountered when trying to start get_VAS_data without setting mandatory fields */
    RUAVASResponseCodeErrorParametersNotSet = 20,
    
    /* Error encountered when trying to launch PLSE */
    RUAVASResponseCodeErrorPLSEFail = 21,
    
    /* Error encountered when trying to launch VAS application selection */
    RUAVASResponseCodeErrorSelectOSEFail = 22,
    
    /* Error returned by the smartphone indicating that P1 and P2 of the selection command was wrong */
    RUAVASResponseCodeErrorSelectWSWrongP1P2 = 23,
    
    /* Error returned by the smartphone indicating that some mandatory parameters are missing */
    RUAVASResponseCodeErrorSelectMandatoryDataMissed = 24,
    
    /* Unknown Error returned by the smartphone (SW) */
    RUAVASResponseCodeErrorSWOther = 25,
    
    /* Error TAG 6F not found in the smartphone response */
    RUAVASResponseCodeErrorTag6F = 26,
    
    /* Error application label not found in the smartphone response */
    RUAVASResponseCodeErrorMissingAppLabel = 27,
    
    /* Error application version not found in the smartphone response */
    RUAVASResponseCodeErrorMissingAppVersionNumber = 28,
    
    /* Error unpredictable number not found in the smartphone response */
    RUAVASResponseCodeErrorMissingUNMobile = 29,
    
    /* Error mobile capabilities not found in the smartphone response */
    RUAVASResponseCodeErrorMissingMobileCapabilities = 30,
    
    /* Error bad format of the mobile capabilities in the smartphone response */
    RUAVASResponseCodeErrorMobileCapabilitiesFormat = 31,
    
    /* Error mobile app version less then 0x0100 */
    RUAVASResponseCodeErrorMobileAppVersion = 32,
    
    // Error encountered in get VAS data step
    
    /* Error VAS data not found in the smartphone response */
    RUAVASResponseCodeErrorVASDataNotFound = 40,
    
    /* Error wrong VAS data format in the smartphone response */
    RUAVASResponseCodeErrorVASDataWrongP2 = 41,
    
    /* Error signup smartphone response is different from 9000 */
    RUAVASResponseCodeErrorVASDataSignUpWrongSW = 42,
    
    /* Error signup smartphone response is not empty */
    RUAVASResponseCodeErrorVASDataSignUpTemplateNotEmpty = 43,
    
    /* Error returned by the smartphone indicating that P1 and P2 of the get VAS data command was wrong */
    RUAVASResponseCodeErrorVASDataWrongP1P2 = 44,
    
    /* Error returned by the smartphone indicating wrong VAS data length */
    RUAVASResponseCodeErrorVASDataWrongLength = 45,
    
    /* Error TAG 6F not found in the smartphone response */
    RUAVASResponseCodeErrorVASDataTag70 = 46,
    
    /* Error bad data format given by the smartphone as response to get VAS data command */
    RUAVASResponseCodeErrorVASDataIncorrectData = 47,
    
    /* Error TAG 9F2A (mobile token) not found in the smartphone response */
    RUAVASResponseCodeErrorVASData9F2AMissing = 48,
    
    /* Error TAG 9F27 (VAS data) not found in the smartphone response*/
    RUAVASResponseCodeErrorVASData9F27Missing = 49,
    
    /* Card is swiped. In this case, you’ll get 2 bytes Length (Big Endian) and
     * encrypted card data after response code. */
    RUAVASResponseCodeSwipeDetected = 101,

    /* EMV Chip Card is inserted, you can proceed with reading this card with appropriate
     * commands or start a transaction. */
    RUAVASResponseCodeChipDetected = 102,

    /* a Key is pressed. You’ll get the key code as 1 byte after response code section. */
    RUAVASResponseCodeKeyboardDetected = 103
};

#endif /* RUAVASResponseCode_h */
