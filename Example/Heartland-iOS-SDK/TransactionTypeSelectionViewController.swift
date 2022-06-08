//
//  TransactionViewController.swift
//  Heartland-iOS-SDK
//

import UIKit
import os
import GlobalMobileSDK

class TransactionTypeSelectionViewController: BaseTransactionViewController {
    
    // MARK: Variables
    var transactionType: TransactionType?
    let transactionsArray: [TransactionType] =  TransactionType.allCases
    private var searchAlert: UIAlertController?
    
    // MARK: IBOutlets
    @IBOutlet private(set) weak var transactionTableView: UITableView!
    @IBOutlet weak var connectionIndicator: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var disconnectButton: UIButton!
    @IBOutlet weak var manualCardToggle: UISwitch!
    @IBOutlet weak var quickChipToggle: UISwitch!
    @IBOutlet weak var progressContainerView: UIVisualEffectView!
    @IBOutlet weak var progressLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // This will remove extra separators
        transactionTableView.tableFooterView = UIView()
        connectionIndicator.layer.cornerRadius = connectionIndicator.frame.height / 2
        progressContainerView.isHidden = true

        if UserDefaults.currentGatewayConfig!.terminalType == .none {
            connectionIndicator.backgroundColor = .systemGray
            connectButton.isEnabled = false
            disconnectButton.isEnabled = false
            manualCardToggle.setOn(true, animated: true)
            manualCardToggle.isEnabled = false
            searchButton.isEnabled = false
        } else {
            if GMSManager.shared.terminalConnected {
                connectionIndicator.backgroundColor = .systemGreen
            } else {
                connectionIndicator.backgroundColor = .systemRed
                GMSManager.shared.connect(terminalInfo: UserDefaults.currentTerminalInfo!, delegate: self)
            }
            searchButton.isEnabled = true
            connectButton.isEnabled = !GMSManager.shared.terminalConnected
            disconnectButton.isEnabled = GMSManager.shared.terminalConnected
        }
    }
    
    @IBAction func disconnect(_ sender: Any) {
        GMSManager.shared.disconnect()
    }
    
    @IBAction func connect(_ sender: UIButton) {
        GMSManager.shared.connect(terminalInfo: UserDefaults.currentTerminalInfo!, delegate: self)
    }
    
    @IBAction func searchDevices(_ button: UIButton) {
        if presentedViewController != nil {
            dismiss(animated: false, completion: nil)
        }

        searchAlert = UIAlertController(title: "Search", message: nil, preferredStyle: .alert)
        searchAlert?.addAction(.init(title: "Cancel", style: .cancel, handler: { [unowned self] _ in
            GMSManager.shared.cancelSearch()
            self.searchAlert?.dismiss(animated: true, completion: nil)
        }))
        present(searchAlert!, animated: true) {
            GMSManager.shared.search(delegate: self)
        }
    }
}

extension TransactionTypeSelectionViewController: SearchDelegate {
    func deviceFound(terminalInfo: TerminalInfo) {
        searchAlert?.addAction(.init(title: terminalInfo.name, style: .default, handler: { [unowned self] _ in
            GMSManager.shared.cancelSearch()
            UserDefaults.currentTerminalInfo = terminalInfo
            self.searchAlert?.dismiss(animated: true)
        }))
    }
    
    func onSearchComplete() {
        if #available(iOS 12.0, *) {
            os_log(.debug, "search complete", [])
        } else {
            print("search complete")
        }
    }
    
    func onError(error: SearchError) {
        fatalError("Not implemented yet")
    }
}

// MARK: UITableViewDelegate
extension TransactionTypeSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = transactionsArray[indexPath.row]
        
        switch type {
        case .ListSaf:
            navigationController?.pushViewController(SafListViewController.instantiate()!, animated: true)
        default:
            if manualCardToggle.isOn {
                showManualCardDialogue { data in
                    guard let data = data else {
                        return
                    }
                    
                    ScreenSequence.startTransaction(for: type, manualCardData: data)
                }
            } else {
                ScreenSequence.startTransaction(for: type, manualCardData: nil, quickChipEnabled: quickChipToggle.isOn)
            }
        }
    }
}

// MARK: UITableViewDataSource
extension TransactionTypeSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") else { return UITableViewCell() }
        cell.textLabel?.text = transactionsArray[indexPath.row].rawValue
        
        return cell

    }
}

extension TransactionTypeSelectionViewController: ConnectionDelegate {
    func onConnected(terminalInfo: TerminalInfo) {
        UserDefaults.currentTerminalInfo = terminalInfo
        connectButton.isEnabled = false
        disconnectButton.isEnabled = true
        connectionIndicator.backgroundColor = .systemGreen
    }
    
    func onDisconnected(terminalInfo: TerminalInfo) {
        UserDefaults.currentTerminalInfo = terminalInfo
        connectButton.isEnabled = true
        disconnectButton.isEnabled = false
        connectionIndicator.backgroundColor = .systemRed
    }

    
    
    func configuringTerminal(state: TransactionState) {
        if state == .ready {
            progressContainerView.isHidden = true
        } else {
            progressContainerView.isHidden = false
        }

        progressLabel.text = "\(state)"
    }
    
    func onError(error: ConnectionError) {
        let alert = UIAlertController(title: "Connection Error", message: "\(error)", preferredStyle: .alert)
        alert.addAction(.init(title: "ok", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
}
