//
//  BBDeviceController.h
//  BBDeviceAPI
//
//  Created by Alex Wong on 2017-08-18.
//  Copyright (c) 2020 BBPOS Limited. All rights reserved.
//  RESTRICTED DOCUMENT
//

#import <Foundation/Foundation.h>
#import "CAPK.h"
#import "VASMerchantConfig.h"

//For iOS
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <ExternalAccessory/ExternalAccessory.h>

//For macOS
//#import <AppKit/AppKit.h>
//#import <IOBluetooth/IOBluetooth.h>
//#import <CoreBluetooth/CoreBluetooth.h>

typedef NS_ENUM (NSUInteger, BBDeviceControllerState) {
    BBDeviceControllerState_CommLinkUninitialized = 0,
    BBDeviceControllerState_Idle = 1,
    BBDeviceControllerState_WaitingForResponse = 2,
};

typedef NS_ENUM (NSUInteger, BBDeviceBatteryStatus) {
    BBDeviceBatteryStatus_Low = 0,
    BBDeviceBatteryStatus_CriticallyLow = 1,
};

typedef NS_ENUM (NSUInteger, BBDeviceConnectionMode) {
    BBDeviceConnectionMode_None = 0,
    BBDeviceConnectionMode_Audio = 1,
    BBDeviceConnectionMode_Bluetooth = 2,
    BBDeviceConnectionMode_USB = 3,
};

typedef NS_ENUM (NSUInteger, BBDeviceEmvOption) {
    BBDeviceEmvOption_Start = 0,
    BBDeviceEmvOption_StartWithForceOnline = 1,
};

typedef NS_ENUM (NSUInteger, BBDeviceCheckCardResult) {
    BBDeviceCheckCardResult_NoCard = 0,
    BBDeviceCheckCardResult_InsertedCard = 1,
    BBDeviceCheckCardResult_NotIccCard = 2,
    BBDeviceCheckCardResult_BadSwipe = 3,
    BBDeviceCheckCardResult_SwipedCard = 4,
    BBDeviceCheckCardResult_MagHeadFail = 5,
    BBDeviceCheckCardResult_UseIccCard = 6,
    BBDeviceCheckCardResult_TapCardDetected = 7,
    BBDeviceCheckCardResult_ManualPanEntry = 8,
    BBDeviceCheckCardResult_CardNotSupported = 9,
};

typedef NS_ENUM (NSUInteger, BBDeviceErrorType) {
    BBDeviceErrorType_InvalidInput = 0,
    BBDeviceErrorType_InvalidInput_NotNumeric = 1,
    BBDeviceErrorType_InvalidInput_InputValueOutOfRange = 2,
    BBDeviceErrorType_InvalidInput_InvalidDataFormat = 3,
    BBDeviceErrorType_InvalidInput_NotAcceptAmountForThisTransactionType = 4,
    BBDeviceErrorType_InvalidInput_NotAcceptCashbackForThisTransactionType = 5,

    BBDeviceErrorType_Unknown = 6,
    BBDeviceErrorType_IllegalStateException = 7,

    BBDeviceErrorType_CommError = 8,
    BBDeviceErrorType_CommandNotAvailable = 9,
    BBDeviceErrorType_DeviceBusy = 10,

    BBDeviceErrorType_CommLinkUninitialized = 11,
    BBDeviceErrorType_InvalidFunctionInCurrentConnectionMode = 12,

    BBDeviceErrorType_AudioFailToStart = 13,
    BBDeviceErrorType_AudioFailToStart_OtherAudioIsPlaying = 14,
    BBDeviceErrorType_AudioRecordingPermissionDenied = 15,
    BBDeviceErrorType_AudioBackgroundTimeout = 16,

    BBDeviceErrorType_BTv4NotSupported = 17,
    BBDeviceErrorType_BTFailToStart = 18,
    BBDeviceErrorType_BTAlreadyConnected = 19,

    BBDeviceErrorType_HardwareNotSupported = 20, //Firmware supported but hardware not supported
    BBDeviceErrorType_PCIError = 21,

    BBDeviceErrorType_BLESecureConnectionNotSupported = 22, //BT 4.2
    BBDeviceErrorType_PairingError = 23,
    BBDeviceErrorType_PairingError_IncorrectPasskey = 24,
    BBDeviceErrorType_PairingError_AlreadyPairedWithAnotherDevice = 25,

    BBDeviceErrorType_BTUnauthorized = 26,

    BBDeviceErrorType_ContactlessError = 27,

    BBDeviceErrorType_PairingError_PeerRemovedPairingInformation = 28,
};

