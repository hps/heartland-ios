//
//  C2XTransactionsViewController.swift
//  Heartland-iOS-SDK_Example
//
//  Created by Renato Santos on 04/11/2022.
//  Copyright © 2022 Shaunti Fondrisi. All rights reserved.
//

import Heartland_iOS_SDK
import UIKit

enum MainTransaction {
    case auth
    case credit
    case refund
    case void
    case reversal
    case capture
}

class C2XTransactionsViewController: UIViewController, UITextFieldDelegate {
    // MARK: Outlets
    public let PorticoTransactionSurchargeAPIRequestTimeOut = "\n\n\nSurcharge eligibility was unable to be verified."
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var creditSaleButton: UIButton!
    @IBOutlet weak var manualCardTransactionButton: UIButton!
    @IBOutlet weak var tipAdjustButton: UIButton!
    @IBOutlet weak var creditReturnButton: UIButton!
    @IBOutlet weak var creditVoidButton: UIButton!
    @IBOutlet weak var reversalTransactionButton: UIButton!
    @IBOutlet weak var authTransaction: UIButton!
    @IBOutlet weak var captureTransaction: UIButton!
    @IBOutlet weak var resetValues: UIButton!
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var gratuityTextField: UITextField!
    @IBOutlet weak var transactionIdTextField: UITextField!
    @IBOutlet weak var clinicHealthCareTotalTextField: UITextField!
    @IBOutlet weak var dentalHealthCareTotalTextField: UITextField!
    @IBOutlet weak var prescriptionHealthCareTotalTextField: UITextField!
    @IBOutlet weak var visionHealthCareTotalTextField: UITextField!
    @IBOutlet weak var allowPartialAuthToggle: UISwitch!
    @IBOutlet weak var allowSurcharge: UISwitch!
    @IBOutlet weak var surchargePercent: UITextField!
    
    @IBOutlet weak var DialogView: UIView!
    @IBOutlet weak var dialogText: UILabel!
    @IBOutlet weak var dialogSpinner: UIActivityIndicatorView!
    
    
    // MARK: - Properties
    var mainTransaction: MainTransaction = .credit
    let notificationCenter: NotificationCenter = NotificationCenter.default
    var devicesFound: NSMutableArray = []
    var deviceList: HpsTerminalInfo?
    var device: HpsC2xDevice? {
        didSet {
            device?.transactionDelegate = self
        }
    }
    
    var isDeviceConnected: Bool = false
    var terminalRefNumber: String?
    var clientTransactionId: String?
    var clientTxnID: String?
    
    var transactionId: String? {
        didSet {
            if transactionIdTextField != nil, transactionId != transactionIdTextField.text {
                transactionIdTextField.text = transactionId
            }
        }
    }
    var transactionAmount: NSDecimalNumber = 0.0
    
    // MARK: Introducing Local Builder for surcharge confirmation
    var builder: HpsC2xBaseBuilder?
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addObserver()
        configureView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureActions()
        surchargePercent.delegate = self
        surchargePercent.keyboardType = .decimalPad
        allowSurcharge.addTarget(self, action: #selector(toggleSurcharge(_:)), for: .valueChanged)
        
        if allowSurcharge.isOn {
            surchargePercent.text = "3.00"
            surchargePercent.isEnabled = true
        } else {
            surchargePercent.text = ""
            surchargePercent.isEnabled = false
        }
    }
    
    private func addObserver() {
        let notificationName = Notification.Name(Constants.selectedDeviceNotification)
        notificationCenter.addObserver(self,
                                       selector: #selector(selectedDevice),
                                       name: notificationName,
                                       object: nil)
    }
    
    private func configureView() {
        DialogView.layer.cornerRadius = 10
        amountTextField.keyboardType = .decimalPad
        gratuityTextField.keyboardType = .decimalPad
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleContainerViewTap))
        containerView.addGestureRecognizer(tapGesture)
        
        amountTextField.text = "1.28"
        gratuityTextField.text = "0.00"
        allowPartialAuthToggle.setOn(false, animated: true)
        transactionIdTextField.text = String.empty
        clinicHealthCareTotalTextField.text = "0.00"
        dentalHealthCareTotalTextField.text = "0.00"
        prescriptionHealthCareTotalTextField.text = "0.00"
        visionHealthCareTotalTextField.text = "0.00"
        
        enableButtons(true)
    }
}

// MARK: - Actions

