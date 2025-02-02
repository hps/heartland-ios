//
//  LandiCommandHelper.h
//  ROAMreaderUnifiedAPI
//
//  Created by Russell Kondaveti on 10/19/13.
//  Copyright (c) 2013 ROAM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUA.h"
#import "RUAPublicKey.h"
#import "RUAApplicationIdentifier.h"
#import "RUAByteUtils.h"
#import "RUAParameter.h"
#import "RUACommand.h"
#import "RUAEnumerationHelper.h"
#import "RUAVASMode.h"

typedef struct TLV {
	RUAParameter parameter;
	NSString *code;
	u_int32_t minLen;
	u_int32_t maxLen;
    RUAValueFormat valueFormat;
    BOOL isProprietary;
} RUAParameterTLV;

@interface RUACommandHelper : NSObject

+ (NSData *)getBatteryInfoCommand;
+ (NSData *)getBatteryInfoCommandWithChargingStatus;
+ (NSData *)getCancelWaitCommand;
+ (NSData *)getClearAIDsListCommand;
+ (NSData *)getClearPubliKeysCommand;
+ (NSData *)getConfigureDOLListCommand:(RUACommand)cmd withDataObjectList:(NSArray *)dols;
+ (NSData *)getEncryptedDataStatusCommand;
+ (NSData *)getGenerateBeepCommand;
+ (NSData *)getReadCapabilitiesCommand;
+ (NSData *)getReadMagStripeCommand;
+ (NSData *)getReadVersionCommand;
+ (NSData *)getReadKeyMappingInformation;
+ (NSData *)getReadCertificateFilesVersion;
+ (NSData *)getEnableRKIModeCommand;
+ (NSData *)getResetReaderCommand;
+ (NSData *)getEnableContactessCommand;
+ (NSData *)getEnableFirmwareUpdateCommand;
+ (NSData *)getDisableContactessCommand;
+ (NSData *)getDeviceStatisticsCommand;
+ (NSData *)getSetSystemLanguageCommandWithLanguage: (RUASystemLanguage) language;
+ (NSData *)getWaitForCardRemovalCommand:(NSInteger)cardRemovalTimeout;
+ (NSString *)getRUAParameterCode:(RUAParameter)paramter;
+ (int)getRUAParameterMaxLength:(RUAParameter)paramter;
+ (int)getRUAParameterMinLength:(RUAParameter)paramter;
+ (RUAParameter)getRUAParameter:(NSString *)emvTag;
+ (NSString *)getRUAParameterMaxLengthString:(RUAParameter)paramter;
+ (NSString *)getRUAParameterMinLengthString:(RUAParameter)paramter;
+ (BOOL)isRUAParameterLengthVariable:(RUAParameter)paramter;
+ (BOOL)isRUAParameterProprietary:(RUAParameter)paramter;
+ (RUAValueFormat)getRUAValueFormat:(RUAParameter)paramter;
+ (NSData *)getSubmitPublicKeyListCommand:(RUAPublicKey *)key;
+ (NSData *)getRevokePublicKeyListCommand:(RUAPublicKey *)key;
+ (NSData *)getSubmitAIDSListCommand:(NSArray *)aids forCommand:(RUACommand) command;
+ (NSData *)getTransactionCommand:(RUACommand)cmd withInputParameters:(NSDictionary *)input;
+ (NSData *)getLoadSessionKeyCommand:(int) keyLength
                 withSessionKeyLocator: (NSString *) sessionKeyLocator
                  withMasterKeyLocator: (NSString *) masterKeyLocator
                      withEncryptedKey: (NSString *) encryptedKey
                        withCheckValue: (NSString *) checkValue
                                withId: (NSString *) ID;

+ (NSData *)getLoadSessionKeyCommand:(int) keyLength
                        withKeyUsage:(RUAKeyUsage) keyUsage
               withSessionKeyLocator: (NSString *) sessionKeyLocator
                withMasterKeyLocator: (NSString *) masterKeyLocator
                    withEncryptedKey: (NSString *) encryptedKey
                      withCheckValue: (NSString *) checkValue
                              withId: (NSString *) ID;

+ (NSData *)getEnergySaverTimeCommand:(int)seconds;

+ (NSData *)getShutDownModeTimeCommand:(int)seconds;