typedef NS_ENUM (NSUInteger, BBDeviceTransactionResult) {
    BBDeviceTransactionResult_Approved = 0,
    BBDeviceTransactionResult_Terminated = 1,
    BBDeviceTransactionResult_Declined = 2,
    BBDeviceTransactionResult_CanceledOrTimeout = 3,
    BBDeviceTransactionResult_CapkFail = 4,
    BBDeviceTransactionResult_NotIcc = 5,
    BBDeviceTransactionResult_CardBlocked = 6,
    BBDeviceTransactionResult_DeviceError = 7,
    BBDeviceTransactionResult_SelectApplicationFail = 8,
    BBDeviceTransactionResult_CardNotSupported = 9,
    BBDeviceTransactionResult_MissingMandatoryData = 10,
    BBDeviceTransactionResult_NoEmvApps = 11,
    BBDeviceTransactionResult_InvalidIccData = 12,
    BBDeviceTransactionResult_ConditionsOfUseNotSatisfied = 13,
    BBDeviceTransactionResult_ApplicationBlocked = 14,
    BBDeviceTransactionResult_IccCardRemoved = 15,
    BBDeviceTransactionResult_CardSchemeNotMatched = 16,
    BBDeviceTransactionResult_Canceled = 17,
    BBDeviceTransactionResult_Timeout = 18,
};

typedef NS_ENUM (NSUInteger, BBDeviceTransactionType) {
    BBDeviceTransactionType_Goods = 0,
    BBDeviceTransactionType_Services = 1,
    BBDeviceTransactionType_Cashback = 2,
    BBDeviceTransactionType_Inquiry = 3,
    BBDeviceTransactionType_Transfer = 4,
    BBDeviceTransactionType_Payment = 5,
    BBDeviceTransactionType_Refund = 6,
    BBDeviceTransactionType_Void = 7,
    BBDeviceTransactionType_Reversal = 8,
    BBDeviceTransactionType_Cash = 9,
};

typedef NS_ENUM (NSUInteger, BBDeviceDisplayText) {
    BBDeviceDisplayText_APPROVED = 0,
    BBDeviceDisplayText_CALL_YOUR_BANK = 1,
    BBDeviceDisplayText_DECLINED = 2,
    BBDeviceDisplayText_ENTER_AMOUNT = 3,
    BBDeviceDisplayText_ENTER_PIN = 4,
    BBDeviceDisplayText_INCORRECT_PIN = 5,
    BBDeviceDisplayText_INSERT_CARD = 6,
    BBDeviceDisplayText_NOT_ACCEPTED = 7,
    BBDeviceDisplayText_PIN_OK = 8,
    BBDeviceDisplayText_PLEASE_WAIT = 9,
    BBDeviceDisplayText_REMOVE_CARD = 10,
    BBDeviceDisplayText_USE_MAG_STRIPE = 11,
    BBDeviceDisplayText_TRY_AGAIN = 12,
    BBDeviceDisplayText_REFER_TO_YOUR_PAYMENT_DEVICE = 13,
    BBDeviceDisplayText_TRANSACTION_TERMINATED = 14,
    BBDeviceDisplayText_PROCESSING = 15,
    BBDeviceDisplayText_LAST_PIN_TRY = 16,
    BBDeviceDisplayText_SELECT_ACCOUNT = 17,
    BBDeviceDisplayText_PRESENT_CARD = 18,
    BBDeviceDisplayText_APPROVED_PLEASE_SIGN = 19,
    BBDeviceDisplayText_PRESENT_CARD_AGAIN = 20,
    BBDeviceDisplayText_AUTHORISING = 21,
    BBDeviceDisplayText_INSERT_SWIPE_OR_TRY_ANOTHER_CARD = 22,
    BBDeviceDisplayText_INSERT_OR_SWIPE_CARD = 23,
    BBDeviceDisplayText_MULTIPLE_CARDS_DETECTED = 24,
    BBDeviceDisplayText_TIMEOUT = 25,
    BBDeviceDisplayText_APPLICATION_EXPIRED = 26,
    BBDeviceDisplayText_FINAL_CONFIRM = 27,
    BBDeviceDisplayText_SHOW_THANK_YOU = 28,
    BBDeviceDisplayText_PIN_TRY_LIMIT_EXCEEDED = 29,
    BBDeviceDisplayText_NOT_ICC_CARD = 30,
    BBDeviceDisplayText_CARD_INSERTED = 31,
    BBDeviceDisplayText_CARD_REMOVED = 32,
    BBDeviceDisplayText_NO_EMV_APPS = 33,
    BBDeviceDisplayText_CTL_NO_EMV_APPS = 34,
    BBDeviceDisplayText_CTL_APP_NOT_SUPPORTED = 35,
    BBDeviceDisplayText_CTL_TRANSACTION_LIMIT_EXCEEDED = 36,
};

typedef NS_ENUM (NSUInteger, BBDeviceTerminalSettingStatus) {
    BBDeviceTerminalSettingStatus_Success = 0,
    BBDeviceTerminalSettingStatus_InvalidTlvFormat = 1,
    BBDeviceTerminalSettingStatus_TagNotFound = 2,
    BBDeviceTerminalSettingStatus_InvalidLength = 3,
    BBDeviceTerminalSettingStatus_BootLoaderNotSupported = 4,
    BBDeviceTerminalSettingStatus_TagNotAllowedToAccess = 5,
    BBDeviceTerminalSettingStatus_TagNotWrittenCorrectly = 6,
    BBDeviceTerminalSettingStatus_InvalidValue = 7,
};

