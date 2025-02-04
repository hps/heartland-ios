//
//  HpsUpaCAVoidModelResponse.swift
//  Heartland-iOS-SDK
//
//  Created by Renato Santos on 21/06/2023.
//

import Foundation

public struct HpsUpaCAVoidModelResponse: Codable {
    public let message: String?
    
    public let data: HpsUpaCAVoidModelResponseData?
    public var jsonTransactionResponse: String?

    public init(message: String?, data: HpsUpaCAVoidModelResponseData?, json: String?) {
        self.message = message
        self.data = data
        self.jsonTransactionResponse = json
    }
}

// MARK: - CMD Result
public struct CMDVoidResult: Codable {
    let result: String?

    enum CodingKeys: String, CodingKey {
        case result
    }
}

// MARK: - CDD Result
public struct DCCVoidResult: Codable {
    public let exchangeRate: String?
    public let markUp: String?
    public let transactionCurrency: String?
    public let transactionAmount: String?
}

// MARK: - HpsUpaCAVoidModelResponseData

public struct HpsUpaCAVoidModelResponseData: Codable {
    public let ecrId: String?
    public let data: DataVoidResponse?
    public let cmdResult: CMDVoidResult?
    public let response, requestId: String?

    enum CodingKeys: String, CodingKey {
        case ecrId = "EcrId"
        case data
        case cmdResult
        case response
        case requestId = "requestId"
    }
}

public struct DataVoidResponse: Codable {
    public let emv: [String: String]?
    public let terminalId: String?
    public let payment: UpsUpaCAVoidModelResponsePayment?
    public let host: HpsUpaCAVoidModelResponseHost?
    public let merchantId, multipleMessage: String?

    enum CodingKeys: String, CodingKey {
        case emv
        case terminalId = "terminalId"
        case payment
        case host
        case merchantId = "merchantId"
        case multipleMessage
    }
}

// MARK: - UpsUpaCAVoidModelResponsePayment
public struct UpsUpaCAVoidModelResponsePayment: Codable {
    let cardType, signatureLine, storeAndForward, appName: String?
    let cardGroup, expiryDate, cardAcquisition, fallback: String?
    let maskedPan, pinVerified, transactionType: String?
    let cardHolderName, accountType, posSequenceNbr: String?

    enum CodingKeys: String, CodingKey {
        case cardType
        case signatureLine
        case storeAndForward
        case appName
        case cardGroup
        case expiryDate
        case cardAcquisition
        case fallback
        case maskedPan
        case pinVerified = "PinVerified"
        case transactionType
        case cardHolderName = "cardHolderName"
        case accountType = "AccountType"
        case posSequenceNbr = "PosSequenceNbr"
    }
}

// MARK: - HpsUpaCAVoidModelResponseHost
public struct HpsUpaCAVoidModelResponseHost: Codable {
    public let responseId: Int?
    public let tipAmount, totalAmount, responseText: String?
    public let referenceNumber: Int?
    public let tranNo, baseAmount: String?
    public let approvalCode, authorizedAmount, responseCode, gatewayResponseMessage: String?
    public let respDateTime, gatewayResponseCode, isoRespCode, issuerResp, bankRespCode: String?

    enum CodingKeys: String, CodingKey {
        case responseId = "responseId"
        case tipAmount
        case totalAmount
        case responseText
        case tranNo
        case referenceNumber
        case baseAmount
        case approvalCode
        case authorizedAmount
        case responseCode
        case gatewayResponseMessage
        case respDateTime
        case gatewayResponseCode
        case bankRespCode = "BankRespCode"
        case isoRespCode = "IsoRespCode"
        case issuerResp = "IssuerResp"
    }
}
