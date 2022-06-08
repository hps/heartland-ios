//
//  BaseTransactionViewController.swift
//  Heartland-iOS-SDK
//
//  Created by Todd Lahtinen on 8/12/20.
//  Copyright (c) 2020 GlobalPayments. All rights reserved.
//

import UIKit
import GlobalMobileSDK

class BaseTransactionViewController: BaseViewController {

    private let cardHolderNameID = 300
    private let cardnumberID = 301
    private let cvcID = 302
    private let expirationID = 303
    private let postalCodeID = 304
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showManualCardDialogue(_ completion: @escaping (_ manualCard: ManualCardData?) -> Void) {
        let alert = UIAlertController.init(title: "Manual Entry", message: nil, preferredStyle: .alert)
        alert.addTextField() { [unowned self] handler in
            handler.tag = self.cardHolderNameID
            handler.placeholder = "Cardholder Name"
            handler.text = " Test Cardholder Name"
        }
        alert.addTextField() { [unowned self] handler in
            handler.tag = self.cardnumberID
            handler.placeholder = "card Number (4111111111111111)"
            handler.text = "4111111111111111"
        }
        alert.addTextField() { [unowned self] handler in
            handler.tag = self.expirationID
            handler.placeholder = "experation (1222)"
            handler.text = "1222"
        }
        alert.addTextField() { [unowned self] handler in
            handler.tag = self.cvcID
            handler.placeholder = "Security code (999)"
            handler.text = "999"
        }
        alert.addTextField() { [unowned self] handler in
            handler.tag = self.postalCodeID
            handler.placeholder = "Postal Code (90210)"
            handler.text = "90210"
        }
        
        alert.addAction(.init(title: "cancel", style: .cancel, handler: { _ in
            alert.dismiss(animated: true) {
                completion(nil)
            }
        }))
        alert.addAction(.init(title: "submit - card present", style: .default, handler: { _ in
            alert.dismiss(animated: true) {
                let nameTextField = alert.view.viewWithTag(self.cardHolderNameID) as! UITextField
                let cardnumberTextField = alert.view.viewWithTag(self.cardnumberID) as! UITextField
                let experationTextField = alert.view.viewWithTag(self.expirationID) as! UITextField
                let cvcTextField = alert.view.viewWithTag(self.cvcID) as! UITextField
                let postalCode = alert.view.viewWithTag(self.postalCodeID) as! UITextField
                var cardData = ManualCardData.cardData(cardholderName: nameTextField.text ?? "", cardNumber: cardnumberTextField.text ?? "", expirationDate: experationTextField.text ?? "", cvv: cvcTextField.text ?? "", cardPresent: true, readerPresent: true, terminalType: .none)
                
                if !(postalCode.text?.isEmpty ?? false) {
                    var address = Address()
                    address.postalCode = postalCode.text
                    cardData.cardHolderAddress = address
                }
                completion(cardData)
            }
        }))
        alert.addAction(.init(title: "submit - card not present", style: .default, handler: { _ in
            alert.dismiss(animated: true) {
                let nameTextField = alert.view.viewWithTag(self.cardHolderNameID) as! UITextField
                let cardnumberTextField = alert.view.viewWithTag(self.cardnumberID) as! UITextField
                let experationTextField = alert.view.viewWithTag(self.expirationID) as! UITextField
                let cvcTextField = alert.view.viewWithTag(self.cvcID) as! UITextField
                let postalCode = alert.view.viewWithTag(self.postalCodeID) as! UITextField
                var cardData = ManualCardData.cardData(cardholderName: nameTextField.text ?? "", cardNumber: cardnumberTextField.text ?? "", expirationDate: experationTextField.text ?? "", cvv: cvcTextField.text ?? "", cardPresent: false, readerPresent: false, terminalType: .none)
                
                if !(postalCode.text?.isEmpty ?? false) {
                    var address = Address()
                    address.postalCode = postalCode.text
                    cardData.cardHolderAddress = address
                }
                completion(cardData)
            }
        }))
        DispatchQueue.main.async { [unowned self] in
            self.present(alert, animated: true, completion: nil)
        }
    }
}
