/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>

typedef enum {
    RUALanguageCodeENGLISH = 0,
    RUALanguageCodeFRENCH = 1,
    RUALanguageCodeCHINESE = 2,
    RUALanguageCodeSPANISH = 3,
    RUALanguageCodePORTUGUESE = 4,
    RUALanguageCodeGERMAN = 5,
    RUALanguageCodeDUTCH = 6,
    RUALanguageCodeITALIAN = 7,
    RUALanguageCodeRUSSIAN = 8,
    RUALanguageCodePOLISH = 9,
    RUALanguageCodeSWEDISH = 10
}RUALanguageCode;

typedef NS_ENUM(NSInteger, RUAPinByPassOption) {
    RUAPinByPassOptionDefault = 0,
    RUAPinByPassOptionNotAllowed = 1,
    RUAPinByPassOptionAllowedEnterKey = 2,
    RUAPinByPassOptionAllowedRedKey = 3
};

typedef enum{
    /** All data requested (swiped or keyed) */
    RUAKeyedDataAllDataSwipeOrKeyed = 0,
    
    /** All data requested except cvv (swiped or keyed)*/
    RUAKeyedDataExceptCVVSwipeOrKeyed = 1,
    
    /** All data requested except cvv (swiped or keyed or chip)*/
    RUAKeyedDataExceptCVVChipOrSwipeOrKeyed = 2,
    
    /** Request only CVV; Must immediately follow KeyedData = ExceptCVVSwipeOrKeyed or
     KeyedData = ExceptCVVChipOrSwipeOrKeyed command*/
    RUAKeyedDataOnlyCVV = 3,
    
    /** Request only CVV with 4 digits allowed; Must immediately follow KeyedData = ExceptCVVSwipeOrKeyed or
     KeyedData = ExceptCVVChipOrSwipeOrKeyed command*/
    RUAKeyedDataOnlyCVVFourDigitsAllowed = 4,
    
    /** All data requested (keyed only) */
    RUAKeyedDataAllDataKeyedOnly = 5,
    
    /** All data requested except cvv (keyed only)*/
    RUAKeyedDataExceptCVVKeyedOnly = 6,
    
    /** All data requested except CVV (swipe only) */
    RUADataAllExceptCCVSwipe = 7,
    
    /** All data requested except CVV (insert only) */
    RUADataAllExceptCCVInsert = 8,
    
    /** All data requested except CVV (swipe or insert) */
    RUADataAllExceptCCVSwipeOrInsert = 9,
    
    /** All data requested except CVV (insert or keyed) */
    RUADataAllExceptCCVInsertOrKeyed = 10,
    
    RUAKeyedDataUnknown = 0
}RUAKeyedData;

/**
 * KeyPadControl provides interface to control the keypad of ROAM device.<br>
 * @author rkondaveti
 */
@protocol RUAKeypadControl <NSObject>
/**
 * This methods sends the command to keypad to set click duration and click frequency. <br>
 * @param clickDuration                 Click duration
 * @param clickFrequnecy                Click frequency
 * @param response                      OnResponse block
 */
- (void)setClickFrequency:(int)clickDuration frequency:(int)clickFrequnecy response:(OnResponse _Nonnull)response;

/**
 * This methods sends the command to keypad to prompt for PIN with TDES DUKPT ISO PIN Block encryption. <br>
 * When the reader processes the command, it returns the result as a map to
 * the callback method onResponse on the DeviceResponseHandler passed.<br>
 * The map passed to the onResponse callback contains the following
 * parameters as keys, <br>
 * - Parameter.ResponseCode (ResponseCode enumeration as value)<br>
 * - Parameter.ErrorCode (if not successful, ErrorCode enumeration as value)<br>
 * - Parameter.EncryptedIsoPinBlock<br>
 * - Parameter.KSN<br>
 * @param languageCode                  Language code
 * @param pinBlockFormat                Pin block format
 * @param keyLocator                    Key locator
 * @param cardLast4Digits               Last four digits of the card
 * @param macData                       Mac data
 * @param clearOnlyLastDigitEntered     BOOL describes, if only the last digit entered is cleared
 * @param interDigitTimeout             Inter digit timeout
 * @param response                      OnResponse block
 */
- (void)promptPinTDESBlockWithEncryptedPAN:(RUALanguageCode)languageCode pinBlockFormat:(NSString * _Nonnull)pinBlockFormat keyLocator:(NSString * _Nonnull)keyLocator
                           cardLast4Digits:(NSString * _Nonnull)cardLast4Digits macData:(NSString * _Nullable)macData clearOnlyLastDigitEntered:(BOOL)clearOnlyLastDigitEntered
                         interDigitTimeout:(int)interDigitTimeout response:(OnResponse _Nonnull)response;

/**
 * This methods sends the command to keypad to prompt for PIN with TDES DUKPT ISO PIN Block encryption. <br>
 * When the reader processes the command, it returns the result as a map to
 * the callback method onResponse on the DeviceResponseHandler passed.<br>
 * The map passed to the onResponse callback contains the following
 * parameters as keys, <br>
 * - Parameter.ResponseCode (ResponseCode enumeration as value)<br>
 * - Parameter.ErrorCode (if not successful, ErrorCode enumeration as value)<br>
 * - Parameter.EncryptedIsoPinBlock<br>
 * - Parameter.KSN<br>
 * @param languageCode                  Language code
 * @param pinBlockFormat                Pin block format
 * @param keyLocator                    Key locator
 * @param cardLast4Digits               Last four digits of the card
 * @param macData                       Mac data
 * @param clearOnlyLastDigitEntered     BOOL describes, if only the last digit entered is cleared
 * @param interDigitTimeout             Inter digit timeout
 * @param pinByPassOption               RUAPinByPassOption
 * @param response                      OnResponse block
 */
