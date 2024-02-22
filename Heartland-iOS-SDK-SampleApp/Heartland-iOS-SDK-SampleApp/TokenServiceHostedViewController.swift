//
//
//  TokenServiceHostedViewController.swift
//  Heartland-iOS-SDK-SampleApp
//
    

import Foundation
import UIKit
import Heartland_iOS_SDK

private enum TokenServiceHostedViewControllerErrors: Error {
    case unableToCreateVc
}

class TokenServiceHostedViewController: UIViewController {
    var vc: UIViewController?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let tokenService = HpsTokenServiceWeb()
        do {
            if let vc = try tokenService.tokenServiceWebView(completion: { response in
                self.vc?.dismiss(animated: true)
                
                let alert = UIAlertController(title: "Response", message: "\(String(describing: response))", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true)
            }) {
                self.vc = vc
                self.present(vc, animated: true)
            } else {
                throw TokenServiceHostedViewControllerErrors.unableToCreateVc
            }
        } catch {
            let alert = UIAlertController(title: "Error", message: "Unable to show web view", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true)
        }
    }
}
