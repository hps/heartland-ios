//
//  C2XTransactionsViewController.swift
//  Heartland-iOS-SDK_Example
//
//  Created by Renato Santos on 04/11/2022.
//  Copyright © 2022 Shaunti Fondrisi. All rights reserved.
//

import UIKit
import Heartland_iOS_SDK

class C2XTransactionsViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var creditSaleButton: UIButton!
    @IBOutlet weak var manualCardTransactionButton: UIButton!
    @IBOutlet weak var tipAdjustButton: UIButton!
    @IBOutlet weak var creditReturnButton: UIButton!
    @IBOutlet weak var creditVoidButton: UIButton!
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var gratuityTextField: UITextField!
    
    @IBOutlet weak var DialogView: UIView!
    @IBOutlet weak var dialogText: UILabel!
    @IBOutlet weak var dialogSpinner: UIActivityIndicatorView!
    
    // MARK: - Properties
    let notificationCenter: NotificationCenter = NotificationCenter.default
    var devicesFound: NSMutableArray = []
    var deviceList: HpsTerminalInfo?
    var device: HpsC2xDevice? {
        didSet {
            self.device?.transactionDelegate = self
        }
    }
    var isDeviceConnected: Bool = false
    var transactionId: String?
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
        self.DialogView.layer.cornerRadius = 10
        self.amountTextField.keyboardType = .decimalPad
        self.gratuityTextField.keyboardType = .decimalPad
        
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
        
    }
    
    @objc func selectedDevice(_ notification: Notification) {
        guard let notificationData = notification.userInfo as? [String: HpsC2xDevice] else { return }
        if let device = notificationData["selectedDevice"] {
            self.device = device
        }
    }
    
    @objc func creditSaleButtonAction(_ sender: UIButton) {
        guard let amountText = self.amountTextField.text, amountText.count > 0 else { showTextDialog(LoadingStatus.AMOUNT_SHOULD_BE_LARGER_THAN_ZERO.rawValue)
            return
        }
        if let device = self.device {
            showProgress(true)
            setText(LoadingStatus.WAIT.rawValue)
            let amountNumber = NSDecimalNumber(string: amountText)
            let builder: HpsC2xCreditSaleBuilder = HpsC2xCreditSaleBuilder(device: device)
            builder.amount = amountNumber
            builder.clientTransactionId = UUID().uuidString
            if let cTransactionId = builder.clientTransactionId {
                NSLog("Client Transaction Id Generated In The Client - Request  %@", cTransactionId)
            }
            builder.execute()
        } else {
            showTextDialog(LoadingStatus.DEVICE_NOT_CONNECTED_ALERT.rawValue)
        }
    }
    
    @objc func manualTransactionButtonAction(_ sender: UIButton) {
        if let device = self.device {
            showProgress(true)
            setText(LoadingStatus.WAIT.rawValue)
            
            let card: HpsCreditCard = HpsCreditCard()
            card.cardNumber = "374245001751006"
            card.expMonth = 12
            card.expYear = 2024
            card.cvv = "201"
            
            let amountString = NSDecimalNumber(string: self.amountTextField.text)
            let builder: HpsC2xCreditAuthBuilder = HpsC2xCreditAuthBuilder(device: device)
            builder.amount = amountString
            builder.creditCard = card
            builder.execute()
        } else {
            showTextDialog(LoadingStatus.DEVICE_NOT_CONNECTED_ALERT.rawValue)
        }
    }
    
    @objc func creditVoidTransactionButtonAction(_ sender: UIButton) {
        if let device = self.device {
            showProgress(true)
            setText(LoadingStatus.WAIT.rawValue)
            
            if let transactionId = self.transactionId {
                let builder: HpsC2xCreditSaleBuilder = HpsC2xCreditSaleBuilder(device: device)
                builder.transactionId = transactionId
                builder.amount = self.transactionAmount
                builder.execute()
            } else {
                showTextDialog(LoadingStatus.NOT_TRANSACTION_ID.rawValue)
            }
        } else {
            showTextDialog(LoadingStatus.DEVICE_NOT_CONNECTED_ALERT.rawValue)
        }
    }
    
    @objc func handleContainerViewTap() {
        self.view.endEditing(true)
    }
}