private extension C2XTransactionsViewController {
    private func configureActions() {
        self.creditSaleButton.addTarget(self,
                                        action: #selector(creditSaleButtonAction(_:)),
                                        for: .touchUpInside)
        
        self.manualCardTransactionButton.addTarget(self,
                                                   action: #selector(manualTransactionButtonAction(_:)),
                                                   for: .touchUpInside)
        self.creditVoidButton.addTarget(self,
                                        action: #selector(creditVoidTransactionButtonAction(_:)),
                                        for: .touchUpInside)
        
        self.reversalTransactionButton.addTarget(self,
                                                 action: #selector(creditReversalTransaction),
                                                 for: .touchUpInside)
        self.authTransaction.addTarget(self,
                                       action: #selector(authTransactionAction),
                                       for: .touchUpInside)
        
        self.creditReturnButton.addTarget(self,
                                          action: #selector(refundTransactionAction),
                                          for: .touchUpInside)
        
        self.captureTransaction.addTarget(self,
                                          action: #selector(captureAuthTransaction),
                                          for: .touchUpInside)
        
        self.tipAdjustButton.addTarget(self, 
                                       action: #selector(tipAdjustTransaction),
                                       for: .touchUpInside)
        
        self.resetValues.addTarget(self,
                                   action: #selector(resetScreenValues),
                                   for: .touchUpInside)
        
    }
    
    @objc func selectedDevice(_ notification: Notification) {
        guard let notificationData = notification.userInfo as? [String: HpsC2xDevice] else { return }
        if let device = notificationData["selectedDevice"] {
            self.device = device
        }
    }
    
    @objc func creditSaleButtonAction(_: UIButton) {
        guard let amountText = amountTextField.text, amountText.count > 0 else { showTextDialog(LoadingStatus.AMOUNT_SHOULD_BE_LARGER_THAN_ZERO.rawValue)
            return
        }
        
        guard validateHeathCareWithTransactionAmount() else {
            showTextDialogWith("Transaction Cannot Be Performed",
                               LoadingStatus.AMOUNT_SHOULD_BE_HIGHER_THAN_HEALTHCARE_TOTAL.rawValue)
            return
        }
        
        if let device = device {
            
            let amountNumber = NSDecimalNumber(string: amountText)
            let builder = HpsC2xCreditSaleBuilder(device: device)
            builder.amount = amountNumber
            builder.allowPartialAuth = NSNumber(value: allowPartialAuthToggle.isOn)
            builder.cpcReq = true
            builder.allowDuplicates = true
            builder.isSurchargeEnabled = NSNumber(value: allowSurcharge.isOn)
            builder.surchargeFee = NSDecimalNumber(string: surchargePercent.text)
            
            let autoSubstantiation = getHealthCareComponent()
            builder.autoSubstantiation = autoSubstantiation
            
            let gratuity = gratuityTextField.text ?? "0.00"
            builder.gratuity = NSDecimalNumber(string: gratuity)
            
            if let cTransactionId = builder.clientTransactionId {
                NSLog("Client Transaction Id Generated In The Client - Request  %@", cTransactionId)
            }
            self.builder = builder
            
            if allowSurcharge.isOn,
               let surchargeValue = Decimal(string: surchargePercent.text ?? "3.0"),
                surchargeValue < 2 || surchargeValue > 3 {
                showTextDialogWith("Transaction Cannot Be Performed",
                                   "Custom surcharge fee is limited to a value of 2% or greater and less than 3%")
                return
            }
            
            showProgress(true)
            setText(LoadingStatus.WAIT.rawValue)
            builder.execute()
        } else {
            showTextDialog(LoadingStatus.DEVICE_NOT_CONNECTED_ALERT.rawValue)
        }
    }
    
