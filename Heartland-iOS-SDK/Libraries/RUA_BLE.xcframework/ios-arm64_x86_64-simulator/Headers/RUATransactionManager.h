/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>

#import "RUADeviceResponseHandler.h"
#import "RUACommand.h"
#import "RUAVASMode.h"
#import "RUAPaymentInterface.h"
#import "RUAAPDUResponseType.h"
#import "RuaPredifinedScreen.h"

#ifndef RUATransactionManager_h
#define RUATransactionManager_h

@protocol RUATransactionManager <NSObject>

/**
 This is an Asynchronous method that sends the read magnetic stripe command to the reader.
 The reader waits for the magnetic card swipe and when the reader detects a card swipe , it returns the result as a map to the OnResponse block passed.<br>
 @param response OnResponse block
 @param progress OnProgress block
 @see RUAParameter, RUADeviceResponseHandler
 Note: You can still use this command for G4x/G5x. For other card readers, "EMVStartTransaction" command with P2field=04 should be used in case of enabling only magswipe interface.
 @deprecated
 */
- (void)waitForMagneticCardSwipe:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response __deprecated_msg("Use this command for G4x/G5x. For other card readers, use EMVStartTransaction");

/**
 Stops the reader from waiting for magnetic card swipe.
 */
- (void)stopWaitingForMagneticCardSwipe;

