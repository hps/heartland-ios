import Foundation
import GlobalMobileSDK

@objc
public enum HpsTransactionStatus: UInt {
    case waitingForConfiguration,
         configuringTerminal,
         configurationFailedTryAgain,
         ready,
         started,
         waitingForCard,
         insertCard,
         removeCard,
         cardRemoved,
         pleaseWait,
         pleaseSeePhone,
         useMagstripe,
         tryAgain,
         swipeErrorReSwipe,
         noEmvApps,
         applicationExpired,
         cardReadError,
         processing,
         processingDoNotRemoveCard,
         presentCard,
         presentCardAgain,
         insertSwipeOrTryAnotherCard,
         insertOrSwipeCard,
         multipleCardDetected,
         contactlessCardStillInField,
         transactionTerminated,
         waitingForTerminal,
         cardDetected,
         cardBlocked,
         notAuthorized,
         notAcceptedRemoveCard,
         fallbackToMSR,
         fallbackToChip,
         waitingForAmountConfirmation,
         waitingForAidSelection,
         waitingForPostalCode,
         waitingForSafApproval,
         cardHolderBypassedPIN,
         processingSaf,
         requestingOnlineProcessing,
         reversal,
         reversalInProgress,
         complete,
         cancel,
         cancelling,
         cancelled,
         error,
         unknown,
         terminalDeclined,
         surchargeRequested
}

public extension HpsTransactionStatus {
    static func fromTransactionState(_ state: TransactionState) -> HpsTransactionStatus {
        switch state {
        case .waitingForConfiguration: return .waitingForConfiguration
        case .configuringTerminal: return .configuringTerminal
        case .configurationFailedTryAgain: return .configurationFailedTryAgain
        case .ready: return .ready
        case .started: return .started
        case .waitingForCard: return .waitingForCard
        case .insertCard: return .insertCard
        case .removeCard: return .removeCard
        case .cardRemoved: return .cardRemoved
        case .pleaseWait: return .pleaseWait
        case .pleaseSeePhone: return .pleaseSeePhone
        case .useMagstripe: return .useMagstripe
        case .tryAgain: return .tryAgain
        case .swipeErrorReSwipe: return .swipeErrorReSwipe
        case .noEmvApps: return .noEmvApps
        case .applicationExpired: return .applicationExpired
        case .cardReadError: return .cardReadError
        case .processing: return .processing
        case .processingDoNotRemoveCard: return .processingDoNotRemoveCard
        case .presentCard: return .presentCard
        case .presentCardAgain: return .presentCardAgain
        case .insertSwipeOrTryAnotherCard: return .insertSwipeOrTryAnotherCard
        case .insertOrSwipeCard: return .insertOrSwipeCard
        case .multipleCardDetected: return .multipleCardDetected
        case .contactlessCardStillInField: return .contactlessCardStillInField
        case .transactionTerminated: return .transactionTerminated
        case .waitingForTerminal: return .waitingForTerminal
        case .cardDetected: return .cardDetected
        case .cardBlocked: return .cardBlocked
        case .notAuthorized: return .notAuthorized
        case .notAcceptedRemoveCard: return .notAcceptedRemoveCard
        case .fallbackToMSR: return .fallbackToMSR
        case .fallbackToChip: return .fallbackToChip
        case .waitingForAmountConfirmation: return .waitingForAmountConfirmation
        case .waitingForAidSelection: return .waitingForAidSelection
        case .waitingForPostalCode: return .waitingForPostalCode
        case .waitingForSafApproval: return .waitingForSafApproval
        case .cardHolderBypassedPIN: return .cardHolderBypassedPIN
        case .processingSaf: return .processingSaf
        case .requestingOnlineProcessing: return .requestingOnlineProcessing
        case .reversal: return .reversal
        case .reversalInProgress: return .reversalInProgress
        case .complete: return .complete
        case .cancel: return .cancel
        case .cancelling: return .cancelling
        case .cancelled: return .cancelled
        case .error: return .error
        case .unknown: return .unknown
        case .terminalDeclined: return .terminalDeclined
        case .waitingForSurchargeAcceptance: return .surchargeRequested
        @unknown default: return .unknown
        }
    }
}