    @objc func manualTransactionButtonAction(_: UIButton) {
        if let device = device {
            
            let address = HpsAddress()
            address.address = "6860 Dallas Pkwy"
            address.zip = "75024"
            
            let card = HpsCreditCard()
            card.cardNumber = "374245001751006"
            card.expMonth = 12
            card.expYear = 2024
            card.cvv = "201"
            
            let amountString = NSDecimalNumber(string: amountTextField.text)
            let builder = HpsC2xCreditAuthBuilder(device: device)
            builder.amount = amountString
            builder.creditCard = card
            builder.address = address
            builder.isSurchargeEnabled = NSNumber(value: allowSurcharge.isOn)
            builder.surchargeFee = NSDecimalNumber(string: surchargePercent.text)
            
            builder.allowPartialAuth = true
            builder.allowDuplicates = true
            
            self.mainTransaction = .auth
            self.builder = builder
            
            if allowSurcharge.isOn,
               let surchargeValue = Decimal(string: surchargePercent.text ?? "3.0"),
                surchargeValue < 2 || surchargeValue > 3 {
                showTextDialogWith("Transaction Cannot Be Performed",
                                   "Custom surcharge fee is limited to a value of 2% or greater and less than 3%")
                return
            }
            showProgress(true)
            setText(LoadingStatus.WAIT.rawValue)
            builder.execute()
        } else {
            showTextDialog(LoadingStatus.DEVICE_NOT_CONNECTED_ALERT.rawValue)
        }
    }
    
    @objc func creditVoidTransactionButtonAction(_: UIButton) {
        if let device = device {
            showProgress(true)
            transactionIdTextField.text = String.empty
            setText(LoadingStatus.WAIT.rawValue)
            
            if let transactionId = transactionIdTextField.text {
                let builder = HpsC2xCreditVoidBuilder(device: device)
                builder.transactionId = transactionId
                builder.execute()
            } else {
                showTextDialog(LoadingStatus.NOT_TRANSACTION_ID.rawValue)
            }
        } else {
            showTextDialog(LoadingStatus.DEVICE_NOT_CONNECTED_ALERT.rawValue)
        }
    }
    
    @objc func handleContainerViewTap() {
        view.endEditing(true)
    }
    
    @objc func creditReversalTransaction(_ sender: UIButton) {
        guard let amountText = self.amountTextField.text, amountText.count > 0 else { showTextDialog(LoadingStatus.AMOUNT_SHOULD_BE_LARGER_THAN_ZERO.rawValue)
            return
        }
        if let device = self.device {
            showProgress(true)
            setText(LoadingStatus.WAIT.rawValue)
            let amountNumber = NSDecimalNumber(string: amountText)
            let builder: HpsC2xCreditReversalBuilder = HpsC2xCreditReversalBuilder(device: device)
            builder.amount = amountNumber
            builder.transactionId = self.transactionIdTextField.text
            builder.allowPartialAuth = NSNumber(value: allowPartialAuthToggle.isOn)
            print("Transaction ID coming from response is: \(builder.transactionId)")
            builder.clientTransactionId = self.clientTransactionId
            if let cTransactionId = builder.clientTransactionId {
                NSLog("Client Transaction Id Generated In The Client - Request  %@", cTransactionId)
            }
            builder.execute()
        } else {
            showTextDialog(LoadingStatus.DEVICE_NOT_CONNECTED_ALERT.rawValue)
        }
    }
    
    @objc func authTransactionAction(_ sender: UIButton) {
        guard let amountText = self.amountTextField.text, amountText.count > 0 else { showTextDialog(LoadingStatus.AMOUNT_SHOULD_BE_LARGER_THAN_ZERO.rawValue)
            return
        }
        if let device = self.device {
            
            transactionIdTextField.text = String.empty
            
            
            let card: HpsCreditCard = HpsCreditCard()
            card.cardNumber = "374245001751006"
            card.expMonth = 12
            card.expYear = 2024
            card.cvv = "201"
            
            self.mainTransaction = .auth
            self.transactionId = ""
            let amountNumber = NSDecimalNumber(string: amountText)
            let builder: HpsC2xCreditAuthBuilder = HpsC2xCreditAuthBuilder(device: device)
            builder.amount = amountNumber
            builder.clientTransactionId = "02997841500"
            let gratuity = gratuityTextField.text ?? "0.00"
            builder.gratuity = NSDecimalNumber(string: gratuity)
//            builder.creditCard = card -- Keep commented if you want to use the reader for card
            builder.allowDuplicates = true
            builder.isSurchargeEnabled = NSNumber(value: allowSurcharge.isOn)
            builder.surchargeFee = NSDecimalNumber(string: surchargePercent.text)
            if let cTransactionId = builder.clientTransactionId {
                NSLog("Client Transaction Id Generated In The Client - Request  %@", cTransactionId)
            }
            self.builder = builder
            if allowSurcharge.isOn,
               let surchargeValue = Decimal(string: surchargePercent.text ?? "3.0"),
                surchargeValue < 2 || surchargeValue > 3 {
                showTextDialogWith("Transaction Cannot Be Performed",
                                   "Custom surcharge fee is limited to a value of 2% or greater and less than 3%")
                return
            }
            showProgress(true)
            setText(LoadingStatus.WAIT.rawValue)
            builder.execute()
            
            
        } else {
            showTextDialog(LoadingStatus.DEVICE_NOT_CONNECTED_ALERT.rawValue)
        }
    }
    
