//
//  HpsUpaCommandPayload.swift
//  Heartland-iOS-SDK
//

import Foundation

// MARK: - HpsUpaCommandPayload

public struct HpsUpaCommandPayload<T: Codable>: Codable {
    public let command, requestId, ecrId: String?
    public let data: T?

    enum CodingKeys: String, CodingKey {
        case command, requestId
        case ecrId = "EcrId"
        case data
    }

    public init(command: String?, requestId: String?, ecrId: String?, data: T?) {
        self.command = command
        self.requestId = requestId
        self.ecrId = ecrId
        self.data = data
    }
}

// MARK: - HpsUpaCommandPayloadNoData

public struct HpsUpaCommandPayloadNoData: Codable {
    public let command, requestId, ecrId: String?

    enum CodingKeys: String, CodingKey {
        case command, requestId
        case ecrId = "EcrId"
    }

    public init(command: String?, requestId: String?, ecrId: String?) {
        self.command = command
        self.requestId = requestId
        self.ecrId = ecrId
    }
}
