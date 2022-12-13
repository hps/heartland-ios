//
//  C2XFirmwareUpdateViewController.swift
//  Heartland-iOS-SDK-SampleApp
//
//  Created by Renato Santos on 13/12/2022.
//

import Foundation
import UIKit
import Heartland_iOS_SDK

class C2XFirmwareUpdateViewController: UIViewController {
    
    var device: HpsC2xDevice? {
        didSet {
            self.device?.otaFirmwareUpdateDelegate = self
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var updateFirmwareButton: UIButton!
    
    
    // MARK: - Actions
    
    @IBAction func updateFimwareTappedButton(_ sender: Any) {
        self.device?.requestUpdateVersionForC2X()
    }
}

extension C2XFirmwareUpdateViewController: GMSDeviceFirmwareUpdateDelegate {
    func onTerminalVersionDetails(info: [AnyHashable : Any]?) {
        print("Info: \(info)")
    }
    
    func terminalOTAResult(info: [String : AnyObject]?, error: Error?) {
        print("terminalOTAResult: \(info) - \(error)")
    }
    
    func listOfVersionsFor(results: [Any]?) {
        print("listOfVersionsFor: \(results)")
    }
    
    func otaUpdateProgress(percentage: Float) {
        print("otaUpdateProgress: \(percentage)")
    }
    
    func onReturnSetTargetVersion(message: String) {
        print("onReturnSetTargetVersion: \(message)")
    }
}