    @objc func refundTransactionAction(_: UIButton) {
        guard let amountText = amountTextField.text, amountText.count > 0 else { showTextDialog(LoadingStatus.AMOUNT_SHOULD_BE_LARGER_THAN_ZERO.rawValue)
            return
        }
        if let device = device {
            showProgress(true)
            setText(LoadingStatus.WAIT.rawValue)
            let amountNumber = NSDecimalNumber(string: amountText)
            let builder = HpsC2xCreditReturnBuilder(device: device)
            builder.amount = amountNumber
            builder.allowPartialAuth = NSNumber(value: allowPartialAuthToggle.isOn)
            builder.transactionId = self.transactionIdTextField.text
            
            if let cTransactionId = builder.clientTransactionId {
                NSLog("Client Transaction Id Generated In The Client - Request  %@", cTransactionId)
            }
            builder.execute()
        } else {
            showTextDialog(LoadingStatus.DEVICE_NOT_CONNECTED_ALERT.rawValue)
        }
    }
    
    @objc func captureAuthTransaction(_: UIButton?) {
        guard let amountText = self.amountTextField.text, amountText.count > 0 else { showTextDialog(LoadingStatus.AMOUNT_SHOULD_BE_LARGER_THAN_ZERO.rawValue)
            return
        }
        if let device = self.device {
            showProgress(true)
            setText(LoadingStatus.WAIT.rawValue)
            
            self.mainTransaction = .capture
            let amountNumber = NSDecimalNumber(string: amountText)
            let builder: HpsC2xCreditCaptureBuilder = HpsC2xCreditCaptureBuilder(device: device)
            builder.amount = amountNumber
            builder.clientTransactionId = self.clientTransactionId
            builder.referenceNumber = self.terminalRefNumber
            builder.transactionId = self.transactionIdTextField.text
            builder.execute()
            
        } else {
            showTextDialog(LoadingStatus.DEVICE_NOT_CONNECTED_ALERT.rawValue)
        }
    }
    
    @objc func tipAdjustTransaction(_: UIButton?) {
        guard let amountText = self.amountTextField.text, amountText.count > 0 else { showTextDialog(LoadingStatus.AMOUNT_SHOULD_BE_LARGER_THAN_ZERO.rawValue)
            return
        }
        
        guard let gratuityAmountText = self.gratuityTextField.text,
                gratuityAmountText.count > 0 else { showTextDialog(LoadingStatus.AMOUNT_SHOULD_BE_LARGER_THAN_ZERO.rawValue)
            return
        }
        if let device = self.device {
            showProgress(true)
            setText(LoadingStatus.WAIT.rawValue)
            
            self.mainTransaction = .capture
            let amountNumber = NSDecimalNumber(string: amountText)
            let gratuityNumber = NSDecimalNumber(string: gratuityAmountText)
            let builder: HpsC2xCreditAdjustBuilder = HpsC2xCreditAdjustBuilder(device: device)
            builder.amount = amountNumber.adding(gratuityNumber)
            builder.gratuity = gratuityNumber
            builder.clientTransactionId = self.clientTransactionId
            builder.referenceNumber = self.terminalRefNumber
            builder.transactionId = self.transactionIdTextField.text
            builder.isSurchargeEnabled = true
            builder.execute()
            
        } else {
            showTextDialog(LoadingStatus.DEVICE_NOT_CONNECTED_ALERT.rawValue)
        }
    }
    
    @objc func resetScreenValues(_: UIButton?) {
        configureView()
    }
    
    @objc func toggleSurcharge(_ sender: UISwitch) {
       if sender.isOn {
           surchargePercent.text = "3.00"
           surchargePercent.isEnabled = true
       } else {
           surchargePercent.text = ""
           surchargePercent.isEnabled = false
       }
   }
    
