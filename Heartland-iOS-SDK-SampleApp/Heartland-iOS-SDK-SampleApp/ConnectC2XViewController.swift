//
//  ConnectC2XViewController.swift
//

import CoreBluetooth
import Foundation
import Heartland_iOS_SDK
import UIKit

class ConnectC2XViewController: UIViewController {
    var device: HpsC2xDevice?
    var paxDevice: HpsPaxDevice?
    private let notificationCenter: NotificationCenter = .default
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    // MARK: - C2X TextFields
    @IBOutlet fileprivate weak var username: UITextField!
    @IBOutlet fileprivate weak var password: UITextField!
    @IBOutlet fileprivate weak var siteID: UITextField!
    @IBOutlet fileprivate weak var deviceID: UITextField!
    @IBOutlet fileprivate weak var licenseID: UITextField!
    @IBOutlet fileprivate weak var developerID: UITextField!
    @IBOutlet fileprivate weak var versionNumber: UITextField!
    
    @IBOutlet var connectionLabel: UILabel!
    @IBOutlet weak var scanButtonStackView: UIStackView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scanButtonReference: UIButton!
    
    private var textFieldTogglePassword: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI() {
        for tf in [username, password, siteID, deviceID,
                   licenseID, developerID, versionNumber] {
            tf?.delegate = self
        }
        
        // Setup password textField toggle
        if #available(iOS 13.0, *) {
            let imageIcon = UIImageView()
            let imageResource = UIImage(systemName: "eye")
            imageIcon.image = imageResource
            imageIcon.tag = 1111
            let contentView = UIView()
            contentView.addSubview(imageIcon)
            contentView.frame = CGRect.init(
                x: 0,
                y: 0,
                width: imageResource!.size.width,
                height: imageResource!.size.height
            )
            imageIcon.frame = CGRect.init(
                x: -10,
                y: 0,
                width: imageResource!.size.width,
                height: imageResource!.size.height
            )
            
            password.rightView = contentView
            password.rightViewMode = .always
            
            imageIcon.isUserInteractionEnabled = true
            imageIcon.addGestureRecognizer(UITapGestureRecognizer.init(
                target: self,
                action: #selector(toggleShowPasswordTextField(gesture:))
            ))
        }
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(hideKeyboard)))
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)),
                                       name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)),
                                       name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(hideKeyboard)))
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)),
                                       name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)),
                                       name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        if #available(iOS 13.0, *) {
            notificationCenter.addObserver(self, selector: #selector(appMovingToBackground),
                                           name: UIApplication.didEnterBackgroundNotification, object: nil)
        }
    }
    
    @available(iOS 13.0, *)
    @objc func toggleShowPasswordTextField(gesture: UITapGestureRecognizer) {
        guard let toggleIcon = gesture.view as? UIImageView else { return }
        
        if textFieldTogglePassword {
            toggleIcon.image = UIImage(systemName: "eye")
            password.isSecureTextEntry = true
        } else {
            toggleIcon.image = UIImage(systemName: "eye.slash")
            password.isSecureTextEntry = false
        }
        
        textFieldTogglePassword.toggle()
    }
    
    @available(iOS 13.0, *)
    @objc func appMovingToBackground() {
        guard let contentView = self.password.rightView,
              let toggleIcon = contentView.viewWithTag(1111) as? UIImageView else { return }
        
        toggleIcon.image = UIImage(systemName: "eye")
        password.isSecureTextEntry = true
        textFieldTogglePassword = false
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            self.scrollView.contentInset = .zero
        } else {
            self.scrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    @IBAction func scanButtonPressed() {
        if self.validateC2XFields() {
            scanButtonReference.isEnabled = false
            let timeout = 120

            let config = HpsConnectionConfig()
            config.username = self.username.text ?? ""
            config.password = self.password.text ?? ""
            config.siteID = self.siteID.text ?? ""
            config.deviceID = self.deviceID.text ?? ""
            config.licenseID = self.licenseID.text ?? ""
            config.developerID = self.developerID.text ?? ""
            config.versionNumber = self.versionNumber.text ?? ""
            
            config.timeout = timeout

            device = HpsC2xDevice(config: config)
            device?.deviceDelegate = self
            device?.scan()
            print(" Is Device Connected?: \(device?.isConnected())")
            activityIndicator.isHidden = false
        }
    }
    
    private func validateC2XFields() -> Bool {
        var requiredFields: String = ""
        
        if let text = self.username?.text, text.isEmpty { requiredFields += "Username\n" }
        if let text = self.password.text, text.isEmpty { requiredFields += "Password\n" }
        if let text = self.siteID.text, text.isEmpty { requiredFields += "siteID\n" }
        if let text = self.deviceID.text, text.isEmpty { requiredFields += "deviceID\n" }
        if let text = self.licenseID.text, text.isEmpty { requiredFields += "licenseID\n" }
        if let text = self.developerID.text, text.isEmpty { requiredFields += "developerID\n" }
        if let text = self.versionNumber.text, text.isEmpty { requiredFields += "versionNumber\n" }
        
        if requiredFields.isEmpty {
            return true
        } else {
            self.showAlert(message: "Required Fields: \n\n \(requiredFields)")
            
            return false
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction.init(title: "OK", style: .default))
        
        self.present(alert, animated: true)
    }
    
}

extension ConnectC2XViewController: HpsC2xDeviceDelegate {
    func onConnected() {
        connectionLabel.text = "Connected"
        scanButtonReference.isEnabled = true
        
        let selectedDevice: [String: HpsC2xDevice?] = ["selectedDevice": device]
        notificationCenter.post(name: Notification.Name(Constants.selectedDeviceNotification),
                                object: nil, userInfo: selectedDevice)
        
        print(" Is Device Connected?: \(device?.isConnected())")
    }
    
    func onDisconnected() {
        connectionLabel.text = "Disconnected"
        scanButtonReference.isEnabled = true
    }
    
    func onError(_: NSError) {
        connectionLabel.text = "Error"
        scanButtonReference.isEnabled = true
    }
    
    func onBluetoothDeviceList(_ peripherals: NSMutableArray) {
        let alertController = UIAlertController(title: "Devices", message: "Please select a device to connect", preferredStyle: .actionSheet)
        
        for peripheral in peripherals {
            if let peripheral = peripheral as? HpsTerminalInfo {
                let action = UIAlertAction(title: peripheral.name, style: .default) { [weak self] _ in
                    self?.device?.connectDevice(peripheral)
                }
                alertController.addAction(action)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { [weak self] _ in
            self?.scanButtonReference.isEnabled = true
        }
        alertController.addAction(cancelAction)
        if case .pad = UIDevice.current.userInterfaceIdiom {
            alertController.popoverPresentationController?.sourceView = scanButtonStackView
            alertController.popoverPresentationController?.sourceRect = scanButtonStackView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = .down
        }
        present(alertController, animated: true)
        
        activityIndicator.isHidden = true
    }
}

// MARK: - IDIOM

private extension ConnectC2XViewController {
    enum UIUserInterfaceIdiom: Int {
        case phone // iPhone and iPod touch style UI
        case pad // iPad style UI (also includes macOS Catalyst)
    }
}

extension ConnectC2XViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case username:
            password.becomeFirstResponder()
        case password:
            siteID.becomeFirstResponder()
        case siteID:
            deviceID.becomeFirstResponder()
        case deviceID:
            licenseID.becomeFirstResponder()
        case licenseID:
            developerID.becomeFirstResponder()
        case developerID:
            versionNumber.becomeFirstResponder()
        case versionNumber:
            hideKeyboard()
        default:
            hideKeyboard()
        }
        
        return true
    }
}
