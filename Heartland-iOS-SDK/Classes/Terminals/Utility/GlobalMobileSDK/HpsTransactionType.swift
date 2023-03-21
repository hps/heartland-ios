import Foundation

@objc
public enum HpsTransactionType: UInt {
    case batchClose,
         creditAdjust,
         creditAuth,
         creditCapture,
         creditReturn,
         creditReversal,
         creditSale,
         creditVoid,
         unknown
}
