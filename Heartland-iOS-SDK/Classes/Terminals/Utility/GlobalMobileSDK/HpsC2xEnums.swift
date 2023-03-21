import Foundation
import GlobalMobileSDK

@objc
public class HpsC2xEnums: NSObject {
    public static func transactionTypeToString(_ transactionType: GlobalMobileSDK.TransactionType?) -> String {
        switch transactionType {
        case .Auth:
            return "Auth"
        case .BatchClose:
            return "BatchClose"
        case .Capture:
            return "Capture"
        case .ListSaf:
            return "ListSaf"
        case .Return:
            return "Return"
        case .Reversal:
            return "Reversal"
        case .Sale:
            return "Sale"
        case .TipAdjust:
            return "TipAdjust"
        case .Tokenize:
            return "Tokenize"
        case .Verify:
            return "Verify"
        default:
            return "unknown"
        }
    }

    public static func cardDataSourceTypeToString(_ cardDataSourceType: GlobalMobileSDK.EntryMode?) -> String {
        switch cardDataSourceType {
        case .chipFallback:
            return "chipFallback"
        case .contact:
            return "contact"
        case .contactless:
            return "contactless"
        case .manual:
            return "manual"
        case .msr:
            return "msr"
        case .quickChip:
            return "quickChip"
        default:
            return "unknown"
        }
    }

    public static func cardDataSourceTypeToEntryMode(_ cardDataSourceType: GlobalMobileSDK.EntryMode?) -> HpsPaxEntryModes {
        switch cardDataSourceType {
        case .chipFallback:
            return .chipFallBackSwipe
        case .contact:
            return .chip
        case .contactless:
            return .contactless
        case .manual:
            return .manual
        case .msr:
            return .swipe
        case .quickChip:
            return .chip
        default:
            return .unknown
        }
    }

    public static func reversalReasonCodeToReversalReason(_ reversalReasonCode: ReversalReasonCode) -> ReversalReason {
        switch reversalReasonCode {
        case .CUSTOMERCANCELLATION:
            return .voidedByCustomer
        case .TERMINALERROR:
            return .deviceUnavailable
        case .TIMEOUT:
            return .deviceTimeOut
        case .PARTIALREVERSAL:
            return .partialReversal
        default:
            return .undefined
        }
    }

    public static func cardTypeToString(_ cardType: CardType?) -> String {
        switch cardType {
        case .amex:
            return "amex"
        case .dinersClub:
            return "diners"
        case .discover:
            return "discover"
        case .jcb:
            return "jcb"
        case .maestro:
            return "maestro"
        case .masterCard:
            return "mastercard"
        case .tokenizedCard:
            return "token"
        case .unionPay:
            return "unionpay"
        case .visa:
            return "visa"
        default:
            return "unknown"
        }
    }
}
