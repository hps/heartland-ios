//
//  HpsUpaCASaleModelResponse.swift
//  Heartland-iOS-SDK
//

import Foundation

public struct HpsUpaCASaleModelResponse: Codable {
    public let message: String?
    public let data: HpsUpaCASaleModelResponseData?

    public init(message: String?, data: HpsUpaCASaleModelResponseData?) {
        self.message = message
        self.data = data
    }
}

// MARK: - CMD Result
public struct CMDSaleResult: Codable {
    public let result: String?
}

// MARK: - CDD Result
public struct DCCSaleResult: Codable {
    public let exchangeRate: String?
    public let markUp: String?
    public let transactionCurrency: String?
    public let transactionAmount: String?
}

// MARK: - HpsUpaCASaleModelResponseData

public struct HpsUpaCASaleModelResponseData: Codable {
    public let ecrID: String?
    public let data: DataSaleResponse?
    public let cmdResult: CMDSaleResult?
    public let response, requestID: String?

    enum CodingKeys: String, CodingKey {
        case ecrID = "EcrId"
        case data, cmdResult, response
        case requestID = "requestId"
    }

}

public struct DataSaleResponse: Codable {
    public let emv: [String: AnyValue]?
    public let terminalID: String?
    public let payment: UpsUpaCASaleModelResponsePayment?
    public let host: HpsUpaCASaleModelResponseHost?
    public let merchantID, multipleMessage: String?

    enum CodingKeys: String, CodingKey {
        case emv
        case terminalID = "terminalId"
        case payment, host
        case merchantID = "merchantId"
        case multipleMessage
    }
}

// MARK: - UpsUpaCASaleModelResponsePayment
public struct UpsUpaCASaleModelResponsePayment: Codable {
    public let pinVerified, fallback, maskedPan, qpsQualified: String?
    public let cardGroup, cardType, appName, transactionType: String?
    public let storeAndForward, cardAcquisition, signatureLine, expiryDate: String?

    enum CodingKeys: String, CodingKey {
        case pinVerified = "PinVerified"
        case fallback, maskedPan
        case qpsQualified = "QpsQualified"
        case cardGroup, cardType, appName, transactionType, storeAndForward, cardAcquisition, signatureLine, expiryDate
    }
}

// MARK: - HpsUpaCASaleModelResponseHost
public struct HpsUpaCASaleModelResponseHost: Codable {
    public let responseID: Int?
    public let avsResultCode, tipAmount, totalAmount, responseText: String?
    public let cardBrandTransID: Int?
    public let tranNo: String?
    public let referenceNumber: Int?
    public let avsResultText, baseAmount, approvalCode, authorizedAmount: String?
    public let responseCode, respDateTime, gatewayResponseMessage, gatewayResponseCode: String?

    enum CodingKeys: String, CodingKey {
        case responseID = "responseId"
        case avsResultCode = "AvsResultCode"
        case tipAmount, totalAmount, responseText
        case cardBrandTransID = "cardBrandTransId"
        case tranNo, referenceNumber
        case avsResultText = "AvsResultText"
        case baseAmount, approvalCode, authorizedAmount, responseCode, respDateTime, gatewayResponseMessage, gatewayResponseCode
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