/**
 This is an Asynchronous method that sends the transaction command to the roam reader.<br>
 When the reader processes the command, it returns the result as a map to the OnResponse block passed.<br>
 <p>
 Usage:
 <code>
 RUADeviceManager deviceManager; <br>
 ....<br>
 NSMutableDictionary* transactionParameters = [[NSMutableDictionary alloc] init];
 [transactionParameters setObject:[RUAEnumerationHelper RUACommand_toString:RUACommandEMVStartTransaction] forKey:[NSNumber numberWithInt:RUAParameterCommand]];
 [transactionParameters setObject:@"0826" forKey:[NSNumber numberWithInt:RUAParameterTransactionCurrencyCode]];
 [transactionParameters setObject:@"00" forKey:[NSNumber numberWithInt:RUAParameterTransactionType]];
 [transactionParameters setObject:@"000100000000" forKey:[NSNumber numberWithInt:RUAParameterAmountAuthorizedNumeric]];
 [transactionParameters setObject:@"000000000000" forKey:[NSNumber numberWithInt:RUAParameterAmountOtherNumeric]];
 [transactionParameters setObject:@"030507" forKey:[NSNumber numberWithInt:RUAParameterTransactionDate]];
 [transactionParameters setObject:@"0826" forKey:[NSNumber numberWithInt:RUAParameterTerminalCountryCode]];
 [transactionParameters setObject:@"E0B8C8" forKey:[NSNumber numberWithInt:RUAParameterTerminalCapabilities]];
 [transactionParameters setObject:@"22" forKey:[NSNumber numberWithInt:RUAParameterTerminalType]];
 [transactionParameters setObject:@"F000F0A001" forKey:[NSNumber numberWithInt:RUAParameterAdditionalTerminalCapabilities]];
 [transactionParameters setObject:@"9F3704" forKey:[NSNumber numberWithInt:RUAParameterDefaultValueForDDOL]];
 [transactionParameters setObject:@"59315A3159325A3259335A333030303530313034" forKey:[NSNumber numberWithInt:RUAParameterAuthorizationResponseCodeList]];
 [transactionParameters setObject:@"03" forKey:[NSNumber numberWithInt:RUAParameterTerminalConfiguration]];
 [transactionParameters setObject:dateStr forKey:[NSNumber numberWithInt:RUAParameterTransactionTime]];
 [transactionParameters setObject:@"00" forKey:[NSNumber numberWithInt:RUAParameterPOSEntryMode]];
 [transactionParameters setObject:@"0000" forKey:[NSNumber numberWithInt:RUAParameterMerchantCategoryCode]];
 [transactionParameters setObject:@"0000000000000000" forKey:[NSNumber numberWithInt:RUAParameterTerminalIdentification]];
 [transactionParameters setObject:@"00110321" forKey:[NSNumber numberWithInt:RUAParameterTransactionSequenceCounter]];
 [[deviceManager getTransactionManager] sendCommand:RUACommandEMVStartTransaction withParameters:[processor getEMVStartTransactionParameters] progress:^(RUAProgressMessage messageType) {
 }
 response:^(RUAResponse *ruaResponse) {
 
 }
 ];
 </code>
 </p><p>
 For EMVStartTransaction Command, the valid input parameters are as below:<br>
 - RUAParameterCommand (Mandatory)<br>
 - RUAParameterTransactionCurrencyCode (Mandatory)<br>
 - RUAParameterTransactionType (Mandatory)<br>
 - RUAParameterTerminalConfiguration (Mandatory)<br>
 - RUAParameterTransactionDate (Mandatory)<br>
 - RUAParameterTerminalCapabilities (Mandatory)<br>
 - RUAParameterTerminalType (Mandatory)<br>
 - RUAParameterAdditionalTerminalCapabilities (Mandatory)<br>
 - RUAParameterDefaultValueForDDOL (Mandatory)<br>
 - RUAParameterAuthorizationResponseCodeList (Mandatory)<br>
 - RUAParameterAmountAuthorizedBinary (Optional)<br>
 - RUAParameterAmountOtherBinary (Optional)<br>
 - RUAParameterTerminalCountryCode (Optional)<br>
 - RUAParameterTransactionCurrencyExponent (Optional)<br>
 - RUAParameterAmountAuthorizedNumeric (Optional)<br>
 - RUAParameterAmountOtherNumeric (Optional)<br>
 <br>
 The map passed to the onResponse callback contains the following parameters, <br>
 - RUAParameterResponseCode (ResponseCode enumeration as value) <br>
 - RUAParameterErrorCode (if not successful, ErrorCode enumeration as value) <br>
 - RUAParameterKSN (String as value)<br>
 - RUAParameterEncryptedTrack(String as value)<br>
 The map also includes the EMV parameters configured through setAmountDOL.<br>
 </p><p>
 For EMVTransactionData Command, the valid input parameters are as below:<br>
 - RUAParameterCommand (Mandatory)<br>
 - RUAParameterThresholdvalue (Mandatory)<br>
 - RUAParameterTargetpercentage (Mandatory)<br>
 - RUAParameterMaximumtargetpercentage (Mandatory)<br>
 - RUAParameterTerminalActionCodeDefault (Mandatory)<br>
 - RUAParameterTerminalActionCodeDenial (Mandatory)<br>
 - RUAParameterTerminalActionCodeOnline (Mandatory)<br>
 - RUAParameterTerminalFloorLimit (Mandatory)<br>
 - RUAParameterAmountAuthorizedBinary (Optional)<br>
 - RUAParameterAmountAuthorizedNumeric (Optional)<br>
 - RUAParameterAmountOtherBinary (Optional)<br>
 - RUAParameterAmountOtherNumeric (Optional)<br>
 - RUAParameterAmountOfLasttransactionWithSameCard (Optional)<br>
 - RUAParameterCardIsInTheHotlist (Optional)<br>
 - RUAParameterTransactionForcedOnline (Optional)<br>
 - RUAParameterTerminalCountryCode (Optional)<br>
 - RUAParameterTerminalCapabilities (Optional)<br>
 - RUAParameterDefaultValueForDDOL (Optional)<br>
 - RUAParameterDefaultValueForTDOL (Optional)<br>
 - RUAParameterPINEntryDisplayPromptString (Optional)<br>
 - RUAParameterVerificationonlyTransactionFlag (Optional)<br>
 - RUAParameterOnlinePINBlockKeyLocator (Deprecated)<br>
 - RUAParameterOnlinePINBlockFormat (Optional)<br>
 - RUAParameterMACDOL (Optional)<br>
 - RUAParameterMACData (Optional)<br>
 - RUAParameterMACInitialisationVector (Optional)<br>
 - RUAParameterOnlinePINKeyLocator (Optional)<br>
 - RUAParameterPinByPassCFG (Optional)<br>
 <br>
 The map passed to the onResponse callback contains the following parameters. <br>
 - RUAParameterResponseCode (ResponseCode enumeration as value) <br>
 - RUAParameterErrorCode (if not successful, ErrorCode enumeration as value) <br>
 - RUAParameterKSN (String as value)<br>
 - RUAParameterEncryptedTrack(String as value)<br>
 The map also includes the EMV parameters configured through setOnlineDOL.<br>
 </p><p>
 For EMVCompleteTransaction Command, the valid input parameters are as below,<br>
 - RUAParameterCommand (Mandatory)<br>
 - RUAParameterResultofOnlineProcess (Mandatory)<br>
 - RUAParameterIssuerScript1 (Optional)<br>
 - RUAParameterIssuerScript2 (Optional)<br>
 - RUAParameterWrapperforIssuerScriptTagWithIncorrectLength (Optional)<br>
 - RUAParameterAuthorizationCode (Optional)<br>
 - RUAParameterAuthorizationResponseCode (Optional)<br>
 - RUAParameterIssuerAuthenticationData (Optional)<br>
 - RUAParameterAuthorizationResponseCodeList (Optional)<br>
 <br>
 The map passed to the onResponse callback contains the following parameters and the data for EMV tag DOLs configured, <br>
 - RUAParameterResponseCode (ResponseCode enumeration as value) <br>
 - RUAParameterErrorCode (if not successful, ErrorCode enumeration as value) <br>
 - RUAParameterKSN (String as value)<br>
 - RUAParameterEncryptedTrack(String as value)<br>
 The map also includes the EMV parameters configured through setResponseDOL.<br>
 </p><p>
 For EMVTransactionStop Command, the valid input parameters are as below, <br>
 - RUAParameterCommand (Mandatory)<br>
 - RUAParameterAlternateMessageForRemoveCardPrompt (Optional)<br>
 - RUAParameterContactlessSignatureCheckResult (Optional)<br>
 <br>
 The map passed to the onResponse callback contains the following parameters, <br>
 - RUAParameterResponseCode (ResponseCode enumeration as value) <br>
 - RUAParameterErrorCode (if not successful, ErrorCode enumeration as value) <br>
 </p><p>
 For EMVFinalApplicationSelection Command, the valid input parameters are as below,<br>
 - RUAParameterCommand (Mandatory)<br>
 - RUAParameterApplicationIdentifier (Mandatory)<br>
 <br>
 The map passed to the onResponse callback contains the following parameters, <br>
 - RUAParameterResponseCode (ResponseCode enumeration as value) <br>
 - RUAParameterErrorCode (if not successful, ErrorCode enumeration as value) <br>
 - RUAParameterKSN (String as value)<br>
 - RUAParameterEncryptedTrack(String as value)<br>
 </p>
 @param parameters input map containing the input reader parameters
 @param response OnResponse block
 @param progress OnProgress block
 @see RUAParameter, RUACommand
 */
