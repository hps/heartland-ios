//
//  UIKitView.swift
//  Heartland-iOS-SDK
//

import Foundation
import UIKit
import SwiftUI

@available(iOS 13.0, *)
struct UIKitView: UIViewControllerRepresentable {
    typealias UIViewControllerType = PairingViewController

    func makeUIViewController(context: Context) -> PairingViewController {
        let sb = UIStoryboard(name: "RuaPairingStoryBoard", bundle: nil)
        let viewController = sb.instantiateViewController(identifier: "PairingViewController") as! PairingViewController
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: PairingViewController, context: Context) {
        
    }
}
