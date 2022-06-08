//
//  Heartland-iOS-SDKExtensions.swift
//  Heartland-iOS-SDK
//

import UIKit
import GlobalMobileSDK

@objc protocol StackViewTextFieldDelegate: UITextFieldDelegate {
    func stopEditing()
    func advanceToNextTextField()
    func advanceToPrevTextField()
    
    var stackView: UIStackView! { get }
    var currentTextField: UITextField? { get set }
}

enum Fillables: String {
    case signatureAgreement
    case acknowledgement
    case refundPolicy
}

protocol Showeable {
    func allowShow(_ label: String?) -> Bool
}

extension Showeable {
    func allowShow(_ label: String?) -> Bool {
        return true
    }
}

extension Showeable where Self: BaseViewController {
    func allowShow(_ label: String?) -> Bool {
        if self is GatewayConfigViewController {
            return true
        }
        if let label = label {
            return Fillables(rawValue: label) == nil
        }
        return true
    }
}

extension BaseViewController: Showeable {}

extension UITextField {
    
    func didBeginEditing() {
        if let toolbarItems = (inputAccessoryView as? UIToolbar)?.items {
            toolbarItems[0].isEnabled = (tag != 1)
            toolbarItems[1].isEnabled = (returnKeyType != .done)
        }
        (delegate as? StackViewTextFieldDelegate)?.currentTextField = self
    }
    
    func advanceToNextTextField() { advanceTextField(forward: true) }
    func advanceToPrevTextField() { advanceTextField(forward: false) }
    
    private func advanceTextField(forward: Bool) {
        (delegate as? StackViewTextFieldDelegate)?.stackView
            .viewWithTag(tag + (forward ? 1 : -1))?.becomeFirstResponder()
    }
}

var IdentifiableLabelWidthKey = "kIdentifiableLabelWidthKey"
var IdentifiableLastTextfieldKey = "kIdentifiableLastTextfieldKey"

extension UIStackView {
    
