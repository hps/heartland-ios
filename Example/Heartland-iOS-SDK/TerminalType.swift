//
//  Terminal.swift
//  Heartland-iOS-SDK
//

import Foundation
import GlobalMobileSDK

extension TerminalType: Enableable {
    var isEnabled: Bool {
        guard let config = UserDefaults.currentGatewayConfig else {
            return false
        }
        return config.supportedTerminals.keys.contains(self)
    }
}
