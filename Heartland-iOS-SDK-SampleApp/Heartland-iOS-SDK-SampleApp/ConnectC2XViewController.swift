//
//  ConnectC2XViewController.swift
//

import CoreBluetooth
import Foundation
import Heartland_iOS_SDK
import UIKit

class ConnectC2XViewController: UIViewController {
    var device: HpsC2xDevice?
    var paxDevice: HpsPaxDevice?
    private let notificationCenter: NotificationCenter = .default

    @IBOutlet var connectionLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scanButtonStackView: UIStackView!
    @IBOutlet weak var scanButtonReference: UIButton!
    
    
    @IBAction func scanButtonPressed() {
        scanButtonReference.isEnabled = false
        let timeout = 120

        let config = HpsConnectionConfig()
        config.username = ""
        config.password = ""
        config.siteID = ""
        config.deviceID = ""
        config.licenseID = ""
        config.developerID = ""
        config.versionNumber = ""
        config.timeout = timeout

        device = HpsC2xDevice(config: config)
        device?.deviceDelegate = self
        device?.scan()
        activityIndicator.isHidden = false
    }

    func testPaxDeviceManual() {
        let timeout = 120

        let config = HpsConnectionConfig()
        config.ipAddress = ""
        config.port = ""
        config.username = ""
        config.password = ""
        config.siteID = ""
        config.deviceID = ""
        config.licenseID = ""
        config.developerID = ""
        config.versionNumber = ""
        config.connectionMode = 1
        config.timeout = timeout

        paxDevice = HpsPaxDevice(config: config)

        let builder = HpsPaxCreditSaleBuilder(device: paxDevice)
        builder?.amount = 11.0
        builder?.referenceNumber = 10
        builder?.allowDuplicates = false

        builder?.execute { response, error in

            if let error = error {
                print("Error: \(error)")
                return
            }
            if let response = response {
                print("Response: \(response)")
                let responseReturn = response.parseResponse()
                print("Response Parse: \(responseReturn.debugDescription)")
            }
        }
    }

    func testPaxDeviceAuth() {
        let timeout = 120

        let config = HpsConnectionConfig()
        config.ipAddress = ""
        config.port = ""
        config.username = ""
        config.password = ""
        config.siteID = "";
        config.deviceID = ""
        config.licenseID = ""
        config.developerID = ""
        config.versionNumber = ""
        config.connectionMode = 1
        config.timeout = timeout

        paxDevice = HpsPaxDevice(config: config)

        let card = HpsCreditCard()
        card.cardNumber = ""
        card.expMonth = 1
        card.expYear = 2
        card.cvv = ""

        let address = HpsAddress()
        address.address = ""
        address.zip = ""

        let builder = HpsPaxCreditAuthBuilder(device: paxDevice)
        builder?.amount = 11.0
        builder?.referenceNumber = 1
        builder?.allowDuplicates = true
        builder?.requestMultiUseToken = true
        builder?.creditCard = card
        builder?.address = address

        builder?.execute { response, error in

            if let error = error {
                print("Error: \(error)")
                return
            }
            if let response = response {
                print("Response: \(response)")
                let responseReturn = response.parseResponse()
                print("Response Parse: \(responseReturn.debugDescription)")
            }
        }
    }
}

extension ConnectC2XViewController: HpsC2xDeviceDelegate {
    func onConnected() {
        connectionLabel.text = "Connected"
        scanButtonReference.isEnabled = true

        let selectedDevice: [String: HpsC2xDevice?] = ["selectedDevice": device]
        notificationCenter.post(name: Notification.Name(Constants.selectedDeviceNotification),
                                object: nil, userInfo: selectedDevice)
    }

    func onDisconnected() {
        connectionLabel.text = "Disconnected"
        scanButtonReference.isEnabled = true
    }

    func onError(_: NSError) {
        connectionLabel.text = "Error"
        scanButtonReference.isEnabled = true
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

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { [weak self] _ in
            self?.scanButtonReference.isEnabled = true
        }
        alertController.addAction(cancelAction)
        if case .pad = UIDevice.current.userInterfaceIdiom {
            alertController.popoverPresentationController?.sourceView = scanButtonStackView
            alertController.popoverPresentationController?.sourceRect = scanButtonStackView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = .down
        }
        present(alertController, animated: true)

        activityIndicator.isHidden = true
    }
}

// MARK: - IDIOM

private extension ConnectC2XViewController {
    enum UIUserInterfaceIdiom: Int {
        case phone // iPhone and iPod touch style UI
        case pad // iPad style UI (also includes macOS Catalyst)
    }
}


extension ConnectC2XViewController {
    public func setupUpaDevice() -> HpsUpaDevice? {
            let config = HpsConnectionConfig()
            config.ipAddress = "192.168.31.118" //"192.168.31.107" // 199
            config.port = "8081"
            config.connectionMode = HpsConnectionModes.TCP_IP.rawValue
            config.timeout = 1000
            return HpsUpaDevice(config: config)
     }
    
    public func testingUPAUsaSignatureData() {
        let device = setupUpaDevice()
        if let builder = HpsUpaSaleBuilder(device: device) {
            builder.ecrId = "13"
            builder.clerkId = "1234"
            builder.referenceNumber = 1234
            builder.amount = 30.0;
            builder.details = HpsTransactionDetails()
            builder.details.invoiceNumber = generateInvoiceNumber()

            builder.execute(forUPAUSA: { response, error in
                if let error = error {
                    print(" Error: \(error)")
                    return
                }

                if let response = response {
                    print(" Response return ")
                    print(response.approvalCode)
                    print(" Device signature data")
                    device?.getSignatureData(builder.ecrId, andRequestId: "1234", response: { signatureDataResponse, error in
                        if let error = error {
                            print(" Error: \(error)")
                            return
                        }
                        
                        if let signatureDataResponse = signatureDataResponse {
                            print(" Signature Response")
                            print(signatureDataResponse.data.data.signatureData)
                        }
                    })
                }
            })
        }
    }
    
    func generateInvoiceNumber() -> String {
        let number = Int.random(in: 0001..<5000)
        return "\(number)"
    }
}
