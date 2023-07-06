//
//  HpsUpaLineItemDisplay.swift
//  Heartland-iOS-SDK
//

import Foundation

public struct HpsUpaLineItemDisplay: Codable {
    public var message: String
    public let data: HpsUpaLineItemDisplayData?

    public init(message: String = "MSG", data: HpsUpaLineItemDisplayData?) {
        self.message = message
        self.data = data
    }
}

public struct HpsUpaLineItemDisplayData: Codable {
    public var command: String
    public let EcrId, requestId: String?
    public let data: HpsUpaLineItemData?

    public init(command: String = "LineItemDisplay", EcrId: String?,
                requestId: String?, data: HpsUpaLineItemData?) {
        self.command = command
        self.EcrId = EcrId
        self.requestId = requestId
        self.data = data
    }
}

public struct HpsUpaLineItemData: Codable {
    public let params: HpsUpaLineItemDisplayParams?
    public let transaction: HpsUpaTipAdjustTransaction?

    public init(params: HpsUpaLineItemDisplayParams?, transaction: HpsUpaTipAdjustTransaction? = nil) {
        self.params = params
        self.transaction = transaction
    }
}

public struct HpsUpaLineItemDisplayParams: Codable {
    public let lineItemLeft, lineItemRight: String?

    public init(lineItemLeft: String?, lineItemRight: String?) {
        self.lineItemLeft = lineItemLeft
        self.lineItemRight = lineItemRight
    }
}