// MARK: C2X Delegate

extension C2XTransactionsViewController: HpsC2xDeviceDelegate, GMSTransactionDelegate, GMSClientAppDelegate {
    func onStatusUpdate(_ transactionStatus: HpsTransactionStatus) {
        var statusText: String = ""
        switch transactionStatus {
            
        case .waitingForCard, .presentCard, .presentCardAgain, .started:
            statusText = LoadingStatus.WAITING_FOR_CARD.rawValue
            break
        case .processing:
            statusText = LoadingStatus.PROCESSING.rawValue
            break
        case .complete:
            statusText = LoadingStatus.COMPLETED.rawValue
            showProgress(false)
            break
        case .error:
            statusText = LoadingStatus.ERROR.rawValue
            break
        case .terminalDeclined:
            statusText = LoadingStatus.DECLINED.rawValue
            break
        case .transactionTerminated:
            statusText = LoadingStatus.TERMINATED.rawValue
            break;
        default:
            statusText = LoadingStatus.PROCESSING.rawValue
            break
        }
        
        let isProcessing = statusText.contains(LoadingStatus.PROCESSING.rawValue)
        enableButtons(!isProcessing)
        setText(statusText)
    }
    
    func onConfirmAmount(_ amount: Decimal) {
        self.device?.confirmAmount(amount)
    }
    
    func onConfirmApplication(_ applications: Array<AID>) {
        self.device?.confirmApplication(applications[0])
    }
    
    func onTransactionComplete(_ response: HpsTerminalResponse) {
        if let responseAmount = response.approvedAmount {
            self.transactionAmount = responseAmount
        }
        
        if let responseStatus = response.status {
            print (" Status response: \(responseStatus)")
        }
        
        if let responseTransactionId = response.transactionId {
            self.transactionId = responseTransactionId
        }
        
        if let cTransactionId = response.clientTransactionId {
            NSLog("Client Transaction Id Generated In The Client - Response %@", cTransactionId)
        }
        
        if let deviceResponseCode = response.deviceResponseCode {
            switch deviceResponseCode {
            case LoadingStatus.APPROVAL.rawValue:
                showDialog(for: .APPROVED(response: response))
                break
            case LoadingStatus.DECLINED.rawValue:
                showDialog(for: .DECLINED(response: response))
                break
            case LoadingStatus.CANCELLED.rawValue:
                showDialog(for: .CANCELLED(response: response))
                break
            default:
                showDialog(for: .MESSAGE(message: deviceResponseCode))
                break
            }
        }
        
        showProgress(false)
    }
    
    func onTransactionCancelled() {
        showProgress(false)
    }
    
    func onTransactionError(_ error: NSError) {
        showProgress(false)
    }
    