typedef NS_ENUM (NSUInteger, BBDeviceCheckCardMode) {
    BBDeviceCheckCardMode_Swipe = 0,
    BBDeviceCheckCardMode_Insert = 1,
    BBDeviceCheckCardMode_Tap = 2,
    BBDeviceCheckCardMode_SwipeOrInsert = 3,
    BBDeviceCheckCardMode_SwipeOrTap = 4,
    BBDeviceCheckCardMode_SwipeOrInsertOrTap = 5,
    BBDeviceCheckCardMode_InsertOrTap = 6,
    BBDeviceCheckCardMode_ManualPanEntry = 7,
    BBDeviceCheckCardMode_QRCode = 8,
};

typedef NS_ENUM (NSUInteger, BBDeviceEncryptionMethod) {
    BBDeviceEncryptionMethod_TDES_ECB = 0,
    BBDeviceEncryptionMethod_TDES_CBC = 1,
    BBDeviceEncryptionMethod_AES_ECB = 2,
    BBDeviceEncryptionMethod_AES_CBC = 3,
    BBDeviceEncryptionMethod_AES_CMAC = 8,
    BBDeviceEncryptionMethod_MAC_ANSI_X9_9 = 4,
    BBDeviceEncryptionMethod_MAC_ANSI_X9_19 = 5,
    BBDeviceEncryptionMethod_MAC_METHOD_1 = 6,
    BBDeviceEncryptionMethod_MAC_METHOD_2 = 7,
};

typedef NS_ENUM (NSUInteger, BBDeviceEncryptionKeySource) {
    BBDeviceEncryptionKeySource_BY_DEVICE_16_BYTES_RANDOM_NUMBER = 0,
    BBDeviceEncryptionKeySource_BY_DEVICE_8_BYTES_RANDOM_NUMBER = 1,
    BBDeviceEncryptionKeySource_BOTH = 2,
    BBDeviceEncryptionKeySource_BY_SERVER_16_BYTES_WORKING_KEY = 3,
    BBDeviceEncryptionKeySource_BY_SERVER_8_BYTES_WORKING_KEY = 4,
    BBDeviceEncryptionKeySource_STORED_IN_DEVICE_16_BYTES_KEY = 5,
};

typedef NS_ENUM (NSUInteger, BBDeviceEncryptionPaddingMethod) {
    BBDeviceEncryptionPaddingMethod_ZERO_PADDING = 0,
    BBDeviceEncryptionPaddingMethod_PKCS7 = 1,
};

typedef NS_ENUM (NSUInteger, BBDeviceEncryptionKeyUsage) {
    BBDeviceEncryptionKeyUsage_TEK = 0,
    BBDeviceEncryptionKeyUsage_TAK = 1,
    BBDeviceEncryptionKeyUsage_TPK = 2,
};

typedef NS_ENUM (NSUInteger, BBDevicePinEntryResult) {
    BBDevicePinEntryResult_PinEntered = 0,
    BBDevicePinEntryResult_Cancel = 1,
    BBDevicePinEntryResult_Timeout = 2,
    BBDevicePinEntryResult_ByPass = 3,
    BBDevicePinEntryResult_IncorrectPinLength = 4,
    BBDevicePinEntryResult_IncorrectPin = 5,
};

typedef NS_ENUM (NSUInteger, BBDeviceCurrencyCharacter) {
    BBDeviceCurrencyCharacter_A = 0,
    BBDeviceCurrencyCharacter_B = 1,
    BBDeviceCurrencyCharacter_C = 2,
    BBDeviceCurrencyCharacter_D = 3,
    BBDeviceCurrencyCharacter_E = 4,
    BBDeviceCurrencyCharacter_F = 5,
    BBDeviceCurrencyCharacter_G = 6,
    BBDeviceCurrencyCharacter_H = 7,
    BBDeviceCurrencyCharacter_I = 8,
    BBDeviceCurrencyCharacter_J = 9,
    BBDeviceCurrencyCharacter_K = 10,
    BBDeviceCurrencyCharacter_L = 11,
    BBDeviceCurrencyCharacter_M = 12,
    BBDeviceCurrencyCharacter_N = 13,
    BBDeviceCurrencyCharacter_O = 14,
    BBDeviceCurrencyCharacter_P = 15,
    BBDeviceCurrencyCharacter_Q = 16,
    BBDeviceCurrencyCharacter_R = 17,
    BBDeviceCurrencyCharacter_S = 18,
    BBDeviceCurrencyCharacter_T = 19,
    BBDeviceCurrencyCharacter_U = 20,
    BBDeviceCurrencyCharacter_V = 21,
    BBDeviceCurrencyCharacter_W = 22,
    BBDeviceCurrencyCharacter_X = 23,
    BBDeviceCurrencyCharacter_Y = 24,
    BBDeviceCurrencyCharacter_Z = 25,
    BBDeviceCurrencyCharacter_Space = 26,
    BBDeviceCurrencyCharacter_Dirham = 27,
    BBDeviceCurrencyCharacter_Dollar = 28,
    BBDeviceCurrencyCharacter_Euro = 29,
    BBDeviceCurrencyCharacter_IndianRupee = 30,
    BBDeviceCurrencyCharacter_Pound = 31,
    BBDeviceCurrencyCharacter_SaudiRiyal = 32,
    BBDeviceCurrencyCharacter_SaudiRiyal2 = 33,
    BBDeviceCurrencyCharacter_Won = 34,
    BBDeviceCurrencyCharacter_Yen = 35,
    BBDeviceCurrencyCharacter_SlashAndDot = 36,
    BBDeviceCurrencyCharacter_Dot = 37,
    BBDeviceCurrencyCharacter_Yuan = 38,
    BBDeviceCurrencyCharacter_NewShekel = 39,
    BBDeviceCurrencyCharacter_Dong = 40,
    BBDeviceCurrencyCharacter_Rupiah = 41,
    BBDeviceCurrencyCharacter_Sol = 42,
    BBDeviceCurrencyCharacter_Peso = 43,
};

