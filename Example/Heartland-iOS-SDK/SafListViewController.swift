//
//  SafListViewController.swift
//  Heartland-iOS-SDK
//
//  Created by Rishil Patel on 11/10/20.
//  Copyright © 2020 GlobalPayments. All rights reserved.
//

import UIKit
import GlobalMobileSDK

class SafListViewController: BaseViewController {
    
    // MARK: IBOutlets
    @IBOutlet private(set) weak var safListTableView: UITableView!
    
    private var alert: UIAlertController? = nil
    private var searchAlert: UIAlertController?
    private var storedTransactions = [Transaction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Stored Transactions"
        
        safListTableView.tableFooterView = UIView()
        
        GMSManager.shared.listSaF(delegate: self)
    }
}

// MARK: UITableViewDelegate
extension SafListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let processSaf = storedTransactions[indexPath.row] as? ProcessSaF else {
            return
        }
        
        let alert = UIAlertController(title: "Process SaF",
                                      message: "Are you sure you want to process this transaction?",
                                      preferredStyle: .alert)
        alert.addAction(.init(title: "YES", style: .default, handler: { [unowned self] _ in
            GMSManager.shared.start(transaction: processSaf, entryModes: EntryMode.allCases, delegate: self)
        }))
        
        alert.addAction(.init(title: "NO", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        showAlert(alert: alert)
    }
}

// MARK: UITableViewDataSource
extension SafListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if storedTransactions.count > 0 {
            tableView.removeNoDataPlaceholder()
            return 1
        } else {
            tableView.setNoDataPlaceholder("No transactions found.")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storedTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: SaFListTableViewCell = tableView.dequeueReusableCell(withIdentifier: SaFListTableViewCell.reusableIdentifier) as? SaFListTableViewCell else {
            return SaFListTableViewCell()
        }
        
        guard let processSaf = storedTransactions[indexPath.row] as? ProcessSaF else {
            return cell
        }
           
        cell.setupUI(from: processSaf)
        
        return cell
    }
}

extension SafListViewController: TransactionDelegate {

    func requestPostalCode(maskedPan: String,
                           expiryDate: String,
                           cardholderName: String?) {
        fatalError("It shouldn't get called here.")
    }

    func onState(state: TransactionState) {
        //
    }
    
    func requestAIDSelection(aids: [AID]) {
        //
    }
    
    func requestAmountConfirmation(amount: Decimal?) {
        //
    }
    
    func requestSaFApproval() {
        //
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
    
    func onTransactionComplete(result: TransactionResult, response: TransactionResponse?) {
        guard let response = response else {
            let alert = UIAlertController(title: "Result",
                                          message: "\(result)",
                                          preferredStyle: .alert)
            alert.addAction(.init(title: "ok", style: .default, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            showAlert(alert: alert)
            
            return
        }
        
        ScreenSequence.showTransactionResponse(for: response)
    }
    
    func onListSaFComplete(transactions: [Transaction]) {
        storedTransactions = transactions
        safListTableView.reloadData()
    }
    
    func onTransactionCancelled() {
        print("Transaction Cancelled")
    }
    
    func onError(error: TransactionError) {
        showError("\(error)")
    }
    
    fileprivate func showError(_ error: String) {
        let alert = UIAlertController.init(title: "Error",
                                           message: "\(error)",
                                           preferredStyle: .alert)
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
}

extension UITableView {
    func setNoDataPlaceholder(_ message: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        label.text = message
        label.textAlignment = NSTextAlignment.center
        
        self.backgroundView = label
        self.separatorStyle = .none
        self.isScrollEnabled = false
    }
    
    func removeNoDataPlaceholder() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
        self.isScrollEnabled = true
    }
}