- (void)promptPinTDESBlockWithEncryptedPAN:(RUALanguageCode)languageCode pinBlockFormat:(NSString * _Nonnull)pinBlockFormat keyLocator:(NSString * _Nonnull)keyLocator cardLast4Digits:(NSString * _Nonnull)cardLast4Digits macData:(NSString * _Nullable)macData clearOnlyLastDigitEntered:(BOOL)clearOnlyLastDigitEntered interDigitTimeout:(int)interDigitTimeout pinByPassOption: (RUAPinByPassOption) pinByPassOption response:(OnResponse _Nonnull)response;

/**
* This methods sends the command to keypad to prompt for PIN with TDES DUKPT ISO PIN Block encryption after a card swipe. This method only applies to reader with On Guard firmware.<br>
* When the reader processes the command, it returns the result as a map to
* the callback method onResponse on the DeviceResponseHandler passed.<br>
* The map passed to the onResponse callback contains the following
* parameters as keys, <br>
* - Parameter.ResponseCode (ResponseCode enumeration as value)<br>
* - Parameter.ErrorCode (if not successful, ErrorCode enumeration as value)<br>
* - Parameter.EncryptedIsoPinBlock<br>
* - Parameter.KSN<br>
* @param languageCode                  Language code
* @param pinBlockFormat                Pin block format
* @param keyLocator                    Key locator
* @param macData                       Mac data
* @param clearOnlyLastDigitEntered     BOOL describes, if only the last digit entered is cleared
* @param interDigitTimeout             Inter digit timeout
* @param pinByPassOption               RUAPinByPassOption
* @param response                      OnResponse block
*/
- (void)promptPinTDESBlockWithOnGuardEncryptedPAN:(RUALanguageCode)languageCode pinBlockFormat:(NSString * _Nonnull)pinBlockFormat keyLocator:(NSString * _Nonnull)keyLocator macData:(NSString * _Nullable)macData clearOnlyLastDigitEntered:(BOOL)clearOnlyLastDigitEntered interDigitTimeout:(int)interDigitTimeout pinByPassOption:(RUAPinByPassOption)pinByPassOption response:(OnResponse _Nonnull)response;

/**
 * This methods sends the command to keypad to prompt for PIN with Master and session key encryption. <br>
 * When the reader processes the command, it returns the result as a map to
 * the callback method onResponse on the DeviceResponseHandler passed.<br>
 * The map passed to the onResponse callback contains the following
 * parameters as keys, <br>
 * - Parameter.ResponseCode (ResponseCode enumeration as value)<br>
 * - Parameter.ErrorCode (if not successful, ErrorCode enumeration as value)<br>
 * - Parameter.EncryptedIsoPinBlock<br>
 * - Parameter.KSN<br>
 * @param languageCode                  Language code
 * @param pinBlockFormat                Pin block format
 * @param keyLocator                    Key locator
 * @param cardLast4Digits               Last four digits of the card
 * @param clearOnlyLastDigitEntered     BOOL describes, if only the last digit entered is cleared
 * @param interDigitTimeout             Inter digit timeout
 * @param response                      OnResponse block
 */
- (void)promptPinMasterSessionKeyWithEncryptedPAN:(RUALanguageCode)languageCode pinBlockFormat:(NSString * _Nonnull)pinBlockFormat keyLocator:(NSString * _Nonnull)keyLocator
                                  cardLast4Digits:(NSString * _Nonnull)cardLast4Digits clearOnlyLastDigitEntered:(BOOL)clearOnlyLastDigitEntered
                                interDigitTimeout:(int)interDigitTimeout response:(OnResponse _Nonnull)response;


/**
 This method sends the command to keypad to collect card data (PAN, expiry date, CVC)
 from the user.<br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br>
 @param response OnResponse block
 @param progress OnProgress block
 */

- (void)retrieveKeyedCardData:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response;

/**
 This method sends the command to keypad to collect card data (PAN, expiry date, CVC)
 from the user.<br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br>
 @param keyedData the type of data requested
 @param response OnResponse block
 @param progress OnProgress block
 
 @see KeyedData
 
 */

- (void)retrieveKeyedCardData:(RUAKeyedData)keyedData progress:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response;

/**
 This method is used to collect the zipcode from the customer. Times out after 60 seconds.
 @param response OnResponse block
 @param progress OnProgress block
 */
- (void)retrieveZipCode:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response;

/**
 This method is used to collect the tip amount from the customer. Times out after 60 seconds.
 @param response OnResponse block
 @param progress OnProgress block
 */
- (void)retrieveTipAmount:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response;

/**
 * This method is used to capture a key press on reader<br>
 * @param timeout Timeout period in milliseconds. A value of 65,535 indicates an infinite timeout, other values from 0 to 65,534 specify the timeout period in milliseconds with a resolution of 10 milliseconds
 * @param response OnResponse block
 */
-(void)captureKeyPress:(int)timeout response:(OnResponse _Nonnull)response;

@end
