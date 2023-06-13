//
//  HpsUpaCAStartCardResponse.swift
//  Heartland-iOS-SDK
//

import Foundation

public struct HpsUpaCAStartCardResponse: Codable {
    public let message: String?
    public let data: HpsUpaResponsePayload<HpsUpaCAStartCardResponseData>?

    public init(message: String?, data: HpsUpaResponsePayload<HpsUpaCAStartCardResponseData>?) {
        self.message = message
        self.data = data
    }
}

// MARK: - CMD Result
public struct CMDResult: Codable {
    public let result: String?
}

// MARK: - CDD Result
public struct DCCResult: Codable {
    public let exchangeRate: String?
    public let markUp: String?
    public let transactionCurrency: String?
    public let transactionAmount: String?
}

// MARK: - HpsUpaCAStartCardResponseData

public struct HpsUpaCAStartCardResponseData: Codable {
    private let multipleMessage: Int?
    private let terminalNumber: String?
    private let terminalId: String?
    private let merchantId: String?
    public let host: HpsUpaCAStartCardResponseHost?
    private let payment: UpsUpaCAStartCardResponsePayment?
    public let emvTags: [String: AnyValue]?
    private let ecrId: String?
    private let requestID: String?
    private let response: String?
    private let cmdResult: CMDResult?
    private let dcc: DCCResult?
    
    enum CodingKeys: String, CodingKey {
        case multipleMessage = "multiplemessage"
        case terminalNumber
        case terminalId
        case merchantId
        case host
        case payment
        case emvTags = "emv"
        case ecrId = "EcrId"
        case requestID = "requestId"
        case cmdResult
        case dcc = "Dcc"
        case response
    }

}

// MARK: - UpsUpaCAStartCardResponsePayment
struct UpsUpaCAStartCardResponsePayment: Codable {
    let pinVerified, fallback, maskedPan, qpsQualified: String?
    let cardGroup, cardType, appName, transactionType: String?
    let storeAndForward, cardAcquisition, signatureLine, expiryDate: String?
    let posSequenceNbr, accountType: String?

    enum CodingKeys: String, CodingKey {
        case pinVerified = "PinVerified"
        case fallback, maskedPan
        case qpsQualified = "QpsQualified"
        case posSequenceNbr = "PosSequenceNbr"
        case accountType = "AccountType"
        case cardGroup, cardType, appName, transactionType, storeAndForward, cardAcquisition, signatureLine, expiryDate
    }
}

// MARK: - HpsUpaCAStartCardResponseHost
public struct HpsUpaCAStartCardResponseHost: Codable {
    public let responseID: Int?
    public let avsResultCode, tipAmount, totalAmount, additionalTipAmount, responseText: String?
    public let cardBrandTransID, tranNo, traceNumber: String?
    public let referenceNumber: Int?
    public let avsResultText, baseAmount, authorizedAmount, responseCode: String?
    public let respDateTime, gatewayResponseMessage, gatewayResponseCode: String?
    public let isoRespCode, issuerResp, approvalCode: String?

    enum CodingKeys: String, CodingKey {
        case responseID = "responseId"
        case avsResultCode = "AvsResultCode"
        case tipAmount, totalAmount, additionalTipAmount, responseText
        case cardBrandTransID = "cardBrandTransId"
        case tranNo, referenceNumber, traceNumber
        case avsResultText = "AvsResultText"
        case baseAmount, authorizedAmount, responseCode, respDateTime
        case gatewayResponseMessage, gatewayResponseCode, approvalCode
        case isoRespCode = "IsoRespCode"
        case issuerResp = "IssuerResp"
    }
}

public enum AnyValue: Codable {
    
    case int(Int), string(String)
    
    public init(from decoder: Decoder) throws {
        if let int = try? decoder.singleValueContainer().decode(Int.self) {
            self = .int(int)
            return
        }
        
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }
        
        throw QuantumError.missingValue
    }
    
    enum QuantumError:Error {
        case missingValue
    }
}
