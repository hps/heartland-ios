//
//  GatewayConfigViewControler.swift
//  Heartland-iOS-SDK
//

import UIKit
import GlobalMobileSDK

class GatewayConfigViewController: BaseViewController {

    func configure(for gateway: GatewayType) {
        config = gateway.configType.init()
        navigationItem.title = "\(config.gatewayType) Gateway Config"
    }
    
    func configure(for config: GatewayConfig) {
        self.config = config
        navigationItem.title = "\(config.gatewayType) Gateway Config"
    }
    
    // MARK: Variables
    private(set) var config: GatewayConfig!
    private var scrollView: UIScrollView! {
        stackView.superview as? UIScrollView
    }
    private var custom: GatewayEnvironment?
    var gatewayEnvironment: GatewayEnvironment {
        switch environmentSegmentControl.selectedSegmentIndex {
        case 0: return .certification
        case 1:
            guard let custom = custom else {
                return .custom(url: URL(string: "https://127.0.0.1:8080")!)
            }
            return custom
        case 2: return .production
        default: fatalError("invalid gateway environment index \(environmentSegmentControl.selectedSegmentIndex)")
        }
    }
    
    internal var currentTextField: UITextField?
    @IBOutlet weak var environmentSegmentControl: UISegmentedControl! {
        didSet {
            guard let config = config else { return }
            switch config.environment {
            case .certification:
                environmentSegmentControl.selectedSegmentIndex = 0
            case .custom(_):
                custom = config.environment
                environmentSegmentControl.selectedSegmentIndex = 1
            case .production:
                environmentSegmentControl.selectedSegmentIndex = 2
            @unknown default:
                environmentSegmentControl.selectedSegmentIndex = 0 // Set to Certification
            }
        }
    }
    
    @IBOutlet weak var safSupportedSwitch: UISwitch! {
        didSet {
            guard let config = config else { return }
            safSupportedSwitch.isOn = config.supportSaf
        }
    }
    
    @IBOutlet private(set) weak var stackView: UIStackView! {
        didSet {
            guard var config = config else { return }
            config.fill()
            stackView.addTextFields(for: config, withLabels: true, delegate: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardChanged(_:)),
            name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }

    /// add/remove extra padding to scrollView.contentSize so everything can be viewed
    @objc func keyboardChanged(_ notification: Notification) {

        guard let frameInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey],
              let keyboardFrame = (frameInfo as? NSValue)?.cgRectValue else { return }

        UIView.animate(withDuration: 0.3) {
            if keyboardFrame.minY > self.scrollView.frame.maxY {
                self.scrollView.contentSize.height = self.stackView.frame.height
            }
            else
            {
                let offset = self.scrollView.frame.maxY - keyboardFrame.minY

                if offset > 0 {
                    self.scrollView.contentSize.height = self.stackView.frame.height + offset
                    if let textField = self.currentTextField { self.textFieldDidBeginEditing(textField) }
                }
            }
        }
    }

    // MARK: IBActions
    override func showNextScreen() {
        do {
            try config.assign(values: stackView.textFieldValues)
        } catch {
            showError(message: error.localizedDescription)
            return
        }
        
        config.environment = gatewayEnvironment
        
        UserDefaults.currentGatewayConfig = config
        ScreenSequence.showNextScreen(with: config)
    }
    
    @IBAction func actionSafSupportSwitch(_ sender: UISwitch) {
        config.supportSaf = sender.isOn
    }
    
    @IBAction func environmentSegmentControl(_ sender: UISegmentedControl) {
        switch gatewayEnvironment {
        case .custom(_):
            let alert = UIAlertController.init(title: "url", message: "Enter URL", preferredStyle: .alert)
            let tag = 37
            alert.addTextField { textField in
                textField.placeholder = "https://127.0.0.1"
                textField.tag = tag
            }
            alert.addAction(UIAlertAction.init(title: "done", style: .default, handler: { _ in
                let text = (alert.view.viewWithTag(tag) as! UITextField).text
                alert.dismiss(animated: true) {
                    guard let urlText = text, let url = URL(string:urlText) else {
                        self.environmentSegmentControl.selectedSegmentIndex = 0
                        self.showError(message: "bad url \(text ?? "")")
                        self.custom = nil
                        return
                    }
                    self.custom = .custom(url: url)
                }
            }))
            present(alert, animated: true, completion: nil)
        default:
            custom = nil
            return
        }
    }
}

extension GatewayConfigViewController: StackViewTextFieldDelegate {

    func stopEditing() { currentTextField?.resignFirstResponder() }
    func advanceToNextTextField() { currentTextField?.advanceToNextTextField() }
    func advanceToPrevTextField() { currentTextField?.advanceToPrevTextField() }

    // ensure textField is visible above virtual keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {

        textField.didBeginEditing()

        var contentOffset = scrollView.contentOffset
        let frame = scrollView.convert(textField.frame,
                                       from: textField.superview)
        let topOffset = frame.minY - scrollView.contentOffset.y
        let bottomOffset = frame.maxY -
            (scrollView.contentOffset.y + scrollView.frame.height -
                (scrollView.contentSize.height - stackView.frame.height))

        if topOffset < 0 { contentOffset.y += topOffset }
        else if bottomOffset > 0 { contentOffset.y += bottomOffset }
        else { return }

        scrollView.setContentOffset(contentOffset, animated: true)
    }

    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.returnKeyType {
        case .done: stopEditing()
        default: advanceToNextTextField()
        }
        return false
    }
}

private extension Fillables {
    
    var description: String? {
        switch self {
        case .signatureAgreement: return LocalizableHelper.sharedInstance.localizableStringFor("signature_agreement")
        case .acknowledgement: return LocalizableHelper.sharedInstance.localizableStringFor("acknowledgement")
        case .refundPolicy: return LocalizableHelper.sharedInstance.localizableStringFor("refund_policy")
        }
    }
    
    var keyPath: AnyKeyPath? {
        switch  self {
        case .signatureAgreement: return \PorticoConfig.signatureAgreement
        case .acknowledgement: return \PorticoConfig.acknowledgement
        case .refundPolicy: return \PorticoConfig.refundPolicy
        }
    }
}

private extension GatewayConfig {
    
    mutating func fill() {
        Mirror(reflecting: self).children.forEach {
            if let label = $0.label,
               let value = Fillables(rawValue: label)?.description {
                set(value, for: label)
            }
        }
    }
    
    mutating func set<T>(_ value: T, for key: String) {
        let rawKeyPath = Fillables(rawValue: key)?.keyPath
        
        if let kp = rawKeyPath as? WritableKeyPath<Self, T> {
            self[keyPath: kp] = value
        }
        else if let kp = rawKeyPath as? WritableKeyPath<Self, T?> {
            self[keyPath: kp] = value
        }
    }
}
