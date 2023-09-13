//
//  EMVTagDescriptor.h
//  GlobalMobileSDK
//
//  Created by Govardhan Padamata on 8/2/20.
//  Copyright (c) 2020 GlobalPayments. All rights reserved.
//

#ifndef EMVTagDescriptor_h
#define EMVTagDescriptor_h

typedef NS_ENUM(NSUInteger, EMVTagDescriptor)
{

    //region General EMV Tags.
    /**
     * The number that identifies the major industry and the card issuer and that forms the first part of the Primary
     * Account Number (PAN)EMVTagDescriptor.h
     */
    EMV_TAG_ISSUER_IDENTIFICATION_NUMBER = 0x42,


    /**
     * The ADF Name identifies the application as described in [ISO 7816-5]. The AID is made up of the Registered
     * Application Provider Identifier (RID) and the Proprietary Identifier Extension (PIX).
     */
    EMV_TAG_APPLICATION_IDENTIFIER = 0x4F,

    /**
     * Mnemonic associated with AID according to [ISO 7816-5]. Used in application selection.
     */
    EMV_TAG_APP_LABEL = 0x50,

    /**
     * Track 1 Data contains the data objects of the track 1 according to [ISO/IEC 7813] Structure B, excluding start
     * sentinel, end sentinel and LRC.
     */
    EMV_TAG_TRACK_1 = 0x56,

    /**
     * Contains the data elements of track 2 according to ISO/IEC 7813, excluding start sentinel, end sentinel, and
     * Longitudinal Redundancy Check  = LRC, as follows:
     */
    EMV_TAG_TRACK_2_EQUIVALENT_DATA = 0x57,

    /**
     * Valid cardholder account number
     */
    EMV_TAG_PAN = 0x5A,

    /**
     * Indicates cardholder name according to ISO 7813
     */
    EMV_TAG_CARDHOLDER_NAME = 0x5F20,

    /**
     * Date after which application expires. The date is expressed in the YYMMDD format.
     */
    EMV_TAG_APPLICATION_EXPIRATION_DATE = 0x5F24,

    /**
     * Date from which the application may be used. The date is expressed in the YYMMDD format.
     */
    EMV_TAG_APPLICATION_EFFECTIVE_DATE = 0x5F25,

    /**
     * Indicates the country of the issuer according to ISO 3166-1
     */
    EMV_TAG_ISSUER_COUNTRY_CODE = 0x5F28,

    /**
     * Indicates the currency code of the transaction according to ISO 4217
     */
    EMV_TAG_TRANSACTION_CURRENCY_CODE = 0x5F2A,

    /**
     * 1-4 languages stored in order of preference, each represented by 2 alphabetical characters according to ISO 639
     * <p/>
     * Note: EMVCo strongly recommends that cards be personalised with data element '5F2D' coded in lowercase, but that
     * terminals accept the data element whether it is coded in upper or lower case.
     */
    EMV_TAG_LANGUAGE_PREFERENCE = 0x5F2D,

    /**
     * Service code as defined in ISO/IEC 7813 for Track 1 and Track 2
     */
    EMV_TAG_SERVICE_CODE = 0x5F30,

    /**
     * Identifies and differentiates cards with the same Application PAN
     */
    EMV_TAG_PAN_SEQUENCE_NUMBER = 0x5F34,

    /**
     * Indicates the implied position of the decimal point from the right of the transaction amount represented
     * according to ISO 4217. Required to determine if Status Check is requested.
     */
    EMV_TAG_TRANSACTION_CURRENCY_EXPONENT = 0x5F36,

    /**
     * The URL provides the location of the Issuer's Library Server on the Internet.
     */
    EMV_TAG_ISSUER_URL = 0x5F50,

    /**
     * Uniquely identifies the account of a customer at a financial institution as defined in ISO 13616.
     */
    EMV_TAG_INTERNATION_BANK_ACCOUNT_NUMBER = 0x5F53,

    /**
     * Uniquely identifies a bank as defined in ISO 9362.
     */
    EMV_TAG_BANK_IDENTIFIER_CODE = 0x5F54,

    /**
     * Indicates the country of the issuer as defined in ISO 3166 (using a 2 character alphabetic code)
     */
    EMV_TAG_ISSUER_COUNTRY_CODE_ALPHA_2 = 0x5F55,

    /**
     * Indicates the country of the issuer as defined in ISO 3166 (using a 3 character alphabetic code)
     */
    EMV_TAG_ISSUER_COUNTRY_CODE_ALPHA_3 = 0x5F56,

    /**
     * Indicates the type of account selected on the terminal.
     */
    EMV_TAG_ACCOUNT_TYPE = 0x5F57,

    /**
     * Template containing one or more data objects relevant to an application directory entry according to [ISO
     * 7816-5].
     */
    EMV_TAG_APPLICATION_TEMPLATE = 0x61,

    /**
     * Identifies the FCP template according to ISO/IEC 7816-4
     */
    EMV_TAG_FILE_CONTROL_PARAMETERS_TEMPLATE = 0x62,

    /**
     * Identifies the FCI template according to ISO/IEC 7816-4
     */
    EMV_TAG_FILE_CONTROL_INFORMATION_TEMPLATE = 0x6F,

    /**
     * Template containing the data objects returned by the Card in response to a READ RECORD command.
     */
    EMV_TAG_READ_RECORD_RESPONSE_MESSAGE_TEMPLATE = 0x70,

    /**
     * Contains proprietary issuer data for transmission to the ICC before the second GENERATE AC command.
     */
    EMV_TAG_ISSUER_SCRIPT_TEMPLATE_1 = 0x71,

    /**
     * Contains proprietary issuer data for transmission to the ICC after the second GENERATE AC command.
     */
    EMV_TAG_ISSUER_SCRIPT_TEMPLATE_2 = 0x72,

    /**
     * Issuer discretionary part of the directory according to ISO/IEC 7816-5
     */
    EMV_TAG_DIRECTORY_DISCRETIONARY_TEMPLATE = 0x73,

    /**
     * Contains the data objects (with tags and lengths) returned by the ICC in response to a command
     */
    EMV_TAG_RESPONSE_MESSAGE_TEMPLATE_FORMAT_1 = 0x77,

    /**
     * Contains the data objects (without tags and lengths) returned by the ICC in response to a command
     */
    EMV_TAG_RESPONSE_MESSAGE_TEMPLATE_FORMAT_2 = 0x80,

    /**
     * Authorised amount of the transaction (excluding adjustments)
     */
    EMV_TAG_AMOUNT_AUTHORIZED_BINARY = 0x81,

    /**
     * Indicates the capabilities of the card to support specific functions in the application
     */
    EMV_TAG_APPLICATION_INTERCHANGE_PROFILE = 0x82,

    /**
     * Identifies the data field of a command message
     */
    EMV_TAG_COMMAND_TEMPLATE = 0x83,

    /**
     * Identifies the name of the DF as described in ISO/IEC 7816-4
     */
    EMV_TAG_DEDICATED_FILE_NAME = 0x84,

    /**
     * Contains a command for transmission to the ICC
     */
    EMV_TAG_ISSUER_SCRIPT_COMMAND = 0x86,

    /**
     * Indicates the priority of a given application or group of applications in a directory
     */
    EMV_TAG_APPLICATION_PRIORITY_INDICATOR = 0x87,

    /**
     * Identifies the AEF referenced in commands related to a given ADF or DDF. It is a binary data object having a
     * value in the range 1 to 30 and with the three high order bits set to zero.
     */
    EMV_TAG_SHORT_FILE_IDENTIFIER = 0x88,

    /**
     * Non-zero value generated by the Authorisation Systems for an approved transaction.
     */
    EMV_TAG_AUTHORIZATION_CODE = 0x89,

    /**
     * Indicates the transaction disposition of the transaction received from the issuer for online authorisations.
     */
    EMV_TAG_AUTHORIZATION_RESPONSE_CODE = 0x8A,

    /**
     * List of data objects (tag and length) to be passed to the ICC in the first GENERATE AC command
     */
    EMV_TAG_CARD_RISK_MANAGEMENT_DATA_OBJECT_LIST_1 = 0x8C,

    /**
     * List of data objects (tag and length) to be passed to the ICC in the second GENERATE AC command
     */
    EMV_TAG_CARD_RISK_MANAGEMENT_DATA_OBJECT_LIST_2 = 0x8D,

    /**
     * Identifies a method of verification of the cardholder supported by the application
     */
    EMV_TAG_CARD_VERIFICATION_METHOD_LIST = 0x8E,

    /**
     * Identifies the certification authority's public key in conjunction with the RID
     */
    EMV_TAG_CA_PUBLIC_KEY_INDEX = 0x8F,

    /**
     * Issuer public key certified by a certification authority
     */
    EMV_TAG_ISSUER_PUBLIC_KEY_CERTIFICATE = 0x90,

    /**
     * Data sent to the ICC for online Issuer Authentication
     */
    EMV_TAG_ISSUER_AUTHENTICATION_DATA = 0x91,

    /**
     * Remaining digits of the Issuer Public Key Modulus
     */
    EMV_TAG_ISSUER_PUBLIC_KEY_REMAINDER = 0x92,

    /**
     * Digital signature on critical application parameters that is used in static data authentication (SDA).
     */
    EMV_TAG_SIGNED_STATIC_APP_DATA = 0x93,

    /**
     * Indicates the location (SFI range of records) of the Application Elementary Files associated with a particular
     * AID, and read by the Kernel during a transaction
     */
    EMV_TAG_APPLICATION_FILE_LOCATOR = 0x94,

    /**
     * Status of the different functions from the Terminal perspective. The Terminal Verification Results is coded
     * according to Annex C.5 of [EMV Book 3].
     */
    EMV_TAG_TERMINAL_VERIFICATION_RESULTS = 0x95,

    /**
     * List of data objects (tag and length) to be used by the terminal in generating the TC Hash Value
     */
    EMV_TAG_TRANSACTION_CERTIFICATE_DATA_OBJECT_LIST = 0x97,

    /**
     * Result of a hash function specified in Book 2, Annex B3.1
     */
    EMV_TAG_TRANSACTION_CERTIFICATE_HASH_VALUE = 0x98,

    /**
     * Data entered by the cardholder for the purpose of the PIN verification
     */
    EMV_TAG_PIN = 0x99,

    /**
     * Local date that the transaction was authorised. Requested in CDOL1.
     */
    EMV_TAG_TRANSACTION_DATE = 0x9A,

    /**
     * Indicates the functions performed in a transaction
     */
    EMV_TAG_TRANSACTION_STATUS_INFORMATION = 0x9B,

    /**
     * Indicates the type of financial transaction, represented by the first two digits of the ISO 8583:1987 Processing
     * Code.
     * <p/>
     * Requested in CDOL1. Possible values are:
     * <ul>
     * <li>'00' for a purchase transaction</li>
     * <li>'01' for a cash advance transaction</li>
     * <li>'09' for a purchase with cashback</li>
     * <li>'20' for a refund transaction</li>
     * </ul>
     */
    EMV_TAG_TRANSACTION_TYPE = 0x9C,

    /**
     * Identifies the name of a DF associated with a directory
     */
    EMV_TAG_DIRECTORY_DEFINITION_FILE_NAME = 0x9D,

    /**
     * Uniquely identifies the acquirer within each payment system
     */
    EMV_TAG_ACQUIRER_ID = 0x9F01,

    /**
     * Authorised amount of the transaction (excluding adjustments).
     * <p/>
     * This amount is expressed with implicit decimal point corresponding to the minor unit of currency as defined by
     * [ISO 4217] (for example the six bytes '00 00 00 00 01 23' represent USD 1.23 when the currency code is '840').
     */
    EMV_TAG_AMOUNT_AUTHORIZED_NUMERIC = 0x9F02,

    /**
     * Secondary amount associated with the transaction representing a cash back amount.
     * <p/>
     * This amount is expressed with implicit decimal point corresponding to the minor unit of currency as defined by
     * [ISO 4217] (for example the 6 bytes '00 00 00 00 01 23' represent GBP 1.23 when the currency code is '826').
     */
    EMV_TAG_AMOUNT_OTHER_NUMERIC = 0x9F03,

    /**
     * Secondary amount associated with the transaction representing a cash back amount
     */
    EMV_TAG_AMOUNT_OTHER_BINARY = 0x9F04,

    /**
     * Issuer or payment system specified data relating to the application
     */
    EMV_TAG_APPLICATION_DISCRETIONARY_DATA = 0x9F05,

    /**
     * Identifies the application as described in ISO/IEC 7816-5
     */
    EMV_TAG_AID_TERMINAL = 0x9F06,

    /**
     * Indicates issuer's specified restrictions on the geographic usage and services allowed for the application
     */
    EMV_TAG_APPLICATION_USAGE_CONTROL = 0x9F07,

    /**
     * Version number assigned by the Issuer for the application in the Card
     */
    EMV_TAG_APPLICATION_VERSION_NUMBER = 0x9F08,

    /**
     * Version number assigned by the Issuer for the Kernel application
     */
    EMV_TAG_APPLICATION_VERSION_NUMBER_TERMINAL = 0x9F09,

    /**
     * Indicates the whole cardholder name when greater than 26 characters using the same coding convention as in ISO
     * 7813
     */
    EMV_TAG_CARDHOLDER_NAME_EXTENDED = 0x9F0B,

    /**
     * Specifies the issuer's conditions that cause a transaction to be rejected if it might have been approved online,
     * but the terminal is unable to process the transaction online
     */
    EMV_TAG_ISSUER_ACTION_DEFAULT = 0x9F0D,

    /**
     * Specifies the issuer's conditions that cause the denial of a transaction without attempt to go online
     */
    EMV_TAG_ISSUER_ACTION_DENIAL = 0x9F0E,

    /**
     * Specifies the issuer's conditions that cause a transaction to be transmitted online
     */
    EMV_TAG_ISSUER_ACTION_ONLINE = 0x9F0F,

    /**
     * Contains proprietary application data for transmission to the Issuer in an online transaction.
     */
    EMV_TAG_ISSUER_APP_DATA = 0x9F10,

    /**
     * Indicates the code table according to ISO/IEC 8859 for displaying the Application Preferred Name
     */
    EMV_TAG_ISSUER_CODE_TABLE_INDEX = 0x9F11,

    /**
     * Preferred mnemonic associated with the AID
     */
    EMV_TAG_APPLICATION_PREFERRED_NAME = 0x9F12,

    /**
     * ATC value of the last transaction that went online
     */
    EMV_TAG_LAST_ONLINE_APPLICATION_TRANSACTION_COUNTER_REGISTER = 0x9F13,

    /**
     * Issuer-specified preference for the maximum number of consecutive offline transactions for this ICC application
     * allowed in a terminal with online capability
     */
    EMV_TAG_LOWER_CONSECUTIVE_OFFLINE_LIMIT = 0x9F14,

    /**
     * Classifies the type of business being done by the merchant, represented according to ISO 8583:1993 for Card
     * Acceptor Business Code
     */
    EMV_TAG_MERCHANT_CATEGORY_CODE = 0x9F15,

    /**
     * When concatenated with the Acquirer Identifier, uniquely identifies a given merchant
     */
    EMV_TAG_MERCHANT_IDENTIFIER = 0x9F16,

    /**
     * Number of PIN tries remaining
     */
    EMV_TAG_PIN_TRY_COUNTER = 0x9F17,

    /**
     * May be sent in authorisation response from issuer when response contains Issuer Script. Assigned by the issuer
     * to
     * uniquely identify the Issuer Script.
     */
    EMV_TAG_ISSUER_SCRIPT_IDENTIFIER = 0x9F18,

    /**
     * Indicates the country of the terminal, represented according to ISO 3166. Requested in CDOL1.
     */
    EMV_TAG_TERMINAL_COUNTRY_CODE = 0x9F1A,

    /**
     * Indicates the floor limit in the terminal in conjunction with the AID
     */
    EMV_TAG_TERMINAL_FLOOR_LIMIT = 0x9F1B,

    /**
     * Designates the unique location of a Terminal at a merchant
     */
    EMV_TAG_TERMINAL_IDENTIFICATION = 0x9F1C,

    /**
     * Application-specific value used by the card for risk management purposes
     */
    EMV_TAG_TERMINAL_RISK_MANAGEMENT_DATA = 0x9F1D,

    /**
     * Unique and permanent serial number assigned to the IFD by the manufacturer
     */
    EMV_TAG_IFD_SERIAL_NUMBER = 0x9F1E,

    /**
     * Discretionary part of track 1 according to ISO/IEC 7813
     */
    EMV_TAG_TRACK_1_DISCRETIONARY_DATA = 0x9F1F,

    /**
     * Discretionary part of track 2 according to ISO/IEC 7813
     */
    EMV_TAG_TRACK_2_DISCRETIONARY_DATA = 0x9F20,

    /**
     * Local time at which the transaction was performed.
     */
    EMV_TAG_TRANSACTION_TIME = 0x9F21,

    /**
     * Identifies the Certificate Authority's public key in conjunction with the RID for use in offline static and
     * dynamic data authentication.
     */
    EMV_TAG_CA_PUBLIC_KEY_INDEX_2 = 0x9F22,

    /**
     * Issuer-specified preference for the maximum number of consecutive offline transactions for this ICC application
     * allowed in a terminal without online capability
     */
    EMV_TAG_UPPER_CONSECUTIVE_OFFLINE_LIMIT = 0x9F23,

    /**
     * Cryptogram returned by the ICC in response of the GENERATE AC or RECOVER AC command
     */
    EMV_TAG_APPLICATION_CRYPTOGRAM = 0x9F26,

    /**
     * Indicates the type of cryptogram and the actions to be performed by the terminal
     */
    EMV_TAG_CRYPTOGRAM_INFORMATION_DATA = 0x9F27,

    /**
     * The value to be appended to the ADF Name in the data field of the SELECT command, if the Extended Selection
     * Support flag is present and set to 1. Content is payment system proprietary.
     */
    EMV_TAG_EXTENDED_SELECTION = 0x9F29,

    /**
     * Indicates the card's preference for the kernel on which the contactless application can be processed.
     */
    EMV_TAG_KERNEL_IDENTIFIER = 0x9F2A,

    /**
     * ICC PIN Encipherment Public Key certified by the issuer (PIN KSN)
     */
    EMV_TAG_ICC_PIN_ENCIPHERMENT_PUBLIC_KEY_CERTIFICATE = 0x9F2D,

    /**
     * ICC PIN Encipherment Public Key Exponent used for PIN encipherment
     */
    EMV_TAG_ICC_PIN_ENCIPHERMENT_PUBLIC_KEY_EXPONENT = 0x9F2E,

    /**
     * Remaining digits of the ICC PIN Encipherment Public Key Modulus
     */
    EMV_TAG_ICC_PIN_ENCIPHERMENT_PUBLIC_KEY_REMAINDER = 0x9F2F,

    /**
     * Issuer public key exponent used for the verification of the Signed Static Application Data and the ICC Public
     * Key
     * Certificate
     */
    EMV_TAG_ISSUER_PUBLIC_KEY_EXPONENT = 0x9F32,

    /**
     * Indicates the card data input, CVM, and security capabilities of the Terminal.
     */
    EMV_TAG_TERMINAL_CAPABILITIES = 0x9F33,

    /**
     * Indicates the results of the last CVM performed
     */
    EMV_TAG_CVM_RESULT = 0x9F34,

    /**
     * Indicates the environment of the terminal, its communications capability, and its operational control
     */
    EMV_TAG_TERMINAL_TYPE = 0x9F35,

    /**
     * Counter maintained by the application in the ICC (incrementing the ATC is managed by the ICC)
     */
    EMV_TAG_APPLICATION_TRANSACTION_COUNTER = 0x9F36,

    /**
     * Value to provide variability and uniqueness to the generation of a cryptogram
     */
    EMV_TAG_UNPREDICTABLE_NUMBER = 0x9F37,

    /**
     * Contains a list of terminal resident data objects (tags and lengths) needed by the ICC in processing the GET
     * PROCESSING OPTIONS command
     */
    EMV_TAG_PROCESSING_OPTIONS_DOL = 0x9F38,

    /**
     * Indicates the method by which the PAN was entered, according to the first two digits of the ISO 8583:1987 POS
     * Entry Mode
     */
    EMV_TAG_POS_ENTRY_MODE = 0x9F39,

    /**
     * Authorised amount expressed in the reference currency
     */
    EMV_TAG_AMOUNT_REFERENCE_CURRENCY = 0x9F3A,

    /**
     * 1-4 currency codes used between the terminal and the ICC when the Transaction Currency Code is different from
     * the
     * Application Currency Code, each code is 3 digits according to ISO 4217
     */
    EMV_TAG_APP_REFERENCE_CURRENCY_CODE = 0x9F3B,

    /**
     * Code defining the common currency used by the terminal in case the Transaction Currency Code is different from
     * the Application Currency Code
     */
    EMV_TAG_TRANSACTION_REFERENCE_CURRENCY_CODE = 0x9F3C,

    /**
     * Indicates the implied position of the decimal point from the right of the transaction amount, with the
     * Transaction Reference Currency Code represented according to ISO 4217
     */
    EMV_TAG_TRANSACTION_REFERENCE_CURRENCY_EXPONENT = 0x9F3D,

    /**
     * Indicates the data input and output capabilities of the Terminal and Reader. The Additional Terminal
     * Capabilities
     * is coded according to Annex A.3 of [EMV Book 4].
     */
    EMV_TAG_ADDITIONAL_TERMINAL_CAPABILITIES = 0x9F40,

    /**
     * Counter maintained by the terminal that is incremented by one for each transaction
     */
    EMV_TAG_TRANSACTION_SEQUENCE_NUMBER = 0x9F41,

    /**
     * Indicates the currency in which the account is managed according to ISO 4217
     */
    EMV_TAG_APPLICATION_CURRENCY_CODE = 0x9F42,

    /**
     * Indicates the implied position of the decimal point from the right of the amount, for each of the 1-4 reference
     * currencies represented according to ISO 4217
     */
    EMV_TAG_APPLICATION_REFERENCE_CURRENCY_EXPONENT = 0x9F43,

    /**
     * Indicates the implied position of the decimal point from the right of the amount represented according to ISO
     * 4217
     */
    EMV_TAG_APPLICATION_CURRENCY_EXPONENT = 0x9F44,

    /**
     * An issuer assigned value that is retained by the terminal during the verification process of the Signed Static
     * Application Data
     */
    EMV_TAG_DATA_AUTHENTICATION_CODE = 0x9F45,

    /**
     * ICC Public Key certified by the issuer
     */
    EMV_TAG_ICC_PUBLIC_KEY_CERTIFICATE = 0x9F46,

    /**
     * Exponent ICC Public Key Exponent used for the verification of the Signed Dynamic Application Data
     */
    EMV_TAG_ICC_PUBLIC_KEY_EXPONENT = 0x9F47,

    /**
     * Remaining digits of the ICC Public Key Modulus
     */
    EMV_TAG_ICC_PUBLIC_KEY_REMAINDER = 0x9F48,

    /**
     * List of data objects (tag and length) to be passed to the ICC in the INTERNAL AUTHENTICATE command
     */
    EMV_TAG_DYNAMIC_DATA_OBJECT_LIST = 0x9F49,

    /**
     * List of tags of primitive data objects defined in this specification whose value fields are to be included in
     * the
     * Signed Static or Dynamic Application Data
     */
    EMV_TAG_STATIC_DATA_AUTHENTICATION_TAG_LIST = 0x9F4A,

    /**
     * Digital signature on critical application parameters for CDA
     */
    EMV_TAG_SIGNED_DYNAMIC_APP_DATA = 0x9F4B,

    /**
     * Time-variant number generated by the ICC, to be captured by the terminal
     */
    EMV_TAG_ICC_DYNAMIC_NUMBER = 0x9F4C,

    /**
     * Provides the SFI of the Transaction Log file and its number of records
     */
    EMV_TAG_LOG_ENTRY = 0x9F4D,

    /**
     * Indicates the name and location of the merchant. The reader shall return the value of the Merchant Name and
     * Location when requested by the card in a Data Object List.
     */
    EMV_TAG_MERCHANT_NAME_AND_LOCATION = 0x9F4E,

    /**
     * List (in tag and length format) of data objects representing the logged data elements that are passed to the
     * terminal when a transaction log record is read
     */
    EMV_TAG_LOG_FORMAT = 0x9F4F,

    /**
     * Indicates the type of transaction being performed, and which may be used in card risk management. As defined by
     * MasterCard
     */
    EMV_TAG_MASTERCARD_TRANSACTION_CATEGORY_CODE = 0x9F53,

    /**
     * Defines the max lifetime of a MasterCard Torn Transaction Log Record.
     */
    EMV_TAG_INTERAC_MERCHANT_TYPE_INDICATOR = 0x9F58,

    /**
     * Contains terminal transaction information for a contactless application.
     */
    EMV_TAG_TERMINAL_TRANSACTION_INFORMATION = 0x9F59,

    /**
     *
     */
    EMV_TAG_TERMINAL_OPTION_STATUS = 0x9F53,

    /**
     * Indicates reader capabilities, requirements, and preferences to the card. TTQ byte 2 bits 8-7 are transient
     * values, and reset to zero at the beginning of the transaction. All other TTQ bits are static values, and not
     * modified based on transaction conditions. TTQ byte 3 bit 7 shall be set by the acquirer-merchant to 1b.
     */
    EMV_TAG_VISA_TERMINAL_TRANSACTION_QUALIFIERS = 0x9F66,

    /**
     * Track 2 Data contains the data objects of the track 2 according to [ISO/IEC 7813], excluding start sentinel, end
     * sentinel and LRC. The Track 2 Data is present in the file read using the READ RECORD command during a mag-stripe
     * mode transaction.
     */
    EMV_TAG_TRACK_2_DATA_CONTACTLESS = 0x9F6B,

    /**
     * In this version of the specification, used to indicate to the device the card CVM requirements, issuer
     * preferences, and card capabilities.
     */
    EMV_TAG_VISA_CARD_TRANSACTION_QUALIFIERS = 0x9F6C,

    /**
     * Defines the terminal capabilities for ExpressPay applications.
     */
    EMV_TAG_EXPRESSPAY_TERMINAL_CAPABILITIES = 0x9F6D,

    /**
     * Enhanced Expresspay Terminal Capabilities
     */
    EMV_TAG_EXPRESSPAY_ENHANCED_TERMINAL_CAPABILITIES = 0x9F6E,

    /**
     * Indicates the form factor of the consumer payment device and the type of contactless interface over which the
     * transaction was conducted. This information is made available to the issuer host.
     */
    EMV_TAG_VISA_FORM_FACTOR_INDICATOR = 0x9F6E,

    /**
     * Contains data for transmission to the issuer.
     */
    EMV_TAG_CUSTOMER_EXCLUSIVE_DATA = 0x9F7C,

    /**
     *
     */
    EMV_TAG_MOBILE_SUPPORT_INDICATOR = 0x9F7E,

    /**
     * Identifies the data object proprietary to this specification in the FCI template according to ISO/IEC 7816-4
     */
    EMV_TAG_FCI_PROPRIETARY_TEMPLATE = 0xA5,

    /**
     * Issuer discretionary part of the File Control Information Proprietary Template.
     */
    EMV_TAG_FCI_ISSUER_DISCRETIONARY_DATA = 0xBF0C,

    /**
     * Used as a return value for {@link #fromHexString(String)} if the given string is not a recognized Tag.
     */
    EMV_TAG_UNKNOWN = 0x0000,
    //endregion

    //region BBPOS Terminal EMV Tags
    /**
     * The amount of idle time (in seconds) before entering Standby mode. Default is 30s, value range from 0x0F - 0xFF.
     */
    EMV_TAG_BBPOS_NORMAL_MODE_TIMEOUT = 0xDF8370,

    /**
     * The amount of idle time (in hours) before device power off. Default is 10 hours, value range from 0x01 - 0xFF.
     */
    EMV_TAG_BBPOS_STANDBY_MODE_TIMEOUT = 0xDF8367,

    /**
     * The amount of bluetooth discovery time (in minutes) before device power off. Default is 5 minutes, value range
     * from 0x01 - 0x05.
     */
    EMV_TAG_BBPOS_BLUETOOTH_DISCOVERY_TIMEOUT = 0xDF837B,

    /**
     * Enable (0x00) or disable (0x01) firmware fallback. If the firmware supported fallback and it is enabled in the
     * config, the device will return display text callback with enum INSERT_SWIPE_OR_TRY_ANOTHER_CARD and trigger
     * onWaitingForCard when read card failed. The device will retry 3 times before falling back to swipe mode.
     * Default is enabled.
     */
    EMV_TAG_BBPOS_ENABLE_FIRMWARE_FALLBACK = 0xDF8407,

    /**
     * Enabled (0x00) or disable (0x01) firmware force chip transaction. If the feature is enabled in config, the device
     * will check the service code of the swiped card. When chip card is detected, the device will return display text
     * callback with enum INSERT_SWIPE_OR_TRY_ANOTHER_CARD and trigger onWaitingForCard to prompt for
     * insert card or swipe another card. Default is enabled
     */
    EMV_TAG_BBPOS_ENABLE_FORCE_CHIP_TRANSACTION = 0xDF840D,

    /**
     * Enabled (0x00) or disable (0x01) firmware swipe retry. If the feature is enabled in config, when a bad swipe is
     * detected, the device will return display text callback with enum TRY_AGAIN and trigger onWaitingForCard to prompt
     * for insert card or swipe another card. The device will retry 3 times before returning CheckCardResult.BAD_SWIPE.
     * Default is enabled.
     */
    EMV_TAG_BBPOS_ENABLE_FIRMWARE_SWIPE_RETRY = 0xDF840E,

    /**
     * Encrypted tags list return in Tag C2 (Encrypted Online Message) at onRequestOnlineMessage. The KSN for decryption
     * is returned in custom Tag C0 {@link EmvTagDescriptor#BBPOS_ARQC_DECRYPTION_KSN}.
     */
    EMV_TAG_BBPOS_ARQC_TAG_LIST = 0xDFDF02,

    /**
     * BbPos Device Serial Number.
     */
    EMV_TAG_BBPOS_SERIAL_NUMBER = 0xDF826E,

    /**
     * BbPos Additional Tag (with no description from BbPos), Portico doesn't require this.
     */
    EMV_TAG_BBPOS_BID = 0xDF834F,

    /**
     * Quick Chip Indicator.
     */
    EMV_TAG_BBPOS_QUICK_CHIP_INDICATOR = 0xDF8362,

    /**
     * Proprietary BbPos Tag.
     */
    EMV_TAG_BBPOS_PROPRIETARY_TAG_1 = 0xDF8120,

    /**
     * Proprietary BbPos Tag.
     */
    EMV_TAG_BBPOS_PROPRIETARY_TAG_2 = 0xDF8121,

    /**
     * Proprietary BbPos Tag.
     */
    EMV_TAG_BBPOS_PROPRIETARY_TAG_3 = 0xDF8122,

    /**
     * Proprietary BbPos WiseCube Tag.
     */
    EMV_TAG_BBPOS_WISECUBE_UNKNOWN_TAG_1 = 0xDF08,

    /**
     * Proprietary BbPos WiseCube Tag.
     */
    EMV_TAG_BBPOS_WISECUBE_UNKNOWN_TAG_2 = 0xDC,

    /**
     * KSN for decrypting the encrypted tags returned in onRequestOnlineMessage that were listed in {@link
     * EmvTagDescriptor#BBPOS_ARQC_TAG_LIST}
     */
    EMV_TAG_BBPOS_ARQC_DECRYPTION_KSN = 0xC0,

    /**
     * KSN for decrypting Encrypted PIN Block.
     */
    EMV_TAG_BBPOS_ONLINE_PIN_KSN = 0xC1,

    /**
     * Encrypted tags list return in Tag C5 (Encrypted Batch Message) at onReturnBatchData for approved (DFDF45)
     * transaction result. The KSN for decryption is returned in custom Tag C3  {@link
     * EmvTagDescriptor#BBPOS_AAC_TC_DECRYPTION_KSN}
     */
    EMV_TAG_BBPOS_TC_TAG_LIST = 0xDFDF45,

    /**
     * Encrypted tags list return in Tag C5 (Encrypted Batch Message) at onReturnBatchData for declined (DFDF46)
     * transaction result. The KSN for decryption is returned in custom Tag C3 {@link
     * EmvTagDescriptor#BBPOS_AAC_TC_DECRYPTION_KSN}
     */
    EMV_TAG_BBPOS_AAC_TAG_LIST = 0xDFDF45,

    /**
     * The KSN for decrypting the encrypted tags return in onReturnBatchData that were listed in {@link
     * EmvTagDescriptor#BBPOS_AAC_TAG_LIST} and {@link EmvTagDescriptor#BBPOS_TC_TAG_LIST}
     */
    EMV_TAG_BBPOS_AAC_TC_DECRYPTION_KSN = 0xC3,

    /**
     * KSN for decrypting the encrypted tags returned in onRequestOnlineMessage that were listed in {@link
     * EmvTagDescriptor#BBPOS_ARQC_TAG_LIST}
     */
    EMV_TAG_BBPOS_MASKED_PAN = 0xC4,

    /**
     * Encrypted batch message. Contains ARQC, TC, and AAC tag data.
     */
    EMV_TAG_BBPOS_ENCRYPTED_BATCH_MESSAGE = 0xC5,

    /**
     * Encrypted tags list return in Tag C6 ({@link EmvTagDescriptor#BBPOS_ENCRYPTED_REVERSAL_MESSAGE }).
     */
    EMV_TAG_BBPOS_REVERSAL_TAG_LIST = 0xDFDF05,

    /**
     * Contains the encrypted tag data returned in tags listed in {@link EmvTagDescriptor#BBPOS_REVERSAL_TAG_LIST}
     */
    EMV_TAG_BBPOS_ENCRYPTED_REVERSAL_MESSAGE = 0xC6,

    /**
     * KSN used for decrypting the Track 2 Equivalent Data returned from the card.
     */
    EMV_TAG_BBPOS_TRACK_2_EQUIVALENT_DATA_KSN = 0xC7,

    /**
     * Track 2 data formatted with EMV separator.
     */
    EMV_TAG_BBPOS_TRACK_2_EQUIVALENT_DATA = 0xC8,

    /**
     * Custom Bluetooth name prefix, in ASCII. Maximum Bluetooth name is 20 characters (DF8408 name prefix + DF8409
     * last N digits of serial number).
     */
    EMV_TAG_BBPOS_BLUETOOTH_NAME_PREFIX = 0xDF8408,

    /**
     * Last N digits of serial number for the custom Bluetooth name. Maximum Bluetooth name is 20 characters
     * (DF8408 name prefix + DF8409 last N digits of serial number).
     */
    EMV_TAG_BBPOS_BLUETOOTH_SERIAL_NUMBER_SUFFIX = 0xDF8409,

    /**
     * Terminal serial number.
     */
    EMV_TAG_BBPOS_DEVICE_SERIAL_NUMBER = 0xDF78,

    /**
     * Terminal kernel version number.
     */
    EMV_TAG_BBPOS_KERNEL_VERSION_NUMBER = 0xDF79,

    /**
     * Encrypted Online Message
     */
    EMV_TAG_BBPOS_ENCRYPTED_ONLINE_MESSAGE = 0xC2,
    //endregion
};

#endif /* EMVTagDescriptor_h */
