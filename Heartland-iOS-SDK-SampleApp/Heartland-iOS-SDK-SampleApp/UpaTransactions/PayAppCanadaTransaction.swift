//
//  PayAppCanadaTransaction.swift
//  Heartland-iOS-SDK-SampleApp
//
//  Created by Francis Legaspi on 2023-06-23.
//

import Foundation
import Heartland_iOS_SDK

struct PayAppCanadaTransaction: UpaTransactionProtocol {
    func onSaleTransaction(ipAddress: String, amount: String, completion: @escaping (String?) -> Void) {
        let device = self.setupDevice(ipAddress: ipAddress)
        let builder = HpsUpaCASaleBuilder(with: device)
        builder.clerkId = "1234"
        builder.ecrId = "12"
        builder.baseAmount = amount
        builder.requestId = "1234"
        builder.tipAmount = "0.00"
        
        builder.execute { deviceResponse, upaResponse, error in
            if let _ = error {
                print(error!)
                completion(nil)
            } else {
                
                if let _ = deviceResponse {
                    print(deviceResponse!)
                }
                
                if let _ = upaResponse {
                    print(upaResponse!)
                    
                    if let tranNo = upaResponse?.data?.data?.host?.tranNo {
                        completion(tranNo)
                    }
                }
            }
        }
    }
    
    func onRefundTransaction(ipAddress: String, amount: String) {
        let device = self.setupDevice(ipAddress: ipAddress)
        let builder = HpsUpaCARefundBuilder(with: device)
        builder.clerkId = "1234"
        builder.ecrId = "12"
        builder.totalAmount = amount
        builder.requestId = "1234"
        
        builder.execute { deviceResponse, upaResponse, error in
            if let _ = error {
                print(error!)
            } else {
                
                if let _ = deviceResponse {
                    print(deviceResponse!)
                }
                
                if let _ = upaResponse {
                    print(upaResponse!)
                }
            }
        }
    }
    
    func onVoidTransaction(ipAddress: String, tranNo: String?) {
        let device = self.setupDevice(ipAddress: ipAddress)
        let builder = HpsUpaCAVoidBuilder(with: device)
        builder.clerkId = "1234"
        builder.ecrId = "12"
        builder.requestId = "1234"
        builder.tranNo = tranNo
        
        builder.execute { deviceResponse, upaResponse, error in
            if let _ = error {
                print(error!)
            } else {
                
                if let _ = deviceResponse {
                    print(deviceResponse!)
                }
                
                if let _ = upaResponse {
                    print(upaResponse!)
                }
            }
        }
    }
    
}
