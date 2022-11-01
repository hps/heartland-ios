//
//  ConnectC2XViewController.swift
//

import Foundation
import UIKit
import Heartland_iOS_SDK

class ConnectC2XViewController: UIViewController {
    @IBOutlet var connectionLabel: UILabel!
    
    @IBAction func scanButtonPressed() {
        let config = HpsConnectionConfig()
        config.username = ""
        config.password = ""
        config.siteID = ""
        config.deviceID = ""
        config.licenseID = "372711"
        config.developerID = "002914"
        config.versionNumber = "3409"
        
        let device = HpsC2xDevice(config: config)
        device.scan()
        
    }
    
    @IBAction func rescanButtonPressed() {
    }
}
