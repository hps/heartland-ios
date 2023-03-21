import Foundation
import GlobalMobileSDK

@objc
public enum ReversalReasonCode: NSInteger {
    case CUSTOMERCANCELLATION,
         TERMINALERROR,
         TIMEOUT,
         PARTIALREVERSAL,
         NOREASON
}