typedef NS_ENUM (NSUInteger, BBDeviceAmountInputType) {
    BBDeviceAmountInputType_AmountOnly = 0,
    BBDeviceAmountInputType_AmountAndCashback = 1,
    BBDeviceAmountInputType_CashbackOnly = 2,
    BBDeviceAmountInputType_TipsOnly = 3,
    BBDeviceAmountInputType_AmountAndTips = 4,
    BBDeviceAmountInputType_AmountAndTipsInPercentage = 5,
};

typedef NS_ENUM (NSUInteger, BBDevicePinEntrySource) {
    BBDevicePinEntrySource_Phone = 0,
    BBDevicePinEntrySource_Keypad = 1,
};

typedef NS_ENUM (NSUInteger, BBDeviceCardScheme) {
    BBDeviceCardScheme_Visa = 0,
    BBDeviceCardScheme_Master = 1,
    BBDeviceCardScheme_UnionPay = 2,
};

typedef NS_ENUM (NSUInteger, BBDeviceSessionError) {
    BBDeviceSessionError_FirmwareNotSupported = 0,
    BBDeviceSessionError_SessionNotInitialized = 1,
    BBDeviceSessionError_InvalidVendorToken = 2,
    BBDeviceSessionError_InvalidSession = 3,
};

typedef NS_ENUM (NSUInteger, BBDeviceNfcDetectCardResult) {
    BBDeviceNfcDetectCardResult_WaitingForCard = 0,
    BBDeviceNfcDetectCardResult_WaitingCardRemoval = 1,
    BBDeviceNfcDetectCardResult_CardDetected = 2,
    BBDeviceNfcDetectCardResult_CardRemoved = 3,
    BBDeviceNfcDetectCardResult_Timeout = 4,
    BBDeviceNfcDetectCardResult_CardNotSupported = 5,
    BBDeviceNfcDetectCardResult_MultipleCardDetected = 6,
};

typedef NS_ENUM (NSUInteger, BBDeviceNfcReadNdefRecord) {
    BBDeviceNfcReadNdefRecord_ReadFirst = 0,
    BBDeviceNfcReadNdefRecord_ReadNext = 1,
};

typedef NS_ENUM (NSUInteger, BBDevicePrintResult) {
    BBDevicePrintResult_Success = 0,
    BBDevicePrintResult_NoPaperOrCoverOpened = 1,
    BBDevicePrintResult_WrongPrinterCommand = 2,
    BBDevicePrintResult_Overheat = 3,
    BBDevicePrintResult_PrinterError = 4,
};

typedef NS_ENUM (NSUInteger, BBDevicePhoneEntryResult) {
    BBDevicePhoneEntryResult_Entered = 0,
    BBDevicePhoneEntryResult_Timeout = 1,
    BBDevicePhoneEntryResult_WrongLength = 2,
    BBDevicePhoneEntryResult_Cancel = 3,
    BBDevicePhoneEntryResult_Bypass = 4,
};

typedef NS_ENUM (NSUInteger, BBDeviceAccountSelectionResult) {
    BBDeviceAccountSelectionResult_Success = 0,
    BBDeviceAccountSelectionResult_Canceled = 1,
    BBDeviceAccountSelectionResult_Timeout = 2,
    BBDeviceAccountSelectionResult_InvalidSelection = 3,
};

typedef NS_ENUM (NSUInteger, BBDeviceLEDMode) {
    BBDeviceLEDMode_Default = 0,
    BBDeviceLEDMode_On = 1,
    BBDeviceLEDMode_Off = 2,
    BBDeviceLEDMode_Flash = 3,
};

typedef NS_ENUM (NSUInteger, BBDeviceVASTerminalMode) {
    BBDeviceVASTerminalMode_VAS = 0,
    BBDeviceVASTerminalMode_Dual = 1,
    BBDeviceVASTerminalMode_Single = 2,
    BBDeviceVASTerminalMode_Payment = 3,
};

