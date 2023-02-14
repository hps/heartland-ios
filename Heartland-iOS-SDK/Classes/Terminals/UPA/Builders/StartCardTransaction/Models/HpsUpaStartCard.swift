//
//  HpsUpaStartCard.swift
//  Heartland-iOS-SDK
//

import Foundation

public struct HpsUpaStartCard: Codable {
    public var message: String
    public let data: HpsUpaStartCardData
    
    public init(message: String = "MSG", data: HpsUpaStartCardData) {
        self.message = message
        self.data = data
    }
}

public struct HpsUpaStartCardData: Codable {
    public var command: String
    public let EcrId: String
    public let requestId: String
    public let data: HpsUpaStartCardDataDetails
    
    public init(command: String = "StartCardTransaction", EcrId: String, requestId: String, data: HpsUpaStartCardDataDetails) {
        self.command = command
        self.EcrId = EcrId
        self.requestId = requestId
        self.data = data
    }
}

public struct HpsUpaStartCardDataDetails: Codable {
    public let params: HpsUpaStartCardParams
    public let processingIndicators: HpsUpaStartCardProcessingIndicators
    public let transaction: HpsUpaStartCardTransaction
    
    public init(params: HpsUpaStartCardParams, processingIndicators: HpsUpaStartCardProcessingIndicators, transaction: HpsUpaStartCardTransaction) {
        self.params = params
        self.processingIndicators = processingIndicators
        self.transaction = transaction
    }
}

public struct HpsUpaStartCardParams: Codable {
    public let acquisitionTypes: String
    public let timeout: Int?
    public let header: String?
    public let displayTotalAmount: String?
    public let promptForManualEntryPassword: String?
    public let brandIcon1: Int?
    public let brandIcon2: Int?
    
    public init(acquisitionTypes: String, timeout: Int?, header: String?, displayTotalAmount: String?, promptForManualEntryPassword: String?, brandIcon1: Int?, brandIcon2: Int?) {
        self.acquisitionTypes = acquisitionTypes
        self.timeout = timeout
        self.header = header
        self.displayTotalAmount = displayTotalAmount
        self.promptForManualEntryPassword = promptForManualEntryPassword
        self.brandIcon1 = brandIcon1
        self.brandIcon2 = brandIcon2
    }
}

public struct HpsUpaStartCardProcessingIndicators: Codable {
    public let quickChip: String
    public let checkLuhn: String?
    public let securityCode: String?
    public let cardFilterType: String?
    
    public init(quickChip: String, checkLuhn: String?, securityCode: String?, cardFilterType: String?) {
        self.quickChip = quickChip
        self.checkLuhn = checkLuhn
        self.securityCode = securityCode
        self.cardFilterType = cardFilterType
    }
}

public struct HpsUpaStartCardTransaction: Codable {
    public let totalAmount: String
    public let cashBackAmount: String?
    public let tranDate: String?
    public let tranTime: String?
    public let transactionType: String
    
    public init(totalAmount: String, cashBackAmount: String?, tranDate: String?, tranTime: String?, transactionType: String) {
        self.totalAmount = totalAmount
        self.cashBackAmount = cashBackAmount
        self.tranDate = tranDate
        self.tranTime = tranTime
        self.transactionType = transactionType
    }
}
