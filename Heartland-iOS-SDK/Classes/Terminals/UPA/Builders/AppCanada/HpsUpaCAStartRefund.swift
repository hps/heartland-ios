//
//  HpsUpaCAStartRefund.swift
//  Heartland-iOS-SDK
//

import Foundation

// MARK: - Void
public struct HpsUpaCAStartRefund: Codable {
    public let params: HpsUpaCAStartRefundParams?
    public let transaction: HpsUpaCAStartRefundTransaction?
    
    public init(params: HpsUpaCAStartRefundParams?, transaction: HpsUpaCAStartRefundTransaction?) {
        self.params = params
        self.transaction = transaction
    }
}

// MARK: - Token Request
public enum TokenRequest: String, Codable {
    case YES
    case NO
    
    public var rawValue: String {
        switch self {
        case .YES:
            return "1"
        case .NO:
            return "0"
        }
    }
}

// MARK: - Params
public struct HpsUpaCAStartRefundParams: Codable {
    public let clerkID: String?
    public let tokenRequest: String?
    public let tokenValue: String?

    enum CodingKeys: String, CodingKey {
        case clerkID = "clerkId"
        case tokenRequest
        case tokenValue
    }
    
    public init(clerkID: String?, tokenRequest: TokenRequest?, tokenValue: String?) {
        self.clerkID = clerkID
        self.tokenRequest = tokenRequest?.rawValue
        self.tokenValue = tokenValue
    }
}

// MARK: - Transaction
public struct HpsUpaCAStartRefundTransaction: Codable {
    public let totalAmount: String?
    public let invoiceNbr: String?
    
    public init(totalAmount: String?, invoiceNbr: String?) {
        self.totalAmount = totalAmount
        self.invoiceNbr = invoiceNbr
    }
}
