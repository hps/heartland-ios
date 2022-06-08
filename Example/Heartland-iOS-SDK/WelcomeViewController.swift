//
//  HpsWelcomeViewController.swift
//  Heartland-iOS-SDK_Example
//
//  Created by Chibwe, Martin on 5/27/22.
//  Copyright © 2022 Shaunti Fondrisi. All rights reserved.
//

import UIKit
import GlobalMobileSDK


class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let config = UserDefaults.currentGatewayConfig {
            switch config {
            case var portico as PorticoConfig:
                portico.timeout = 60
                try! GMSManager.shared.configure(gatewayConfig: portico)

            case let propay as PropayConfig:
                try! GMSManager.shared.configure(gatewayConfig: propay)

            default:
                fatalError("Unhandled gateway config")
            }
        }
    }
    
    @IBAction func PorticoButtonTapped(_ sender: Any) {

        guard let gateway = GatewayType(rawValue: "Portico") else {return}
        ScreenSequence.startConfiguration(for: gateway)
        
        
    }
    @IBAction func changeTerminalTapped(_ sender: Any) {
        ScreenSequence.changeTerminal()
    }
    @IBAction func startTransactionButtonTapped(_ sender: Any) {
        ScreenSequence.startTransaction()
    }
}
