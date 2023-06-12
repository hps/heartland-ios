//
//  HpsUpaCAStartVoid.swift
//  Heartland-iOS-SDK
//

import Foundation

// MARK: - Void
public struct HpsUpaCAVoid: Codable {
    public let params: HpsUpaCAVoidParams?
    public let transaction: HpsUpaCAVoidTransaction?
    
    public init(params: HpsUpaCAVoidParams?, transaction: HpsUpaCAVoidTransaction?) {
        self.params = params
        self.transaction = transaction
    }
}

// MARK: - Params
public struct HpsUpaCAVoidParams: Codable {
    public let clerkID: String?

    enum CodingKeys: String, CodingKey {
        case clerkID = "clerkId"
    }
    
    public init(clerkID: String?) {
        self.clerkID = clerkID
    }
}

// MARK: - Transaction
public struct HpsUpaCAVoidTransaction: Codable {
    public let tranNo: String?
    
    public init(tranNo: String?) {
        self.tranNo = tranNo
    }
}
