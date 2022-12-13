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
    
    var currentFirmwareVerion: String = "" {
        didSet {
            self.device?.getAllVersionsForC2X()
        }
    }
    
    var lastFirmwareVersion: String = "" {
        didSet {
            self.compareVersions()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var updateFirmwareButton: UIButton!
    
    
    // MARK: - Actions
    
    @IBAction func updateFimwareTappedButton(_ sender: Any) {
//        self.device?.requestUpdateVersionForC2X()
//        self.device?.getAllVersionsForC2X() - lIST OF VERSIONS. NEED TO SORT BY HIGHER AND CHECK IF WE ALREADY HAVE THAT VERSION.
        self.device?.requestTerminalVersionData()
    }
    
    func compareVersions() {
        let versionCompare = currentFirmwareVerion.compare(lastFirmwareVersion, options: .numeric)
        if versionCompare == .orderedAscending {
            self.device?.requestUpdateVersionForC2X()
        }
    }
}

extension C2XFirmwareUpdateViewController: GMSDeviceFirmwareUpdateDelegate {
    func onTerminalVersionDetails(info: [AnyHashable : Any]?) {
        if let info = info, let firmwareVersion = info["firmwareVersion"],
            let stringFirmwareVersion = firmwareVersion as? String {
            print("Info: \(stringFirmwareVersion)")
            self.currentFirmwareVerion = stringFirmwareVersion
        }
        
    }
    
    func terminalOTAResult(info: [String : AnyObject]?, error: Error?) {
        print("terminalOTAResult: \(info) - \(error)")
    }
    
    func listOfVersionsFor(results: [Any]?) {
        print("listOfVersionsFor: \(results)")
        if let results = results,
           let firmwareVersions = results as? FirmwareVersions {
            if let lastVersion = firmwareVersions.reversed().first,
               let stringVersion = lastVersion.firmwareVersion {
                self.lastFirmwareVersion = stringVersion
            }
            
        }
    }
    
    func otaUpdateProgress(percentage: Float) {
        print("otaUpdateProgress: \(percentage)")
    }
    
    func onReturnSetTargetVersion(message: String) {
        print("onReturnSetTargetVersion: \(message)")
    }
}

typealias FirmwareVersions = [FirmwareVersion]
struct FirmwareVersion: Codable {
    let firmwareVersion: String?
}