- (void)sendCommand:(RUACommand)command withParameters:(NSDictionary * _Nullable)parameters progress:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response;

/**
 * Cancels any one of the previously issued commands,
 * <ul>
 * <li>EMVStartTransaction</li>
 * <li>WaitForMagneticCardSwipe</li>
 * <li>ReadKeypad</li>
 * <li>KeyPadControl</li>
 * </ul>
 * Unlike other commands, this command will not receive a response,
 * even if there is no outstanding command to be cancelled.
 */
- (void)cancelLastCommand;

/**
 * This command will make the card reader wait until the card is fully removed or if the timeout expires before returning a response.
 * @param cardRemovalTimeout timeout period for card removal in seconds.<br> Range 1 - 65 <br> 0 - indefinite wait
 * @param response OnResponse block
 */
- (void)waitForCardRemoval:(NSInteger)cardRemovalTimeout response:(OnResponse _Nonnull)response;

/**
 * Asynchronous method that returns the VAS(Value Added Services) Version. <br>
 * When the reader processes the command, it passes the result as a map to
 * the onResponse method of handler passed, with RUAParameterVASVersion as key<br>
 * @param response OnResponse block
 * @see RUAParameter, RUACommand
 */
-(void)getVASVersion:(OnResponse _Nonnull)response;

