//
//  HpsUpaResponsePayload.swift
//  Heartland-iOS-SDK
//

import Foundation

// MARK: - HpsUpaResponsePayload

public struct HpsUpaResponsePayload<T: Codable>: Codable {
    public let response, ecrId, requestId: String?
    public let cmdResult: HpsUpaResponsePayloadCmdResult?
    public let data: T?

    enum CodingKeys: String, CodingKey {
        case response
        case ecrId = "EcrId"
        case requestId, cmdResult, data
    }

    public init(response: String?, ecrId: String?, requestId: String?, cmdResult: HpsUpaResponsePayloadCmdResult?, data: T?) {
        self.response = response
        self.ecrId = ecrId
        self.requestId = requestId
        self.cmdResult = cmdResult
        self.data = data
    }
}

// MARK: - HpsUpaResponsePayloadNoData

public struct HpsUpaResponsePayloadNoData: Codable {
    public let response, ecrId, requestId: String?
    public let cmdResult: HpsUpaResponsePayloadCmdResult?

    enum CodingKeys: String, CodingKey {
        case response
        case ecrId = "EcrId"
        case requestId, cmdResult
    }

    public init(response: String?, ecrId: String?, requestId: String?, cmdResult: HpsUpaResponsePayloadCmdResult?) {
        self.response = response
        self.ecrId = ecrId
        self.requestId = requestId
        self.cmdResult = cmdResult
    }
}

// MARK: - HpsUpaResponsePayloadCmdResult

public struct HpsUpaResponsePayloadCmdResult: Codable {
    public let result, errorCode, errorMessage: String?

    public init(result: String?, errorCode: String?, errorMessage: String?) {
        self.result = result
        self.errorCode = errorCode
        self.errorMessage = errorMessage
    }
}
