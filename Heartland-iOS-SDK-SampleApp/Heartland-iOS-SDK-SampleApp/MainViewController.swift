//
//  MainViewController.swift
//

import Heartland_iOS_SDK
import UIKit
import SwiftUI

class MainViewController: UITableViewController {
    // MARK: Device
    
    private var device: HpsC2xDevice?
    private var mobyDevice: HpsMobyDevice?
    private var isTransactioning: Bool = false
    
    
    // MARK: NotificationCenter
    
    let notificationCenter: NotificationCenter = .default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObserver()
    }
    
    func addObserver() {
        let notificationName = Notification.Name(Constants.selectedDeviceNotification)
        notificationCenter.addObserver(self,
                                       selector: #selector(selectedDevice),
                                       name: notificationName,
                                       object: nil)
    }
    
    @IBSegueAction func showSwiftUIComponentView(_ coder: NSCoder) -> UIViewController? {
//        return UIHostingController(coder: coder,
//                                   rootView: MobyDevicesView())
        
        let alert = UIAlertController(title: "Not Implemented Yet",
                                          message: "This feature will be available soon.",
                                          preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        if let topController = UIApplication.shared.windows.first?.rootViewController {
            topController.present(alert, animated: true, completion: nil)
        }
        
        return nil
    }
    
    @IBSegueAction func showTransactionsComponentView(_ coder: NSCoder) -> UIViewController? {
//        return UIHostingController(coder: coder,
//                                   rootView: MobyTransactionsView())
        
        let alert = UIAlertController(title: "Not Implemented Yet",
                                          message: "This feature will be available soon.",
                                          preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        if let topController = UIApplication.shared.windows.first?.rootViewController {
            topController.present(alert, animated: true, completion: nil)
        }
        
        return nil
    }
    
}

// MARK: Segue

extension MainViewController {
    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if let transactionDestination = segue.destination as? ConnectC2XViewController {
            transactionDestination.device = device
        }
        
        if let transactionDestination = segue.destination as? C2XTransactionsViewController {
            transactionDestination.device = device
        }
        
        if let transactionDestination = segue.destination as? C2XFirmwareUpdateViewController {
            transactionDestination.device = device
        }
        
        if let transactionDestination = segue.destination as? UpaTransactionsViewController,
           let selectedRowIndexPath = self.tableView.indexPathForSelectedRow,
           let selectedCell = self.tableView.cellForRow(at: selectedRowIndexPath) {
            
            transactionDestination.upaTransaction = (selectedCell.tag == 1010) ? UpaUSATransaction() : PayAppCanadaTransaction()
            transactionDestination.title = (selectedCell.tag == 1010) ? "UPA USA Transactions" : "PayApp Canada Transactions"
        }
    }
}

private extension MainViewController {
    @objc func selectedDevice(_ notification: Notification) {
        guard let notificationData = notification.userInfo as? [String: HpsC2xDevice] else { return }
        if let device = notificationData["selectedDevice"] {
            self.device = device
        }
    }
}