    func onError(_ error: NSError) {
        self.device?.onError(error)
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
    
    func deviceFound(_ device: NSObject) {
        print(" deviceFound ")
    }
    
    func onStatus(_ status: HpsTransactionStatus) {
        let statusText = "\(status.rawValue)".uppercased()
        setText(statusText)
        self.device?.onStatus(status)
    }
    
    func requestAIDSelection(_ applications: Array<AID>) {
        print(" requestAIDSelection ")
    }
    
    func requestAmountConfirmation(_ amount: Decimal) {
        print(" requestAmountConfirmation ")
    }
    
    func requestPostalCode(_ maskedPan: String, expiryDate: String, cardholderName: String) {
        print(" requestPostalCode ")
    }
    
    func requestSaFApproval() {
        print(" requestSaFApproval ")
    }
    
    func onTransactionComplete(_ result: String, response: HpsTerminalResponse) {
        self.device?.onTransactionComplete(result, response: response)
        showProgress(false)
    }
    
    func onConnected() {
        setStatus(LoadingStatus.CONNECTED_DEVICE.rawValue)
        self.device?.transactionDelegate = self
        self.isDeviceConnected = true
        enableButtons(self.isDeviceConnected)
        showProgress(false)
    }
    
    func onDisconnected() {
        setStatus(LoadingStatus.DEVICE_NOT_CONNECTED.rawValue)
        self.isDeviceConnected = false
        enableButtons(self.isDeviceConnected)
    }
    
    func onBluetoothDeviceList(_ peripherals: NSMutableArray) {
        if peripherals.count == 0 {
            return;
        }
        self.devicesFound = NSMutableArray()
        
        for (index, _) in peripherals.enumerated() {
            if let tInfo = peripherals[index] as? HpsTerminalInfo {
                self.deviceList = tInfo
                self.device?.stopScan()
                self.device?.connectDevice(tInfo)
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
    func setText(_ text:String) {
        DispatchQueue.main.async {
            self.dialogText.text = text
            self.dialogSpinner.startAnimating()
            self.setStatus(text)
        }
    }
    
    func showProgress(_ show: Bool) {
        self.DialogView.isHidden = !show
        if show {
            self.dialogSpinner.startAnimating()
        } else {
            self.dialogSpinner.stopAnimating()
        }
    }
    
    func setStatus(_ text: String) {
        DispatchQueue.main.async {
            self.labelStatus.text = text
        }
    }
    
    private func showDialog(for status: Status) {
        var messageResult: String = ""
        var isApproved: Bool = false
        switch status {
        case .APPROVED(let response):
            messageResult = "Response: \nStatus: \(response.deviceResponseCode!)\n Amount: \(response.approvedAmount!)\n"
            isApproved = true
            break
        case .CANCELLED(let response):
            guard let statusResponse = response.deviceResponseCode else { return }
            guard let deviceResponseMessage = response.deviceResponseMessage else { return }
            messageResult = "Response: \nStatus: \(statusResponse)\n Message: \(deviceResponseMessage)\n"
            isApproved = false
            break
        case .DECLINED(let response):
            guard let declinedMessage = response.deviceResponseMessage else { return }
            messageResult = "Response: \nStatus: \(response.deviceResponseCode!)\n Message: \(declinedMessage)\n"
            isApproved = false
            break
        case .MESSAGE(let message):
            messageResult = message
        }
        showTextDialog(messageResult, isApproved)
    }
    
    func showTextDialog(_ message: String, _ success: Bool = false) {
        let uialert = UIAlertController(title: success ? "Yes!" : "Oops",
                                        message: message,
                                        preferredStyle: UIAlertController.Style.alert)
        uialert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(uialert, animated: true, completion: nil)
    }
}

// MARK: - Internal Enums

private extension C2XTransactionsViewController {
    enum Status {
        case APPROVED(response: HpsTerminalResponse)
        case CANCELLED(response: HpsTerminalResponse)
        case DECLINED(response: HpsTerminalResponse)
        case MESSAGE(message: String)
    }
    
    enum LoadingStatus: String {
        case WAIT = "PLEASE WAIT..."
        case CONNECTING = "Connecting to C2X Device..."
        case WAITING_FOR_CARD = "WAITING FOR CARD..."
        case PROCESSING = "PROCESSING..."
        case CANCELLED = "CANCELLED"
        case DECLINED = "DECLINED"
        case COMPLETED = "COMPLETED"
        case ERROR = "ERROR"
        case TERMINATED = "TERMINATED"
        case APPROVAL = "APPROVAL"
        case DEVICE_NOT_CONNECTED_ALERT = "You must have a connected device to proceed."
        case NOT_TRANSACTION_ID = "You Must have a valid Transaction ID for this action."
        case CONNECTED_DEVICE = "Device connected."
        case DEVICE_NOT_CONNECTED = "Device not connected."
        case AMOUNT_SHOULD_BE_LARGER_THAN_ZERO = "You must inform an amount to proceed."
    }
}