+ (NSData *)retrieveCommandToSetFirmwareType:(RUAFirmwareType)firmwareType withVersionString:(NSString*)versionString;

+ (NSData *)retrieveCommandToGetVersionForFirmwareType:(RUAFirmwareType)firmwareType;

+ (NSData *)getCommandToConfigureReadMagneticCardBeep:(BOOL)disableReadMagneticCardBeep removeCardBeep:(BOOL)disableRemoveCardBeep andEMVStartTransactionBeep:(BOOL)disableEMVStartTransactionBeep;

+ (RUAErrorCode)getRUAErrorCode:(NSString *)readerError;

+ (NSData *)getKeyedCardData;

+ (RUAErrorCode) getLastRuaErrorCode;

+ (NSString *) getLastRuaRawErrorCode;

+ (void) saveLastRuaErrorCode:(RUAErrorCode) ruaErrorCode;

+ (void) saveLastRuaRawErrorCode:(NSString *) lastRuaRawErrorCode;

+ (NSData *)getKeyedCardData:(RUAKeyedData)keyedData;

+ (NSData*) getCommandDataWithTimeout:(int)cardRemovalTimeout
                               cmd: (RUACommand) cmd;
                               
+ (NSData*) getCaptureKeyPressCommandWithTimeout:(int)timeout;

+ (NSData *)retrieveCommandToGetChecksumForFirmwareType:(RUAFirmwareChecksumType)firmwareChecksumType;
+ (NSData *)retrieveCommandToSetApplicationSelectionFlag:(RUAApplicationSelectionOption)applicationSelectionOption;

/**
 Description of dictionary containing RUA parameters and values
 @param parameters Dictionary of RUA parameters and values
 @return String description of parameter dictionary
 @see RUAProgressMessage
 */
+ (NSString *)RUADescriptionOfParameters:(NSDictionary*)parameters;

+ (NSData *)getVASVersionCommand;

+ (NSData *)getMerchantsCountCommand;

+ (NSData *)getClearVASMerchantsCommand;

+ (NSData *)getVASErrorMessageCommand;

+ (NSData *)getActivateVASExchangedMessageLogCommand;

+ (NSData *)getDeactivateVASExchangedMessageLogCommand;

+ (NSData *)getVASExchangedMessageLogCommand;

+ (NSData *)getEnableVASModeCommand:(RUAVASMode)vasMode;

+ (NSData *)getVASDataCommandForMerchant:(NSUInteger)merchantIndex;

+ (NSData *)getEnableVASPLSEStateCommandforState:(BOOL)isEnabled;

+ (NSData *)retrieveSetVASUnpredictableNumberCommandFor:(NSString*)unpredictableNumberString;

+ (NSData *)retrieveSetVASApplicationVersionCommandFor:(NSString*)applicationVersionString;

+ (NSData *)getEnableVASModeCommand:(RUAVASMode)vasMode forMerchant:(NSString*)merchantId;

+ (NSData *)getAddVASMerchantCommand:(RUAVASMode)vasMode merchantID:(NSString*)merchantId merchantURL:(NSString*)merchantURL categoryFilter:(NSString*)categoryFilter;

+ (NSData *)getStartVASCommandWithTimeout:(NSUInteger)timeout andCanMagneticSwipeEventInterruptVASInDualMode:(bool)canMagneticSwipeEventInterruptVASInDualMode andCanChipCardInsertedEventInterruptVASInDualMode:(bool)canChipCardInsertedEventInterruptVASInDualMode andCanKeyPressEventInterruptVASInDualMode:(bool)canKeyPressEventInterruptVASInDualMode;

+ (BOOL) isCommandCancelWait:(NSData *) data;

+ (NSData *)getReadVersionExtCommand;

+ (NSData *)getCardInsertionStatusCommand;

+ (NSData *)getCardInsertionStatusCommandWithCardType : (int) cardType ;

+ (NSData *)getSelectE2ECommand:(NSInteger) keyLocationIndex;

+ (NSData *)getRetrieveKSNCommand:(NSInteger) keyLocationIndex;

+ (NSData *)getStartLogRecordCommand:(BOOL)transactionsLogOnly;

+ (NSData *)getStopLogRecordCommand;

+ (NSData *)getRetrieveLogCommand;

+ (NSData *)getDeleteLogCommand;

+ (NSData *)getResetLogCommand;

