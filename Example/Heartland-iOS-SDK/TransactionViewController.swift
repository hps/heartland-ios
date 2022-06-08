//
//  SaleViewController.swift
//  Heartland-iOS-SDK
//
//  Created by Todd Lahtinen on 8/11/20.
//  Copyright (c) 2020 GlobalPayments. All rights reserved.
//

import UIKit
import GlobalMobileSDK

class TransactionViewController: BaseTransactionViewController {
    
    var manualCardData: ManualCardData?
    var transactionType: TransactionType?
    var quickChipEnabled = true
    var alert: UIAlertController? = nil
    var entryModes: [EntryMode] {
        var modes = EntryMode.allCases
        if !quickChipEnabled {
            modes.removeAll { mode -> Bool in
                mode == .quickChip
            }
        }
        return modes
    }
    // MARK: fields
    @IBOutlet weak var tokenizeTransaction: UISwitch!
    @IBOutlet weak var clientTransactionIDTextField: UITextField!
    @IBOutlet weak var gatewayTransactionIDTextField: UITextField!
    @IBOutlet weak var operationUserIDTextField: UITextField!
    @IBOutlet weak var totalTextField: UITextField!
    @IBOutlet weak var tipTextField: UITextField!
    @IBOutlet weak var surchargeTextField: UITextField!
    @IBOutlet weak var taxAmountTextField: UITextField!
    @IBOutlet weak var posReferenceNumberTextField: UITextField!
    @IBOutlet weak var invoiceNumberTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var progressMessageLabel: UILabel!
    @IBOutlet weak var progressMessageContainer: UIVisualEffectView!
    @IBOutlet var dismissToolbar: UIToolbar!
    
    @IBOutlet var fieldStackViews: [UIStackView]!
    @IBOutlet var saleFieldStackViews: [UIStackView]!
    @IBOutlet var authFieldStackViews: [UIStackView]!
    @IBOutlet var captureFieldStackViews: [UIStackView]!
    @IBOutlet var voidFieldStackViews: [UIStackView]!
    @IBOutlet var returnFieldStackViews: [UIStackView]!
    @IBOutlet var batchCloseFieldStackViews: [UIStackView]!
    @IBOutlet var tipAdjustFieldStackViews: [UIStackView]!
    @IBOutlet var verifyFieldStackViews: [UIStackView]!
    @IBOutlet var tokenizeFieldStackViews: [UIStackView]!

    @IBOutlet weak var reversalReasonSelection: UISegmentedControl! {
        didSet {
            reversalReasonSelection.removeAllSegments()
            ReversalReason.allCases.forEach { reason in
                reversalReasonSelection.insertSegment(withTitle: reason.rawValue, at: 0, animated: true)
            }
            reversalReasonSelection.selectedSegmentIndex = 0
        }
    }
    
