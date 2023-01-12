//
//  HpsUpaLineItemDisplay.swift
//  Heartland-iOS-SDK
//

import Foundation

public struct HpsUpaLineItemDisplay: Codable {
    public var message: String = "MSG"
    public let data: HpsUpaLineItemDisplayData?
}

public struct HpsUpaLineItemDisplayData: Codable {
    public var command = "LineItemDisplay"
    public let EcrId, requestId: String?
    public let data: HpsUpaLineItemData?
}

public struct HpsUpaLineItemData: Codable {
    public let params: HpsUpaLineItemDisplayParams?

    public init(params: HpsUpaLineItemDisplayParams?) {
        self.params = params
    }
}

public struct HpsUpaLineItemDisplayParams: Codable {
    public let lineItemLeft, lineItemRight: String?

    public init(lineItemLeft: String?, lineItemRight: String?) {
        self.lineItemLeft = lineItemLeft
        self.lineItemRight = lineItemRight
    }
}
