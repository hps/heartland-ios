//
//  ConnectC2XViewController.swift
//

import Foundation
import UIKit
import Heartland_iOS_SDK
import CoreBluetooth

class ConnectC2XViewController: UIViewController {
    
    private var device: HpsC2xDevice?
    
    @IBOutlet var connectionLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func scanButtonPressed() {
        let config = HpsConnectionConfig()
        config.username = ""
        config.password = ""
        config.siteID = ""
        config.deviceID = ""
        config.licenseID = "372711"
        config.developerID = "002914"
        config.versionNumber = "3409"
        
        self.device = HpsC2xDevice(config: config)
        self.device?.deviceDelegate = self
        self.device?.scan()
        self.activityIndicator.isHidden = false
    }
}

extension ConnectC2XViewController: HpsC2xDeviceDelegate {
    func onConnected() {
        self.connectionLabel.text = "Connected"
    }
    
    func onDisconnected() {
        self.connectionLabel.text = "Disconnected"
    }
    
    func onError(_ deviceError: NSError) {
        self.connectionLabel.text = "Error"
    }
    
    func onBluetoothDeviceList(_ peripherals: NSMutableArray) {
        
        let alertController = UIAlertController(title: "Devices", message: "Please select a device to connect", preferredStyle: .actionSheet)
        
        for peripheral in peripherals {
            if let peripheral = peripheral as? HpsTerminalInfo {
                let action = UIAlertAction(title: peripheral.name, style: .default) { [weak self] _ in
                    self?.device?.connectDevice(peripheral)
                }
                alertController.addAction(action)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
        
        self.activityIndicator.isHidden = true
    }
}