typedef NS_ENUM (NSUInteger, BBDeviceVASProtocolMode) {
    BBDeviceVASProtocolMode_URL = 0,
    BBDeviceVASProtocolMode_Full = 1,
};

typedef NS_ENUM (NSUInteger, BBDeviceVASResult) {
    BBDeviceVASResult_Success = 0,
    BBDeviceVASResult_VASDataNotFound = 1,
    BBDeviceVASResult_VASDataNotActivated = 2,
    BBDeviceVASResult_UserInterventionRequired = 3,
    BBDeviceVASResult_IncorrectData = 4,
    BBDeviceVASResult_UnsupportedAppVersion = 5,
    BBDeviceVASResult_NonVASCardDetected = 6,
};

typedef NS_ENUM (NSUInteger, BBDeviceDisplayPromptOption) {
    BBDeviceDisplayPromptOption_DisplayOnly = 0,
    BBDeviceDisplayPromptOption_DisplayWithConfirmButtons = 1,
    BBDeviceDisplayPromptOption_DisplayOnlyWithoutTimeout = 2,
};

typedef NS_ENUM (NSUInteger, BBDeviceDisplayPromptIcon) {
    BBDeviceDisplayPromptIcon_CheckMark = 0,
    BBDeviceDisplayPromptIcon_CrossMark = 1,
    BBDeviceDisplayPromptIcon_ExclamationMark = 2,
};

typedef NS_ENUM (NSUInteger, BBDeviceDisplayPromptResult) {
    BBDeviceDisplayPromptResult_ConfirmButtonPressed = 0,
    BBDeviceDisplayPromptResult_CancelButtonPressed = 1,
    BBDeviceDisplayPromptResult_CancelledByCommand = 2,
    BBDeviceDisplayPromptResult_ButtonConfirmationTimeout = 3,
    BBDeviceDisplayPromptResult_DisplayEnd = 4,
};

// SPoC
typedef NS_ENUM (NSUInteger, BBDeviceSPoCError) {
    BBDeviceSPoCError_Unknown,
    BBDeviceSPoCError_NotSCRPDevice,
    BBDeviceSPoCError_NoNetworkConnection,
    BBDeviceSPoCError_COTSDeviceNotSupported,
    BBDeviceSPoCError_DebuggerDetected,
    BBDeviceSPoCError_RequiredSDKUpdate,
    BBDeviceSPoCError_RequiredFirmwareUpdate,
    BBDeviceSPoCError_LocationServiceIsDisabled,
    BBDeviceSPoCError_SetupError,
    BBDeviceSPoCError_ServerCommError,
    BBDeviceSPoCError_SecureChannelError,
    BBDeviceSPoCError_AttestationFailed,
    BBDeviceSPoCError_PinPadLostFocus,
    BBDeviceSPoCError_SCRPDeviceTampered,
    BBDeviceSPoCError_SCRPDeviceAndAppPairNotMatch,
    BBDeviceSPoCError_AppDecommissioned,
};

@protocol BBDeviceControllerDelegate;

@interface BBDeviceController : NSObject {
    id <BBDeviceControllerDelegate> delegate;

    BOOL debugLogEnabled;
    BOOL detectAudioDevicePlugged;
}

@property (nonatomic, weak) id <BBDeviceControllerDelegate> delegate;
@property (nonatomic, getter=isDebugLogEnabled, setter=setDebugLogEnabled:) BOOL debugLogEnabled;
@property (nonatomic, getter=isDetectAudioDevicePlugged, setter=setDetectAudioDevicePlugged:) BOOL detectAudioDevicePlugged;

+ (BBDeviceController *)sharedController;
- (BBDeviceControllerState)getBBDeviceControllerState;
- (void)releaseBBDeviceController;

// ----------------------------------------- API Version -----------------------------------------------

- (NSString *)getApiVersion;
- (NSString *)getApiBuildNumber;

// ----------------------------------------- Communication Channel -----------------------------------------------

- (void)isDeviceHere;    //Send out a detect command to check the device is valid
- (BOOL)isControllerSupportAudioChannel;
- (BOOL)isAudioDevicePlugged;
- (BBDeviceConnectionMode)getConnectionMode;

// Communication Channel - Audio
- (BOOL)startAudio;
- (void)stopAudio;

// Communication Channel - BT
- (void)startBTScan:(NSArray *)deviceNameArray scanTimeout:(int)scanTimeout;
- (void)stopBTScan;
- (void)connectBT:(NSObject *)device;                       //EAAccessory or CBPeripheral object
- (void)connectBTWithUUID:(NSString *)UUID;                 //For BT4 only, not for BT2
- (void)disconnectBT;
- (NSString *)getPeripheralUUID:(CBPeripheral *)peripheral; //For BT4 only, not for BT2

// Communication Channel - USB (For macOS, not for iOS)
- (void)startUsb;
- (void)stopUsb;

// ----------------------------------------- Session Token -----------------------------------------------