    func reversalAuthTransaction() {
        guard let amountText = self.amountTextField.text, amountText.count > 0 else { showTextDialog(LoadingStatus.AMOUNT_SHOULD_BE_LARGER_THAN_ZERO.rawValue)
            return
        }
        if let device = self.device {
            showProgress(true)
            setText(LoadingStatus.WAIT.rawValue)
            
            self.mainTransaction = .reversal
            
            let amountNumber = NSDecimalNumber(string: amountText)
            let builder: HpsC2xCreditReversalBuilder = HpsC2xCreditReversalBuilder(device: device)
            builder.amount = amountNumber
            builder.clientTransactionId = self.clientTransactionId
            if let cTransactionId = builder.clientTransactionId {
                NSLog("Client Transaction Id Generated In The Client - Request  %@", cTransactionId)
            }
            builder.execute()
        } else {
            showTextDialog(LoadingStatus.DEVICE_NOT_CONNECTED_ALERT.rawValue)
        }
    }
    
    func checkReversalResult() {
        print("REVERSAL WORKS: - CLIENT_TRANSACTION_ID: \(self.clientTransactionId)")
        showProgress(false)
    }
    
    func validateHeathCareWithTransactionAmount() -> Bool {
        let clinicTotal = Double(clinicHealthCareTotalTextField.text ?? "0.00") ?? 0.00
        let dentalTotal = Double(dentalHealthCareTotalTextField.text ?? "0.00") ?? 0.00
        let prescriptionTotal = Double(prescriptionHealthCareTotalTextField.text ?? "0.00") ?? 0.00
        let visionTotal = Double(visionHealthCareTotalTextField.text ?? "0.00") ?? 0.00
        
        let amount = Double(amountTextField.text ?? "0.00") ?? 0.00
        
        let sumHealthCareTotal = clinicTotal + dentalTotal + prescriptionTotal + visionTotal
        if sumHealthCareTotal > amount {
            return false
        }
        
        return true
    }
    
    func getHealthCareComponent() -> HpsAutoSubstantiation {
        var healthCareAmount: HpsAutoSubstantiation = HpsAutoSubstantiation()
        
        let clinicTotal = Double(clinicHealthCareTotalTextField.text ?? "0.00")
        let dentalTotal = Double(dentalHealthCareTotalTextField.text ?? "0.00")
        let prescriptionTotal = Double(prescriptionHealthCareTotalTextField.text ?? "0.00")
        let visionTotal = Double(visionHealthCareTotalTextField.text ?? "0.00")
        
        if let clinicTotal = clinicTotal, clinicTotal > 0 {
            healthCareAmount.setClinicSubTotal(NSDecimalNumber(string: "\(clinicTotal)"))
        }
        
        if let dentalTotal = dentalTotal, dentalTotal > 0 {
            healthCareAmount.setDentalSubTotal(NSDecimalNumber(string: "\(dentalTotal)"))
        }
        
        if let dentalTotal = dentalTotal, dentalTotal > 0 {
            healthCareAmount.setDentalSubTotal(NSDecimalNumber(string: "\(dentalTotal)"))
        }
        
        if let prescriptionTotal = prescriptionTotal, prescriptionTotal > 0 {
            healthCareAmount.setPrescriptionSubTotal(NSDecimalNumber(string: "\(prescriptionTotal)"))
        }
        
        if let visionTotal = visionTotal, visionTotal > 0 {
            healthCareAmount.setVisionSubTotal(NSDecimalNumber(string: "\(visionTotal)"))
        }
        
        return healthCareAmount
    }
}

// MARK: C2X Delegate

extension C2XTransactionsViewController: HpsC2xDeviceDelegate, GMSTransactionDelegate, GMSClientAppDelegate {
    func onStatusUpdate(_ transactionStatus: HpsTransactionStatus) {
        var statusText = ""
        switch transactionStatus {
        case .waitingForCard, .presentCard, .presentCardAgain, .started:
            statusText = LoadingStatus.WAITING_FOR_CARD.rawValue
        case .processing:
            statusText = LoadingStatus.PROCESSING.rawValue
        case .complete:
            statusText = LoadingStatus.COMPLETED.rawValue
            showProgress(false)
        case .error:
            statusText = LoadingStatus.ERROR.rawValue
        case .terminalDeclined:
            statusText = LoadingStatus.DECLINED.rawValue
        case .transactionTerminated:
            statusText = LoadingStatus.TERMINATED.rawValue
        case .surchargeRequested:
            statusText = "Surcharge Requested"
        default:
            statusText = LoadingStatus.PROCESSING.rawValue
        }
        
        let isProcessing = statusText.contains(LoadingStatus.PROCESSING.rawValue)
        enableButtons(!isProcessing)
        setText(statusText)
    }
    
