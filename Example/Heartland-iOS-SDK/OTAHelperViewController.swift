//
//  OTAHelperViewController.swift
//  Heartland-iOS-SDK
//
//  Created by Rishil Patel on 2/3/22.
//  Copyright © 2022 GlobalPayments. All rights reserved.
//

import UIKit
import GlobalMobileSDK

protocol SelectedVersionDelegate {
    func selectedVersion(versionString: String, type: TerminalOTAUpdateType)
}

enum ProgressType {
    case normal, percentage
}

class OTAHelperViewController: BaseViewController {
    // MARK: IBOutlets
    @IBOutlet private(set) weak var selectedVersionLabel: UILabel!
    @IBOutlet private(set) weak var getCurrentTargetButton: UIButton!
    @IBOutlet private(set) weak var getConfigVersionsButton: UIButton!
    @IBOutlet private(set) weak var getFirmwareVersionButton: UIButton!
    @IBOutlet private(set) weak var startOTAProcessButton: UIButton!
    @IBOutlet private(set) weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private(set) weak var percentageLabel: UILabel!
    @IBOutlet private(set) weak var loadingView: UIStackView! {
      didSet {
        loadingView.layer.cornerRadius = 10
      }
    }
    // MARK: Variables
    private var otaType: TerminalOTAUpdateType?
    private var isTerminalConnected: Bool = false {
        didSet {
            getCurrentTargetButton.isEnabled = isTerminalConnected
            getConfigVersionsButton.isEnabled = isTerminalConnected
            getFirmwareVersionButton.isEnabled = isTerminalConnected
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isTerminalConnected = GMSManager.shared.terminalConnected
        
        if !isTerminalConnected {
            GMSManager.shared.connect(terminalInfo: UserDefaults.currentTerminalInfo!, delegate: self)
        }
        
        hideSpinner()
        startOTAProcessButton.isEnabled = false
    }
    
    private func showSpinner(type: ProgressType) {
        loadingView.superview?.isHidden = false
        activityIndicator.startAnimating()
        loadingView.isHidden = false
        percentageLabel.isHidden = type != .percentage
    }

    private func hideSpinner() {
        loadingView.superview?.isHidden = true
        activityIndicator.stopAnimating()
        percentageLabel.isHidden = true
        loadingView.isHidden = true
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: IBActions
    @IBAction func getCurrentTargetPressed(_ sender: UIButton) {
        showSpinner(type: .normal)
        GMSManager.shared.requestTerminalVersionData(delegate: self)
    }
    
    @IBAction func getConfigVersionsPressed(_ sender: UIButton) {
       if let versionListViewController =
            UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "OTAVersionsListViewController") as? OTAVersionsListViewController {
        versionListViewController.otaType = .config
        versionListViewController.delegate = self
        navigationController?.pushViewController(versionListViewController, animated: true)
       }
    }
    
    @IBAction func getFirmwareVersionPressed(_ sender: UIButton) {
        if let versionListViewController =
             UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "OTAVersionsListViewController") as? OTAVersionsListViewController {
         versionListViewController.otaType = .firmware
         versionListViewController.delegate = self
         navigationController?.pushViewController(versionListViewController, animated: true)
        }
    }
    
    @IBAction func startOTAProcessPressed(_ sender: UIButton) {
        if let type = otaType {
            showSpinner(type: .normal)
            GMSManager.shared.requestToStartUpdateFor(type: type, delegate: self)
        }
    }
}

extension OTAHelperViewController: TerminalOTAManagerDelegate {
    func terminalVersionDetails(info: [AnyHashable : Any]?) {
        hideSpinner()
        
        showAlert(title: "Device Info", message: "Firmware Version:\((info?["firmwareVersion"] ?? "")) \n\n DeviceSettingVersion: \((info?["deviceSettingVersion"] ?? "")) \n\n TerminalSettingVersion: \((info?["terminalSettingVersion"] ?? ""))")
    }
    
    func terminalOTAResult(resultType: TerminalOTAResult, info: [String : AnyObject]?, error: Error?) {
        hideSpinner()
        if resultType != .success {
            showAlert(title: "Update Failed", message: "\(resultType)")
        }
    }
    
    func otaUpdateProgress(percentage: Float) {
        showSpinner(type: .percentage)
        percentageLabel.text = String(format: "Updating... %.2f%%", percentage)
    }
    
    func listOfVersionsFor(type: TerminalOTAUpdateType, results: [Any]?) {}
    
    func onReturnSetTargetVersion(resultType: TerminalOTAResult, type: TerminalOTAUpdateType, message: String) {}
}

extension OTAHelperViewController: SelectedVersionDelegate {
    func selectedVersion(versionString: String, type: TerminalOTAUpdateType) {
        if versionString.isEmpty {
            selectedVersionLabel.isHidden = true
            startOTAProcessButton.isEnabled = false
        } else {
            otaType = type
            selectedVersionLabel.isHidden = false
            selectedVersionLabel.text = "Selected Version: \(versionString)"
            startOTAProcessButton.isEnabled = true
        }
    }
}

extension OTAHelperViewController: ConnectionDelegate {
    func onConnected(terminalInfo: TerminalInfo) {
        UserDefaults.currentTerminalInfo = terminalInfo
        isTerminalConnected = true
    }
    
    func onDisconnected(terminalInfo: TerminalInfo) {
        UserDefaults.currentTerminalInfo = terminalInfo
        isTerminalConnected = false
    }
    
    func configuringTerminal(state: TransactionState) {}
    
    func onError(error: ConnectionError) {
        showAlert(title: "Connection Error", message: "\(error)")
    }
}