- (BOOL)isSessionInitialized;
- (void)initSession:(NSString *)vendorToken;
- (void)resetSession;

// ----------------------------------------- Device Info -----------------------------------------------

- (void)getDeviceInfo;

// ----------------------------------------- Reset Device -----------------------------------------------

- (void)resetDevice;

// ----------------------------------------- Power Down -----------------------------------------------

- (void)powerDown;

// ----------------------------------------- Standby Mode -----------------------------------------------

- (void)enterStandbyMode;

// ----------------------------------------- LED -----------------------------------------------

- (void)controlLED:(NSDictionary *)data;

// ----------------------------------------- Utility -----------------------------------------------

- (NSString *)encodeTlv:(NSDictionary *)data;
- (NSDictionary *)decodeTlv:(NSString *)tlv;

// ----------------------------------------- Transaction -----------------------------------------------

// Start Transaction
- (void)startEmvWithData:(NSDictionary *)data;

// Request Terminal Time
- (void)sendTerminalTime:(NSString *)terminalTime;

// Request Set Amount
- (BOOL)setAmount:(NSDictionary *)data;
- (BOOL)setAmount:(NSString *)amount
   cashbackAmount:(NSString *)cashbackAmount
     currencyCode:(NSString *)currencyCode
  transactionType:(BBDeviceTransactionType)transactionType
currencyCharacters:(NSArray *)currencyCharacters;
- (void)cancelSetAmount; //Cancel transaction at onRequestSetAmount

// Waiting for card
- (void)cancelCheckCard;

// Request Select Application
- (void)selectApplication:(int)applicationIndex;
- (void)cancelSelectApplication; //Cancel transaction at onRequestSelectApplication

// Request Final Confirm
- (void)sendFinalConfirmResult:(BOOL)isConfirmed;
- (void)sendFinalConfirmResult:(BOOL)isConfirmed withData:(NSString *)tlv;

// Request Online Process
- (void)sendOnlineProcessResult:(NSString *)tlv;

// Set Amount on device with keypad before startEmv
- (void)enableInputAmount:(NSDictionary *)data;
- (void)disableInputAmount;

// PIN entry on device with keypad
- (void)startPinEntry:(NSDictionary *)data; // start PIN entry mode only available after swiped card
- (void)cancelPinEntry; //Cancel transaction at onRequestPinEntry

// PIN entry on App for device with PBOC firmware
- (void)sendPinEntryResult:(NSString *)pin;
- (void)bypassPinEntry;

// ----------------------------------------- Check Card Data -----------------------------------------------

- (void)checkCard:(NSDictionary *)data;
- (void)getEmvCardData;
- (void)getEmvCardNumber;

// ----------------------------------------- Data Encryption -----------------------------------------------

- (void)encryptPin:(NSDictionary *)data;
- (void)encryptDataWithSettings:(NSDictionary *)data;

// ----------------------------------------- Contact Card -----------------------------------------------

- (void)powerOnIcc:(NSDictionary *)data;
- (void)powerOffIcc;
- (void)powerOffIcc:(NSDictionary *)data;
- (void)sendApdu:(NSDictionary *)data;

// ----------------------------------------- Contactless Card -----------------------------------------------

- (void)startNfcDetection:(NSDictionary *)data;
- (void)stopNfcDetection:(NSDictionary *)data;
- (void)nfcDataExchange:(NSDictionary *)data;

// ----------------------------------------- Terminal Settings -----------------------------------------------

// Terminal Setting
- (void)readTerminalSetting:(NSString *)dol;
- (void)updateTerminalSetting:(NSString *)tlv;
- (void)updateTerminalSettings:(NSString *)tlv;

- (void)readAID:(NSString *)appIndex;
- (void)updateAID:(NSDictionary *)data;

// CAPK
- (void)getCAPKList;
- (void)getCAPKDetail:(NSString *)location;
- (void)findCAPKLocation:(NSDictionary *)data;
- (void)updateCAPK:(CAPK *)capk;
- (void)removeCAPK:(NSDictionary *)data;
- (void)getEmvReportList;
- (void)getEmvReport:(NSString *)applicationIndex;

// Standalone Mode
- (void)readWiFiSettings;
- (void)updateWiFiSettings:(NSDictionary *)settings;
- (void)readGprsSettings;
- (void)updateGprsSettings:(NSDictionary *)settings;

// ----------------------------------------- Printer (For WisePad 2 Plus) -----------------------------------------------

// Printing Command
- (void)startPrint:(int)numOfData reprintOrPrintNextTimeout:(int)reprintOrPrintNextTimeout;
- (void)sendPrintData:(NSData *)data;

// Printing Utility
- (NSString *)getBarcodeCommand:(NSDictionary *)barcodeData; //codeType accept 128 and 39 only
- (NSString *)getImageCommand:(NSObject *)image; //Max image width is 384 pixel. UIImage for iOS, NSImage for macOS
- (NSString *)getUnicodeCommand:(NSString *)data;

// ----------------------------------------- Account Selection -----------------------------------------------

