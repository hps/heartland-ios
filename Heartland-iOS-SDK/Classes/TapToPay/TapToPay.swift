//
//
//  TapToPay.swift
//  Heartland-iOS-SDK
//
    

import Foundation
import SwiftUI

@available(iOS 16.0, *)
public class TapToPay {
    public init() { }
    
    public func tapToPayViewController() -> UIViewController {
        UIHostingController(rootView: TapToPayView(model: TapToPayViewModel()))
    }
}