+ (NSData *)getStartLogRecordViaUSBCommand;

+ (NSData *)getStopLogRecordViaUSBCommand;

+ (NSData *)getCardPresenceInRFFieldStatusCommand;

+ (NSData *)getRequestStateInformationCommand;

+ (NSData *)getLoadIntermediateCertificateCommand:(NSString *) keyFile;

+ (NSData *)getLoadP2PEIssuingCertificateCommand:(NSString *) keyFile;

+ (NSData *)getLoadValidationPublicKeyCertificateCommand:(NSString *) keyFile;

+ (NSData *)getLoadRsaOaepPublicKeyCertificateCommand:(NSString *) keyName keyFile:(NSString *) keyFile;

+ (NSData *)getDeletePublicKeyCommand:(NSString *) keyName;

+ (NSData *)getSelectPublicKeyCommand:(NSString *) keyName;

+ (NSData *)getUpdateRsaOaepPublicKeyDynamicallyCommand:(NSString *) keyName
                                                keyFile:(NSString *) keyFile
                                              signature:(NSString *) signature;

+ (RUAResponse *) validateParameterList:(NSArray *) list forCommand:(RUACommand) command;

+ (NSString *)getDisplayTextCharsetCommand:(RUADisplayTextCharset) charset;

+ (NSData *)getWaitForInsertionCommand:(int)timeOut paymentInterface:(RUAPaymentInterface)interface;

+ (NSData *)getPowerCardCommandWithPowerUp:(BOOL)isPowerUp interface:(RUAPaymentInterface)interface;

+ (NSData *)getAPDUExchangeCommand:(RUAAPDUResponseType)response interface:(RUAPaymentInterface)interface memoryPage:(int)page;

+ (NSData *)getComputeMacCommand:(RUAMacAlgorithm)algorithm keyLocator:(NSString *)keyLocator macData:(NSString* )macData;

+ (NSData *)getComputeMacCommand:(RUAMacAlgorithm)algorithm keyLocator:(NSString *)keyLocator isEncryptedPANIncludedInMacData:(BOOL)isEncryptedPANIncluded encryptedPANOffset:(int)offset encryptedPANLength:(int)length macData:(NSString* )macData;

+ (NSData *)getVerifyMacCommand:(RUAMacAlgorithm)algorithm keyLocator:(NSString *)keyLocator mac:(NSString* )mac macInputData:(NSString* )macInputData;

+ (NSData *)getChangeBackgroundImageCommand:(NSString *)imageName;

+ (NSData *)getExtendedSetUserInterfaceOptionsCommand:(int) cardInsertionTimeout
                              withDefaultLanguageCode:(RUALanguageCode)languageCode
                               withSupportedLanguages:(NSOrderedSet *)supportedLangugaes
                     allowCardholderLanguageSelection:(BOOL)allowCardholderLanguageSelection
                                    withPinPadOptions:(Byte) pinPadOptions
                                 withBackLightControl:(Byte) backlightControl;

+ (NSData *)getStartJsonProvisioningCommand:(NSData *)jsonData;

+ (NSData *)getBackgroundColorCommandWithRedColor:(int)redColor andGreenColor:(int)greenColor andBlueColor:(int) blueColor;

+ (NSData *)getPredifinedScreenCommandWithIndex:(int)screenIndex andLanguage :(NSString *) language;

+ (NSData *)getPairingCommandWithMode:(RUAPairingBluetoothMode)mode andCodePin:(NSString*)codePin;

+ (NSData *)getEchoCommand;

+ (NSData *)getDestroyDeviceConfigCommand;

+ (NSData*) getSetBacklightControlCommand:(BOOL)enableOnStartup brightness:(Byte)backlightBrightness;

+ (NSData*) getSetE2EECustomConfigCommandWithMode:(RUAE2EEMode)mode nBin: (int)nBin extensiveFlag: (BOOL)flag panEndEncryptionType:(RUAEncryptionPANEndType)panEndEncryptionType encryptionType:(RUAEncryptionType)encryptionType paddingType:(RUAPaddingType)paddingType;

+ (NSData*) getResetE2EECustomConfigCommand;

+ (NSData*) getE2EEObfuscationLevelCommandWithLevel: (int) level;

+ (NSData*) getGetE2EECustomConfigCommand;

@end
