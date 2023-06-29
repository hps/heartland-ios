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

class C2XTransactionsViewController: UIViewController {
    // MARK: Outlets
    
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var creditSaleButton: UIButton!
    @IBOutlet weak var manualCardTransactionButton: UIButton!
    @IBOutlet weak var tipAdjustButton: UIButton!
    @IBOutlet weak var creditReturnButton: UIButton!
    @IBOutlet weak var creditVoidButton: UIButton!
    @IBOutlet weak var reversalTransactionButton: UIButton!
    @IBOutlet weak var authTransaction: UIButton!
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var gratuityTextField: UITextField!
    
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
    
    var transactionId: String? {
        didSet {
            if let transactionId = self.transactionId, transactionId.count > 0 {
                checkForMainTransaction()
            }
        }
    }
    var transactionAmount: NSDecimalNumber = 0.0

    // MARK: - LifeCycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addObserver()
        configureView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureActions()
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
        if let device = device {
            showProgress(true)
            setText(LoadingStatus.WAIT.rawValue)
            let amountNumber = NSDecimalNumber(string: amountText)
            let builder = HpsC2xCreditSaleBuilder(device: device)
            builder.amount = amountNumber
            builder.clientTransactionId = "123456789"
            builder.allowPartialAuth = false
            builder.cpcReq = true
            
            let autoSubstantiation = HpsAutoSubstantiation()
            autoSubstantiation.setClinicSubTotal(NSDecimalNumber(string: "1.10"))
            
            builder.autoSubstantiation = autoSubstantiation
            
            if let cTransactionId = builder.clientTransactionId {
                NSLog("Client Transaction Id Generated In The Client - Request  %@", cTransactionId)
            }
            builder.execute()
        } else {
            showTextDialog(LoadingStatus.DEVICE_NOT_CONNECTED_ALERT.rawValue)
        }
    }

    @objc func manualTransactionButtonAction(_: UIButton) {
        if let device = device {
            showProgress(true)
            setText(LoadingStatus.WAIT.rawValue)

            let card = HpsCreditCard()
            card.cardNumber = "374245001751006"
            card.expMonth = 12
            card.expYear = 2024
            card.cvv = "201"

            let amountString = NSDecimalNumber(string: amountTextField.text)
            let builder = HpsC2xCreditAuthBuilder(device: device)
            builder.amount = amountString
            builder.creditCard = card
            builder.execute()
        } else {
            showTextDialog(LoadingStatus.DEVICE_NOT_CONNECTED_ALERT.rawValue)
        }
    }

    @objc func creditVoidTransactionButtonAction(_: UIButton) {
        if let device = device {
            showProgress(true)
            setText(LoadingStatus.WAIT.rawValue)

            if let transactionId = transactionId {
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
            builder.transactionId = self.transactionId
            print("Transaction ID coming from response is: \(builder.transactionId)")
            builder.clientTransactionId = "02997841500"
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
            showProgress(true)
            setText(LoadingStatus.WAIT.rawValue)
            
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
            builder.gratuity = 0.00
            builder.creditCard = card
            if let cTransactionId = builder.clientTransactionId {
                NSLog("Client Transaction Id Generated In The Client - Request  %@", cTransactionId)
            }
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
            builder.allowPartialAuth = true
            
            if let cTransactionId = builder.clientTransactionId {
                NSLog("Client Transaction Id Generated In The Client - Request  %@", cTransactionId)
            }
            builder.execute()
        } else {
            showTextDialog(LoadingStatus.DEVICE_NOT_CONNECTED_ALERT.rawValue)
        }
    }
    
    func captureAuthTransaction() {
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
            builder.transactionId = self.transactionId
            builder.execute()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
               /// Forcing the timeout in order to test the reversal
                self.reversalAuthTransaction()
            }
            
        } else {
            showTextDialog(LoadingStatus.DEVICE_NOT_CONNECTED_ALERT.rawValue)
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

        if let responseTransactionId = response.transactionId {
            
            self.terminalRefNumber = response.terminalRefNumber
            self.clientTransactionId = response.clientTransactionId
            self.transactionId = responseTransactionId
        }

        if let cTransactionId = response.clientTransactionId {
            NSLog("Client Transaction Id Generated In The Client - Response %@", cTransactionId)
        }

        if let deviceResponseCode = response.deviceResponseCode {
            switch deviceResponseCode {
            case LoadingStatus.APPROVAL.rawValue:
                showDialog(for: .APPROVED(response: response))
            case LoadingStatus.DECLINED.rawValue:
                showDialog(for: .DECLINED(response: response))
            case LoadingStatus.CANCELLED.rawValue:
                showDialog(for: .CANCELLED(response: response))
            default:
                showDialog(for: .MESSAGE(message: deviceResponseCode))
            }
        }

        showProgress(false)
    }

    func onTransactionCancelled() {
        showProgress(false)
    }

    func onTransactionError(_: NSError) {
        showProgress(false)
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
        switch status {
        case let .APPROVED(response):
            guard let responseCode = response.deviceResponseCode else { return }
            var issuerMSG = ""
            var authCode = ""
            if let responseIssuerMSG = response.issuerRspMsg {
                issuerMSG = responseIssuerMSG
            }
            if let authCodeResponse = response.authCodeData {
                authCode = authCodeResponse
            }
            print("Auth Resp.: \(authCode) - Issuer Auth Data: \(issuerMSG)")
            messageResult = "Response: \nStatus: \(responseCode)\n Amount: \(response.approvedAmount!)\n Auth Resp.: \(authCode)\n Issuer Auth Data: \(issuerMSG)"
            isApproved = true
        case let .CANCELLED(response):
            guard let deviceResponseMessage = response.deviceResponseMessage else { return }
            var issuerMSG = ""
            var authCode = ""
            if let responseIssuerMSG = response.issuerRspMsg {
                issuerMSG = responseIssuerMSG
            }
            if let authCodeResponse = response.authCodeData {
                authCode = authCodeResponse
            }
            print("Auth Resp.: \(authCode) - Issuer Auth Data: \(issuerMSG)")
            messageResult = "Response: \nStatus: \(deviceResponseMessage)\n Amount: \(response.approvedAmount!)\n Auth Resp.: \(authCode)\n Issuer Auth Data: \(issuerMSG)"
            isApproved = false
        case let .DECLINED(response):
            guard let deviceResponseMessage = response.deviceResponseMessage else { return }
            var issuerMSG = ""
            var authCode = ""
            if let responseIssuerMSG = response.issuerRspMsg {
                issuerMSG = responseIssuerMSG
            }
            if let authCodeResponse = response.authCodeData {
                authCode = authCodeResponse
            }
            print("Auth Resp.: \(authCode) - Issuer Auth Data: \(issuerMSG)")
            messageResult = "Response: \nStatus: \(deviceResponseMessage)\n Amount: \(response.approvedAmount!)\n Auth Resp.: \(authCode)\n Issuer Auth Data: \(issuerMSG)"
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
}

extension UIViewController {
    func showTextDialog(_ message: String, _ success: Bool = false) {
        let uialert = UIAlertController(title: success ? "Yes!" : "Oops",
                                        message: message,
                                        preferredStyle: UIAlertController.Style.alert)
        uialert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        present(uialert, animated: true, completion: nil)
    }
}

extension C2XTransactionsViewController {
    func checkForMainTransaction() {
        switch mainTransaction {
        case .auth:
            captureAuthTransaction()
            break
        case .reversal:
            checkReversalResult()
            break
        default:
            ()
        }
    }
}