- (void)enableAccountSelection:(NSDictionary *)data;
- (void)disableAccountSelection;

// ----------------------------------------- Display Prompt -----------------------------------------------

- (void)displayPrompt:(NSDictionary *)data;
- (void)cancelDisplayPrompt;

// ----------------------------------------- Other -----------------------------------------------

// Phone Number
- (void)startGetPhoneNumber;
- (void)cancelGetPhoneNumber;

// ----------------------------------------- Key Exchange -----------------------------------------------

- (void)injectSessionKey:(NSDictionary *)data;

// ----------------------------------------- Update Display Setting -----------------------------------------------

- (void)updateDisplaySettings:(NSDictionary *)data;

// ----------------------------------------- SPOC -----------------------------------------------

// SPoC
- (void)setSPoCController:(NSObject *)controller;
- (void)setupSPoCSecureSession:(NSDictionary *)data;

@end




// ========================================= BBDeviceControllerDelegate =========================================

@protocol BBDeviceControllerDelegate <NSObject>

@optional

// ----------------------------------------- Battery Warning -----------------------------------------------

- (void)onBatteryLow:(BBDeviceBatteryStatus)batteryStatus;

// ----------------------------------------- Error Handling -----------------------------------------------

- (void)onError:(BBDeviceErrorType)errorType errorMessage:(NSString *)errorMessage;

// ----------------------------------------- Power Button Event -----------------------------------------------

- (void)onPowerButtonPressed;
- (void)onDeviceReset;

// ----------------------------------------- Power Down Event -----------------------------------------------

- (void)onPowerDown;

// ----------------------------------------- Standby Mode -----------------------------------------------

- (void)onEnterStandbyMode;

// ----------------------------------------- LED -----------------------------------------------

- (void)onReturnControlLEDResult:(BOOL)isSuccess errorMessage:(NSString *)errorMessage;

// ----------------------------------------- Communication Channel -----------------------------------------------

// Communication Channel
- (void)onDeviceHere:(BOOL)isHere;

// Communication Channel - Audio
- (void)onAudioDevicePlugged;
- (void)onAudioDeviceUnplugged;
- (void)onAudioInterrupted;
- (void)onNoAudioDeviceDetected;

// Communication Channel - BT - BT2 or BT4
- (void)onBTScanStopped;
- (void)onBTScanTimeout;
- (void)onBTReturnScanResults:(NSArray *)devices;
- (void)onBTConnectTimeout;
- (void)onBTConnected:(NSObject *)connectedDevice;
- (void)onBTDisconnected;
- (void)onRequestEnableBluetoothInSettings;

// BT 4.2
- (void)onBTRequestPairing;

// Communication Channel - USB (For macOS, not for iOS)
- (void)onUsbConnected;
- (void)onUsbDisconnected;

// ----------------------------------------- Session Token -----------------------------------------------

- (void)onSessionInitialized;
- (void)onSessionReset;
- (void)onSessionError:(BBDeviceSessionError)sessionError errorMessage:(NSString *)errorMessage;

// ----------------------------------------- Device Info -----------------------------------------------

- (void)onReturnDeviceInfo:(NSDictionary *)deviceInfo;

// ----------------------------------------- Transaction -----------------------------------------------

// Start Transaction
- (void)onRequestTerminalTime;
- (void)onRequestSetAmount;
- (void)onRequestSelectApplication:(NSArray *)applicationArray;

// Confirm Amount on device with keypad after set amount
- (void)onReturnAmountConfirmResult:(BOOL)isConfirmed;

// Waiting for card
- (void)onWaitingForCard:(BBDeviceCheckCardMode)checkCardMode;

// Confirm Transaction
- (void)onRequestFinalConfirm;
- (void)onRequestOnlineProcess:(NSString *)tlv;
- (void)onReturnBatchData:(NSString *)tlv;
- (void)onReturnReversalData:(NSString *)tlv;
- (void)onReturnTransactionResult:(BBDeviceTransactionResult)result;

// DisplayText
- (void)onRequestDisplayText:(BBDeviceDisplayText)displayText displayTextLanguage:(NSString *)languageCode;
- (void)onRequestClearDisplay;

// Set Amount on device with keypad before startEmv
- (void)onReturnEnableInputAmountResult:(BOOL)isSuccess;
- (void)onReturnDisableInputAmountResult:(BOOL)isSuccess;
- (void)onReturnAmount:(NSDictionary *)data;

// PIN entry on device with keypad or with PBOC firmware
- (void)onRequestPinEntry:(BBDevicePinEntrySource)pinEntrySource;
- (void)onReturnPinEntryResult:(BBDevicePinEntryResult)result data:(NSDictionary *)data;

// ----------------------------------------- Check Card Data -----------------------------------------------

- (void)onReturnCancelCheckCardResult:(BOOL)isSuccess;
- (void)onReturnCheckCardResult:(BBDeviceCheckCardResult)result cardData:(NSDictionary *)cardData;
- (void)onReturnEmvCardDataResult:(BOOL)isSuccess tlv:(NSString *)tlv;
- (void)onReturnEmvCardDataResult:(NSArray *)applicationArray;
- (void)onReturnEmvCardNumber:(BOOL)isSuccess cardNumber:(NSString *)cardNumber;