    var labelWidth: CGFloat {
        get { (objc_getAssociatedObject(self, &IdentifiableLabelWidthKey) as? CGFloat) ?? 0 }
        set { objc_setAssociatedObject(self, &IdentifiableLabelWidthKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    var lastTextField: UITextField? {
        get { objc_getAssociatedObject(self, &IdentifiableLastTextfieldKey) as? UITextField }
        set { objc_setAssociatedObject(self, &IdentifiableLastTextfieldKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    var textFieldValues: [String:String] {
        subviews.reduce([String:String]()) {
            
            let textField: UITextField?
            if let item = $1 as? UITextField { textField = item }
            else { textField = $1.subviews.last as? UITextField }
            
            guard let label = textField?.placeholder,
                let value = textField?.text else { return $0 }
            
            var result = $0
            result[label] = value
            
            return result
        }
    }
    
    func insertRow() -> UIStackView {
        let row = UIStackView()
        addArrangedSubview(row)
        
        row.spacing = 8
        row.axis = .horizontal
        row.alignment = .center
        row.distribution = .fill
        row.contentMode = .scaleToFill
        
        return row
    }
    
    /// add a UIButton to a UIStackView for each case.
    /// (not the most elegant, but it beats copy-pasting this code)
    func addButtons<T: CaseIterable>(for caseIterable: T.Type,
                                     target: Any, selector: Selector) {
        caseIterable.allCases.forEach {
            let button = UIButton()
            
            self.addArrangedSubview(button)
            
            if let enableable = $0 as? Enableable {
                button.isEnabled = enableable.isEnabled
            }

            button.setTitle("\($0)", for: .normal)
            button.showsTouchWhenHighlighted = true
            button.layer.cornerRadius = .cornerRadius
            button.backgroundColor = UIColor.systemGray
                .withAlphaComponent(button.isEnabled ? 1 : 0.5)
            
            button.addConstraints(NSLayoutConstraint
                .constraints(withVisualFormat: "V:[button(45)]",
                             metrics: nil, views: ["button": button]))
            self.addConstraints(NSLayoutConstraint
                .constraints(withVisualFormat: "H:|[button]|",
                             metrics: nil, views: ["button": button]))
            
            button.addTarget(target, action: selector, for: .touchUpInside)
        }
    }
    
    private func addLabels(_ labels: [Any]) {
        labels.forEach {
            if isSupported($0) {
                if case Optional<Any>.some(let value) = $0 {
                    let label = UILabel()
                    label.numberOfLines = 0
                    label.textAlignment = .center
                    label.text = "\(value)"
                    insertRow().addArrangedSubview(label)
                    addConstraints(NSLayoutConstraint.constraints(
                                    withVisualFormat: "V:|-(4)-[label]-(4)-|",
                                    metrics: nil, views: ["label": label]))
                }
            }
        }
    }
    
    private func addTextField(withLabel: Bool,
                      editable: Bool = true,
                      toolbar: UIView?,
                      propertyLabel: String?,
                      value: Any,
                      labelWidth: inout CGFloat,
                      lastTextField: inout UITextField?,
                      delegate: UITextFieldDelegate? = nil) {
        
        if !isSupported(value) { return }
        
        let textField = UITextField()
        
        // there doesn't seem to be any
        // better way to index the textFields
        // for manually advancing key focus
        textField.tag =
            (lastTextField?.tag ?? 0) + 1
        
        lastTextField = textField
        textField.delegate = delegate
        textField.isEnabled = editable
        textField.borderStyle = .roundedRect
        
        textField.placeholder = propertyLabel
        textField.inputAccessoryView = toolbar
        
        if case Optional<Any>.some(_) = value {
            switch value {
            case let string as String:
                textField.text = "\(string)"
            case let int as Int:
                textField.text = "\(int)"
            case let dec as Decimal:
                textField.text = NSDecimalNumber(decimal: dec).stringValue
            case let boolValue as Bool:
                textField.text = String(boolValue)
            case let cardDataSourceType as EntryMode:
                textField.text = cardDataSourceType.rawValue
            case let transactionType as TransactionType:
                textField.text = transactionType.rawValue

            case let token as TokenizedCardData:
                let encoder = JSONEncoder()
                let string = try? String(data: encoder.encode(token), encoding: .utf8)
                textField.text = string
            default:
                textField.text = nil
            }
        } else {
            textField.text = nil
        }
        
        textField.returnKeyType = .next
        textField.smartQuotesType = .no
        textField.spellCheckingType = .no
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = propertyLabel?
            .lowercased().contains("password") == true
        
        if value is Int || type(of:
            value) == Optional<Int>.self {
            
            textField.keyboardType = .numberPad
        }
        else if propertyLabel?
            .lowercased().contains("url") == true {
            textField.keyboardType = .URL
        }
        
        if withLabel {
            let row = insertRow()
            
            let label = UILabel()
            label.textAlignment = .right
            label.text = propertyLabel?.appending(":")
            
            row.addArrangedSubview(label)
            row.addArrangedSubview(textField)
            
            label.setContentHuggingPriority(.defaultHigh,
                                            for: .horizontal)
            labelWidth = max(labelWidth, label.intrinsicContentSize.width)
            
            addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[row]|",
                metrics: nil, views: ["row": row]))
        } else {
            addArrangedSubview(textField)
            addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[textField]|",
                metrics: nil, views: ["textField": textField]))
        }
        
        textField.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[textField(45)]",
            metrics: nil, views: ["textField": textField]))
    }
    
