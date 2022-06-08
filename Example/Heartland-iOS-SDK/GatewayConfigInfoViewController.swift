//
//  GatewayConfigInfoViewController.swift
//  Heartland-iOS-SDK
//

import UIKit

class GatewayConfigInfoViewController: BaseViewController {
    
    // MARK: IBOutlets
    @IBOutlet private(set) weak var saveButton: UIButton!
    
    // MARK: IBActions
    @IBAction func savePressed(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}

