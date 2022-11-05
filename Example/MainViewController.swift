//
//  MainViewController.swift
//

import UIKit
import Heartland_iOS_SDK

class MainViewController: UITableViewController {
    
    // MARK: Device
    private var device: HpsC2xDevice?
    
    // MARK: NotificationCenter
    let notificationCenter: NotificationCenter = NotificationCenter.default
    
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
}

// MARK: Segue

extension MainViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let transactionDestination = segue.destination as? ConnectC2XViewController {
            transactionDestination.device?.disconnectDevice()
        }
        
        if let transactionDestination = segue.destination as? C2XTransactionsViewController {
            transactionDestination.device = self.device
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
