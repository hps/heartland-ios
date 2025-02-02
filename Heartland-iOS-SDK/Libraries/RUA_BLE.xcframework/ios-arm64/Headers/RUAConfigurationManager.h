/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>
#import "RUADevice.h"
#import "RUADeviceResponseHandler.h"
#import "RUAApplicationIdentifier.h"
#import "RUAPublicKey.h"
#import "RUADisplayControl.h"
#import "RUAKeypadControl.h"
#import "RUAFirmwareType.h"
#import "RUAFirmwareChecksumType.h"
#import "RUASystemLanguageHelper.h"
#import "RUAApplicationSelectionOption.h"
#import "RUAMacAlgorithm.h"
#import "RUAKeyUsage.h"
#import "RUACardInsertionStatusType.h"
#import "RUAPairingBluetoothMode.h"
#import "RUAE2EEMode.h"
#import "RUAEncryptionPANEndType.h"
#import "RUAEncryptionType.h"
#import "RUAPaddingType.h"

@protocol RUAConfigurationManager <NSObject>

/**
 This methods activates the roam device passed. <br>
 <br>
 This method is required only for devices that have Bluetooth interface or both audio jack and Bluetooth interfaces.<br>
 For G4x and RP350x where the reader has only one interface (audio jack), the audio jack interface gets activated. <br>
 @param device the roam device object
 @return true, if successful
 @see RUADevice
 */
- (BOOL)activateDevice:(RUADevice * _Nonnull)device;

/**
 This is an Asynchronous method that sends the clear AIDS command to the device. <br>
 <br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br>
 @param response OnResponse block
 @param progress OnProgress block
 
 */
- (void)clearAIDSList:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response __deprecated;

/**
 This is an Asynchronous method that sends the clear public keys command to the reader.<br>
 <br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br>
 @param response OnResponse block
 @param progress OnProgress block
 
 */
- (void)clearPublicKeys:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response __deprecated;


/**
 This is an Asynchronous method that sends the generate beep command to the reader.<br>
 <br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br>
 @param response OnResponse block
 @param progress OnProgress block
 
 */
- (void)generateBeep:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response;

/**
 This is an Asynchronous method that sends the reader capabilities control to the reader.<br>
 <br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br>
 @param response OnResponse block
 @param progress OnProgress block
 

 */
- (void)getReaderCapabilities:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response;

/**
 This is an Asynchronous method that sends the set system language command to the reader.<br>
 <br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br>
 @param language RUASystemLanguage
 @param response OnResponse block
 @param progress OnProgress block
 @deprecated
 */
