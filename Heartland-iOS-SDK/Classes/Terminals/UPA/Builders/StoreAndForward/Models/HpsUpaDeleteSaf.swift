//
//  HpsUpaDeleteSaf.swift
//  Heartland-iOS-SDK
//

import Foundation

struct HpsUpaDeleteSafConstants {
    static let command = "DeleteSAF"
}

// MARK: - HpsUpaDeleteSaf

public struct HpsUpaDeleteSaf: Codable {
    public let message: String?
    public let data: HpsUpaCommandPayload<HpsUpaDeleteSafData>?
    
    public init(message: String? = "MSG", data: HpsUpaCommandPayload<HpsUpaDeleteSafData>?) {
        self.message = message
        self.data = data
    }
}

public struct HpsUpaDeleteSafData: Codable {
    public let transaction: HpsUpaDeleteSafTransaction
    
    public init(transaction: HpsUpaDeleteSafTransaction) {
        self.transaction = transaction
    }
}

public struct HpsUpaDeleteSafTransaction: Codable {
    public let tranNo: String
    public let referenceNumber: String
    
    public init(tranNo: String, safReferenceNumber: String) {
        self.tranNo = tranNo
        self.referenceNumber = safReferenceNumber
    }
}
