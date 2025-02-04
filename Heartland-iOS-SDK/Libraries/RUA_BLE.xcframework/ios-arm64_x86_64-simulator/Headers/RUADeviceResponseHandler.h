/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>
#import "RUAResponse.h"
#ifndef ROAMreaderUnifiedAPI_RUAResponseHandler_h
#define ROAMreaderUnifiedAPI_RUAResponseHandler_h

typedef NS_ENUM(NSInteger, RUAProgressMessage) {
	RUAProgressMessagePleaseInsertCard,
	RUAProgressMessagePleaseRemoveCard,
	RUAProgressMessageSwipeDetected,
	RUAProgressMessageWaitingforCardSwipe,
	RUAProgressMessageWaitingforDevice,
	RUAProgressMessageDecodingStarted,
	RUAProgressMessageCommandSent,
    RUAProgressMessageICCErrorSwipeCard,
    RUAProgressMessageSwipeErrorReswipe,
    RUAProgressMessageMagCardDataInsertCard,
    RUAProgressMessageCardInserted,
    RUAProgressMessageCardReadError,
	RUAProgressMessageUnknown,
    RUAProgressMessageApplicationSelectionStarted,
    RUAProgressMessageApplicationSelectionCompleted,
    RUAProgressMessageCardHolderPressedCancelKey,
	RUAProgressMessageContactlessTransactionRevertedToContact,
    RUAProgressMessageDeviceBusy,
    RUAProgressMessageFirstPinEntryPrompt,
    RUAProgressMessageErrorReadingContactlessCard,
    RUAProgressMessageLasttPinEntryPrompt,
    RUAProgressMessageMultipleContactlessCardsDetected,
    RUAProgressMessagePinEntryFailed,
    RUAProgressMessagePinEntryInProgress,
    RUAProgressMessagePinEntrySuccessful,
    RUAProgressMessageRetrytPinEntryPrompt,
    RUAProgressMessageSwipeErrorReswipeMagStripe,
	RUAProgressMessageUpdatingFirmware,
    RUAProgressMessageTapDetected,
    RUAProgressMessageContactlessCardStillInField,
    RUAProgressMessageFirstEnterNewPINPrompt,
    RUAProgressMessageValidateNewPINPrompt,
    RUAProgressMessageRetryEnterNewPINPrompt,
    RUAProgressMessagePINChangeFailed,
    RUAProgressMessagePINChangeEnded,
    RUAProgressMessagePleaseSeePhone,
//  C017 is a Fallback progress message informing the mobile app that contactless transaction has failled and the cardholder should insert or swipe his card
    RUAProgressMessageContactlessInterfaceFailedTryContact,
    RUAProgressMessagePresentCardAgain,
    RUAProgressMessageCardRemoved,
    RUAProgressMessageCardBlocked,
    RUAProgressMessageNotAuthorized,
    RUAProgressMessageCompleteCardRemove,
    RUAProgressMessageRemoveCard,
    RUAProgressMessageInsertOrSwipeCard,
    RUAProgressMessageTransactionVoid,
    RUAProgressMessageCardReadOkRemoveCard,
    /*!
     * Returned for retrieveKeyedCardData API in KeypadControl
     * when KeyedData is AllDataSwipeOrKeyed}/ExceptCVVSwipeOrKeyed
     */
    RUAProgressMessageEnterCardNumberOrSwipeCard,
    /*!
     * Returned for retrieveKeyedCardData API in KeypadControl
     * when KeyedData is ExceptCVVChipOrSwipeOrKeyed
     */
    RUAProgressMessageEnterCardNumberOrInsertOrSwipeCard,
    /*!
     * Returned for retrieveKeyedCardData API in KeypadControl
     * for all KeyedData values
     */
    RUAProgressMessageEnterExpiryDate,
    /*!
     * Returned for retrieveKeyedCardData API in KeypadControl
     * when KeyedData is AllDataSwipeOrKeyed/AllDataKeyedOnlyOnlyCVV/OnlyCVVFourDigitsAllowed
     */
    RUAProgressMessageEnterSecurityCode,
    /*!
     * Returned for retrieveKeyedCardData API in KeypadControl
     * when incorrect card number was entered
     */
    RUAProgressMessageIncorrrectCardNumber,
    /*!
     * Returned for retrieveKeyedCardData API in KeypadControl
     * when incorrect expiration date was entered
     */
    RUAProgressMessageIncorrectExpirationDate,
    RUAProgressMessageUSDebit,
    RUAProgressMessageProcessingTransaction,
    RUAProgressMessageCardExpired,
    RUAProgressMessageCardHolderBypassedPIN,
    RUAProgressMessageNotAccepted,
    RUAProgressMessageProcessingDoNotRemoveCard,
    RUAProgressMessageAuthorizing,
    RUAProgressMessageNotAcceptedRemoveCard,
    RUAProgressMessageCardError,
    RUAProgressMessageCardErrorRemoveCard,
    RUAProgressMessageCancelled,
    RUAProgressMessageCancelledRemoveCard,
    RUAProgressMessageTransactionVoidRemoveCard,
    RUAProgressMessageUnknownAID,
	RUAProgressMessageReinsertCard,
    RUAProgressMessageCardHolderLanguageChoice,
    RUAProgressMessageApproved,//progress messages below are new ones added in MBL-8838
    RUAProgressMessageCompleteRemoveCard,
    RUAProgressMessageComplete,
    RUAProgressMessageWaitingforChipCard,
    RUAProgressMessageWaitingforSwipeCard,
    RUAProgressMessageWaitingforChipAndSwipe,
    RUAProgressMessageWaitingforTapCard,
    RUAProgressMessageWaitingforChipAndTap,
    RUAProgressMessageWaitingforSwipeAndTap,
    RUAProgressMessageWaitingforChipSwipeTap,
    RUAProgressMessageWaitingforFallbackSwipe,
    RUAProgressMessageWaitingforReinsertChip,
    RUAProgressMessageWaitingforReinsertAll,
    RUAProgressMessageWaitingforSwipeError,
    RUAProgressMessageWaitingforTapCardCollision,
    RUAProgressMessageWaitingforCardFullRemoval,
    RUAProgressMessageWaitingforFallbackChip,
    RUAProgressMessageWaitingforPleaseSeePhone,
    RUAProgressMessageWaitingforTapAgain,
    RUAProgressMessageWaitingforTapAndOther,
    RUAProgressMessageWaitingforChipTapOther,
    RUAProgressMessageWaitingforSwipeChipTapOther,
    RUAProgressMessageWaitingforChipSwipeOther,
    RUAProgressMessageRetrievingDeviceLogs,
    RUAProgressMessageProvisioningJson,
    RUAProgressMessageBatteryDropOverWarningValueDetected,
    RUAProgressMessageBatteryVoltageReachedLimit,
    RUAProgressMessageDeprecatedCommand,
    RUAProgressMessageWarningDeviceReachedMaximumEncryptionLimit
};



typedef void (^OnProgress)(RUAProgressMessage messageType, NSString* _Nullable additionalMessage);
typedef void (^OnResponse)(RUAResponse * _Nullable response);

#endif