// ----------------------------------------- Data Encryption -----------------------------------------------

- (void)onReturnEncryptPinResult:(BOOL)isSuccess data:(NSDictionary *)data;
- (void)onReturnEncryptDataResult:(BOOL)isSuccess data:(NSDictionary *)data;

// ----------------------------------------- Contact Card -----------------------------------------------

- (void)onReturnPowerOnIccResult:(BOOL)isSuccess ksn:(NSString *)ksn atr:(NSString *)atr atrLength:(int)atrLength;
- (void)onReturnPowerOffIccResult:(BOOL)isSuccess;
- (void)onReturnApduResult:(BOOL)isSuccess data:(NSDictionary *)data;

// ----------------------------------------- Contactless Card -----------------------------------------------

- (void)onReturnNfcDetectCardResult:(BBDeviceNfcDetectCardResult)nfcDetectCardResult data:(NSDictionary *)data;
- (void)onReturnNfcDataExchangeResult:(BOOL)isSuccess data:(NSDictionary *)data;

// VAS
- (void)onReturnVASResult:(BBDeviceVASResult)result data:(NSDictionary *)data;
- (void)onRequestStartEmv;

// ----------------------------------------- Terminal Settings -----------------------------------------------

// Terminal Setting
//- (void)onReturnReadTerminalSettingResult:(BBDeviceTerminalSettingStatus)status tagValue:(NSString *)tagValue;
- (void)onReturnReadTerminalSettingResult:(NSDictionary *)data;
- (void)onReturnUpdateTerminalSettingResult:(BBDeviceTerminalSettingStatus)status;
- (void)onReturnUpdateTerminalSettingsResult:(NSDictionary *)data;

- (void)onReturnReadAIDResult:(NSDictionary *)data;
- (void)onReturnUpdateAIDResult:(NSDictionary *)data;

// CAPK
- (void)onReturnCAPKList:(NSArray *)capkArray;
- (void)onReturnCAPKDetail:(CAPK *)capk;
- (void)onReturnCAPKLocation:(NSString *)location;
- (void)onReturnUpdateCAPKResult:(BOOL)isSuccess;
- (void)onReturnRemoveCAPKResult:(BOOL)isSuccess;
- (void)onReturnEmvReportList:(NSDictionary *)data;
- (void)onReturnEmvReport:(NSString *)tlv;

// Standalone Mode
- (void)onReturnReadWiFiSettingsResult:(BOOL)isSuccess data:(NSDictionary *)data;
- (void)onReturnUpdateWiFiSettingsResult:(BOOL)isSuccess data:(NSDictionary *)data;
- (void)onReturnReadGprsSettingsResult:(BOOL)isSuccess data:(NSDictionary *)data;
- (void)onReturnUpdateGprsSettingsResult:(BOOL)isSuccess data:(NSDictionary *)data;

// ----------------------------------------- Receipt Printing (For WisePad 2 Plus) -----------------------------------------------

- (void)onRequestPrintData:(int)index isReprint:(BOOL)isReprint;
- (void)onWaitingReprintOrPrintNext;
- (void)onReturnPrintResult:(BBDevicePrintResult)result;
- (void)onPrintDataEnd;
- (void)onPrintDataCancelled;

// ----------------------------------------- Account Selection -----------------------------------------------

- (void)onReturnEnableAccountSelectionResult:(BOOL)isSuccess;
- (void)onReturnDisableAccountSelectionResult:(BOOL)isSuccess;
- (void)onReturnAccountSelectionResult:(BBDeviceAccountSelectionResult)result selectedAccountType:(int)selectedAccountType;

// ----------------------------------------- Display Prompt -----------------------------------------------

- (void)onDeviceDisplayingPrompt;
- (void)onRequestKeypadResponse;
- (void)onReturnDisplayPromptResult:(BBDeviceDisplayPromptResult)result;

// ----------------------------------------- Set Display Image -----------------------------------------------

- (void)onReturnUpdateDisplaySettingsProgress:(float)percentage;
- (void)onReturnUpdateDisplaySettingsResult:(BOOL)isSuccess message:(NSString *)message;

// ----------------------------------------- Other -----------------------------------------------

- (void)onReturnPhoneNumber:(BBDevicePhoneEntryResult)result phoneNumber:(NSString *)phoneNumber;

// ----------------------------------------- Key Exchange -----------------------------------------------

- (void)onReturnInjectSessionKeyResult:(BOOL)isSuccess data:(NSDictionary *)data;

// ----------------------------------------- SPOC -----------------------------------------------

// SPoC
- (void)onSPoCError:(BBDeviceSPoCError)errorType errorMessage:(NSString *)errorMessage;
- (void)onSPoCRequestSetupSecureSession;
- (void)onSPoCAttestationInProgress;
- (void)onSPoCSetupSecureSessionCompleted;



@end
