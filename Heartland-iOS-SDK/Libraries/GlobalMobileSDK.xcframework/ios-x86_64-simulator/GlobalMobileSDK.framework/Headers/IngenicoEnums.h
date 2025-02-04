//
//  IngenicoEnums.h
//  GlobalMobileSDK
//
//  Created by Govardhan Padamata on 10/7/20.
//  Copyright (c) 2020 GlobalPayments. All rights reserved.
//

#ifndef IngenicoEnums_h
#define IngenicoEnums_h

/*
 NOTE: Some Enums had to be added in Obj-C as compiler is not able to generate the swift modules.
 These enums aren't working when created in swift.
 */

typedef NS_ENUM(NSUInteger, ProgressMessage)
{
    ProgressMessageUnknown,
    ProgressMessageConfigurationComplete,
    ProgressMessagePresentCard,
    ProgressMessageInsertCard,
    ProgressMessageRemoveCard,
    ProgressMessageConfirmAmount,
    ProgressMessageSwipeDetected,
    ProgressMessageWaitingforCardSwipe,
    ProgressMessageWaitingforDevice,
    ProgressMessageDecodingStarted, //10
    ProgressMessageICCErrorSwipeCard,
    ProgressMessageSwipeErrorReswipe,
    ProgressMessageMagCardDataInsertCard,
    ProgressMessageCardInserted,
    ProgressMessageCardReadError,
    ProgressMessageDeviceBusy,
    ProgressMessageErrorReadingContactlessCard,
    ProgressMessageMultipleContactlessCardsDetected,
    ProgressMessageSwipeErrorReswipeMagStripe,
    ProgressMessageUpdatingFirmware, //20
    ProgressMessageTapDetected,
    ProgressMessageContactlessCardStillInField,
    ProgressMessagePleaseSeePhone,
    ProgressMessageContactlessInterfaceFailedTryContact,
    ProgressMessagePresentCardAgain,
    ProgressMessageCardRemoved,
    ProgressMessageCardBlocked,
    ProgressMessageNotAuthorized,
    ProgressMessageCompleteCardRemove,
    ProgressMessageInsertOrSwipeCard, //30
    ProgressMessageTransactionVoid,
    ProgressMessageCardReadOkRemoveCard,
    ProgressMessageProcessingTransaction,
    ProgressMessageCardHolderBypassedPIN,
    ProgressMessageNotAccepted,
    ProgressMessageProcessingDoNotRemoveCard,
    ProgressMessageAuthorizing,
    ProgressMessageNotAcceptedRemoveCard,
    ProgressMessageCardError,
    ProgressMessageCardErrorRemoveCard, //40
    ProgressMessageCancelled,
    ProgressMessageCancelledRemoveCard,
    ProgressMessageTransactionVoidRemoveCard,
    ProgressMessageUnknownAID,
    ProgressMessageReinsertCard,
    ProgressMessageApproved,
    ProgressMessageCompleteRemoveCard,
    ProgressMessageComplete,
    ProgressMessageWaitingforFallbackSwipe,//50
    ProgressMessageWaitingforFallbackChip,
    ProgressMessageGoOnlineRequested,
    ProgressMessageReversalRequested,
    ProgressMessagePostAuthChipDecline
};

typedef NS_ENUM(NSUInteger, TerminalTransactionType)
{
    TerminalTransactionTypeSale,
    TerminalTransactionTypeReturn,
    TerminalTransactionTypeVoid,
    TerminalTransactionTypeAuth,
    TerminalTransactionTypeCapture,
    TerminalTransactionTypeBatchClose,
    TerminalTransactionTypeVerify,
    TerminalTransactionTypeTokenize,
    TerminalTransactionTypeTipAdjust,
    TerminalTransactionTypeProcessSaf,
    TerminalTransactionTypeListSaf
};

#endif /* IngenicoEnums_h */
