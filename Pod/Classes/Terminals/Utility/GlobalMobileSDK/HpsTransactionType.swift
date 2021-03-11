import Foundation

@objc
public enum HpsTransactionType: UInt {
    case batchClose,
        creditAdjust,
        creditAuth,
        creditCapture,
        creditReturn,
        creditSale,
        creditVoid,
        unknown
}
