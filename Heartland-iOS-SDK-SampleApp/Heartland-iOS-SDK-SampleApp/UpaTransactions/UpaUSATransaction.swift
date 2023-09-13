//
//  UpaUSATransaction.swift
//  Heartland-iOS-SDK-SampleApp
//
//  Created by Francis Legaspi on 2023-06-23.
//

import Foundation
import Heartland_iOS_SDK

struct UpaUSATransaction: UpaTransactionProtocol {
    func onSaleTransaction(ipAddress: String, amount: String, completion: @escaping (String?) -> Void) {
        let device = self.setupDevice(ipAddress: ipAddress)
        if let builder = HpsUpaSaleBuilder(device: device) {
            builder.clerkId = "1234"
            builder.ecrId = "12"
            builder.amount = NSDecimalNumber(string: amount)
            builder.gratuity = 0
            
            builder.execute(forUPAUSA: { hpsUpaResponse, error in
               
                if let _ = error {
                    print(error!)
                    completion(nil)
                } else {
                    if let _ = hpsUpaResponse {
                        print(hpsUpaResponse!)
                        
                        completion(hpsUpaResponse?.referenceNumber)
                    }
                }
                
            })
        }
    }
    
    func onRefundTransaction(ipAddress: String, amount: String) {
        let device = self.setupDevice(ipAddress: ipAddress)
        
        if let builder = HpsUpaReturnBuilder(device: device) {
            builder.clerkId = "1234"
            builder.ecrId = "12"
            builder.amount = NSDecimalNumber(string: amount)
            
            builder.execute { hpsUpaResponse, error in
                
                if let _ = error {
                    print(error!)
                } else {
                    if let _ = hpsUpaResponse {
                        print(hpsUpaResponse!)
                    }
                }
                
            }
        }
    }
    
    func onVoidTransaction(ipAddress: String, tranNo: String?) {
        let device = self.setupDevice(ipAddress: ipAddress)
        
        if let builder = HpsUpaVoidBuilder(device: device) {
            builder.clerkId = "1234"
            builder.ecrId = "12"
            builder.terminalRefNumber = "1234"
            
            builder.execute { hpsUpaResponse, error in
                
                if let _ = error {
                    print(error!)
                } else {
                    if let _ = hpsUpaResponse {
                        print(hpsUpaResponse!)
                    }
                }
                
            }
            
        }
    }
    
}

extension UpaUSATransaction {
    
    func onSignatureDataTransaction(ipAddress: String) {
        let device = self.setupDevice(ipAddress: ipAddress)
        
        if let builder = HpsUpaSaleBuilder(device: device) {
            builder.ecrId = "13"
            builder.clerkId = "1234"
            builder.referenceNumber = 1234
            builder.taxAmount = 0
            builder.amount = 30.0
            builder.details = HpsTransactionDetails()
            builder.details.invoiceNumber = "123"
            
            builder.execute(forUPAUSA: { hpsUpaResponse, error in
               
                if let _ = error {
                    print(error!)
                } else {
                    if let _ = hpsUpaResponse {
                        print(hpsUpaResponse!)
                        device.getSignatureData("13", andRequestId: "1234") { response, error in
                            if let error = error {
                                print(error)
                                return
                            }
                            if let response = response {
                                print(response)
                            }
                        }
                    }
                }
                
            })
        }
    }
}
