//
//  UpaTransactionsViewController.swift
//  Heartland-iOS-SDK-SampleApp
//
//  Created by Francis Legaspi on 2023-06-23.
//

import Foundation
import Heartland_iOS_SDK

class UpaTransactionsViewController: UIViewController {
    
    @IBOutlet private weak var ipAddressTextField: UITextField!
    @IBOutlet private weak var amountTextField: UITextField!
    @IBOutlet private weak var voidButton: UIButton!
    @IBOutlet private weak var upaSignatureDataButton: UIButton!
    
    private var previousTranNo: String?
    
    var upaTransaction: UpaTransactionProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(
            UITapGestureRecognizer.init(target: self, action: #selector(self.dismissKeyboard))
        )
        
        self.voidButton.isEnabled = false
        self.upaSignatureDataButton.isHidden = (upaTransaction is PayAppCanadaTransaction) ? true : false
    }
    
    // MARK: - Actions
    @IBAction func onSaleButtonClicked(_ sender: UIButton) {
        print("onSaleButtonClicked")
        if self.validateTextField() {
            self.upaTransaction.onSaleTransaction(ipAddress: ipAddressTextField.text!,
                                                  amount: amountTextField.text!, completion: { [weak self] transNo in
                self?.previousTranNo = transNo
                
                self?.voidButton.isEnabled = (self!.previousTranNo == nil) ? false : true
            })
        }
    }
    
    @IBAction func onRefundButtonClicked(_ sender: UIButton) {
        print("onRefundButtonClicked")
        if self.validateTextField() {
            self.upaTransaction.onRefundTransaction(ipAddress: ipAddressTextField.text!,
                                                    amount: amountTextField.text!)
        }
    }
    
    @IBAction func onVoidButtonClicked(_ sender: UIButton) {
        print("onVoidButtonClicked")
        if self.validateTextField() {
            self.upaTransaction.onVoidTransaction(ipAddress: ipAddressTextField.text!, tranNo: self.previousTranNo)
            self.previousTranNo = nil
        }
    }
    
    @IBAction func onSignatureDataButtonClicked(_ sender: UIButton) {
        if let upaUsaTransaction = self.upaTransaction as? UpaUSATransaction, self.validateTextField() {
            print("onSignatureDataButtonClicked")
            upaUsaTransaction.onSignatureDataTransaction(ipAddress: ipAddressTextField.text!)
        }
    }
    
    @IBAction func onSendSAFButtonClicked(_ sender: UIButton) {
        if self.validateTextField() {
            print("onSendSAFButtonClicked")
            self.upaTransaction.onSendSAFTransaction(ipAddress: ipAddressTextField.text!)
        }
        
        
    }
    
    @IBAction func onGetSAFButtonClicked(_ sender: UIButton) {
        if self.validateTextField() {
            print("onGetSAFButtonClicked")
            self.upaTransaction.onGetSAFReportTransaction(ipAddress: ipAddressTextField.text!)
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    private func validateTextField() -> Bool {
        self.dismissKeyboard()
        
        var requiredFields: String = ""

        if let text = self.ipAddressTextField?.text, text.isEmpty { requiredFields += "IP Address\n" }
        if let text = self.amountTextField.text, text.isEmpty { requiredFields += "Amount\n" }
        
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