/**
 * Asynchronous method that returns the VAS(Value Added Services) merchant count. <br>
 * When the reader processes the command, it passes the result as a map to
 * the onResponse method of handler passed, with RUAParameterVASMerchantsCount as key<br>
 * @param response OnResponse block
 * @see RUAParameter, RUACommand
 */
-(void)getVASMerchantsCount:(OnResponse _Nonnull)response;

/**
 * Asynchronous method that clears VAS(Value Added Services) merchants. <br>
 * When the reader processes the command, it passes the result as a map to
 * the onResponse method of handler passed<br>
 * @param response OnResponse block
 * @see RUAParameter, RUACommand
 */
-(void)clearVASMerchants:(OnResponse _Nonnull)response;

/**
 * Asynchronous method that returns the last VAS(Value Added Services) error message. <br>
 * When the reader processes the command, it passes the result as a map to
 * the onResponse method of handler passed, with RUAParameterLastVASErrorMessage as key<br>
 * @param response OnResponse block
 * @see RUAParameter, RUACommand
 */
-(void)getVASErrorMessage:(OnResponse _Nonnull)response;

/**
 * Asynchronous method that returns VAS(Value Added Services) Exchanged Message Log. <br>
 * When the reader processes the command, it passes the result as a map to
 * the onResponse method of handler passed, with RUAParameterVASExchangedMessageLog as key<br>
 * @param response OnResponse block
 * @see RUAParameter, RUACommand
 */
-(void)getVASExchangedMessagesLog:(OnResponse _Nonnull)response;

/**
 * Asynchronous method that returns VAS(Value Added Services) response code<br>
 * When the reader processes the command, it passes the result as a map to
 * the onResponse method of handler passed, with  as key<br>
 * @param vasMode RUAVASMode describes the mode for VAS
 * @param response OnResponse block
 * @see RUACommand, RUAVASMode
 */
-(void)enableVASMode:(RUAVASMode)vasMode response:(OnResponse _Nonnull)response;

/**
 * Asynchronous method that returns VAS(Value Added Services) response code<br>
 * When the reader processes the command, it passes the result as a map to
 * the onResponse method of handler passed, with  as key<br>
 * @param isEnabled BOOL indicates if the PLSE state needs to be set or not
 * @param response OnResponse block
 * @see RUACommand
 */
-(void)enableVASPLSEState:(BOOL)isEnabled response:(OnResponse _Nonnull)response;

/**
 * Asynchronous method that returns VAS(Value Added Services) Data <br>
 * When the reader processes the command, it passes the result as a map to
 * the onResponse method of handler passed, with RUAParameterVASData as key<br>
 * @param merchantIndex NSInteger index of the merchant
 * @param response OnResponse block
 * @see RUAParameter, RUACommand
 */
-(void)getVASDataforMerchant:(NSUInteger)merchantIndex response:(OnResponse _Nonnull)response;

/**
 * Asynchronous method that returns VAS(Value Added Services) response code<br>
 * When the reader processes the command, it passes the result as a map to
 * the onResponse method of handler passed<br>
 * @param vasMode RUAVASMode describes the mode for VAS Merchant
 * @param merchantId NSString merchnat id to add VAS Merchant
 * @param merchantUrl NSString merchnat url to add VAS Merchant
 * @param categoryFilter NSString category Filter to add VAS Merchant
 * @param response OnResponse block
 * @see RUACommand, RUAVASMode
 */
-(void)addVASMerchant:(RUAVASMode)vasMode merchantID:(NSString* _Nonnull)mercahntId merchantURL:(NSString* _Nonnull)merchantURL categoryFilter:(NSString* _Nonnull)categoryFilter response:(OnResponse _Nonnull)response;

