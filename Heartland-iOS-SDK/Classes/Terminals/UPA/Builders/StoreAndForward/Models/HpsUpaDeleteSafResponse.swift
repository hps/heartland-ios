//
//  HpsUpaDeleteSafResponse.swift
//  Heartland-iOS-SDK
//
//  Created by P1966 on 2023-07-20.
//

import Foundation

public struct HpsUpaDeleteSafResponse: Codable {
    public let message: String?
    public let data: HpsUpaResponsePayload<HpsUpaSafRecord>?
    
    public init(message: String?, data: HpsUpaResponsePayload<HpsUpaSafRecord>?) {
        self.message = message
        self.data = data
    }
}