    func onConfirmAmount(_ amount: Decimal) {
        device?.confirmAmount(amount)
    }
    
    func onConfirmApplication(_ applications: [AID]) {
        device?.confirmApplication(applications[0])
    }
    
    func onTransactionComplete(_ response: HpsTerminalResponse) {
        if let responseAmount = response.approvedAmount {
            transactionAmount = responseAmount
        }
        
        if let responseStatus = response.status {
            print(" Status response: \(responseStatus)")
        }
        
        if let clientTxnId = response.clientTxnId {
            print("ClientTxnID: \(clientTxnId)")
        }
        
        print(" Response: \(response)")
        
        if response.surchargeRequested != nil {
            print(" Surcharge Requested: \(response.surchargeRequested)")
        }
        
        if let responseTransactionId = response.transactionId {
            
            self.terminalRefNumber = response.terminalRefNumber
            self.clientTransactionId = response.clientTransactionId
            self.clientTxnID = response.clientTxnId
            
            if mainTransaction != .capture {
                self.transactionId = responseTransactionId
            }
        }
        
        if let cTransactionId = response.clientTransactionId {
            NSLog("Client Transaction Id Generated In The Client - Response %@", cTransactionId)
        }
        
        if let deviceResponseCode = response.deviceResponseCode {
            switch deviceResponseCode {
            case LoadingStatus.APPROVAL.rawValue:
                showDialog(for: .APPROVED(response: response))
            case LoadingStatus.PARTIAL_APPROVAL.rawValue:
                showDialog(for: .APPROVED(response: response))
            case LoadingStatus.DECLINED.rawValue:
                showDialog(for: .DECLINED(response: response))
            case LoadingStatus.CANCELLED.rawValue:
                showDialog(for: .CANCELLED(response: response))
            default:
                if let message = response.responseText {
                    showDialog(for: .MESSAGE(message: message))
                } else if let message = response.deviceResponseMessage {
                    showDialog(for: .MESSAGE(message: message))
                } else {
                    showDialog(for: .MESSAGE(message: "We have faced an issue on trying to perform the transaction"))
                }
            }
        }
        
        showProgress(false)
    }
    