    private func arrangeLabelsAndTextfields(labelWidth: CGFloat) {
        subviews.forEach {
            guard let hStack = $0 as? UIStackView else { return }
            guard let label = hStack.subviews.first as? UILabel else { return }
            
            let visualFormat = String(format: "H:[label(%d)]",
                                      Int(ceil(labelWidth)))
            label.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: visualFormat,
                metrics: nil, views: ["label": label]))
        }
    }
    
    private func createToolbar(delegate: UITextFieldDelegate? = nil) -> UIView? {
        guard delegate is StackViewTextFieldDelegate else { return nil }
        
        let toolbar = UIToolbar()
        toolbar.items = [
            UIBarButtonItem(title: "Back", style: .plain, target: delegate,
                            action: #selector(StackViewTextFieldDelegate.advanceToPrevTextField)),
            UIBarButtonItem(title: "Next", style: .plain, target: delegate,
                            action: #selector(StackViewTextFieldDelegate.advanceToNextTextField)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: delegate,
                            action: #selector(StackViewTextFieldDelegate.stopEditing))
        ]
        toolbar.sizeToFit()
        return toolbar
    }
    
    private func isSupported(_ value: Any) -> Bool {
        switch type(of: value) {
        case is Int.Type, is Optional<Int>.Type: return true
        case is String.Type, is Optional<String>.Type: return true
        case is Decimal.Type, is Optional<Decimal>.Type: return true
        case is Bool.Type, is Optional<Bool>.Type: return true
        case is EntryMode.Type, is Optional<EntryMode>.Type: return true
        case is TransactionType.Type, is Optional<TransactionType>.Type: return true
        case is TokenizedCardData.Type, is Optional<TokenizedCardData>.Type: return true
        default: return false // unsupported type
        }
    }
    
    func addTextFields<T>(for template: T,
                          withLabels: Bool,
                          editable: Bool = true,
                          delegate: UITextFieldDelegate? = nil) {
        
        let toolbar = createToolbar(delegate: delegate)
        
        Mirror(reflecting: template).children.forEach {
            if let caller = delegate as? BaseViewController, caller.allowShow($0.label) {
                addTextField(withLabel: withLabels,
                             editable: editable,
                             toolbar: toolbar,
                             propertyLabel: $0.label,
                             value: $0.value,
                             labelWidth: &labelWidth,
                             lastTextField: &lastTextField,
                             delegate: delegate)
            }
        }
        
        lastTextField?.returnKeyType = .done
        
        if withLabels {
            arrangeLabelsAndTextfields(labelWidth: labelWidth)
        }
    }
}

extension GatewayConfig {
    var gatewayType: GatewayType {
        switch self {
        case is PropayConfig: return .ProPay
        case is PorticoConfig: return .Portico
        case is TransITConfig: return .TransIT
            
        default: fatalError()
        }
    }
}

extension UserDefaults {
    private static let gatewayConfigKey = "gatewayConfigKey"
    private static let terminalInfoKey = "terminalInfoKey"
    
    static var currentGateway: GatewayType? {
        return currentGatewayConfig?.gatewayType
    }
    
    static var currentGatewayConfig: GatewayConfig? {
        get {
            guard let data = UserDefaults.standard.data(forKey: UserDefaults.gatewayConfigKey) else {
                return nil
            }
            let jsonDecoder = JSONDecoder()
            if let portico = try? jsonDecoder.decode(PorticoConfig.self, from: data) {
                return portico
            }
            if let propay = try? jsonDecoder.decode(PropayConfig.self, from: data) {
                return propay
            }
            return nil
        }
        set {
            guard newValue != nil else {
                UserDefaults.standard.removeObject(forKey: UserDefaults.gatewayConfigKey)
                return
            }
            let jsonEncoder = JSONEncoder()
            switch newValue {
            case let portico as PorticoConfig:
                UserDefaults.standard.set(try? jsonEncoder.encode(portico), forKey: UserDefaults.gatewayConfigKey)
            case let propay as PropayConfig:
                UserDefaults.standard.set(try? jsonEncoder.encode(propay), forKey: UserDefaults.gatewayConfigKey)
            default:
                fatalError("config type needs to be handled")
            }
        }
    }
    
    static var currentTerminalInfo: TerminalInfo? {
        get { // TODO: deserialize from userDefault storage
            guard let data = UserDefaults.standard.data(forKey: UserDefaults.terminalInfoKey) else {
                return nil
            }
            let jsonDecoder = JSONDecoder()
            if let portico = try? jsonDecoder.decode(GMSTerminalInfo.self, from: data) {
                return portico
            }
            return nil
        }
        set { // TODO: serialize into userDefault storage
            guard let value = newValue else {
                UserDefaults.standard.removeObject(forKey: UserDefaults.terminalInfoKey)
                return
            }
            let jsonEncoder = JSONEncoder()
            UserDefaults.standard.set(try? jsonEncoder.encode(value as? GMSTerminalInfo), forKey: UserDefaults.terminalInfoKey)
        }
    }
}

extension UIViewController {
    func showError(message: String) {
        let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "ok", style: .default, handler: { _ in
            alert.dismiss(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension Date {
    var safFormatted: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }
}
