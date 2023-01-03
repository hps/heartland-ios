//
//  HpsUpaStartCard.swift
//  Heartland-iOS-SDK
//

import Foundation

public struct HpsUpaStartCard: Codable {
    public var message: String = "MSG"
    public let data: HpsUpaStartCardData
}

public struct HpsUpaStartCardData: Codable {
    public var command: String = "StartCardTransaction"
    public let EcrId: String
    public let requestId: String
    public let data: HpsUpaStartCardDataDetails
}

public struct HpsUpaStartCardDataDetails: Codable {
    public let params: HpsUpaStartCardParams
    public let processingIndicators: HpsUpaStartCardProcessingIndicators
    public let transaction: HpsUpaStartCardTransaction
}

public struct HpsUpaStartCardParams: Codable {
    public let acquisitionTypes: String
    public let timeout: Int?
    public let header: String?
    public let displayTotalAmount: String?
    public let promptForManualEntryPassword: String?
    public let brandIcon1: Int?
    public let brandIcon2: Int?
}

public struct HpsUpaStartCardProcessingIndicators: Codable {
    public let quickChip: String
    public let checkLuhn: String?
    public let securityCode: String?
    public let cardFilterType: String?
}

public struct HpsUpaStartCardTransaction: Codable {
    public let totalAmount: String
    public let cashBackAmount: String?
    public let tranDate: String?
    public let tranTime: String?
    public let transactionType: String
}