/**
 * Asynchronous method that returns VAS(Value Added Services) response code<br>
 * When the reader processes the command, it passes the result as a map to
 * the onResponse method of handler passed, with  as key<br>
 * @param vasMode RUAVASMode describes the mode for VAS
 * @param merchantId NSString merchnat id to enable VAS
 * @param response OnResponse block
 * @see RUACommand, RUAVASMode
 */
-(void)enableVASMode:(RUAVASMode)vasMode forMerchant:(NSString* _Nonnull)mercahntId response:(OnResponse _Nonnull)response;

/**
 * Asynchronous method that returns VAS(Value Added Services) response code <br>
 * When the reader processes the command, it passes the result as a map to
 * the onResponse method of handler passed<br>
 * @param timeout NSInteger timeout for VAS
 * @param canMagneticSwipeEventInterruptVASInDualMode if magnetic swipe event can interrupt VAS in Dual Mode
 * @param canChipCardInsertedEventInterruptVASInDualMode if chip insertion event can interrupt VAS in Dual Mode
 * @param canKeyPressEventInterruptVASInDualMode if key press event can interrupt VAS in Dual Mode
 * @param response OnResponse block
 * The map passed to the onResponse callback contains RUAParameterShouldProceedWithPayment and RUAParameterVASResponseCodeInfo as key. The value of the key RUAParameterVASResponseCodeInfo corresponds to RUAVASResponseCode class
 * @see RUAVASResponseCode
 * @Deprecated
 */
-(void)startVAS:(NSUInteger)timeout canMagneticSwipeEventInterruptVASInDualMode:(bool)canMagneticSwipeEventInterruptVASInDualMode
canChipCardInsertedEventInterruptVASInDualMode:(bool)canChipCardInsertedEventInterruptVASInDualMode
canKeyPressEventInterruptVASInDualMode:(bool)canKeyPressEventInterruptVASInDualMode response:(OnResponse _Nonnull)response __deprecated_msg("Use RUACommandEMVStartTransaction instead");

/**
This is an Asynchronous method that lets the reader wait until card is fully inserted or a given timeout expires.
 @param timeout timeout period in seconds. <br> Range 1 - 65 <br> 0 - indefinite wait
 @param interface payment interface
 @param response OnResponse block
 */
-(void)waitForInsertion: (int)timeout paymentInterface: (RUAPaymentInterface)interface response: (OnResponse _Nonnull)response;

/**
This is an Asynchronous method that applies power to card and relays back the Answer to Reset as per ISO/IEC 7816-4.
Note: The response as relayed from the card to the power up command as a string of hexadecimal bytes. If successfully powered up this will contain the ATR followed by SW1SW2=’9000’.  On failure to power up card this may contain extended error codes – for example, after trying to power up a mute card it will return 03E8EA8200: ‘03’ indicating a card error, ‘E8EA’ being the SMC driver error code (least significant byte first) and SW1SW2=8200.
 @param interface payment interface
 @param response OnResponse block
 */
-(void)powerUpCard: (RUAPaymentInterface)interface response: (OnResponse _Nonnull)response;

/**
This is an Asynchronous method that removes power from card.
 @param interface payment interface
 @param response OnResponse block
 */
-(void)powerDownCard: (RUAPaymentInterface)interface response: (OnResponse _Nonnull)response;

/**
This is an Asynchronous method that exchanges APDU with the card reader.
for RUAAPDUResponseTypeClear mode, response will include parameter DF8228, RUAParameterAPDUAnswer, for the other two modes, response will include RUAParameterKSN and parameter DF8223, RUAParameterRoamEncryptedEMVdata.
 @param interface payment interface
 @param page the page of memory to be read
 @param response OnResponse block
 */
-(void)exchangeAPDU:(RUAAPDUResponseType)APDUResponse interface:(RUAPaymentInterface)interface memoryPage:(int)page response:(OnResponse _Nonnull)response;

-(void)setPredifinedScreen: (RUADisplayPredifenedScreen)screenIndex andLanguage : (NSString *_Nullable) language response: (OnResponse _Nonnull)response;

@end

#endif /* ifndef RUATransactionManager_h */