    @IBOutlet weak var taxCategorySelection: UISegmentedControl! {
        didSet {
            taxCategorySelection.removeAllSegments()
            taxCategorySelection.insertSegment(withTitle: "none", at: 0, animated: true)
            taxCategorySelection.selectedSegmentIndex = 0
            TaxCategory.allCases.forEach { category in
                taxCategorySelection.insertSegment(withTitle: category.rawValue, at: taxCategorySelection.numberOfSegments, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInputs()
        setupData()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func cancelTransaction(_ sender: UIButton) {
        GMSManager.shared.cancelTransaction()
        progressMessageContainer.isHidden = true
    }
    
    @IBAction func startTransaction(_ sender: UIButton) {
        switch transactionType! {
        case .Sale:
            do {
                try GMSManager.shared.start(transaction: createSale(), entryModes: entryModes, delegate: self)
            } catch {
                showError("\(error)")
            }
        case .Auth:
            do {
                try GMSManager.shared.start(transaction: createAuth(), entryModes: entryModes, delegate: self)
            } catch {
                showError("\(error)")
            }
        case .Capture:
            do {
                try GMSManager.shared.start(transaction: createCapture(), entryModes: entryModes, delegate: self)
            } catch {
                showError("\(error)")
            }
        case .Void:
            do {
                try GMSManager.shared.start(transaction: createVoid(), entryModes: entryModes, delegate: self)
            } catch {
                showError("\(error)")
            }
        case .Return:
            do {
                try GMSManager.shared.start(transaction: createReturn(), entryModes: entryModes, delegate: self)
            } catch {
                showError("\(error)")
            }
        case .Verify:
            do {
                var modes = entryModes

                if let config = UserDefaults.currentGatewayConfig, config.gatewayType == .ProPay {
                    modes = [.msr, .chipFallback, .manual]
                }

                try GMSManager.shared.start(transaction: createVerify(), entryModes: modes, delegate: self)
            } catch {
                showError("\(error)")
            }
        case .BatchClose:
            do {
                try GMSManager.shared.start(transaction: createBatchClose(), delegate: self)
            } catch {
                showError("\(error)")
            }
        case .TipAdjust:
            do {
                try GMSManager.shared.start(transaction: createTipAdjust(), delegate: self)
            } catch {
                showError("\(error)")
            }
        case .Tokenize:
            do {
                var modes = entryModes

                if let config = UserDefaults.currentGatewayConfig, config.gatewayType == .ProPay {
                    modes = [.msr, .chipFallback, .manual]
                }

                try GMSManager.shared.start(transaction: createToken(), entryModes: modes, delegate: self)
            } catch {
                showError("\(error)")
            }
        default:
            fatalError("")
        }
    }
    
    func createSale() throws -> SaleTransaction {
        guard let manualCard = manualCardData else {
            return SaleTransaction.sale(clientTransactionId: try getClientTransactionIDTextField(),
                                        total: try getTotal(),
                                        tax: try getTax(),
                                        tip: try getTip(),
                                        surcharge: try getSurcharge(),
                                        taxCategory: try getTaxCategory(),
                                        posReferenceNumber: getPosReferenceNumber(),
                                        invoiceNumber: getinvoiceNumber(),
                                        operatingUserId: getOperationUserId(),
                                        requestMultiUseToken:getMultiUseToken())
        }
        return SaleTransaction.sale(clientTransactionId: try getClientTransactionIDTextField(),
                                    total: try getTotal(),
                                    tax: try getTax(),
                                    tip: try getTip(),
                                    surcharge: try getSurcharge(),
                                    taxCategory: try getTaxCategory(),
                                    posReferenceNumber: getPosReferenceNumber(),
                                    invoiceNumber: getinvoiceNumber(),
                                    operatingUserId: getOperationUserId(),
                                    cardData: manualCard,
                                    requestMultiUseToken: getMultiUseToken())
    }
    
    func createAuth() throws -> AuthTransaction {
        guard let manualCard = manualCardData else {
            return AuthTransaction.auth(clientTransactionId: try getClientTransactionIDTextField(),
                                        total: try getTotal(),
                                        tax: try getTax(),
                                        tip: try getTip(),
                                        surcharge: try getSurcharge(),
                                        taxCategory: try getTaxCategory(),
                                        posReferenceNumber: getPosReferenceNumber(),
                                        invoiceNumber: getinvoiceNumber(),
                                        operatingUserId: getOperationUserId(),
                                        requestMultiUseToken: getMultiUseToken())
        }
        return AuthTransaction.auth(clientTransactionId: try getClientTransactionIDTextField(),
                                    total: try getTotal(),
                                    tax: try getTax(),
                                    tip: try getTip(),
                                    surcharge: try getSurcharge(),
                                    taxCategory: try getTaxCategory(),
                                    posReferenceNumber: getPosReferenceNumber(),
                                    invoiceNumber: getinvoiceNumber(),
                                    operatingUserId: getOperationUserId(),
                                    cardData: manualCard,
                                    requestMultiUseToken: getMultiUseToken())
    }
    
    func createVerify() throws -> VerifyTransaction {
        var verify: VerifyTransaction
        if let manualCard = manualCardData {
            verify = VerifyTransaction.verify(clientTransactionId: try getClientTransactionIDTextField(), posReferenceNumber: getPosReferenceNumber(), invoiceNumber: getinvoiceNumber(), operatingUserId: getOperationUserId(), cardData: manualCard, requestMultiUseToken: getMultiUseToken())
        } else {
            verify = VerifyTransaction.verify(clientTransactionId: nil, posReferenceNumber: getPosReferenceNumber(), invoiceNumber: getinvoiceNumber(), operatingUserId: getOperationUserId(), requestMultiUseToken: getMultiUseToken())
        }
        var address = Address()
        address.postalCode = getPostalCode()
        verify.cardholderAddress = address
        return verify
    }
    
    func createBatchClose() throws -> BatchCloseTransaction {
        return BatchCloseTransaction.batchClose(clientTransactionId: try getClientTransactionIDTextField(), operatingUserId: getOperationUserId())
    }
    
    func createCapture() throws -> CaptureTransaction {
        var transaction = CaptureTransaction.capture(clientTransactionId: try getClientTransactionIDTextField(),
                                                     gatewayTransactionId: try getGatewayTransactionID(),
                                                     total: try getTotal(),
                                                     tax: try getTax(),
                                                     tip: try getTip(),
                                                     taxCategory: try getTaxCategory(),
                                                     invoiceNumber: getinvoiceNumber(),
                                                     posReferenceNumber: getPosReferenceNumber(),
                                                     operatingUserId: getOperationUserId())
        
        transaction.signatureData = UIImage(named: "signature")?.pngData()
        return transaction
    }
    
    func createTipAdjust() throws -> TipAdjustTransaction {
        return TipAdjustTransaction.tipAdjust(clientTransactionId: try getClientTransactionIDTextField(),
                                              gatewayTransactionId: try getGatewayTransactionID(),
                                              total: try getTotal(),
                                              tip: try getTip(),
                                              invoiceNumber: getinvoiceNumber(),
                                              posReferenceNumber: getPosReferenceNumber(),
                                              operatingUserId: getOperationUserId())
    }
    
    func createVoid() throws -> VoidTransaction {
        var voidTransaction = VoidTransaction.void(clientTransactionId: try getClientTransactionIDTextField(),
                                                   gatewayTransactionId: try getGatewayTransactionID(),
                                                   reversalReason: try getReversalReason(),
                                                   posReferenceNumber: getPosReferenceNumber(),
                                                   invoiceNumber: getinvoiceNumber(),
                                                   operatingUserId: getOperationUserId())
        voidTransaction.total = try getTotal()
        
        return voidTransaction
    }
    
    func createReturn() throws -> ReturnTransaction {
        guard let manualCard = manualCardData, !manualCard.cardNumber.isEmpty else {
            return ReturnTransaction.returnWithReference(clientTransactionId: try getClientTransactionIDTextField(),
                                                         total: try getTotal(),
                                                         tax: try getTax(),
                                                         tip: try getTip(),
                                                         taxCategory: try getTaxCategory(),
                                                         gatewayTransactionId: try getGatewayTransactionID(),
                                                         posReferenceNumber: getPosReferenceNumber(),
                                                         invoiceNumber: getinvoiceNumber(),
                                                         operatingUserId: getOperationUserId())
        }
        return ReturnTransaction.returnWithManualCard(clientTransactionId: try getClientTransactionIDTextField(),
                                                      total: try getTotal(),
                                                      tax: try getTax(),
                                                      tip: try getTip(),
                                                      taxCategory: try getTaxCategory(),
                                                      posReferenceNumber: getPosReferenceNumber(),
                                                      invoiceNumber: getinvoiceNumber(),
                                                      operatingUserId: getOperationUserId(),
                                                      cardData: manualCard)
    }

    func createToken() throws -> TokenizationTransaction {
        guard let manualCard = manualCardData else {
            return TokenizationTransaction.tokenize(clientTransactionId: try getClientTransactionIDTextField(),
                                                    posReferenceNumber: getPosReferenceNumber(),
                                                    invoiceNumber: getinvoiceNumber(),
                                                    operatingUserId: getOperationUserId())
        }
        return TokenizationTransaction.tokenize(clientTransactionId: try getClientTransactionIDTextField(),
                                                posReferenceNumber: getPosReferenceNumber(),
                                                invoiceNumber: getinvoiceNumber(),
                                                operatingUserId: getOperationUserId(),
                                                cardData: manualCard)
    }
    
    func decimalFromTextField(field: UITextField) throws -> UInt {
        guard let value = field.text, value.count > 0 else {
            return 0
        }
        
        guard let number = UInt(value) else {
            throw NSError.init(domain: "Heartland-iOS-SDK", code: 1, userInfo: ["bad decimal value ": value])
        }
        
        return number
    }
    
    func getTip() throws -> UInt {
        return try decimalFromTextField(field: tipTextField)
    }
    
    func getSurcharge() throws -> UInt {
        return try decimalFromTextField(field: surchargeTextField)
    }
    
    func getTotal() throws -> UInt {
        return try decimalFromTextField(field: totalTextField)
    }
    
    func getTax() throws -> UInt {
        return try decimalFromTextField(field: taxAmountTextField)
    }
    
    func getTaxCategory() throws -> TaxCategory? {
        guard taxCategorySelection.selectedSegmentIndex != 0 else {
            return nil
        }
        guard let text = taxCategorySelection.titleForSegment(at: taxCategorySelection.selectedSegmentIndex) else {
            throw NSError.init(domain: "Heartland-iOS-SDK", code: 1, userInfo: ["bad TaxCategory value": ""])
        }
        guard let category = TaxCategory(rawValue:  text) else {
            throw NSError.init(domain: "Heartland-iOS-SDK", code: 1, userInfo: ["bad TaxCategory value": text])
        }
        return category
    }
    
    func getReversalReason() throws -> ReversalReason {
        guard let text = reversalReasonSelection.titleForSegment(at: reversalReasonSelection.selectedSegmentIndex) else {
            throw NSError.init(domain: "Heartland-iOS-SDK", code: 1, userInfo: ["bad ReversalReason value": ""])
        }
        guard let reversalReason = ReversalReason.init(rawValue: text) else {
            throw NSError.init(domain: "Heartland-iOS-SDK", code: 1, userInfo: ["bad ReversalReason value": text])
        }
        return reversalReason
    }
    
    func getClientTransactionIDTextField() throws -> String {
        guard let id = clientTransactionIDTextField.text else {
            throw NSError(domain: "Heartland-iOS-SDK", code: 1, userInfo: ["gatewayTransactionIDTextField bad value": "nil"])
        }
        return id
    }
    
    func getGatewayTransactionID() throws -> String {
        guard let id = gatewayTransactionIDTextField.text else {
            throw NSError.init(domain: "Heartland-iOS-SDK", code: 1, userInfo: ["gatewayTransactionIDTextField bad value": "nil"])
        }
        return id
    }
    
    func getPosReferenceNumber() -> String? {
        return posReferenceNumberTextField.text
    }
    
    func getPostalCode() -> String? {
        return postalCodeTextField.text
    }
    
    func getOperationUserId() -> String? {
        return operationUserIDTextField.text
    }
    
    func getinvoiceNumber() -> String? {
        return invoiceNumberTextField.text
    }

    func getMultiUseToken() -> Bool {
        return tokenizeTransaction.isOn
    }
    
    func showAlert(alert: UIAlertController) {
        self.alert = alert
        guard let previous = presentedViewController else {
            present(alert, animated: true, completion: nil)
            return
        }
        previous.dismiss(animated: true) { [unowned self] in
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setupInputs() {
        gatewayTransactionIDTextField.inputAccessoryView = dismissToolbar
        operationUserIDTextField.inputAccessoryView = dismissToolbar
        totalTextField.inputAccessoryView = dismissToolbar
        tipTextField.inputAccessoryView = dismissToolbar
        surchargeTextField.inputAccessoryView = dismissToolbar
        taxAmountTextField.inputAccessoryView = dismissToolbar
        posReferenceNumberTextField.inputAccessoryView = dismissToolbar
        invoiceNumberTextField.inputAccessoryView = dismissToolbar
        postalCodeTextField.inputAccessoryView = dismissToolbar
        
        fieldStackViews.forEach { stack in
            
            switch transactionType! {
            case .Sale:
                stack.isHidden = !saleFieldStackViews.contains(stack)
            case .Auth:
                stack.isHidden = !authFieldStackViews.contains(stack)
            case .Capture:
                stack.isHidden = !captureFieldStackViews.contains(stack)
            case .Void:
                stack.isHidden = !voidFieldStackViews.contains(stack)
            case .Return:
                stack.isHidden = !returnFieldStackViews.contains(stack)
            case .Verify:
                stack.isHidden = !verifyFieldStackViews.contains(stack)
            case .Tokenize:
                stack.isHidden = !tokenizeFieldStackViews.contains(stack)
                tokenizeTransaction.isOn = true
                tokenizeTransaction.isUserInteractionEnabled = false
            case .BatchClose:
                stack.isHidden = !batchCloseFieldStackViews.contains(stack)
            case .TipAdjust:
                stack.isHidden = !tipAdjustFieldStackViews.contains(stack)
            default:
                stack.isHidden = true
            }
        }
    }
    
    func setupData() {
        switch transactionType! {
        case .Sale, .Auth: invoiceNumberTextField.text = ReceiptUtility.invoiceNumber
        default: break
        }
    }
}

extension TransactionViewController: TransactionDelegate {
    func requestPostalCode(maskedPan: String,
                           expiryDate: String,
                           cardholderName: String?) {
        let alert = UIAlertController(title: "Require Pincode !!!",
                                      message: "Enter Pincode below to continue transaction. \n CardNumber: \(maskedPan) \n Expiry Date: \(expiryDate). Cardholder Name: \(cardholderName ?? "")",
            preferredStyle: .alert)
        alert.addTextField() { newTextField in
            newTextField.placeholder = "Pincode"
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            GMSManager.shared.cancelTransaction()
        })

        alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
            if let textField = alert.textFields?.first, let result = textField.text, !result.isEmpty {
                GMSManager.shared.postalCode(postalCode: result)
            } else {
                GMSManager.shared.cancelTransaction()
            }
        })

        showAlert(alert: alert)
    }

    func onState(state: TransactionState) {
        guard state != .error, state != .cancelled else { return }
        if state == .complete {
            progressMessageContainer.isHidden = true
        } else {
            progressMessageContainer.isHidden = false
        }
        progressMessageLabel.text = "\(state)"
    }
    
    func requestAIDSelection(aids: [AID]) {
        let alert = UIAlertController(title: "Select AID", message: nil, preferredStyle: .alert)
        for (index, aid) in aids.enumerated() {
            let applicationDisplayName: String?
            if let preferedName = aid.preferredName, preferedName.count > 0 {
                applicationDisplayName = preferedName
            } else {
                applicationDisplayName = aid.label
            }
            alert.addAction(.init(title: applicationDisplayName ?? aid.applicationIdentifier,
                                  style: .default,
                                  handler: { [unowned self] _ in
                                    GMSManager.shared.select(aid: aids[index])
                                    self.alert?.dismiss(animated: true, completion: { [unowned self] in
                                        self.alert = nil
                                    })
            }))
        }
        alert.addAction(.init(title: "Cancel", style: .cancel, handler: { [unowned self] _ in
            GMSManager.shared.cancelTransaction()
            self.alert?.dismiss(animated: true) { [unowned self] in
                self.alert = nil
            }
        }))
        showAlert(alert: alert)
    }
    
    func requestAmountConfirmation(amount: Decimal?) {
        let alert = UIAlertController(title: "Confirm Amount", message: "\(amount ?? 0)", preferredStyle: .alert)
        alert.addAction(.init(title: "Yes", style: .default, handler: { [unowned self] _ in
            GMSManager.shared.confirm(amount: amount ?? 0)
            alert.dismiss(animated: true) {
                if alert == self.alert {
                    self.alert = nil
                }
            }
        }))
        alert.addAction(.init(title: "Cancel", style: .cancel, handler: { [unowned self] _ in
            GMSManager.shared.cancelTransaction()
            alert.dismiss(animated: true) {
                if alert == self.alert {
                    self.alert = nil
                }
            }
        }))
        showAlert(alert: alert)
    }
    
    func requestSaFApproval() {
        let alert = UIAlertController(title: "Approve Saf",
                                      message: "Transaction Unable to go online. Store offline and Process Later?",
                                      preferredStyle: .alert)
        alert.addAction(.init(title: "Approve", style: .default, handler: { _ in
            GMSManager.shared.approveSaF()
        }))
        alert.addAction(.init(title: "Cancel", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        showAlert(alert: alert)
    }
    
    func onTransactionComplete(result: TransactionResult, response: TransactionResponse?) {
        print("TransactionResult \(response)")
        guard let response = response else {
            let alert = UIAlertController(title: "Result", message: "\(result.rawValue.uppercased())", preferredStyle: .alert)
            alert.addAction(.init(title: "ok", style: .default, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            showAlert(alert: alert)
            return
        }
        ScreenSequence.showTransactionResponse(for: response)
        progressMessageContainer.isHidden = true
    }
    
    func onTransactionCancelled() {
        let alert = UIAlertController(title: "Result",
                                      message: "Transaction Cancelled",
                                      preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        showAlert(alert: alert)
    }
    
    fileprivate func showError(_ error: String) {
        let alert = UIAlertController.init(title: "Error", message: "\(error)", preferredStyle: .alert)
        alert.addAction(.init(title: "ok", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))

        guard let controller = presentedViewController else {
            present(alert, animated: true, completion: nil)
            return
        }
        controller.dismiss(animated: true) { [unowned self] in
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func onError(error: TransactionError) {
        progressMessageContainer.isHidden = true
        showError("\(error)")
    }
}

extension TransactionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(false)
    }
}
