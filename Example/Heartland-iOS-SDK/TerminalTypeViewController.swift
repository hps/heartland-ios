//
//  TerminalTypeViewController.swift
//  Heartland-iOS-SDK
//

import UIKit
import os
import GlobalMobileSDK

class TerminalTypeViewController: BaseViewController {
    private var searchAlert: UIAlertController?
    
    private var config: GatewayConfig {
        guard let config = UserDefaults.currentGatewayConfig else {
            fatalError("a persisted gatewayconfig is required at this point")
        }
        return config
    }
    
    // MARK: IBOutlets
    @IBOutlet private(set) weak var buttonsStackView: UIStackView! {
        didSet {
            buttonsStackView.addButtons(for: TerminalType.self, target: self,
                                        selector: #selector(searchDevices(_:)))
        }
    }
    
    @objc func searchDevices(_ button: UIButton) {
        guard let terminalType = TerminalType(rawValue: button.titleLabel?.text ?? "error") else {
            fatalError("unexpected terminal type \(button)")
        }
        
        var update = config
        update.terminalType = terminalType
        UserDefaults.currentGatewayConfig = update
        switch update {
        case var portico as PorticoConfig:
            portico.timeout = 60
            try! GMSManager.shared.configure(gatewayConfig: portico)
        case let propay as PropayConfig:
            try! GMSManager.shared.configure(gatewayConfig: propay)
        default:
            fatalError("Unhandled gateway config")
        }
        
        guard terminalType != .none else {
            navigationController?.pushViewController(GatewayConfigInfoViewController.instantiate()!, animated: true)
            return
        }
        
        if presentedViewController != nil {
            dismiss(animated: false, completion: nil)
        }

        var alertTitle = "Search"

        if terminalType == .ingencio_g4x_g5x ||
            terminalType == .unimag {
            alertTitle = "Insert Cardreader with audio jack"
        }

        searchAlert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        searchAlert?.addAction(.init(title: "Cancel", style: .destructive, handler: { [unowned self] _ in
            GMSManager.shared.cancelSearch()
            self.searchAlert?.dismiss(animated: true, completion: nil)
        }))
        present(searchAlert!, animated: true) {
            GMSManager.shared.search(delegate: self)
        }
    }
}

extension TerminalTypeViewController: SearchDelegate {
    func deviceFound(terminalInfo: TerminalInfo) {
        searchAlert?.addAction(.init(title: terminalInfo.name, style: .default, handler: { [unowned self] _ in
            // Swipers with Audio Jack connection.
            let swipers:[TerminalType] = [.ingencio_g4x_g5x, .unimag]

            if !swipers.contains(terminalInfo.terminalType) {
                GMSManager.shared.cancelSearch()
            }
            
            UserDefaults.currentTerminalInfo = terminalInfo
            self.searchAlert?.dismiss(animated: true, completion: nil)
            self.navigationController?.pushViewController(GatewayConfigInfoViewController.instantiate()!, animated: true)
        }))
    }
    
    func onSearchComplete() {
        if #available(iOS 12.0, *) {
            os_log(.debug, "search complete", [])
        } else {
            print("search complete")
        }
    }
    
    func onError(error: SearchError) {
        fatalError("Not implemented yet")
    }
}
