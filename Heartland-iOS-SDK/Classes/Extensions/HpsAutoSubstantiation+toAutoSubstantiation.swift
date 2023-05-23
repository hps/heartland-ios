//
//  HpsAutoSubstantiation+toAutoSubstantiation.swift
//  Heartland-iOS-SDK
//

import Foundation
import GlobalMobileSDK

extension HpsAutoSubstantiation {
    public func toAutoSubstantiation() -> GlobalMobileSDK.AutoSubstantiation {
        var gAutoSubstantiation = GlobalMobileSDK.AutoSubstantiation()
        gAutoSubstantiation.realTimeSubstantiation = self.realTimeSubstantiation as? Bool
        gAutoSubstantiation.merchantVerificationValue = self.merchantVerificationValue as String?
        if let amounts = self.amounts as? [String:String] {
            gAutoSubstantiation.amounts = amounts
        }
        return gAutoSubstantiation
    }
}
