/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */
#import <Foundation/Foundation.h>

#ifndef ROAMreaderUnifiedAPI_RUAParameterh
#define ROAMreaderUnifiedAPI_RUAParameterh
typedef NS_ENUM(NSInteger, RUAValueFormat) {
    RUAValueFormatBinary = 201,
    RUAValueFormatASCII = 202,
    RUAValueFormatCompressedNumeric = 203,
    RUAValueFormatNumeric = 204,
    RUAValueFormatUnknown = 205
};

typedef NS_ENUM(NSInteger, RUAParameter) {
    
    
    /**
     5F57 : Account Type, 1 byte	<br>
     Indicates the type of account selected on the terminal, coded as specified in Annex G	<br>
     */
    
	RUAParameterAccountType = 300,
    
    /**
     FF7F : Acquirer Exclusion List (Contactless Processing Only), variable length 3 - 127 bytes <br>
     This tag is used to specify a list of acquirers that cannot be used for contactless transaction processing if the external device cannot guarantee that it will complete contactless processing. <br>
     For e.g. if it is unable to store the transaction details offline because it cannot contact the appropriate acquirer.<br>
     Some contactless applications may be pre-paid and, after being approved by the PIN-Pad the card applications offline amount will be deducted.<br>
     If the external device cannot store the details the transaction  may have been completed offline but the acquirer will never be informed.<br>
     
     The tag is encoded in the following manner: <br><br>
     ----------------------------------------------------------------------------------
     | Tag      | Value                         | Length                |Presence     |
     ----------------------------------------------------------------------------------
     | FF7F     | Constructed                   | variable              | Mandatory   |
     |          | 9F01 Acquirer Identifier 1    | n 6-11 (3-6 bytes)    | Mandatory   |
     |          | 9F01Acquirer Identifier n     | n 6-11 (3-6 bytes)    | Conditional |
     ----------------------------------------------------------------------------------
     
     Conditional - If there is more that one acquirer to be specified then the additional 9F01 tags are repeated each with different values (and there may be more acquirers present than are shown above). <br>
     The length of tag FF7F is the total length of all other tags it contains. <br>
     In addition, when using the Submit AID command, the id of the acquirer that acquires that application should be specified in the TLVData field so that the PIN-Pad can make the necessary association between the application and the acquirers specified in tag FF7F. <br>
     @see RUAParameterAcquirerIdentifier
     */
	RUAParameterAcquirerExclusionList = 301,
    
    /**
     9F01 : Acquirer identifier.
     Uniquely identifies the acquirer within each payment system
     */
	RUAParameterAcquirerIdentifier = 302,
    
    /**
     9F40: Additional Terminal Capabilities, 5 Bytes<br>
     Indicates the data input and output capabilities of the terminal<br>
     Approved values: <br>
     FF00F0A001 attended<br>
     8F80F0B001 attended<br>
     6F00F05001 unattended<br>
     */
	RUAParameterAdditionalTerminalCapabilities = 303,
    
    /**
     DF73 : Alternative remove card display prompt string, variable length 1- 16 bytes <br>
     Tag DF73 may be passed in from external device during any of the commands that pass TLV data to the application. <br>
     It is recommended that if this tag is to be used, it should be sent as part of the EMV Stop Transaction command. <br>
     When the remove card prompt is displayed, this string will be used on the third line of the display immediately above 'REMOVE CARD' on the fourth line; <br>
     otherwise, the display message will be determined by the status of the transaction, e.g. 'COMPLETE', 'NOT AUTHORISED', 'CARD ERROR', 'TRANSACTION VOID', etc.
     */
	RUAParameterAlternateMessageForRemoveCardPrompt = 304,
    
    /**
     DF45 : Amex expresspay pseudo track1 data, 62 bytes <br>
     This tag is returned by the terminal during an Amex magswipe contactless transaction. <br>
     It has a fixed length of 62 bytes and has the following format: <br><br>
     -------------------------------------------------
     | Field Name               |    Length in bytes |
     -------------------------------------------------
     | Start Sentinel           |    1               |
     | Format Code              |    1               |
     | Account Number (PAN)     |    15              |
     | Field Separator          |    1               |
     | Cardmember Name          |    23              |
     | ATC                      |    3               |
     | Field Separator          |    1               |
     | Expiration Date (YYMM)   |    4               |
     | Interchange Designator   |    1               |
     | Service Code             |    2               |
     | Unpredictable Number     |    4               |
     | Discretionnary Data      |    5               |
     | End Sentinel             |    1               |
     -------------------------------------------------
     */
	RUAParameterAmexExpresspayPseudoTrack1Data = 305,
    
    /**
     DF46 : Amex expresspay pseudo track2 data, 39 bytes <br>
     This tag is returned by the terminal during an Amex magswipe contactless transaction. <br>
     It has a fixed length of 39 bytes and has the following format: <br><br>
     -------------------------------------------------
     | Field Name               |    Length in bytes |
     -------------------------------------------------
     | Start Sentinel           |    1               |
     | Account Number (PAN)     |    15              |
     | Field Separator          |    1               |
     | Expiration Date (YYMM)   |    4               |
     | Interchange Designator   |    1               |
     | Service Code             |    2               |
     | Unpredictable Number     |    4               |
     | Discretionary Data       |    5               |
     | ATC                      |    3               |
     | Language Code            |    2               |
     | End Sentinel             |    1               |
     -------------------------------------------------
     */
	RUAParameterAmexExpresspayPseudoTrack2Data = 306,
    
    /**
     DF44 : Amex expresspay unpredictable number range. <br>
     */
	RUAParameterAmexExpresspayUnpredictableNumberRange = 307,
    
    /**
     81: Amount Authorized Binary - Authorized amount of the transaction (excluding adjustments)
     */
	RUAParameterAmountAuthorizedBinary = 308,
    
    /**
     9F02 : Amount Authorized Numeric Format: n 12<br>
     */
	RUAParameterAmountAuthorizedNumeric = 309,
    
    /**
     DF25 : Amount found in the transaction file, in a previous transaction performed with the same card.<br>
     */
	RUAParameterAmountOfLasttransactionWithSameCard = 310,
    
    /**
     9F04 : Amount Other Binary<br>
     Secondary amount associated with the transaction representing a cashback amount<br>
     */
	RUAParameterAmountOtherBinary = 311,
    
    /**
     9F03 : Amount Other Numeric  Format: n 12<br>
     Secondary amount associated with the transaction representing a cashback amount<br>
     */
	RUAParameterAmountOtherNumeric = 312,
    
    /**
     9F3A : Amount Reference Currency
     */
	RUAParameterAmountReferenceCurrency = 313,
    
    /**
     9F42 : Application Currency Code, 2 bytes<br>
     Indicates the currency in which the account is managed according to ISO 4217<br>
     */
    RUAParameterApplicationCurrencyCode = 314,
    
    /**
     9F26 : Application cryptogram, 8 bytes<br>
     Cryptogram returned by the ICC in response of the GENERATE AC command<br>
     */
	RUAParameterApplicationCryptogram = 315,
    
    /**
     9F05 : Application Discretionary Data, 32 bytes <br>
     */
	RUAParameterApplicationDiscretionaryData = 316,
    
    /**
     5F25 : Application Effective Date, 3 bytes
     Date from which the application may be used , YYMMDD
     */
	RUAParameterApplicationEffectiveDate = 317,
    
    /**
     5F24 : Application Expiration Date, 3 bytes<br>
     Date after which application expires, YYMMDD<br>
     */
	RUAParameterApplicationExpirationDate = 318,
    
    /**
     5F30 : Service Code, 3 bytes<br>
     Service code as defined in ISO/IEC 7813 for Track 1 and Track 2<br>
     */
	RUAParameterServiceCode= 319,
    
    /**
     94 : Application File Locator<br>
     */
	RUAParameterApplicationFileLocator = 320,
    
    /**
     4F : Application Identifier / Application Dedicated File Name, 16 bytes
     Identifies the application as described in ISO/IEC 7816-5
     */
	RUAParameterApplicationIdentifier = 321,
    
    /**
     82 : Application Interchange Profile, 2 bytes <br>
     Indicates the capabilities of the card to support specific functions in the application <br>
     */
    RUAParameterApplicationInterchangeProfile = 322,
    
    /**
     50 : Application Label, 16 bytes <br>
     Mnemonic associated with the AID according to ISO/IEC 7816-5 <br>
     */
	RUAParameterApplicationLabel = 323,
    
    /**
     9F12 : Application Preferred Name, 16 bytes
     Preferred mnemonic associated with the AID
     */
	RUAParameterApplicationPreferredName = 324,
    
    /**
     61 : Application Template<br>
     */
	RUAParameterApplicationTemplate = 325,
    
    /**
     9F36 : Application Transaction Counter 2 bytes
     Counter maintained by the application in the ICC (incrementing the ATC is managed by the ICC)
     */
	RUAParameterApplicationTransactionCounter = 326,
    /**
     9F08 : Application Transaction Counter 2 bytes
     Version number assigned by the payment system for the application
     */
	RUAParameterApplicationVersionNumber = 327,
    
    /**
     9F09 : Terminal Application Version Number
     */
	RUAParameterTerminalApplicationVersionNumber = 328,
    
    /**
     89 : Value generated by the authorisation authority for an approved transaction
     Format is defined by the Payment Systems
     */
	RUAParameterAuthorizationCode = 329,
    
    
    /**
     8A : Code that defines the disposition of a message
     */
	RUAParameterAuthorizationResponseCode = 330,
    
    /**
     DF16 : List of the possible response codes (each one corresponding to a specific signification), 20 bytes.  <br>
     The tag DF16 gives to EMV the list of the possible Response codes that the Host can send, in case of authorization request.<br>
     DF16 has a length of 20 bytes. Each response code takes 2 bytes. <br>
     The response codes are presented in the following order that must be always the same:<br>
     <table><tbody>
     <tr><th>Bytes</th><th>Meaning</th><th>Default Value</th><th>Cryptogram requested from card if tag 8A set to this value</th></tr>
     <tr><td>First 2 bytes</td><td>Offline Approved.</td><td>"Y1" (0x59/0x31)</td><td>TC (approve)</td></tr>
     <tr><td>Next 2 bytes</td><td>Offline Declined.</td><td>"Z1" (0x5A/0x31)</td><td>AAC (decline)</td></tr>
     <tr><td>Next 2 bytes</td><td>Approval (after card-initiated referral).</td><td>"Y2" (0x59/0x32)</td><td>TC (approve)</td></tr>
     <tr><td>Next 2 bytes</td><td>Declined (after card-initiated referral).</td><td>"Z2" (0x5A/0x32)</td><td>AAC (decline)</td></tr>
     <tr><td>Next 2 bytes</td><td>Unable to go Online - Approved</td><td>"Y3" (0x59/0x33)</td><td>TC (approve)</td></tr>
     <tr><td>Next 2 bytes</td><td>Unable to go Online - Declined</td><td>"Z3" (0x5A/0x33)</td><td>AAC (decline)</td></tr>
     <tr><td>Next 2 bytes</td><td>Online Approved.</td><td>"00" (0x30/0x30)</td><td>TC (approve)</td></tr>
     <tr><td>Next 2 bytes</td><td>Online Declined.</td><td>"05" (0x30/0x35)</td><td>AAC (decline)</td></tr>
     <tr><td>Next 2 bytes</td><td>Referral requested by Issuer.</td><td>"01" (0x30/0x31)</td><td>TC (approve)</td></tr>
     <tr><td>Next 2 bytes</td><td>Capture card.</td><td>"04" (0x30/0x34)</td><td>AAC (decline)</td></tr
     </tbody></table>
     */
	RUAParameterAuthorizationResponseCodeList = 331,
    
    /**
     5F54 : Bank Identifier Code - BIC
     */
	RUAParameterBankIndentifierCode = 332,
    
    /**
     DF8222 Canadian flag.
     */
	RUAParameterCanadianFlag = 333,
    
    /**
     Card Expiration Date
     */
	RUAParameterCardExpDate = 334,
    
    /**
     DF12 : Cardholder Language
     */
	RUAParameterCardHolderLanguage = 335,
    
    /**
     5F20 : Cardholder Name, 26 bytes
     */
	RUAParameterCardHolderName = 336,
    
    /**
     8E : Cardholder Verification Method List
     */
	RUAParameterCardholderVerificationMethodList = 337,
    
    /**
     9F34 : Cardholder Verification Method Result, 3 bytes
     */
	RUAParameterCardholderVerificationMethodResult = 338,
    
    /**
     DF26 : Flag set to ìTrueî if the card is in Hot List
     */
	RUAParameterCardIsInTheHotlist = 339,
    
    /**
     8C :  List of data objects (tag and length) to be passed to the ICC in the first GENERATE AC command, Variable length 1 - 252 bytes
     */
	RUAParameterCardRiskManagementDataObjectList1 = 340,
    
    /**
     8D :  List of data objects (tag and length) to be passed to the ICC in the first GENERATE AC command
     Variable length 1 - 252 bytes
     */
	RUAParameterCardRiskManagementDataObjectList2 = 341,
    
    /**
     Indicates the card type
     @see RUACardType
     */
	RUAParameterCardType = 342,
    
    
    /**
     Certification Authority Public Key Index [8F], 1 byte.
     */
	RUAParameterCertificationAuthorityPublicKeyIndex = 343,
    
    /**
     DF50 : Certification Verification Value, 12 bytes.
     */
	RUAParameterCertificationVerificationValue = 344,
    
    /**
     Holds the value for Roam Reader Command.
     */
	RUAParameterCommand = 345,
    
    /**
     DF6F : Contactless Information Out, 2 bytes
     */
	RUAParameterContactlessInformationOut = 346,
    
    /**
     DF6C : Contactless kernel identifier.
     */
	RUAParameterContactlessKernelIdentifier = 347,
    
    /**
     DF6E : Contactless pos check results.
     */
	RUAParameterContactlessSignatureCheckResult = 348,
    
    /**
     DF71 : Hand over card flag.
     */
	RUAParameterHandOverCardFlag = 349,
    
    
    /**
     91 : Data sent to the ICC for online issuer authentication
     also called Authorization Response Cryptogram
     */
	RUAParameterIssuerAuthenticationData = 350,
    
    /**
     71 : Contains proprietary issuer data for transmission to the ICC before the second GENERATE AC command
     */
	RUAParameterIssuerScript1 = 351,
    
    /**
     72 : Contains proprietary issuer data for transmission to the ICC before the second GENERATE AC command
     */
	RUAParameterIssuerScript2 = 352,
    
	RUAParameterKSN = 353,
    
    /** DF3A :  List of transaction types used by the application.*/
	RUAParameterListOfTransactionTypesUsedByTheApplication = 354,
    
    RUAParameterListOfApplicationIds = 355,
    
    /**
     DF8205 : TDES DUKPT MAC Data
     */
	RUAParameterMACData = 356,
    
    /**
     DF8204
     This tag contains a list of tags and lengths, for which a MAC should be computed over the combined data fields of all tags in the list.  The data fields for all tags are concatenated in the order specified in the list so that they occupy the amount of space specified by the tag length.  The resulting data block is then right-padded with zero bytes so that there is at least 16 bytes in the buffer and it is a multiple of 8 bytes long.
     */
	RUAParameterMACDOL = 357,
    
    /**
     DF8206 : TDES DUKPT MAC Initialisation Vector
     */
	RUAParameterMACInitialisationVector = 358,
    
    /**
     DF8220 : Master session key locator.
     */
	RUAParameterMasterSessionKeyLocator = 359,
    
    /**
     DF09 : Maximum target percentage 1 byte
     */
	RUAParameterMaximumtargetpercentage = 360,
    
    /**
     9F15 : Merchant Category Code, 2 bytes
     */
	RUAParameterMerchantCategoryCode = 361,
    
    /**
     9F16 : Merchant Identifier
     */
	RUAParameterMerchantIdentifier = 362,
    
    /**
     On guard mode status.
     If the previous Encrypted Track Data Mode field is 0x00, this field will also be 0x00.
     Otherwise, it indicates whether the card data passed or failed the consistency checks defined in Reference [18], as a bitmap:
     Bit 0 (lsb)  -	Set if there is a mismatch between the PAN fields (in the track data and possibly  EMV PAN tag data item).
     Bit 1          -	Set if the expiry dates and service codes in Track 1 and Track 2 data do not match.
     Bit 2          -	Set if the expiry date of Track 1 and/or Track 2 does not match the EMV Tag expiry date.
     All zero implies that no consistency error was detected.
     Note that the card data will have been returned whether or not the consistency checks had passed or failed.
     If the previous Data Mode field is 0x02, this field will also be 0x00.
     */
	RUAParameterOnGuardModeStatus = 363,
    
    /** DF4F Online pin block*/
	RUAParameterOnlinePINBlock = 364,
    
    /**
     DF8202 : Online PIN Block Format
     Value Description<br>
     0x00 ISO Format 0<br>
     0x03 ISO Format 3<br>
     0xFF Bypass Online PIN<br>
     */
	RUAParameterOnlinePINBlockFormat = 365,
    
    /**
     DF8200 : TDES DUKPT Key Locator, 4 bytes<br>
     E2EE DUKPT key : 00000001 <br>
     Bank DUKPT keys : <br>
     PIN key : key locator 00010001<br>
     MAC key : key locator 00010002<br>
     COM key : key locator 00010003<br>
     @deprecated<br>
     */
	RUAParameterOnlinePINBlockKeyLocator __attribute__((deprecated)) = 366,
    
    /** DF4E Online PIN SMID*/
	RUAParameterOnlinePINSMID = 367,
    
    /**
     DF65 : Overall contactless transaction limit.
     */
    
	RUAParameterOverallContactlessTransactionLimit = 368,
    
	RUAParameterPartialTrackData = 369,
    
    RUAParameterPackEncryptedTrackData = 370,
    
    /**
     DF6D : Pay pass transaction outcome.
     */
	RUAParameterPayPassTransactionOutcome = 371,
    
    /**
     DF69 : PIN Entry Display Prompt String
     */
	RUAParameterPINEntryDisplayPromptString = 372,
    
    /**
     9F39 : POS Entry Mode (1 Byte, NN)
     Digit 1 - Card Transaction Information (Most Significant Nibble)
     1 Swipe
     2 Keyed
     3 ICC
     4 Recovered data, keyed
     5 Recovered data, electronic
     7 Downgrade ICC transaction
     8 Swipe ICC failure
     9 Proximity
     
     Digit 2 - Cardholder verification if any
     1 Customer present, signature
     2 Customer present, PIN
     4 Customer present, UPT no CVM
     5 Customer present, UPT, PIN
     7 Customer not present
     8 No verification
     */
	RUAParameterPOSEntryMode = 373,
    
    RUAParameterRawResponse = 374,
    
    /**
     DF6B : Reader risk parameter record.
     */
	RUAParameterReaderRiskParameterRecord = 375,
    
	RUAParameterReaderVersion = 376,
    
	RUAParameterResponseCode = 377,
    
	RUAParameterResponseType = 378,
    
    /**
     DF39 : Result of Online Process
     0x01 = 30Online completed (approved or rejected by the host).  The tag ì8Aî must be set to the value from the host.
     0x02 = 30Unable to go online (comms failure, or declined by merchant)
     0x00 = 30ICC referral processed offline, in the case of an ICC-initiated referral, after an auth code has been obtained.  The tag ì8Aî will be set by the EMVL2 kernel.
     */
	RUAParameterResultofOnlineProcess = 380,
    
    /**
     DF74 : Retry configuration flag.
     */
	RUAParameterRetryConfigurationFlag = 381,
    
    /**
     DF8223 Roam encrypted emv data.
     */
	RUAParameterRoamEncryptedEMVdata = 382,
    
    /**
     DF08 : Targetpercentage. 1 byte
     */
	RUAParameterTargetpercentage = 383,
    
    /**
     DF03 : Terminal action code default. 5 Bytes
     */
	RUAParameterTerminalActionCodeDefault = 384,
    
    /**
     DF04 : Terminal action code denial. 5 Bytes
     */
	RUAParameterTerminalActionCodeDenial = 385,
    
    /**
     DF05 : Terminal action code online. 5 Bytes
     */
	RUAParameterTerminalActionCodeOnline = 386,
    
    /**
     9F33 : Terminal Capabilities
      E0F8C8 - Offline PIN, Online PIN, Signature,No CVM, attended.(RP750x)<br>
      E0F0C8 - Offline PIN Online PIN and Signature, attended.(RP750x)<br>
      E0B0C8 - Offline PIN, Signature attended. (RP750x)<br>
      E068C8 - Online PIN, Signature, attended. (RP750x)<br>
      E040C8 - Online PIN only, attended. (RP750x)<br>
      E028C8 - Signature Only, attended. (RP350x)<br>
      6098C8 - Offline PIN only, unattended.<br>
      60D8C8 - Offline PIN and Online PIN, unattended.<br>
     */
	RUAParameterTerminalCapabilities = 387,
    
    /**
     DF3D : Terminal Configuration.
     */
	RUAParameterTerminalConfiguration = 388,
    
    /**
     9F1A : Terminal Country Code, 2 bytes
     */
	RUAParameterTerminalCountryCode = 389,
    
    /**
     DF31 : Terminal Decision after Generate AC , 1 byte
     */
	RUAParameterTerminalDecisionafterGenerateAC = 390,
    
    /**
     9F1B : Indicates the floor limit in the terminal in conjunction with the AID
     Mandatory if offline terminal or offline terminal with online capability
     */
	RUAParameterTerminalFloorLimit = 391,
    
    /**
     9F1C : Designates the unique location of a terminal at a merchant
     */
	RUAParameterTerminalIdentification = 392,
    
    /**
     DF0B : Terminal options. 1 byte
     0x01 = 30Must always perform Terminal Risk Management even if the 'Terminal Risk Management to be Performed' bit of the AIP is set to 0.
     */
	RUAParameterTerminalOptions = 393,
    
    /**
     9F1D : Application-specific value used by the card for risk management purposes
     */
	RUAParameterTerminalRiskManagementData = 394,
    
    /**
     9F35 : Indicates the environment of the terminal, its communications capability, and its operational control
     */
	RUAParameterTerminalType = 395,
    
    /**
     DF07 : Thresholdvalue. 4 Bytes
     */
	RUAParameterThresholdvalue = 396,
    
    /**
     DF4D Transaction class.
     */
	RUAParameterTransactionClass = 397,
    
    /**
     5F2A : Indicates the currency code of the transaction according to ISO 4217	, 2 bytes
     eg: value 0826 for Pound, 0840 for Dollar
     */
	RUAParameterTransactionCurrencyCode = 398,
    
    /**
     5F36 : Indicates the implied position of the decimal point from the right of the transaction amount represented according to ISO 4217
     */
	RUAParameterTransactionCurrencyExponent = 399,
    
    /**
     9A : Local date that the transaction was authorised
     YYMMDD
     */
	RUAParameterTransactionDate = 400,
    
    /**
     DF1C : Flag : Transaction forced On-line
     */
	RUAParameterTransactionForcedOnline = 401,
    
    /**
     99 : Transaction Personal Identification Number Data
     */
	RUAParameterTransactionPersonalIdentificationNumberData = 402,
    
    /**
     9F3C : Code defining the common currency used by the terminal in case the Transaction Currency Code is different from the Application Currency Code
     */
	RUAParameterTransactionReferenceCurrency = 403,
    
    /**
     9F3D : Indicates the implied position of the decimal point from the right of the transaction amount, with the Transaction Reference Currency Code represented according to ISO 4217
     */
	RUAParameterTransactionReferenceCurrencyExponent = 404,
    
    /**
     9F41 : Counter maintained by the terminal that is incremented by one for each transaction
     */
	RUAParameterTransactionSequenceCounter = 405,
    
    /**
     9F21 : Local time that the transaction was authorised
     */
	RUAParameterTransactionTime = 406,
    
    /**
     9C : Transaction type, 1 byte
     Indicates the type of financial transaction, represented by the first two digits of the ISO 8583:1987 Processing Code. <br>
     The actual values to be used for the Transaction Type data element are defined by the relevant payment system. <br><br>
     Possible values are:<br>
     0x00 for a purchase transaction <br>
     0x01 for a cash advance transaction<br>
     0x02 for a Reversal Transaction <br>
     0x09 for a purchase with cashback<br>
     0x20 for a refund transaction<br>
     */
	RUAParameterTransactionType = 407,
    
    /**
     DF70 : Transaction type description.
     */
	RUAParameterTransactionTypeDescription = 408,
    
    /**
     DF75 : Partial transaction upto pin verification only flag.
     */
	RUAParameterVerificationonlyTransactionFlag = 409,
    
    /**
     DF8221 Visa debit opt out.
     */
	RUAParameterVisaDebitOptOut = 410,
    
    /**
     DF6A: Visa terminal entry capability.
     **/
	RUAParameterVisaTerminalEntryCapability = 411,
    
    /**
     DF0C : Wrapper for issuer script tag with incorrect length.
     */
	RUAParameterWrapperforIssuerScriptTagWithIncorrectLength = 412,
    
    /**
     9F4C : ICC Dynamic Number 2-8 bytes
     */
    RUAParameterICCDynamicNumber = 413,
    
    /**
     5F2D : Language Preference 2-8 bytes
     */
    RUAParameterLanguagePreference = 414,
    
    /**
     9F08 : ICC Application Version Number
     */
	RUAParameterICCApplicationVersionNumber = 415,
    
    /**
     9F06 : Application Identifier, 16 bytes
     Identifies the application as described in ISO/IEC 7816-5
     */
	RUAParameterTerminalApplicationIdentifier = 416,
    
    
    /**
     DF15 : Default value for DDOL (to use if the DDOL is absent in ICC)
     It is recommended that a default value of ë9F3704í be used here as this is what the major card issuers (MasterCard, Visa, JCB, American Express) require. Contact ICC transaction only.
     */
	RUAParameterDefaultValueForDDOL = 417,
    
    /**
     DF38 : CVMOUT result , 1-2 bytes
     */
	RUAParameterCVMOUTresult = 418,
    
    /**
     DF18 : Default value for TDOL (to use if the TDOL is absent in ICC)
     */
	RUAParameterDefaultValueForTDOL = 419,
    
    
    /**
     Data Mode
     Indicates whether the card data was returned encrypted or in clear, as follows
     0x00	-   Card data was returned in clear,
     0x01	-   Card data was returned encrypted with OnGuard.
     0x02	-   Card data was returned obfuscated with Roam
     */
	RUAParameterEncryptedTrackDataMode = 420,
    
    /**
     84: Dedicated File (DF) Name
     */
	RUAParameterDedicatedFileName = 421,
    
    /**
     9F27 : Cryptogram Information Data , 1 byte <br>
     The Cryptogram Information Data contains the type of Application Cryptogram generated by the card during the Card Action Analysis stage.
     In addition, the card may also return a reason or advice code (e.g. service not allowed, or issuer authentication failed) to allow the
     terminal to perform any additional processing that may be required.<br><br>
     There are 3 type of cryptogram that can be generated by the card:<br>
     - An AAC (0x00) is generated whenever a card declines a transaction.<br>
     - An ARQC (0x80) is generated whenever a card requests online authorization.<br>
     - A TC (0x40) is generated whenever a card approves a transaction.
     */
	RUAParameterCryptogramInformationData = 422,
    
    /** 
	 9F10 : Issuer Application Data, 32 bytes
     transmission to the issuer in an online transaction.
     Note: For CCD-compliant applications, Annex C, section C7 defines the specific coding of the Issuer Application Data (IAD).
     To avoid potential conflicts with CCD-compliant applications, it is strongly recommended that the IAD data element in an application that is not CCD-compliant should not use the coding for a CCD-compliant application
     */
	RUAParameterIssuerApplicationData = 423,
    
    /**
     DF11 : Result of the execution of the script(s) by the payment device, 5 - 160 bytes<br>
     */
	RUAParameterIssuerScriptResults = 424,
    
    /**
     5A : PAN  can vary up to 19 bytes
     Valid card holder account number
     */
	RUAParameterPAN = 425,
    
    /**
     5F34 : PAN Sequence Number , 1 byte
     Identifies and differentiates cards with the same PAN
     */
	RUAParameterPANSequenceNumber = 426,
    
    /**
     56 : Track 1 Data (MasterCard), 76 bytes
     */
	RUAParameterTrack1Data = 427,
    
    RUAParameterTrack2Data = 428,
    
    RUAParameterTrack3Data = 429,
    
    /**
     9F6B : Track 2 Data (MasterCard), 19 bytes
     payWave defines this tag as Card CVM Limit; numeric, 12 digits over 6 bytes.
     PayPass defines this tag as the Track 2 Data; binary, variable up to 19 bytes.
	 *
     */
	RUAParameterTrack2DataMasterCard = 430,
    
    /**
     57 : Track 2 Equivalent Data, 19 bytes
     Contains the data elements of track 2 according to ISO/IEC 7813, excluding start sentinel, end sentinel, and Longitudinal Redundancy Check (LRC), as follows:
     Primary Account Number (n, var. up to 19) Field Separator (Hex 'D') (b) Expiration Date (YYMM) (n 4) Service Code (n 3) Discretionary Data (defined by individual payment systems) (n, var.) Pad with one Hex 'F' if needed to ensure whole bytes (b)
     */
	RUAParameterTrack2EquivalentData = 431,
    
    /**
     9B : Transaction Status Information, 2 bytes
     Indicates the functions performed in a transaction
     */
	RUAParameterTransactionStatusInformation = 432,
    
    /**
     95 : Transaction Verification Results, 5 bytes
     Status of the different functions as seen from the terminal
     */
	RUAParameterTerminalVerificationResults = 433,
    
    /**
     9F37 : Unpredictable Number, 4 bytes
     Value to provide variability and uniqueness to the generation of a cryptogram
     */
	RUAParameterUnpredictableNumber = 434,
    
    RUAParameterVirtualTrackData = 435,
    
    /**
     9F5D : Visa contactless offline available spending amount.  6 Bytes
     */
	RUAParameterVisaContactlessOfflineAvailableSpendingAmount = 436,
    
	RUAParameterOnlineApproval = 437,
    
    /**
     9F67 :NATC Track2 , 1 byte<br>
     The value of NATC(Track2) represents the number of digits of the Application Transaction Counter to be included in the discretionary data field of Track 2 Data.<br>
     */
    RUAParameterNATCTrack2 = 438,
    
    RUAParameterLast4PANDigits = 439,
    
	RUAParameterEncryptedTrack = 440,
    
    /**
     9F53 : Transaction Category Code
     This is a data object defined by MasterCard which indicates the type of transaction being performed,
     and which may be used in card risk management. (1 byte, binary)
     
     Valid Values:
     Hex ASCII Meaning
     '43' 'C' Cash Disbursement
     '5A' 'Z' ATM Cash Disbursement
     '4F' 'O' College/School Expense
     '48' 'H' Hotel, Motel and Cruise Ship Services
     '58' 'X' Transportation
     '41' 'A' Automobile/Vehicle Rental
     '46' 'F' Restaurant
     '54' 'T' Mail, Telephone Order, Pre-authorized Order
     '55' 'U' Unique Transaction
     '52' 'R' Retail, all other transactions
     */
	RUAParameterTransactionCategoryCode = 441,
	
    
    /**
     9F1E : Interface Device (IFD) Serial Number 8 bytes<br>
     */
    RUAParameterInterfaceDeviceSerialNumber = 442,
    
    RUAParameterEncryptedIsoPinBlock = 443,
    
    /**
     Roam Reader Error Code.
     */
	RUAParameterErrorCode = 444,
    
    
    /**
     9F44 : Application Currency Exponent, 1 Byte<br>
     Indicates the implied position of the decimal point from the right of the amount represented according to ISO 4217<br>
     */
	RUAParameterApplicationCurrencyExponent = 445,
    
    /**
     Holds detailed error string
     */
	RUAParameterErrorDetails = 446,
    
    /**
     DF68 : Extra Progress Message Flag
     */
	RUAParameterExtraProgressMessageFlag = 447,
    
    /**
     Format id.
     G4x returns the format ID when mag stripe is decoded successfully. This parameter will hold that value.
     */
	RUAParameterFormatID = 448,
    
    /**
     DF72 : Generate ac control.
     */
	RUAParameterGenerateACControl = 449,
    
    
    /**
     9F07 : Application Usage Control,  2 bytes <br>
     Indicates issuer’s specified restrictions on the geographic usage and services allowed for the application<br>
     */
	RUAParameterApplicationUsageControl=450,
    
    /**
     9F3B : Application Reference Currency, 2 - 8 bytes <br>
     1-4 currency codes used between the terminal and the ICC when the
     Transaction Currency Code is different from the Application Currency
     Code; each code is 3 digits according to ISO 4217<br>
     */
    
    RUAParameterApplicationReferenceCurrency = 451,
    
    /**
     9F43 : Application Reference Currency Exponent, 1 byte <br>
     Indicates the implied position of the decimal point from the right of the
     amount, for each of the 1-4 reference currencies represented according to
     ISO 4217<br>
     */
    
    RUAParameterApplicationReferenceCurrencyExponent = 452,
    
    /**
     9F0B : Cardholder Name Extended, 27 - 45 bytes <br>
     Indicates the whole cardholder name when greater than 26 characters using
     the same coding convention as in ISO 7813<br>
     */
    RUAParameterCardholderNameExtended = 453,
    
    /**
     9F45 : Data Authentication Code, 2 bytes <br>
     An issuer assigned value that is retained by the terminal during the
     verification process of the Signed Static Application Data<br>
     */
    RUAParameterDataAuthenticationCode = 454,
    
    
    /**
     6F : File Control Information Template, 2 bytes <br>
     Identifies the FCI template according to ISO/IEC 7816-4<br>
     */
    RUAParameterFileControlInformationTemplate = 455,
    
    /**
     9F0D : Issuer Action Code - Default, 5 bytes <br>
     Specifies the issuer's conditions that cause a transaction to be rejected
     if it might have been approved online, but the terminal is unable to
     process the transaction online<br>
     */
    RUAParameterIssuerActionCodeDefault = 456,
    
    /**
     9F0E : Issuer Action Code - Denial, 5 bytes <br>
     Specifies the issuer's conditions that cause the denial of a transaction
     without attempt to go online<br>
     */
    RUAParameterIssuerActionCodeDenial = 457,
    
    /**
     9F0F : Issuer Action Code - Online, 5 bytes <br>
     Specifies the issuer's conditions that cause a transaction to be
     transmitted online<br>
     */
    RUAParameterIssuerActionCodeOnline = 458,
    
    /**
     9F11 : Issuer Code Table Index, 1 byte<br>
     Indicates the code table according to ISO/IEC 8859 for displaying the
     Application Preferred Name<br>
     */
    RUAParameterIssuerCodeTableIndex = 459,
    
    /**
     90 : Issuer Public Key Certificate, 64-248 bytes<br>
     Indicates the code table according to ISO/IEC 8859 for displaying the
     Application Preferred Name<br>
     */
    RUAParameterIssuerPublicKeyCertificate = 460,
    
    /**
     9F64 :NATC Track1 , 1 byte<br>
     The value of NATC(Track1) represents the number of digits of the Application Transaction Counter to be included in the discretionary data field of Track 1 Data.<br>
     */
    RUAParameterNATCTrack1 = 461,
    
    
    /**
     9F65 : PCVC3-TRACK2 , 2 bytes<br>
     PCVC3(Track2) indicates to the Kernel the positions in the discretionary data field of the Track 2 Data where the CVC3 (Track2) digits must be copied.
     */
    RUAParameterPCVC3Track2 = 462,
    
    
    /**
     9F6B : Track 2 Data Contactless , 0 - 19 bytes<br>
     Track 2 Data contains the data objects of the track 2 according to [ISO/IEC 7813], excluding start sentinel, end sentinel and LRC. The Track 2 Data is present in the file read using the READ RECORD command during a mag-stripe mode transaction.<br>
     */
    RUAParameterTrack2DataContactless = 463,
    
    
    
    /**
     9F22 : Certification Authority Public Key Index (PKI), 1 byte<br>
     Identifies the Certificate Authority’s public key in conjunction with the RID for use in offline static and dynamic data authentication.<br>
     */
	RUAParameterCertificationAuthorityPKI = 464,
    
    /**
     9F18 : Issuer Script Identifier, 4 bytes<br>
     May be sent in authorisation response from issuer when response contains Issuer Script. Assigned by the issuer to uniquely identify the Issuer Script.<br>
     */
	RUAParameterIssuerScriptIdentifier = 465,
    
    /**
     9F4E : Merchant Name and Location, variable length <br>
     Indicates the name and location of the merchant. The reader shall return the value of the Merchant Name and Location when requested by the card in a Data Object List.<br>
     */
	RUAParameterMerchantNameLocation = 466,
    
    /**
     9F7A : VLP Terminal Support Indicator, 1 byte	<br>
     If present indicates offline and/or online support. If absent indicates online only support	Terminal<br>
     */
	RUAParameterVLPTerminalSupportIndicator = 467,
    
    /**
     PUNATC (Track2), 2 bytes <br>
     PUNATC(Track2) indicates to the Kernel the positions in the discretionary data field of Track 2 Data where the Unpredictable Number (Numeric) digits and Application Transaction Counter digits have to be copied.<br>
     */
	RUAParameterPUNATCTrack2 = 468,
    
    /**
     9F60 : CVC3 (Track1) , 2 bytes<br>
     The CVC3 (Track1) is a 2-byte cryptogram returned by the Card in the response to the COMPUTE CRYPTOGRAPHIC CHECKSUM command.<br>
     */
    RUAParameterCVC3Track1 = 469,
    
    /**
     9F14 : Lower Consecutive Offline Limit, 1 byte<br>
     Issuer-specified preference for the maximum number of consecutive offline
     transactions for this ICC application allowed in a terminal with online
     capability<br>
     */
    RUAParameterLowerConsecutiveOfflineLimit = 470,
    
    /**
     9F17 : Personal Identification Number (PIN) Try Counter, 1 byte<br>
     Number of PIN tries remaining<br>
     */
    RUAParameterPersonalIdentificationNumberTryCounter = 471,
    
    /**
     88 : Short File Indicator, 1 byte<br>
     Identifies the AEF referenced in commands related to a given ADF or DDF.
     It is a binary data object having a value in the range 1 to 30 and with
     the three high order bits set to zero.<br>
     */
    RUAParameterShortFileIndicator = 472,
    
    /**
     9F1F : Track 1 Discretionary Data, variable length 1-255 bytes<br>
     Discretionary part of track 1 according to ISO/IEC 7813<br>
     */
    RUAParameterTrack1DiscretionaryData = 473,
    
    /**
     9F20 : Track 2 Discretionary Data, variable length 1-255 bytes<br>
     Discretionary part of track 2 according to ISO/IEC 7813<br>
     */
    RUAParameterTrack2DiscretionaryData = 474,
    
    /**
     9F23 : Upper Consecutive Offline Limit, 1 byte<br>
     Issuer-specified preference for the maximum number of consecutive offline
     transactions for this ICC application allowed in a terminal without
     online capability<br>
     */
    RUAParameterUpperConsecutiveOfflineLimit = 475,
    
    /**
     9F61 : CVC3 (Track2), 2 bytes<br>
     The CVC3 (Track2) is a 2-byte cryptogram returned by the Card in the
     response to the COMPUTE CRYPTOGRAPHIC CHECKSUM command.
     */
    RUAParameterCVC3 = 476,
    
    /**
     9F62 : PCVC3 (Track1), 6 bytes<br>
     PCVC3(Track1) indicates to the Kernel the positions in the discretionary
     data field of the Track 1 Data where the CVC3 (Track1) digits must be
     copied.<br>
     */
    RUAParameterPCVC3 = 477,
    
    /**
     9F4D : Log Entry, 2 bytes<br>
     Provides the SFI of the Transaction Log file and its number of records
     */
    RUAParameterLogEntry = 478,
    
    /**
     5F50 : Issuer URL, variable length 1-255 bytes<br>
     The URL provides the location of the Issuer's Library Server on the
     Internet.<br>
     */
    RUAParameterIssuerURL = 479,
    
    /**
     9F79 : VLP Available Funds, variable length 1-255 bytes<br>
     A counter that is decremented by the Amount Authorized when a VLP
     transaction is approved.<br>
     */
    RUAParameterVLPAvailableFunds = 480,
    
    /**
     9F77 : VLP Funds Limit, variable length 1-255 bytes<br>
     A Visa proprietary data element, Issuer Limit for VLP available funds, is
     used to reset VLP Available Funds after an online approved transaction.
     */
    RUAParameterVLPFundsLimit = 481,
    
    /**
     9F74 : VLP Issuer Authorisation Code, 6 bytes<br>
     A Visa proprietary data element containing a code indicating that the
     transaction was an approved VLP transaction. If present indicates offline
     approval from card.<br>
     */
    RUAParameterVLPIssuerAuthorisationCode = 482,
    
    /**
     9F78 : VLP Single Transaction Limit, variable length 1-255 bytes<br>
     A Visa proprietary data element indicating the maximum amount allowed for
     single VLP transaction
     */
    RUAParameterVLPSingleTransactionLimit = 483,
    
    /**
     9F52 : Terminal Compatibility Indicator, 1 byte<br>
     Indicates to the card the transaction modes (EMV, Magstripe) supported by
     the Kernel
     */
    RUAParameterTerminalCompatibilityIndicator = 484,
    
    /**
     9F7B : VLP Terminal Transaction Limit,variable length 1-255 bytes<br>
     */
    RUAParameterVLPTerminalTransactionLimit = 485,
    
    /**
     98 : Transaction Certificate (TC) Hash Value, 20 bytes <br>
     */
    RUAParameterTransactionCertificateHashValue = 486,
    
    /**
     9F13 : Last Online Application Transaction Counter (ATC) Register, 2
     bytes<br>
     ATC value of the last transaction that went online<br>
     */
    RUAParameterLastOnlineApplicationTransactionCounterRegister = 487,
    
    /**
     9F63 :PUNATC (Track1), 6 bytes<br>
     PUNATC(Track1) indicates to the Kernel the positions in the discretionary data field of Track 1 Data where the Unpredictable Number (Numeric) digits and Application Transaction Counter digits have to be copied.<br>
     */
    RUAParameterPUNATCTrack1 = 488,
    
    /**
     5F28: Issuer Country Code, 2 bytes<br>
     */
    RUAParameterIssuerCountryCode = 489,
    
    RUAParameterTrack1Status = 490,

    RUAParameterTrack2Status = 491,
    
    RUAParameterTrack3Status = 492,

	RUAParameterBatteryLevel = 493,
    
    /**
     42: Issuer Identification Number (IIN)<br>
     The number that identifies the major industry and the card issuer and that forms the first part of the Primary Account Number (PAN)<br>
     From ICC<br>
     Length: 3 bytes (binary, NNNNNN)<br>
     */
    RUAParameterIssuerID = 494,
    
    /**
     9F5B: Issuer Script Results (For Processor), 1 - 5 bytes<br>
     Indicates the results of Issuer Script processing. When the reader/terminal transmits this data element to the acquirer, in this version of Kernel 3, it is acceptable that only byte 1 is transmitted, although it is preferable for all five bytes to be transmitted.<br>
     */
    
    RUAParameterIssuerScriptResultsForProcessor = 495,

	RUAParameterSystemCountTotalSwipes  = 496,

	RUAParameterSystemCountAudioJackInsertions = 497,

	RUAParameterSystemCountUSBEvent = 498,

	RUAParameterSystemCountBadSwipes = 499,

	RUAParameterSystemCountFallbackSwipes = 500,

	RUAParameterSystemCountChipInsertions = 501,

	RUAParameterSystemCountPowerOnFailForChipCards = 502,

	RUAParameterSystemCountAPDUFailForChipCards = 503,

	RUAParameterSystemCountRFWupa = 504,

	RUAParameterSystemCountClessActivateFail = 505,

	RUAParameterSystemCountClessAPDUFail = 506,

	RUAParameterSystemCountCharges = 507,

	RUAParameterSystemCountBluetoothConnectionsLost  = 508,

	RUAParameterSystemCountOutOfBattery  = 509,

	RUAParameterSystemCountCompleteCharge = 510,

	RUAParameterSystemCountCommands = 511,

	RUAParameterSystemCountPowerON = 512,
	
	RUAParameterSystemCountKeyHit = 513,

	RUAParameterReaderVersionInfo = 514,

	/**
	 * 87 : Application Priority Indicator, 1 byte <br>
	 * Indicates the priority of a given application or group of applications in
	 * a directory <br>
	 */
	RUAParameterApplicationPriorityIndicator = 515,

	/**
	 * 9F6C: Card Transaction Qualifiers, 2 bytes <br>
	 * In this version of the specification, used to indicate to the device the card CVM requirements, issuer preferences, and card capabilities.<br>
	 */
	RUAParameterCardTransactionQualifiers = 516,

	/**
	9F6D : VLP Reset Threshold, variable length 1-6 bytes<br>
	*/
	RUAParameterVLPResetThreshold = 517,

	/**
	 * 9F68 : Card Additional Processes, 4 bytes
	 */
	RUAParameterCardAdditionalProcesses = 518,

	/**
	 9F7C : CustomerExclusiveData , 1-32 bytes
	 */
	RUAParameterCustomerExclusiveData = 519,

	/**
	 9F6E : Form Factor Indicator, 4 bytes
	 **/
	RUAParameterFormFactorIndicator = 520,

	/**
	 9F6E : Pay pass third party data
	 * */
	RUAParameterPayPassThirdPartyData = 521,
    
    /**
     * 9F5A: Application Program Identifier (Program ID), 1-16 bytes <br>
     * Payment system proprietary data element identifying the Application Program ID of the card application. When personalised, the Application Program ID is returned in the FCI Issuer Discretionary Data of the SELECT response (Tag ‘BF0C'). EMV mode readers that support Dynamic Reader Limits (DRL) functionality examine the Application Program ID to determine the Reader Limit Set to apply.<br>
     */
    
    RUAParameterApplicationProgramIdentifier = 522,
    
    RUAParameterRawResponseWithResponseCode = 523,

    /**
     * DF8129 Outcome Parameter Set 8 bytes
     * Description: This data object is used to indicate to the Terminal the outcome of the transaction processing by the Kernel. Its value is an accumulation of results about applicable parts of the transaction.
     **/

    RUAParameterOutcomeParameterSet = 524,
    
    RUAParameterEncryptedEMVData = 525,
    
    RUAParameterManuallyEnteredPAN = 526,
    
    RUAParameterManuallyEnteredExpiryDate =527,

    /**
     DF56 : Discover Dpas Pseudo Track 1 Data, up to 80 bytes
     * */
    RUAParameterDiscoverDPASPseudoTrack1Data =528,

    /**
     DF57 : Discover Dpas Pseudo Track 2 Data, up to 50 bytes
     * */
    RUAParameterDiscoverDPASPseudoTrack2Data =529,
    
    /**
     *  Parameter related to RKI for Read Key Mapping Information
     */
    RUAParameterKeyMappingInfo = 530,

    /**
     *  This indicated the file version for the certificates installed in the card reader. 
     */
    RUAParameterReadCertificateFilesVersionInfo=531,

    RUAParameterVirtualTrack5Data = 532,

    /**
     DF8230 : Force ONLINE PIN
     0x00 = Default CVM processing
     0x01 = force online PIN as CVM (used for US contactless MSR Debit)
     */
    RUAParameterForceOnlinePIN = 533,

    /**
     DF8231 : Enable contactless PIN bypass
     0x00 = Default no PIN bypass for contactless CVMs
     0x01 = Enable contactless PIN bypass (used for US contactless MSR Debit)
     @deprecated
     * */
    RUAParameterEnableContactlessPINBypass __deprecated_msg("Use RUAParameterPinByPassCFG instead") = 534,
    
    /**
     DF4B : POS Cardholder Interaction Information informs the Kernel about the indicators set in
     the mobile phone that may influence the action flow of the merchant and cardholder. (Mastercard specific)
     */
    RUAParameterPOSCardholderInteractionInformation = 535,
    
    /**
     Returns a boolean value, to indicate if device is charging
     */
    RUAParameterIsDeviceCharging = 536,

    /**
     Returns the redacted card number
     */
    RUAParameterRedactedCardNumber= 537,

    RUAParameterFirmwareVersionString = 538,
    
    //Apple VAS Responses
    RUAParameterVASVersion = 539,
    
    RUAParameterVASMerchantsCount = 540,
    
    RUAParameterLastVASErrorMessage = 541,
    
    RUAParameterVASExchangedMessageLog = 542,

    RUAParameterVASData = 543,
    
    RUAParameterShouldProceedWithPayment = 544,
    
    RUAParameterVASResponseCodeInfo = 545,
    
    RUAParameterFirmwareChecksumInfo = 546,
    
    RUAParameterZipCode = 547,
    
    /**
     * DF8237 : TDES DUKPT Key Locator, 4 bytes<br>
     * E2EE DUKPT key : 00000001 <br>
     * Bank DUKPT keys : <br>
     * PIN key : key locator 00010001<br>
     * MAC key : key locator 00010002<br>
     * COM key : key locator 00010003<br>
     */
    RUAParameterOnlinePINKeyLocator = 548,
    
    /**
     DF8238 : Pin bypass config
     <br>
     0x00 - Bypass forbidden
     <br>
     0x01 - Green key
     <br>
     0x02 - Red key
     * */
    RUAParameterPinByPassCFG = 549,
    
    RUAParameterTipAmount = 550,
    
    /**
     9F71: Mobile CVM Results, 2-3 bytes<br>
     */
    RUAParameterMobileCVMResults = 551,
    
    /**
     DF8236 : Enable Pin on Glass
     */
    RUAParameterEnablePinOnGlass = 552,
    
    /**
     DF8233: Enable US Debit Credit Menu
     0 = Default no menu
     1 = Enable Debit/Credit Menu in case of swipe (used for US MSR)
     */
    RUAParameterEnableUSDebitCreditMenu = 553,
    
    /**
     DF8234 : US Debit Credit Menu Filter
     Only relevant if RUAParameterEnableUSDebitCreditMenu has been set to 1
     <br>
     Examples:
     DF8234 01 7C - no filter
     DF8234 02 33 34 - Debit/credit for all cards except those with PAN starting by 34
     DF8234 03 33 34 7C - Debit/credit for all cards except those with PAN starting by 34
     DF8234 0B 33 34 7C 33 37 7C 35 34 31 33 33 - filter on PAN starting by 34 or 37 or 54133
     */
    RUAParameterUSDebitCreditMenuFilter = 554,
    
    /**
     DF8244 : Supports DSP2 European rules & allows passing Visa performance test
     */
    RUAParameterMagStripeFallbackRules = 555,
    
    /**
     DF8247: The scheme used to encrypt the following clear text will be RSAES-OAEP 2048 bit
     as outlined in PKCS #1: RSA Cryptography Specifications Version 2.0 (RFC 2437).
     Any cipher text data returned to POS will be standard Base 64 encoded (RFC 4648 and RFC 2045).
     */
    RUAParameterRSAEncryptedDataWM = 556,
    
    /**
     DF8245: The scheme used to encrypt the following clear text will be RSAES-OAEP 2048 bit
     as outlined in PKCS #1: RSA Cryptography Specifications Version 2.0 (RFC 2437).
     Any cipher text data returned to POS will be standard Base 64 encoded (RFC 4648 and RFC 2045).
     */
    RUAParameterRSAEncryptedDataOAEP = 557,
    
    /**
     DF8224: (CVV, CVC2, CID)
     This tag contains a number which is the card security code from Card Data Key Entry
     This tag can only be found inside a decrypted DF8223 or DF8245 buffer.
     */
    RUAParameterCardSecurityCode = 558,
    
    /**
     DF8246: The RSAOAEP key ID is variable lenghth up to 11-octet alphanumeric hex string previously loaded using 90.5 Equivalent RSA OAEP
     Encryption - Dynamically Updating RSA-OAEP Public Keys.
     */
    RUAParameterRSAKeyIDOAEP = 559,
    
    /**
     DF8248:
     The key RSA_WM ID is an 11-octet alphanumeric hex string that is tied to the specific public key certificate.
     This key ID will be embedded in the common name field of the subject field of the public key certificate. The leftmost eleven (11) characters before the period are considered the key ID (i.e., “19fea71d8a6.p2pe.testlabs.walmart”). This key is case insensitive.
     The L1 function should extract the key ID and send it to POS with any cipher text that was generated with that key.
     The key ID will be followed explicitly by the characters “.p2pe” for parsing by the L1 function. The key ID will not be considered valid if those five (5) characters do not follow the key ID
     */
    RUAParameterRSAKeyIDWM = 560,
    
    RUAParameterReaderKeyPressCaptured = 561,
    
    /*
    Proprietary data allowing for Proprietary processing during application selection. Proprietary data is identified using Proprietary Data Identifiers that are managed by EMVCo and their usage by the Entry Point is according to their intended usage, as agreed by EMVCo during registration.
    */
    RUAParameterApplicationSelectionRegisteredProprietaryData = 562,
    
    RUAParameterReaderVersionInfoExt = 563,
    
    /**
     DF8261: VirtualTrack6Data, vary up to 44 bytes
     Only supported on USER FW version 10.17 and above
     */
    RUAParameterVirtualTrack6Data = 564,
    
    RUAParameterFirst6PANDigits = 565,
    
    RUAParameterOnGuardKSN = 566,
    
    RUAParameterSwipedDataWKPAN = 567,
    
    /**
     Inquires if a smart card is fully inserted in the reader or fully removed.
    */
    RUAParameterCardInsertionStatus = 568,
    
    /**
     Defines minimum battery level to start a transaction. Min bat level is 12% by default.
     Fixed length = 1 byte
     Value range = 0 ~ 25 (0x00 ~ 0x19)
    */
    RUAParameterMinBatteryLevel = 569,
    
    RUAParameterDeviceLogs = 570,
    
    RUAParameterCustomMenuSelectionResponse = 571,
    
    RUAParameterIsCardPresentInRFField = 572,
    
    /**
     DF8050: VAS Transaction Timeout, 2 bytes
     Timeout in milliseconds, most signifact byte first
     FFFF represents infinite timeout
     */
    RUAParameterVasTransactionTimeout= 573,
    
    /**
    DF8051: VAS cancel method,  1 byte
    Events Which Can Interrupt VAS in Dual Mode beside Contactless EMV Card
    0x01 - Magnetic Swipe
    0x02 - Chip Card Insetion
    0x03 - Key Press
    */
    RUAParameterVasCancelMethod = 574,
    
    /**
    DF8052: VAS transaction result,  1 byte
    */
    RUAParameterVasTransactionResult = 575,
    
    /**
     DF8228: APDU Answer
     */
	RUAParameterAPDUAnswer = 576,
    
    /**
     * DF8235: DisableDomesticPropertyFiltering
     *
     * Bitfield:
     * all set to 0 = Default Filter candidate list using domestic property & CC & IIN checks
     * Bit 1 = Disable candidate list filtering for contact & contactless (has priority on all other bits)
     * Bit 2 = Domestic filtering disabled for contact (has priority on Bit 4)
     * Bit 3 = Domestic filtering disabled for contactless (has priority on Bit 5)
     * Bit 4 = Domestic filtering for contact with CC & IIN filtering disabled
     * Bit 5 = Domestic filtering for contactless with CC & IIN filtering disabled
     */
    RUAParameterDisableDomesticPropertyFiltering = 577,
    
    /**
     Boolean value indicating verify mac command result, returns true if there is a match, otherwise false
     */
    RUAParameterVerifyMacResult = 578,
    
    RUAParameterComputedMac = 579,
    
    /**
     DF8053: VAS Set Mode
     Optional tag to configure VAS mode. This tag supersedes settings made through the enableVASMode command.
     0x00 - VAS ONLY
     0x01 - DUAL MODE
     0x02 - PAY ONLY
     0x03 - SIGNUP
     0x04 - SINGLE
     SIGNUP mode can be combined with others by adding 0x10. Example: 0x10 - VAS ONLY + SIGNUP, 0x14 - SINGLE + SIGNUP
    */
    RUAParameterVasSetMode = 580,
    
    RUAParameterDOLFormat = 581,
    
    RUAParameterSwipedDataTrack1 = 582,
    
    RUAParameterSwipedDataTrack2 = 583,
    
    RUAParameterSwipedDataTrack3 = 584,
    
    /**
     Form Factor Indicator
     */
    RUAParameterInteracIcFormFactorIndicator = 585,
    
    /**
      Card Transaction Information
     */
    RUAParameterInteracCardTransactionInformation = 586,
    
    /**
     Terminal Transaction Information
     */
    RUAParameterInteracTerminalTransactionInformation = 587,
    
    /**
     Terminal Transaction Type
     */
    RUAParameterInteracTerminalTransactionType = 588,
    
    /**
     Contactless floor limit
     */
    RUAParameterInteracContactlessFloorLimit = 589,
    
    /**
     Terminal Option Status
     */
    RUAParameterInteracTerminalOptionStatus = 590,
    
    /**
     Merchant Type Indicator
     */
    RUAParameterInteracMerchantTypeIndicator = 591,
    
    /**
     Terminal Contactless Receipt Required Limit
     */
    RUAParameterInteracTerminalContactlessReceiptRequiredLimit = 592,
    
    /**
     Interac Receipt Status
     */
    RUAParameterInteracInteracReceiptStatus = 593,
    
    RUAParameterQpsFlag = 594,
    RUAParameterQpsLimit = 595,
    RUAParameterCTQFlag = 596,
    RUAParameterMerchantRoutingLimit = 597,
    RUAParameterMerchantRoutingFlag = 598,
    
    
    RUAParameterAESKSN = 599,
    
    RUAParameterRoamAESEncryptedEMVdata = 600,
    
    RUAParameterExpectedOverallFirmwareVersion = 601,
    RUAParameterExpectedDynamicConfigurationVersion = 602,
    RUAParameterExpectedStaticSoftwareVersion = 603,
    
    /**
     DF840B : support of Transaction mode tag
     1 : for debit transaction, reader will leave debit AID only in candidate list
     2 : for credit transaction, reader will leave credit AID only in candidate list
     Otherwise, this tag is ignored
     
     WARNING : Firmware 13.08 or higher is required.
     */
    RUAParameterTransactionMode = 604,
    
    
    RUAParameterPrintablePan = 605,
    
    RUAParameterMagstripFallbackReason = 606,
    
    RUAParameterRawErrorCode = 607,
    
    RUAParameterDisableBypassForDomesticCardTag = 608,
    
    RUAParameterRSAOEPSigningKeyId = 609,
    
    RUAParameterE2EEMode = 610,
    RUAParameterNBin = 611,
    RUAParameterExtensiveFlag = 612,
    RUAParameterEncryptionPANEndType = 613,
    RUAParameterEncryptionType = 614,
    RUAParameterPaddingType = 615,
    RUAParameterMSRFormat = 616,
    
    /**
     Jspeedy parameters
     */
    RUAParameterJspeedyTerminalCompatibilityIndicator = 617,
    RUAParameterJspeedyDynamicTerminalInterchangeProfile = 618,
    RUAParameterJspeedyCombinationOptions = 619,
    RUAParameterJspeedyStaticTerminalInterchangeProfile = 620,
    
    /**
     DF8232 : Enable US Quick Chip Mode
     0x00 - Disable
     0x01 - Enable
     */
    RUAParameterEnableUSQuickChipMode = 996,

    RUAParameterP2Field = 997,

    RUAParameterEMVTLVData = 998,

	RUAParameterUnknown= 999,
};


#endif
