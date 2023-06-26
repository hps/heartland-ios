//
//  HpsUpaCARefundModelResponse.swift
//  Heartland-iOS-SDK
//
//  Created by Renato Santos on 21/06/2023.
//

import Foundation

public struct HpsUpaCARefundModelResponse: Codable {
    public let message: String?
    public let data: HpsUpaCARefundModelResponseData?

    public init(message: String?, data: HpsUpaCARefundModelResponseData?) {
        self.message = message
        self.data = data
    }
}

// MARK: - CMD Result
public struct CMDRefundResult: Codable {
    public let result: String?
}

// MARK: - CDD Result
public struct DCCRefundResult: Codable {
    public let exchangeRate: String?
    public let markUp: String?
    public let transactionCurrency: String?
    public let transactionAmount: String?
}

// MARK: - HpsUpaCARefundModelResponseData

public struct HpsUpaCARefundModelResponseData: Codable {
    public let ecrID: String?
    public let data: DataRefundResponse?
    public let cmdResult: CMDRefundResult?
    public let response, requestID: String?

    enum CodingKeys: String, CodingKey {
        case ecrID = "EcrId"
        case data, cmdResult, response
        case requestID = "requestId"
    }

}

public struct DataRefundResponse: Codable {
    public let emv: [String: AnyValue]?
    public let terminalID: String?
    public let payment: UpsUpaCARefundModelResponsePayment?
    public let host: HpsUpaCARefundModelResponseHost?
    public let merchantID, multipleMessage: String?

    enum CodingKeys: String, CodingKey {
        case emv
        case terminalID = "terminalId"
        case payment, host
        case merchantID = "merchantId"
        case multipleMessage
    }
}

// MARK: - UpsUpaCARefundModelResponsePayment
public struct UpsUpaCARefundModelResponsePayment: Codable {
    let cardType, signatureLine, storeAndForward, appName: String?
    let cardGroup, expiryDate, cardAcquisition, fallback: String?
    let maskedPan, pinVerified, transactionType: String?

    enum CodingKeys: String, CodingKey {
        case cardType, signatureLine, storeAndForward, appName, cardGroup, expiryDate, cardAcquisition, fallback, maskedPan
        case pinVerified = "PinVerified"
        case transactionType
    }
}

// MARK: - HpsUpaCARefundModelResponseHost
public struct HpsUpaCARefundModelResponseHost: Codable {
    let responseID: Int?
    let cardBrandTransID, totalAmount, responseText, tranNo: String?
    let referenceNumber: Int?
    let approvalCode, authorizedAmount, responseCode, respDateTime: String?
    let gatewayResponseMessage, gatewayResponseCode: String?

    enum CodingKeys: String, CodingKey {
        case responseID = "responseId"
        case cardBrandTransID = "cardBrandTransId"
        case totalAmount, responseText, tranNo, referenceNumber, approvalCode, authorizedAmount, responseCode, respDateTime, gatewayResponseMessage, gatewayResponseCode
    }
}
