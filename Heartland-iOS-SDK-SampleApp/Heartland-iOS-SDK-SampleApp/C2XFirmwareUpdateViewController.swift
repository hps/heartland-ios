//
//  C2XFirmwareUpdateViewController.swift
//  Heartland-iOS-SDK-SampleApp
//
//  Created by Renato Santos on 13/12/2022.
//

import Foundation
import Heartland_iOS_SDK
import UIKit

class C2XFirmwareUpdateViewController: UIViewController {
    weak var timeout: Timer?
    private var timoutCounter: Int = 60
    private var isSuccess = false

    var device: HpsC2xDevice? {
        didSet {
            device?.otaFirmwareUpdateDelegate = self
        }
    }

    var currentFirmwareVerion: String = "" {
        didSet {
            device?.getAllVersionsForC2X()
        }
    }

    var lastFirmwareVersion: String = "" {
        didSet {
            compareVersions()
        }
    }

    // MARK: - Outlets

    @IBOutlet var checkForUpdatesFirmwareButton: UIButton!
    @IBOutlet var updateFirmwareButton: UIButton!
    @IBOutlet var updateConfigButton: UIButton!
    @IBOutlet var remoteKeyInjectionButton: UIButton!
    @IBOutlet var DialogView: UIView!
    @IBOutlet var dialogText: UILabel!
    @IBOutlet var dialogSpinner: UIActivityIndicatorView!

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        disableUpdateFirmwareButton()
    }

    // MARK: - Actions

    @IBAction func checkForUpdatesButtonAction(_: Any) {
        if let device = device {
            disableCheckForUpdatesButton()
            showDialogView()
            setText(LoadingStatus.WAIT.rawValue)
            device.requestTerminalVersionData()
        } else {
            showTextDialog(LoadingStatus.DEVICE_NOT_CONNECTED_ALERT.rawValue)
        }
    }

    @IBAction func updateFirmwareButtonAction(_: Any) {
        if let device = device {
            showDialogView()
            device.setVersionDataFor(versionString: lastFirmwareVersion)
            device.requestUpdateVersionForC2X()
            resetTimer()
        } else {
            showTextDialog(LoadingStatus.DEVICE_NOT_CONNECTED_ALERT.rawValue)
        }
    }
    
    @IBAction func updateConfigButtonAction(_: Any) {
        if let device = device {
            showDialogView()
            device.requestUpdateConfigForDevice()
            resetTimer()
        } else {
            showTextDialog(LoadingStatus.DEVICE_NOT_CONNECTED_ALERT.rawValue)
        }
    }
    
    @IBAction func remoteKeyInjections(_: Any) {
        if let device = device {
            showDialogView()
            device.setRemoteKeyInjection()
            resetTimer()
        } else {
            showTextDialog(LoadingStatus.DEVICE_NOT_CONNECTED_ALERT.rawValue)
        }
    }

    func compareVersions() {
        enableUpdateFirmwareButton()
        let versionCompare = currentFirmwareVerion.compare(lastFirmwareVersion, options: .numeric)
        if versionCompare == .orderedAscending {
            showNewVersionMessageUser()
            enableUpdateFirmwareButton()
        } else {
            hideDialogView()
            showLastVersionInstalledAlready()
        }
        enableCheckForUpdatesButton()
    }

    func enableUpdateFirmwareButton() {
        hideDialogView()
        updateFirmwareButton.isEnabled = true
        updateConfigButton.isEnabled = true
    }

    func disableUpdateFirmwareButton() {
        updateFirmwareButton.isEnabled = false
        updateConfigButton.isEnabled = false
    }

    func enableCheckForUpdatesButton() {
        checkForUpdatesFirmwareButton.isEnabled = true
    }

    func disableCheckForUpdatesButton() {
        checkForUpdatesFirmwareButton.isEnabled = false
    }
}

// MARK: - Timer Counting

extension C2XFirmwareUpdateViewController {
    func resetTimer() {
        timeout?.invalidate()
        timeout = .scheduledTimer(timeInterval: TimeInterval(timoutCounter),
                                  target: self,
                                  selector: #selector(handleIdleEvent(_:)),
                                  userInfo: nil,
                                  repeats: false)
    }

    @objc func handleIdleEvent(_: Timer) {
        hideDialogView()
        showTextDialog(LoadingStatus.TAKING_TOO_MUCH_TO_RESPOND.rawValue)
    }
}

extension C2XFirmwareUpdateViewController: GMSDeviceFirmwareUpdateDelegate {
    func onTerminalVersionDetails(info: [AnyHashable: Any]?) {
        if let info = info, let firmwareVersion = info["firmwareVersion"],
           let stringFirmwareVersion = firmwareVersion as? String
        {
            print("Info: \(stringFirmwareVersion)")
            currentFirmwareVerion = stringFirmwareVersion
        }
    }

    func terminalOTAResult(resultType: TerminalOTAResult,
                           info _: [String: AnyObject]?,
                           error _: Error?)
    {
        if resultType == GlobalMobileSDK.TerminalOTAResult.success {
            isSuccess = true
            device?.setVersionDataFor(versionString: lastFirmwareVersion)
        }

        if resultType == GlobalMobileSDK.TerminalOTAResult.setupError {
            hideDialogView()
            showTextDialog(LoadingStatus.SOMETHING_WENT_WRONG.rawValue)
        }
    }

    func listOfVersionsFor(results: [Any]?) {
        if let results = results,
           let lastVersion = results.reversed().first as? [String: AnyObject],
           let firmwareVersion = lastVersion.first?.value
        {
            lastFirmwareVersion = firmwareVersion as? String ?? ""
            print(firmwareVersion)
        } else {
            hideDialogView()
        }
    }

    func otaUpdateProgress(percentage: Float) {
        let str = String(format: "%.f%", percentage)
        timoutCounter = percentage == 100 ? 180 : 60
        setText("\(LoadingStatus.WAIT.rawValue) \(LoadingStatus.PROGRESS.rawValue) \(str)%")
        resetTimer()
    }

    func onReturnSetTargetVersion(message _: String) {
        if isSuccess {
            timeout?.invalidate()
            hideDialogView()
            showTextDialog(LoadingStatus.SUCCESS_UPDATED.rawValue, true)
        }
    }
}

// MARK: - Dialog

extension C2XFirmwareUpdateViewController {
    func setText(_ text: String) {
        DispatchQueue.main.async {
            self.dialogText.text = text
            self.dialogSpinner.startAnimating()
        }
    }

    func showDialogView() {
        DialogView.isHidden = false
        dialogSpinner.startAnimating()
    }

    func hideDialogView() {
        DialogView.isHidden = true
        dialogSpinner.stopAnimating()
    }

    func showNewVersionMessageUser() {
        let message = String(format: LoadingStatus.MESSAGE_FIRMWARE_ALREADY_UPDATED.rawValue,
                             currentFirmwareVerion,
                             lastFirmwareVersion)

        let alert = UIAlertController(title: LoadingStatus.NEW_VERSION_AVAILABLE.rawValue,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: LoadingStatus.OK_BUTTON.rawValue,
                                      style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func showLastVersionInstalledAlready() {
        let message = String(format: LoadingStatus.YOU_ALREADY_HAVE_LAST_UPDATED_VERSION.rawValue,
                             lastFirmwareVersion)

        let alert = UIAlertController(title: LoadingStatus.YOU_ARE_UPDATED.rawValue,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: LoadingStatus.OK_BUTTON.rawValue,
                                      style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
