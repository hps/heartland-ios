//
//
//  TapToPay.swift
//  Heartland-iOS-SDK
//
    

import Foundation
import SwiftUI

public class TapToPay {
    public init() { }
    
    public func tapToPayViewController() -> UIViewController {
        UIHostingController(rootView: TapToPayView(model: TapToPayViewModel()))
    }
}
