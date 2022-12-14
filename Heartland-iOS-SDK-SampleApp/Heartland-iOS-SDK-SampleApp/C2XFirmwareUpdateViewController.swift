//
//  C2XFirmwareUpdateViewController.swift
//  Heartland-iOS-SDK-SampleApp
//
//  Created by Renato Santos on 13/12/2022.
//

import Foundation
import UIKit
import Heartland_iOS_SDK
import GlobalMobileSDK

class C2XFirmwareUpdateViewController: UIViewController {
    
    var device: HpsC2xDevice? {
        didSet {
            self.device?.otaFirmwareUpdateDelegate = self
        }
    }
    
    var currentFirmwareVerion: String = "" {
        didSet {
            self.device?.getAllVersionsForC2X()
        }
    }
    
    var lastFirmwareVersion: String = "" {
        didSet {
            self.compareVersions()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var checkForUpdatesFirmwareButton: UIButton!
    @IBOutlet weak var updateFirmwareButton: UIButton!
    @IBOutlet weak var DialogView: UIView!
    @IBOutlet weak var dialogText: UILabel!
    @IBOutlet weak var dialogSpinner: UIActivityIndicatorView!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableUpdateFirmwareButton()
    }
    
    // MARK: - Actions
    
    @IBAction func checkForUpdatesButtonAction(_ sender: Any) {
//        self.device?.requestUpdateVersionForC2X()
//        self.device?.getAllVersionsForC2X() - lIST OF VERSIONS. NEED TO SORT BY HIGHER AND CHECK IF WE ALREADY HAVE THAT VERSION.
        showDialogView()
        self.showTextDialog("Please wait...")
        self.device?.requestTerminalVersionData()
    }
    
    @IBAction func updateFirmwareButtonAction(_ sender: Any) {
        showDialogView()
//        self.device?.requestUpdateVersionForC2X()
        self.device?.setVersionDataFor(versionString: lastFirmwareVersion)
    }
    
    func compareVersions() {
        disableUpdateFirmwareButton()
        let versionCompare = currentFirmwareVerion.compare(lastFirmwareVersion, options: .numeric)
        if versionCompare == .orderedAscending {
            showNewVersionMessageUser()
            enableUpdateFirmwareButton()
        } else {
            self.hideDialogView()
            showLastVersionInstalledAlready()
        }
    }
    
    func enableUpdateFirmwareButton() {
        self.hideDialogView()
        self.updateFirmwareButton.isEnabled = true
    }
    
    func disableUpdateFirmwareButton() {
        self.updateFirmwareButton.isEnabled = false
    }
}

extension C2XFirmwareUpdateViewController: GMSDeviceFirmwareUpdateDelegate {
    func onTerminalVersionDetails(info: [AnyHashable : Any]?) {
        if let info = info, let firmwareVersion = info["firmwareVersion"],
            let stringFirmwareVersion = firmwareVersion as? String {
            print("Info: \(stringFirmwareVersion)")
            self.currentFirmwareVerion = stringFirmwareVersion
        }
    }
    
    func terminalOTAResult(resultType: TerminalOTAResult,
                           info: [String : AnyObject]?,
                           error: Error?) {
        print("Result Type: \(resultType)")
        if let error = error {
            hideDialogView()
            print("error: \(error.localizedDescription)")
        }
        
        self.device?.setVersionDataFor(versionString: lastFirmwareVersion)
        print("terminalOTAResult: \(info)")
    }
    
    func listOfVersionsFor(results: [Any]?) {
        if let results = results,
           let lastVersion = results.reversed().first as? [String : AnyObject],
           let firmwareVersion = lastVersion.first?.value {
            self.lastFirmwareVersion = firmwareVersion as? String ?? ""
            print(firmwareVersion)
        } else {
            hideDialogView()
        }
    }
    
    func otaUpdateProgress(percentage: Float) {
        let str = String(format: "%.f%", percentage)
        self.showTextDialog("Progress: \(str)%")
    }
    
    func onReturnSetTargetVersion(message: String) {
        print("onReturnSetTargetVersion: \(message)")
    }
    
}

// MARK: - Dialog
extension C2XFirmwareUpdateViewController {
    func showTextDialog(_ message: String) {
        DispatchQueue.main.async {
            self.dialogText.text = message
        }
    }
    
    func showDialogView() {
        self.DialogView.isHidden = false
        self.dialogSpinner.startAnimating()
    }
    
    func hideDialogView() {
        self.DialogView.isHidden = true
        self.dialogSpinner.stopAnimating()
    }
    
    func showNewVersionMessageUser() {
        let message = "Your device firmware version is: \(currentFirmwareVerion).\nWe have a new firmware version availabe: \(lastFirmwareVersion).\nHit 'Update Firmware' to start the process."
        
        let alert = UIAlertController(title: "New Version Available",
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showLastVersionInstalledAlready() {
        let message = "You're already have the last version: \(lastFirmwareVersion)."
        
        let alert = UIAlertController(title: "You're updated!",
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
