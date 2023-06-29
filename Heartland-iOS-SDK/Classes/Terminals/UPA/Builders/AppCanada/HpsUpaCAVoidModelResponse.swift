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

    public init(message: String?, data: HpsUpaCAVoidModelResponseData?) {
        self.message = message
        self.data = data
    }
}

// MARK: - CMD Result
public struct CMDVoidResult: Codable {
    public let result: String?
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
    public let ecrID: String?
    public let data: DataVoidResponse?
    public let cmdResult: CMDVoidResult?
    public let response, requestID: String?

    enum CodingKeys: String, CodingKey {
        case ecrID = "EcrId"
        case data, cmdResult, response
        case requestID = "requestId"
    }

}

public struct DataVoidResponse: Codable {
    public let emv: [String: AnyValue]?
    public let terminalID: String?
    public let payment: UpsUpaCAVoidModelResponsePayment?
    public let host: HpsUpaCAVoidModelResponseHost?
    public let merchantID, multipleMessage: String?

    enum CodingKeys: String, CodingKey {
        case emv
        case terminalID = "terminalId"
        case payment, host
        case merchantID = "merchantId"
        case multipleMessage
    }
}

// MARK: - UpsUpaCAVoidModelResponsePayment
public struct UpsUpaCAVoidModelResponsePayment: Codable {
    let cardType, signatureLine, storeAndForward, appName: String?
    let cardGroup, expiryDate, cardAcquisition, fallback: String?
    let maskedPan, pinVerified, transactionType: String?

    enum CodingKeys: String, CodingKey {
        case cardType, signatureLine, storeAndForward, appName, cardGroup, expiryDate, cardAcquisition, fallback, maskedPan
        case pinVerified = "PinVerified"
        case transactionType
    }
}

// MARK: - HpsUpaCAVoidModelResponseHost
public struct HpsUpaCAVoidModelResponseHost: Codable {
    let responseID: Int?
    let avsResultCode, tipAmount, totalAmount, responseText: String?
    let tranNo, referenceNumber, avsResultText, baseAmount: String?
    let approvalCode, authorizedAmount, responseCode, gatewayResponseMessage: String?
    let respDateTime, gatewayResponseCode: String?

    enum CodingKeys: String, CodingKey {
        case responseID = "responseId"
        case avsResultCode = "AvsResultCode"
        case tipAmount, totalAmount, responseText, tranNo, referenceNumber
        case avsResultText = "AvsResultText"
        case baseAmount, approvalCode, authorizedAmount, responseCode, gatewayResponseMessage, respDateTime, gatewayResponseCode
    }
}