- (void)setSystemLanguage:(RUASystemLanguage)language progress: (OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response __deprecated_msg("Use setUserInterfaceOptions to change system language on the reader instead");

/**
 This is an Asynchronous method that sends the read version command to the reader.<br>
 <br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br>
 @param response OnResponse block
 @param progress OnProgress block
 
 */
- (void)readVersion:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response;

/**
 This is an Asynchronous method that sends the read key mapping command to the reader.<br>
 <br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br>
 @param response OnResponse block
 @param progress OnProgress block
 
 */
- (void)readKeyMapping:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response;
/**
 This is an Asynchronous method that sends the reset device command to the reader.<br>
 <br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br>
 @param response OnResponse block
 @param progress OnProgress block
 
 */
- (void)resetDevice:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response;

/**
 This is an Asynchronous method that sends the retrieve KSN command to the reader.
 It will get the KSN for the key in the first slot.<br>
 <br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br>
 @param response OnResponse block
 @param progress OnProgress block
 
 */
- (void)retrieveKSN:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response;

/**
 This is an Asynchronous method that sends the retrieve KSN command to the reader.
 It allows to get the KSN for the TDES DUKPT key specified in the location.<br>
 <br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br>
 @param keyLocationIndex location of the TDES DUKPT key
 @param response OnResponse block
 @param progress OnProgress block
 
 */
- (void)retrieveKSN:(NSInteger)keyLocationIndex progress:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response;

/**
 This is an Asynchronous method that sends the Revoke public key command to the reader.<br>
 <br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br>
 @param key the public key
 @param response OnResponse block
 @param progress OnProgress block
 
 @see PublicKey
 */
- (void)revokePublicKey:(RUAPublicKey * _Nonnull)key progress:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response __deprecated;


/**
 This is an Asynchronous method that sets the transaction amount data object list<br>
 <br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br>
 @param list list of the data object list parameters (reader parameters)
 @param response OnResponse block
 @param progress OnProgress block
 @see RUAParameter */
- (void)setAmountDOL:(NSArray * _Nonnull)list progress:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response;

/**
 This is an synchronous method that sets the expected transaction amount data object list<br>
 <br>
 This call is used to set up the expected amount DOL format for data parsing, and shall not be used to issue any command
 to the reader.<br>
 @param list list of the data object list parameters (reader parameters)
 @see RUAParameter */
- (void)setExpectedAmountDOL:(NSArray * _Nonnull)list;

/**
 Sets the command timeout value on the reader.
 @param timeout  timeout value in seconds
 */
- (void)setCommandTimeout:(int)timeout;

/**
 This is an Asynchronous method that sets the transaction online data object list<br>
 <br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br>
 @param list list of the data object list parameters (reader parameters)
 @param response OnResponse block
 @param progress OnProgress block
 
 @see RUAParameter
 */
- (void)setOnlineDOL:(NSArray * _Nonnull)list progress:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response;

/**
 This is an synchronous method that sets the expected transaction online data object list<br>
 <br>
 This call is used to set up the expected online DOL format for data parsing, and shall not be used to issue any command
 to the reader. <br>
 @param list list of the data object list parameters (reader parameters)
 @see RUAParameter */
- (void)setExpectedOnlineDOL:(NSArray * _Nonnull)list;

/**
 This is an Asynchronous method that sets the transaction response data object list<br>
 <br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br>
 @param list list of the data object list parameters (reader parameters)
 @param response OnResponse block
 @see RUAParameter
 */
- (void)setResponseDOL:(NSArray * _Nonnull)list progress:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response;

/**
 This is an synchronous method that sets the expected transaction response data object list<br>
 <br>
 This call is used to set up the expected response DOL format for data parsing, and shall not be used to issue any command
 to the reader. <br>
 @param list list of the data object list parameters (reader parameters)
 @see RUAParameter */
- (void)setExpectedResponseDOL:(NSArray * _Nonnull)list;

/**
 This is an Asynchronous method that sets the user Interface Options for the reader.<br>
 <br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br>
 @param response OnResponse block
 @param progress OnProgress block
 */
- (void)setUserInterfaceOptions:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response;

/**
 This command is used to configure options related to the card holder user interface.
 <br>
 @param cardInsertionTimeout timeout period
 @param languageCode system language
 @param pinPadOptions refer to the table below for format of this field, <br>
 <table> <tbody>
 <tr><td>b7</td><td>b6</td><td>b5</td><td>b4</td><td>b3</td><td>b2</td><td>b1</td><td>b0</td><td>Meaning</td></tr>
 <tr><td>x</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td>RFU</td></tr>
 <tr><td></td><td>1</td><td></td><td></td><td></td><td></td><td></td><td></td><td>Ignore ICC inserts when ICC is disabled in the EMV Start Transaction P2 field.</td></tr>
 <tr><td></td><td></td><td>1</td><td></td><td></td><td></td><td></td><td></td><td>Enable Enhanced Contactless Display Control</td></tr>
 <tr><td></td><td></td><td></td><td>1</td><td></td><td></td><td></td><td></td><td>Disable PIN-Pad Exception Handling</td></tr>
 <tr><td></td><td></td><td></td><td></td><td>1</td><td></td><td></td><td></td><td>Display “PIN Tries Exceeded” after last PIN failure</td></tr>
 <tr><td></td><td></td><td></td><td></td><td></td><td>1</td><td></td><td></td><td>Enable cardholder to confirm cancellation</td></tr>
 <tr><td></td><td></td><td></td><td></td><td></td><td></td><td>1</td><td></td><td>Disable PIN-Pad progress screens</td></tr>
 <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td>1</td><td>Enable Call Card Issuer message</td></tr>
 </tbody></table>
 @param backlightControl 0 for manual control over the backlight which can be controlled by using the Level 1 Display Control command. <br>
                         1 for automatic control which will switch the backlight on at the start of an EMVL2 transaction and off at the end.<br>
 @param response OnResponse block
 @param progress OnProgress block
 Note: Only Moby8500 supports changing system language using this API.
 */
- (void) setUserInterfaceOptions:(int) cardInsertionTimeout
         withDefaultLanguageCode:(RUALanguageCode)languageCode
               withPinPadOptions:(Byte) pinPadOptions
            withBackLightControl:(Byte) backlightControl
                        progress:(OnProgress _Nonnull)progress
                        response:(OnResponse _Nonnull)response;


- (void) setUserInterfaceOptions:(int) cardInsertionTimeout
         withDefaultLanguageCode:(RUALanguageCode)languageCode
               withPinPadOptions:(Byte) pinPadOptions
            withBackLightControl:(Byte) backlightControl
                 inExtendedMode : (BOOL) isExtended
     withCardHolderLanguageList : (NSArray *)carHolderLanguageList
     withCardHolderLanguageMenu : (BOOL) cardHolderLanguageMenu
                        progress:(OnProgress _Nonnull)progress
                        response:(OnResponse _Nonnull)response;

/**
This command is used to configure options related to the card holder user interface.
<br>
@param cardInsertionTimeout timeout period
@param languageCode system language
@param supportedLanguages A list of language codes to be used for cardholder screens should the IC card application have a language preference. The list must contain the merchantLanguageCode.
 This list also defines the order that languages are presented during cardholder language menu selection if enabled.
@param allowCardholderLanguageSelection A flag indicating support for cardholder language selection menu should there be no match between the IC card application's language preference and the readers list of supported languages.
@param pinPadOptions refer to the table below for format of this field, <br>
<table> <tbody>
<tr><td>b7</td><td>b6</td><td>b5</td><td>b4</td><td>b3</td><td>b2</td><td>b1</td><td>b0</td><td>Meaning</td></tr>
<tr><td>x</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td>RFU</td></tr>
<tr><td></td><td>1</td><td></td><td></td><td></td><td></td><td></td><td></td><td>Ignore ICC inserts when ICC is disabled in the EMV Start Transaction P2 field.</td></tr>
<tr><td></td><td></td><td>1</td><td></td><td></td><td></td><td></td><td></td><td>Enable Enhanced Contactless Display Control</td></tr>
<tr><td></td><td></td><td></td><td>1</td><td></td><td></td><td></td><td></td><td>Disable PIN-Pad Exception Handling</td></tr>
<tr><td></td><td></td><td></td><td></td><td>1</td><td></td><td></td><td></td><td>Display “PIN Tries Exceeded” after last PIN failure</td></tr>
<tr><td></td><td></td><td></td><td></td><td></td><td>1</td><td></td><td></td><td>Enable cardholder to confirm cancellation</td></tr>
<tr><td></td><td></td><td></td><td></td><td></td><td></td><td>1</td><td></td><td>Disable PIN-Pad progress screens</td></tr>
<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td>1</td><td>Enable Call Card Issuer message</td></tr>
</tbody></table>
@param backlightControl 0 for manual control over the backlight which can be controlled by using the Level 1 Display Control command. <br>
                        1 for automatic control which will switch the backlight on at the start of an EMVL2 transaction and off at the end.<br>
@param response OnResponse block
@param progress OnProgress block
Note: Only Moby8500 supports changing system language using this API.
*/
- (void) setUserInterfaceOptions:(int) cardInsertionTimeout
         withDefaultLanguageCode:(RUALanguageCode)languageCode
          withSupportedLanguages:(NSOrderedSet * _Nonnull)supportedLangugaes
allowCardholderLanguageSelection:(BOOL)allowCardholderLanguageSelection
               withPinPadOptions:(Byte) pinPadOptions
            withBackLightControl:(Byte) backlightControl
                        progress:(OnProgress _Nonnull)progress
                        response:(OnResponse _Nonnull)response;

/**
 This is an Asynchronous method that sends the Submit aid list command to the reader.<br>
 <br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br><br>
 @param aids the list of application identifiers <br>
        FloorLimit,CVMLimit,TxnLimit,TermCaps and TLVData are only applicable for contactless application identifiers <br>
        those properties are not valid for contact application identifiers <br>
 @param response OnResponse block
 @param progress OnProgress block
 @see ApplicationIdentifier
 */
- (void)submitAIDList:(NSArray * _Nonnull)aids progress:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response __deprecated;

/** This is an Asynchronous method that sends the Submit aid list command to the reader.<br>
 <br>
 When the reader processes the command, it returns the result as a map to the callback method onResponse on the DeviceResponseHandler passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br><br>
 @param applicationIdentifiers
            the list of application identifiers,<br>Application Identifier must contain TLVData.<br>
 @param response OnResponse block
 @see ApplicationIdentifier
*/
- (void)submitAIDWithTLVDataList:(NSArray* _Nonnull) applicationIdentifiers response:(OnResponse _Nonnull)response;

/**
 This is an Asynchronous method that sends the Submit public key command to the reader.<br>
 <br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br>
 @param publicKey the public key
 @param response OnResponse block
 @param progress OnProgress block
 @see RUAPublicKey
 */
- (void)submitPublicKey:(RUAPublicKey * _Nonnull)publicKey progress:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response __deprecated;

/**
 This is an Asynchronous method that sends the command string as it is to the reader.<br>
 <br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br>
 @param rawCommand command string
 @param response OnResponse block
 @param progress OnProgress block
 */
- (void)sendRawCommand:(NSString * _Nonnull)rawCommand progress:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response;

/**
 Returns display control of the roam device.
 @return RUADisplayControl display control
 @see RUADisplayControl
 */

- (id <RUADisplayControl> _Nonnull)getDisplayControl;

/**
 Returns the certificate file versions of the connected device.
 @param response OnResponse block
 @param progress OnProgress block
 */

- (void)readCertificateFilesVersion:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response ;


/**
 Returns keypad control of the roam device.
 @return RUAKeypadControl keypad control
 @see RUAKeypadControl
 */

- (id <RUAKeypadControl> _Nonnull)getKeypadControl;

/***
 This command stores a single or double length master or session key specified in a secure memory location with the position specified by the session key locator.
 Session keys are decrypted prior to being stored using the master key corresponding to the specified master key locator.
 
 @param keyLength 0 for single length key and 1 for double length key
 @param sessionKeyLocator Session key locator string
 @param masterKeyLocator Master key locator string
 @param encryptedKey Encrypted key string
 @param checkValue Check value string
 @param ID An ID stored in the Pinpad that can be used to identify the decryption key on the host side. If no ID needs to be specified, this value must be set ‘00000000’.
 @param response OnResponse block
 @deprecated
 */
- (void) loadSessionKey:(int) keyLength
                        withSessionKeyLocator: (NSString * _Nonnull) sessionKeyLocator
                        withMasterKeyLocator: (NSString * _Nonnull) masterKeyLocator
                        withEncryptedKey:(NSString * _Nonnull) encryptedKey
                        withCheckValue: (NSString * _Nonnull) checkValue
                        withId:(NSString * _Nullable) ID
                        response:(OnResponse _Nonnull)response __deprecated;

/**
 This is an Asynchronous method that sets contactless transaction response data object list<br>
 <br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br>
 @param list list of the data object list parameters (reader parameters)
 @param progress OnProgress block
 @param response OnResponse block
 @see RUAParameter
 */
- (void)setContactlessResponseDOL:(NSArray * _Nonnull)list progress:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response;

/**
 This is a synchronous method that sets the expected contactless transaction response data object list<br>
 <br>
 This call is used to set up the expected response DOL format for data parsing, and shall not be used to issue any command
 to the reader. <br>
 @param list list of the data object list parameters (reader parameters)
 @see RUAParameter */
- (void)setExpectedContactlessResponseDOL:(NSArray * _Nonnull)list;

/**
 This is an Asynchronous method that sets the contactless transaction online data object list<br>
 <br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br>
 @param list list of the data object list parameters (reader parameters)
 @param progress OnProgress block
 @param response OnResponse block
 @see RUAParameter
 */
- (void)setContactlessOnlineDOL:(NSArray * _Nonnull)list progress:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response;

/**
 This is a synchronous method that sets the expected contactless transaction online data object list<br>
 <br>
 This call is used to set up the expected response DOL format for data parsing, and shall not be used to issue any command
 to the reader. <br>
 @param list list of the data object list parameters (reader parameters)
 @see RUAParameter */
- (void)setExpectedContactlessOnlineDOL:(NSArray * _Nonnull)list;


/**
 This is an Asynchronous method that sends the Submit contactless aid list command to the reader.<br>
 <br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br><br>
 @param aids the list of application identifiers
 @param response OnResponse block
 @param progress OnProgress block
 @see ApplicationIdentifier
 */
- (void)submitContactlessAIDList:(NSArray * _Nonnull)aids progress:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response __deprecated;

/**
 This method enables the contactless (turns on NFC card reader on the device) <br>
 @param response OnResponse block
 @deprecated
*/
- (void) enableContactless:(OnResponse _Nonnull)response __deprecated;

/**
 This method enables RKI mode for RKI Injection process <br>
 @param response OnResponse block
 */
- (void) enableRKIMode:(OnResponse _Nonnull)response;


/**
 *  This methos does the RKI Injection process
 *
 *  @param groupName      refers to the groupName of the device to do RKI Injection
 *  @param response        OnResponse block
 */
- (void) triggerRKIWithGroupName:(NSString * _Nonnull) groupName response:(OnResponse _Nonnull)response;

/**
 This method disables the contactless (turns OFF NFC card reader on the device) <br>
 @param response OnResponse block
 @deprecated
 */
- (void) disableContactless:(OnResponse _Nonnull)response __deprecated;

/**
 This method configures the contactless transaction options on the reader <br>
 @param response OnResponse block
 */
- (void) configureContactlessTransactionOptions: (BOOL) supportCVM
                                    supportAMEX: (BOOL) supportAMEX
                             enableCryptogram17: (BOOL) enableCryptogram17
                         enableOnlineCryptogram: (BOOL) enableOnlineCryptogram
                                   enableOnline: (BOOL) enableOnline
                                enableMagStripe: (BOOL) enableMagStripe
                                  enableMagChip: (BOOL) enableMagChip
                                    enableQVSDC: (BOOL) enableQVSDC
                                      enableMSD: (BOOL) enableMSD
                                  enableDPASEMV: (BOOL) enableDPASEMV
                                  enableDPASMSR: (BOOL) enableDPASMSR
                  contactlessOutcomeDisplayTime: (int) contactlessOutcomeDisplayTime
                    disableDiscoverIssuerScript: (BOOL) disableDiscoverIssuerScript
                                       response: (OnResponse _Nonnull) response __deprecated;

/**
 This method configures the contactless transaction options on the reader <br>
 @param response OnResponse block
 */
- (void) configureContactlessTransactionOptions: (BOOL) supportCVM
                                    supportAMEX: (BOOL) supportAMEX
                             enableCryptogram17: (BOOL) enableCryptogram17
                         enableOnlineCryptogram: (BOOL) enableOnlineCryptogram
                                   enableOnline: (BOOL) enableOnline
                                enableMagStripe: (BOOL) enableMagStripe
                                  enableMagChip: (BOOL) enableMagChip
                                    enableQVSDC: (BOOL) enableQVSDC
                                      enableMSD: (BOOL) enableMSD
                                  enableDPASEMV: (BOOL) enableDPASEMV
                                  enableDPASMSR: (BOOL) enableDPASMSR
                  contactlessOutcomeDisplayTime: (int) contactlessOutcomeDisplayTime
                                       response: (OnResponse _Nonnull) response __deprecated;

/**
 This method configures the contactless transaction options on the reader <br>
 @param response OnResponse block
 */

- (void) configureContactlessTransactionOptions: (BOOL) supportCVM
									supportAMEX: (BOOL) supportAMEX
							 enableCryptogram17: (BOOL) enableCryptogram17
						 enableOnlineCryptogram: (BOOL) enableOnlineCryptogram
								   enableOnline: (BOOL) enableOnline
								enableMagStripe: (BOOL) enableMagStripe
								  enableMagChip: (BOOL) enableMagChip
									enableQVSDC: (BOOL) enableQVSDC
									  enableMSD: (BOOL) enableMSD
				  contactlessOutcomeDisplayTime: (int) contactlessOutcomeDisplayTime
                                       response: (OnResponse _Nonnull) response __deprecated;

/**
 * This is an Asynchronous method that sets the the time after which the reader switches to energy saving mode
 * @param seconds time in seconds. Allowed range is 0 - 1800 seconds
 * @param response OnResponse block
 */

- (void)setEnergySaverModeTime:(int)seconds res:(OnResponse _Nonnull)response __deprecated;

/**
 * This is an Asynchronous method that sets the time after which the reader turns off.
 * The shutdown mode time kicks in after the energy saver mode time elapses. 
 * @param seconds time in seconds. Allowed range is 0 - 3600 seconds
 * @param response OnResponse block
 */


- (void)setShutDownModeTime:(int)seconds res:(OnResponse _Nonnull)response __deprecated;

/**
 * This is a Asynchronous method that sets the custom firmware version<br>
 * <br>
 * @param firmwareType enum to describe the type firmware that needs to be set
 * @param version string which holds the value of the firmware type.
 * @param response OnResponse block
 * @see RUAFirmwareType
 * When the reader processes the command, it returns the result as a map to the OnResponse block passed.<br>
 */
- (void)setFirmwareType:(RUAFirmwareType)firmwareType withVersion:(NSString* _Nonnull)version response:(OnResponse _Nonnull)response;

/**
 * This is a Asynchronous method that gets the custom firmware version<br>
 * <br>
 * @param firmwareType enum to describe the type firmware that needs to be returned
 * @param response OnResponse block
 * @see RUAFirmwareType
 * When the reader processes the command, it returns the result as a map to the OnResponse block passed.<br>
 */
- (void)getFirmwareVersionStringForType:(RUAFirmwareType)firmwareType response:(OnResponse _Nonnull)response;

/**
 * This is a Asynchronous method that is used to configure the beeps<br>
 * <br>
 * @param disableReadMagneticCardBeep BOOL describes, if reader should disable beep at when ready to read Magnetic Card data
 * @param disableRemoveCardBeep BOOL describes, if reader should disable beep when card is ready to be removed
 * @param disableEMVStartTransactionBeep BOOL describes, if reader should disable beep when ready to start EMV transaction
 * @param response OnResponse block
 * When the reader processes the command, it returns the result as a map to the OnResponse block passed.<br>
 */
- (void)configureReadMagneticCardBeep:(BOOL)disableReadMagneticCardBeep
                       removeCardBeep:(BOOL)disableRemoveCardBeep
           andEMVStartTransactionBeep:(BOOL)disableEMVStartTransactionBeep
                             response:(OnResponse _Nonnull)response;

/**
 * This is a Asynchronous method that is used to get the checksum<br>
 * <br>
 * @param type RUAFirmwareChecksumType enum to describe the firmwaretype
 * @param response OnResponse block
 */
-(void)getChecksumForType:(RUAFirmwareChecksumType)type response:(OnResponse _Nonnull)response;

/**
 * This is a Asynchronous method that is used to set the application selection flag<br>
 * <br>
 * @param applicationSelectionOption RUAApplicationSelectionOption enum to describe the application selection option
 * @param response OnResponse block
 */
-(void)setApplicationSelectionFlag:(RUAApplicationSelectionOption)applicationSelectionOption response:(OnResponse _Nonnull)response __deprecated;

/**
 This is an Asynchronous method that returns additional information regarding reader firmware and kernel.<br>
 <br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains RUAParameterReaderVersionInfoExt as key, <br>
 @param response OnResponse block
 @param progress OnProgress block
 */
- (void)readVersionExt:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response;

/**
 This is an Asynchronous method that indicates if a smart card is fully inserted in the reader or fully removed.<br>
 Please note that this command is non blocking, so it can be executed in the middle of an operation that is initiated by another command.
 @param response OnResponse block
 */
-(void)getCardInsertionStatus:(OnResponse _Nonnull)response;
-(void)getCardInsertionStatusWithCardType : (RUACardInsertionStatusType) cardType :(OnResponse _Nonnull)response;

/**
 This is an aynchronous method that allows switching between multiple BDK’s in the secret area.
 For P2PE, maximum of 10 keys can be injected in to the terminal. Using the below command only one key is made Active for encryption. Reader will keep selected key configuration after reboot.
 Note: This command is valid only when selected P2PE index keys are available in the secret area.
 @param keyLocationIndex points to the location of key to be made active for encryption. Range 1 - 20.
 @param response OnResponse block
*/
- (void)selectE2EKey:(NSInteger)keyLocationIndex response:(OnResponse _Nonnull)response;

/**
This is an Asynchronous method that enables reader to start capturing device logs into its memory.<br>
Note: Traces are only recorded during transactions
@deprecated
@param response OnResponse block
*/
- (void)startLogRecord:(OnResponse _Nonnull)response __deprecated;

/**
This is an Asynchronous method that enables reader to start capturing device logs into its memory.<br>
@param transactionsLogOnly true - traces are only recorded for last transaction
                           false - traces are recorded for all reader events. Supported on FW versions 12.15 or higher. Warning: this mode significantly affects overall performances.
@param response OnResponse block
*/
- (void)startLogRecord:(BOOL)transactionsLogOnly response:(OnResponse _Nonnull)response;

/**
This is an Asynchronous method that stops reader to capture device logs into its memory.<br>
@param response OnResponse block
*/
- (void)stopLogRecord:(OnResponse _Nonnull)response;

/**
This is an Asynchronous method that enables reader to start capturing device logs through USB Interface into its memory.<br>
@param response OnResponse block
*/
- (void)startLogRecordViaUSB:(OnResponse _Nonnull)response;

/**
This is an Asynchronous method that stops reader to capture device logs through USB interface into its memory.<br>
@param response OnResponse block
*/
- (void)stopLogRecordViaUSB:(OnResponse _Nonnull)response;

/**
This is an Asynchronous method that retrieves the device logs captured from the reader.<br>
The map passed to the onResponse callback contains the RUAParameterDeviceLogs parameter as key for the device log<br>
@param progress OnProgress block
@param response OnResponse block
*/
- (void)retrieveLog:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response;

/**
This is an Asynchronous method that deletes the device logs captured from the reader.<br>
@param response OnResponse block
*/
- (void)deleteLog:(OnResponse _Nonnull)response;

/**
This is an Asynchronous method that resets the device logs captured from the reader.<br>
@param response OnResponse block
*/
- (void)resetLog:(OnResponse _Nonnull)response;

/**
 This is an Asynchronous method that indicates if a smart card is present in RF field or not.<br>
 Please note that this command is non blocking, so it can be executed in the middle of an operation that is initiated by another command.
 Please note: This command will be supported by firmware v10.27 or higher only.
 @param response OnResponse block
 */
-(void)getCardPresenceInRFFieldStatus:(OnResponse _Nonnull)response;

/**
This is an Asynchronous method that computes a MAC in CBC mode according to algorithm 1 (ISA 16609) or algorithm 3 (Annex C of X9.19-1996) with no Initialisation Vector (i.e. an Initialisation Vector set to all-zeroes) using the DES or TDES Session key information specified. The map passed to the onResponse callback contains RUAParameterComputedMac.
@param algorithm the algorithm used for MAC computation
@param keyLocator key locator
@param macData mac input data
@param response OnResponse block
 */
-(void)computeMacWithMasterSessionEncryption:(RUAMacAlgorithm)algorithm keyLocator:(NSString * _Nonnull)keyLocator macData:(NSString * _Nonnull)macData response: (OnResponse _Nonnull)response;

/**
This is an Asynchronous method that computes a MAC in CBC mode according to algorithm 1 (ISA 16609) or algorithm 3 (Annex C of X9.19-1996) with no Initialisation Vector (i.e. an Initialisation Vector set to all-zeroes) using the DES or TDES Session key information specified. In this enhanced version, you can specify if the encrypted PAN is included and its relative position in the mac data to be calculated. The map passed to the onResponse callback contains RUAParameterComputedMac.
@param algorithm the algorithm used for MAC computation
@param keyLocator key locator
@param isEncryptedPANIncludedInMacData indicates if encrypted PAN is included in the mac input data, if set to false, The next two fields (PAN offset and PAN Len) will be ignored
@param offset indicates the position of encrypted PAN in the mac input data
@param length indicates the length of encrypted PAN in the mac input data
@param macData mac input data
@param response OnResponse block
 */
-(void)computeMacWithMasterSessionEncryption:(RUAMacAlgorithm)algorithm keyLocator:(NSString * _Nonnull)keyLocator isEncryptedPANIncludedInMacData:(BOOL)isEncryptedPANIncluded encryptedPANOffset:(int)offset encryptedPANLength:(int)length macData:(NSString * _Nonnull)macData response: (OnResponse _Nonnull)response;

/**
This is an Asynchronous method that computes a MAC in CBC mode according to algorithm 1 (ISA 16609) or algorithm 3 (Annex C of X9.19-1996) with an Initialisation Vector using the TDES or DES Session key information specified. With each call to this function the DES DUKPT KSN will be advanced. The map passed to the onResponse callback contains RUAParameterVerifyMacResult.
 @param algorithm the algorithm used for MAC computation
 @param keyLocator key locator
 @param mac mac to be verified
 @param macInputData mac input data
 @param response OnResponse block
 */
-(void)verifyMacWithMasterSessionEncryption:(RUAMacAlgorithm)algorithm keyLocator:(NSString * _Nonnull)keyLocator mac:(NSString * _Nonnull)mac macInputData:(NSString * _Nonnull)macInputData response: (OnResponse _Nonnull)response;

#pragma mark - RSA Key loading commands

/**
This is an Asynchronous method that deletes a RSA OAEP Public key.
@param keyName NSString key name (Max 11 characters)
@param response OnResponse block
 */
-(void)deleteRsaOaepPublicKey:(NSString * _Nullable)keyName response:(OnResponse _Nonnull)response;

/**
This is an Asynchronous method that selects a RSA OAEP Public key.
@param keyName NSString key name (Max 11 characters)
@param response OnResponse block
 */
-(void)selectRsaOaepPublicKey:(NSString * _Nullable)keyName response:(OnResponse _Nonnull)response;

/**
This is an Asynchronous method that dynamically updates RSA OAEP Public key.
@param keyName NSString key name (Max 11 characters)
@param keyFile NSString key file data in PEM format
@param signature NSString signature data in Base64
@param response OnResponse block
 */
-(void)updateRsaOaepPublicKeyDynamically:(NSString * _Nullable)keyName
                                 keyFile:(NSString * _Nullable)keyFile
                              signnature:(NSString * _Nullable)signature
                                response:(OnResponse _Nonnull)response;

/***
 This command stores a single or double length master or session key specified in a secure memory location with the position specified by the session key locator.
 Session keys are decrypted prior to being stored using the master key corresponding to the specified master key locator.
 
 @param keyLength 0 for single length key and 1 for double length key
 @param keyUsage Key usage. Set to RUAKeyUsageUnknown to deduce key usage from key locator
 @param sessionKeyLocator Session key locator string
 @param masterKeyLocator Master key locator string
 @param encryptedKey Encrypted key string
 @param ID An ID stored in the Pinpad that can be used to identify the decryption key on the host side. If no ID needs to be specified, this value must be set ‘00000000’.
 @param response OnResponse block
 */
- (void) loadSessionKey:(int) keyLength
           withKeyUsage:(RUAKeyUsage) keyUsage
  withSessionKeyLocator:(NSString * _Nonnull) sessionKeyLocator
   withMasterKeyLocator:(NSString * _Nonnull) masterKeyLocator
       withEncryptedKey:(NSString * _Nonnull) encryptedKey
         withCheckValue: (NSString * _Nonnull) checkValue
                 withId:(NSString *) ID
               response:(OnResponse _Nonnull)response;

/**
 Perform JSON provisioning with the file path provided and returns the response on the handler passed
 @param jsonFilePath JSON file path string
 @param progress OnProgress block
 @param response OnResponse block
*/
- (void) performJsonProvisioning:(NSString * _Nonnull) jsonFilePath progress:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response;

/**
 This is an Asynchronous method that sets the transaction data object list for mag stripe<br>
 <br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br>
 @param list list of the data object list parameters (reader parameters)
 @param response OnResponse block
 @param progress OnProgress block
 @see RUAParameter */
- (void)setMagStripeDOL:(NSArray * _Nonnull)list progress:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response;

/**
 This is an synchronous method that sets the expected transaction mag stripe data object list<br>
 <br>
 This call is used to set up the expected mag stripe DOL format for data parsing, and shall not be used to issue any command
 to the reader.<br>
 @param list list of the data object list parameters (reader parameters)
 @see RUAParameter */
- (void)setExpectedMagStripeDOL:(NSArray * _Nonnull)list;

/**
 This is an synchronous method that sets reader bacground color<br>
 <br>
 Color is set with rgb color
 to the reader.<br>
 @param redColor red color value
 @param greenColor green color value
 @param blueColor blue color value
 @param response OnResponse block
 */
-(void)setBackgroundColorWith: (int)redColor andGreenColor: (int) greenColor  andBlueColor : (int) blueColor response: (OnResponse _Nonnull)response;

-(void)bluetoothPairingWith: (RUAPairingBluetoothMode) mode andCodePin: (NSString * _Nullable) codePin response: (OnResponse _Nonnull)response;

-(void)callEchoCommand : (OnResponse _Nonnull)response;

/**
 This is an synchronous method that sets E2EE custom configuration<br>
 <br>
 This command is only available on Development devices. It supersedes the whole E2EE configuration coming from USCFG file, including the scheme used for encryption.<br>
 @param mode Mode
 @param nBin Number of digits left in the clear at the beginning of the PAN
 @param flag Flag indicating if the encryption includes the Expiration Date, Service Code and Card Holder Name
 @param panEndEncryptionType Enable/Disable encryption of the last digits of the PAN
 @param encryptionType Type of encryption
 @param paddingType Type of padding
 @param response OnResponse block
 */
-(void)setE2EECustomConfigWithMode: (RUAE2EEMode)mode nBin: (int)nBin extensiveFlag: (BOOL)flag panEndEncryptionType:(RUAEncryptionPANEndType)panEndEncryptionType encryptionType:(RUAEncryptionType)encryptionType paddingType:(RUAPaddingType)paddingType response: (OnResponse _Nonnull)response;

/**
 This is an synchronous method that reset E2EE custom configuration<br>
 <br>
 This command destroys E2EE custom configuration. Once processed, setting coming from USCFG file will be used<br>
 @param response OnResponse block
 */
-(void)resetE2EECustomConfig: (OnResponse _Nonnull)response;

/**
 This is an synchronous method that set E2EE obfuscation level<br>
 <br>
 This command dynamically changes the PAN obfuscation settings.<br>
 @param level Level of obfuscation from 0 to 3
 @param response OnResponse block
 */
-(void)setE2EEObfuscationLevelWithLevel:(int)level response: (OnResponse _Nonnull)response;

/**
 This is an synchronous method that get E2EE custom configuration<br>
 <br>
 This command is only available on Development devices. It retrives the E2EE custom onfiguration.<br>
 
 @param response OnResponse block
 */
-(void)getE2EECustomConfig: (OnResponse _Nonnull)response;
/**
 Command to return last error received from a command
 @param response OnResponse block
 */
-(void) getLastErrorCommand:(OnResponse)response;

-(void)callDestroyDeviceConfigCommand : (OnResponse _Nonnull)response;
@end