    func onTransactionWaitingForSurchargeConfirmation(result: HpsTransactionStatus, response: HpsTerminalResponse) {
        if result == .surchargeRequested, let builder = self.builder,
           let surchargeFee = response.surchargeFee {
            let alertController = UIAlertController(title: "Surcharge Confirmation Required",
                                                    message: "There will be a \(surchargeFee) surcharge added to your purchase",
                                                    preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "Accept", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
                self.device?.confirmSurcharge(true)
            }
            let cancelAction = UIAlertAction(title: "Decline", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
                self.device?.confirmSurcharge(false)
                self.showProgress(false)
            }
            
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func onTransactionCancelled() {
        showProgress(false)
    }
    
    func onTransactionError(_ error: NSError) {
//        device?.cancelTransaction()
        showProgress(false)
        print(error)
        if let errorMessge = error.userInfo["message"] as? String {
            showDialog(for: .MESSAGE(message: errorMessge))
        } else {
            showDialog(for: .MESSAGE(message: "We have faced an issue on trying to perform the transaction"))
        }
    }
    
    func onError(_ error: NSError) {
        device?.onError(error)
    }
    
    func searchComplete() {
        print(" searchComplete ")
    }
    
    func deviceConnected() {
        print(" deviceConnected ")
    }
    
    func deviceDisconnected() {
        print(" deviceDisconnected ")
    }
    
    func deviceFound(_: NSObject) {
        print(" deviceFound ")
    }
    
    func onStatus(_ status: HpsTransactionStatus) {
        let statusText = "\(status.rawValue)".uppercased()
        setText(statusText)
        device?.onStatus(status)
    }
    
    func requestAIDSelection(_: [AID]) {
        print(" requestAIDSelection ")
    }
    
    func requestAmountConfirmation(_: Decimal) {
        print(" requestAmountConfirmation ")
    }
    
    func requestPostalCode(_: String, expiryDate _: String, cardholderName _: String) {
        print(" requestPostalCode ")
    }
    
    func requestSaFApproval() {
        print(" requestSaFApproval ")
    }
    
    func onTransactionComplete(_ result: String, response: HpsTerminalResponse) {
        device?.onTransactionComplete(result, response: response)
        showProgress(false)
    }
    
    func onConnected() {
        setStatus(LoadingStatus.CONNECTED_DEVICE.rawValue)
        device?.transactionDelegate = self
        isDeviceConnected = true
        enableButtons(isDeviceConnected)
        showProgress(false)
    }
    
    func onDisconnected() {
        setStatus(LoadingStatus.DEVICE_NOT_CONNECTED.rawValue)
        isDeviceConnected = false
        enableButtons(isDeviceConnected)
    }
    
    func onBluetoothDeviceList(_ peripherals: NSMutableArray) {
        if peripherals.count == 0 {
            return
        }
        devicesFound = NSMutableArray()
        
        for (index, _) in peripherals.enumerated() {
            if let tInfo = peripherals[index] as? HpsTerminalInfo {
                deviceList = tInfo
                device?.stopScan()
                device?.connectDevice(tInfo)
            }
        }
    }
    
    private func enableButtons(_ shouldEnable: Bool) {
        DispatchQueue.main.async {
            self.creditSaleButton.isEnabled = shouldEnable
            self.manualCardTransactionButton.isEnabled = shouldEnable
            self.creditVoidButton.isEnabled = shouldEnable
        }
    }
}

// MARK: - Dialog

private extension C2XTransactionsViewController {
    func setText(_ text: String) {
        DispatchQueue.main.async {
            self.dialogText.text = text
            self.dialogSpinner.startAnimating()
            self.setStatus(text)
        }
    }
    
    func showProgress(_ show: Bool) {
        DialogView.isHidden = !show
        if show {
            dialogSpinner.startAnimating()
        } else {
            dialogSpinner.stopAnimating()
        }
    }
    
    func setStatus(_ text: String) {
        DispatchQueue.main.async {
            self.labelStatus.text = text
        }
    }
    
    private func showDialog(for status: Status) {
        var messageResult = ""
        var isApproved = false
        var issuerMSG = ""
        var issuerCode = ""
        var GWCode = ""
        var GWMSG = ""
        var GWMSGSurcharge = ""
        var cardHolderName = ""
        
        switch status {
        case let .APPROVED(response):
            guard let responseCode = response.deviceResponseCode else { return }
            
            if let responseIssuerMSG = response.issuerRspMsg {
                issuerMSG = responseIssuerMSG
            }
            if let responseIssuerCode = response.issuerRspCode {
                issuerCode = responseIssuerCode
            }
            
            if let respCode = response.responseCode {
                GWCode = respCode
            }
            
            if let respText = response.responseText {
                GWMSG = respText
            }
            
            if case response.surchargeRequested = .U {
                GWMSGSurcharge = PorticoTransactionSurchargeAPIRequestTimeOut
            }
            
            let surchargeFee = response.surchargeFee ?? "0"
            var surchargeAmount: NSDecimalNumber = NSDecimalNumber(string: "0")
            if response.surchargeRequested == SurchargeEligibility.Y {
                surchargeAmount = NSDecimalNumber(string: response.surchargeAmount ?? "0")
            }
            
            messageResult = "Response: \nStatus: \(responseCode)\nTransaction Type: \(response.transactionType ?? "") \nAmount: \(String(format: "%.2f", response.approvedAmount.doubleValue))\nSurchargeAmount: \(String(format: "%.2f", surchargeAmount.doubleValue))\nSurchargeFee: \(surchargeFee)%\n Issuer Resp.: \(issuerCode)\n Issuer Auth Data: \(issuerMSG)\nGW Code: \(GWCode)\nGW MSG: \(GWMSG) \(GWMSGSurcharge)"
            
            isApproved = true
        case let .CANCELLED(response):
            
            guard let deviceResponseMessage = response.deviceResponseMessage else { return }
            var issuerMSG = ""
            var authCode = ""
            if let responseIssuerMSG = response.issuerRspMsg {
                issuerMSG = responseIssuerMSG
            }
            
            if let authCodeResponse = response.issuerRspCode {
                authCode = authCodeResponse
            }
            
            if let respCode = response.responseCode {
                GWCode = respCode
            }
            
            if let respText = response.responseText {
                GWMSG = respText
            }
            
            messageResult = "Response: \nStatus: \(deviceResponseMessage)\nTransaction Type: \(response.transactionType ?? "") \nAmount: \(response.approvedAmount!)\n Auth Resp.: \(authCode)\n Issuer Auth Data: \(issuerMSG)\nGW Code: \(GWCode)\nGW MSG: \(GWMSG)"
            isApproved = false
        case let .DECLINED(response):
            guard let deviceResponseMessage = response.deviceResponseMessage else { return }
            var issuerMSG = ""
            var issuerCode = ""
            if let responseIssuerMSG = response.issuerRspMsg {
                issuerMSG = responseIssuerMSG
            }
            if let authCodeResponse = response.authCodeData {
                issuerCode = authCodeResponse
            }
            
            if let respCode = response.responseCode {
                GWCode = respCode
            }
            
            if let respText = response.responseText {
                GWMSG = respText
            }
            
            messageResult = "Response: \nStatus: \(deviceResponseMessage)\nTransaction Type: \(response.transactionType ?? "") \nAmount: \(response.approvedAmount)\n Auth Resp.: \(issuerCode)\n Issuer Auth Data: \(issuerMSG)\nGW Code: \(GWCode)\nGW MSG: \(GWMSG)"
            isApproved = false
        case let .MESSAGE(message):
            messageResult = message
        }
        showTextDialog(messageResult, isApproved)
    }
}

// MARK: - Internal Enums

public enum Status {
    case APPROVED(response: HpsTerminalResponse)
    case CANCELLED(response: HpsTerminalResponse)
    case DECLINED(response: HpsTerminalResponse)
    case MESSAGE(message: String)
}

public enum LoadingStatus: String {
    case WAIT = "PLEASE WAIT..."
    case CONNECTING = "Connecting to C2X Device..."
    case WAITING_FOR_CARD = "WAITING FOR CARD..."
    case PROCESSING = "PROCESSING..."
    case CANCELLED
    case DECLINED
    case COMPLETED
    case ERROR
    case TERMINATED
    case PARTIAL_APPROVAL = "PARTIAL APPROVAL"
    case APPROVAL
    case DEVICE_NOT_CONNECTED_ALERT = "You must have a connected device to proceed."
    case NOT_TRANSACTION_ID = "You Must have a valid Transaction ID for this action."
    case CONNECTED_DEVICE = "Device connected."
    case DEVICE_NOT_CONNECTED = "Device not connected."
    case AMOUNT_SHOULD_BE_LARGER_THAN_ZERO = "You must inform an amount to proceed."
    case NEW_VERSION_AVAILABLE = "New Version Available"
    case YOU_ARE_UPDATED = "You're updated!"
    case OK_BUTTON = "Ok"
    case PROGRESS = "\nProgress: "
    case MESSAGE_FIRMWARE_ALREADY_UPDATED = "Your device firmware version is: %@.\nWe have a new firmware version availabe: %@.\nHit 'Update Firmware' to start the process."
    case YOU_ALREADY_HAVE_LAST_UPDATED_VERSION = "You're already have the last version: %@."
    case TAKING_TOO_MUCH_TO_RESPOND = "The server is taking too long to respond. Try again later."
    case SUCCESS_UPDATED = "Updated! Please, wait a few seconds. Device will be restarted."
    case YOUVE_GOT_IT_TITLE = "Yes!"
    case SOMETHING_WENT_WRONG = "Something wen wrong. Please, try update it again."
    case AMOUNT_SHOULD_BE_HIGHER_THAN_HEALTHCARE_TOTAL = "Transaction Amount should be higher than healthcare total."
    
}

extension UIViewController {
    func showTextDialog(title: String = "Transaction Completed",
                        _ message: String, _ success: Bool = false) {
        let uialert = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: UIAlertController.Style.alert)
        uialert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        present(uialert, animated: true, completion: nil)
    }
    
    func showTextDialogWith(_ title: String = "Transaction Completed", _ message: String, _ success: Bool = false) {
        let uialert = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: UIAlertController.Style.alert)
        uialert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        present(uialert, animated: true, completion: nil)
    }
}


extension C2XTransactionsViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let allowedCharacters = CharacterSet(charactersIn: "0123456789.,")
            let characterSet = CharacterSet(charactersIn: string)

            
            if !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }

            
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)

            
            let decimalSeparator = "."
            let decimalCount = newText.components(separatedBy: decimalSeparator).count - 1
            if decimalCount > 1 {
                return false
            }

            
            if let decimalSeparatorIndex = newText.firstIndex(of: Character(decimalSeparator)) {
                let decimalPart = newText[newText.index(after: decimalSeparatorIndex)...]
                if decimalPart.count > 2 {
                    return false
                }
            }

            return true
        }
}
