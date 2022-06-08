//
//  TerminalSettingViewController.swift
//  Heartland-iOS-SDK
//
//  Created by Rishil Patel on 2/23/22.
//  Copyright © 2022 GlobalPayments. All rights reserved.
//

import UIKit
import GlobalMobileSDK

enum TerminalSettingActionType: UInt, CaseIterable {
    case read, update
    public var description: String {
        switch self {
        case .read:    return "Read"
        case .update:  return "Update"
        }
    }
}

class TerminalSettingsViewController: BaseViewController {
    // MARK: IBOutlets
    @IBOutlet private(set) weak var settingTypesSegment: UISegmentedControl!
    @IBOutlet private(set) weak var actionTypesSegment: UISegmentedControl!
    @IBOutlet private(set) weak var valueTextField: UITextField!
    @IBOutlet private(set) weak var actionTerminalSettinButton: UIButton!
    // MARK: Variables
    private var isTerminalConnected: Bool = false {
        didSet {
            actionTerminalSettinButton.isEnabled = isTerminalConnected
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTypesSegment.removeAllSegments()
        actionTypesSegment.removeAllSegments()
        actionTypesSegment.addTarget(self, action: #selector(actionSegmentedControlValueChanged(_:)), for: .valueChanged)
        
        TerminalSettingType.allCases.forEach {
            settingTypesSegment.insertSegment(withTitle: $0.description.capitalized, at: settingTypesSegment.numberOfSegments, animated: false)
        }
        settingTypesSegment.selectedSegmentIndex = 0
        
        TerminalSettingActionType.allCases.forEach {
            actionTypesSegment.insertSegment(withTitle: $0.description.capitalized, at: actionTypesSegment.numberOfSegments, animated: false)
        }
        actionTypesSegment.selectedSegmentIndex = 0
        
        isTerminalConnected = GMSManager.shared.terminalConnected
        if !isTerminalConnected {
            GMSManager.shared.connect(terminalInfo: UserDefaults.currentTerminalInfo!, delegate: self)
        }
        self.title = "Terminal Settings".uppercased()
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 0
        
        valueTextField.delegate = self
        valueTextField.isHidden = true
        actionTerminalSettinButton.setTitle("Read Settings", for: .normal)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func actionSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            valueTextField.isHidden = true
            actionTerminalSettinButton.isEnabled = true
            actionTerminalSettinButton.setTitle("Read Settings", for: .normal)
            actionTerminalSettinButton.isEnabled = !(valueTextField.text?.isEmpty ?? false)
        } else {
            valueTextField.isHidden = false
            actionTerminalSettinButton.setTitle("Update Settings", for: .normal)
        }
    }
    
    // MARK: IBActions
    @IBAction func actionTerminalSettingPressed(_ sender: UIButton) {
        let terminalSettingType: TerminalSettingType = TerminalSettingType(rawValue: UInt(settingTypesSegment.selectedSegmentIndex)) ?? .normalModeTimeout
        if actionTypesSegment.selectedSegmentIndex == 0 {
            GMSManager.shared.requestReadTerminalSetting(settingType: terminalSettingType, delegate: self)
        } else {
            let value: Int = NumberFormatter().number(from: valueTextField.text ?? "0")?.intValue ?? 0
            GMSManager.shared.requestUpdateTerminalSetting(settingType: terminalSettingType, value: value, delegate: self)
        }
    }
}

extension TerminalSettingsViewController: ConnectionDelegate {
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
        showError(message: "\(error)")
    }
}

extension TerminalSettingsViewController: TerminalSettingsUpdateDelegate {
    func onReturnReadSetting(settingType: TerminalSettingType, value: Int?, error: Error?) {
        if let result = value {
            let timeFormat: String
            switch settingType {
            case .normalModeTimeout:
                timeFormat = "Seconds"
            case .bluetoothDiscoveryTimeout:
                timeFormat = "Minutes"
            case .standByModeTimeout:
                timeFormat = "Hours"
            @unknown default:
                fatalError()
            }
            showAlert(title: settingType.description, message: "\(result) \(timeFormat).")
        } else {
            showError(message: error?.localizedDescription ?? "")
        }
    }
    
    func onReturnUpdateSetting(settingType: TerminalSettingType, result: TerminalSettingResult) {
        showAlert(title: settingType.description, message: "\(result)")
    }
}

extension TerminalSettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let manualInputText = textField.text, let range = Range(range, in: manualInputText) {
            let inputText = manualInputText.replacingCharacters(in: range, with: string)
            let minValue = 0 //min value
            let maxValue = 255 //max value
            
            if inputText.isEmpty {
                textField.text = "\(minValue)"
                return false
            } else if textField.text == "0" {
                textField.text = string
                return false
            }
            if let inputValue = Int(inputText), (inputValue >= minValue), (inputValue <= maxValue) {
                return true
            }
        }
        return false
    }
}
