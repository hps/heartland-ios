//
//  UpaTransactionProtocol.swift
//  Heartland-iOS-SDK-SampleApp
//
//  Created by P1966 on 2023-06-23.
//

import Foundation
import Heartland_iOS_SDK

protocol UpaTransactionProtocol {
    func setupDevice(ipAddress: String) -> HpsUpaDevice
    
    func onSaleTransaction(ipAddress: String, amount: String, completion: @escaping (String?) -> Void)
    func onRefundTransaction(ipAddress: String, amount: String)
    func onVoidTransaction(ipAddress: String, tranNo: String?)
    
    func onSendSAFTransaction(ipAddress: String)
    func onGetSAFReportTransaction(ipAddress: String)
}

extension UpaTransactionProtocol {
    
    func setupDevice(ipAddress: String) -> HpsUpaDevice {
        let config = HpsConnectionConfig()
        config.ipAddress = ipAddress
        config.port = "8081"
        
        config.connectionMode = HpsConnectionModes.TCP_IP.rawValue
        config.timeout = 1000
        return HpsUpaDevice(config: config)
    }
    
    func onSendSAFTransaction(ipAddress: String) {
        let device = self.setupDevice(ipAddress: ipAddress)
        let builder = HpsUpaSAFTransactionBuilder(with: device)
        
        let sendSAF = HpsUpaSendSaf(data: HpsUpaCommandPayloadNoData(command: "SendSAF", requestId: "123", ecrId: "123"))
        
        builder.execute(request: sendSAF) { ihpsDeviceResponse, hpsUpaSafResponse, error in
            
            if let error = error {
                print(error)
            } else {
                
                if let _ = ihpsDeviceResponse {
                    print("IHPSDeviceResponse : \(ihpsDeviceResponse!) \n\n")
                }
                
                if let _ = hpsUpaSafResponse {
                    print("HpsUpaSafResponse : \(hpsUpaSafResponse!) \n\n")
                }
                
            }
        }
    }
    
    func onGetSAFReportTransaction(ipAddress: String) {
        let device = self.setupDevice(ipAddress: ipAddress)
        let builder = HpsUpaSAFTransactionBuilder(with: device)
        
        let getSAFReport = HpsUpaGetSaf(
            data: HpsUpaCommandPayload(command: "GetSAFReport", ecrId: "123", requestId: "123", data: HpsUpaGetSafData(params: HpsUpaGetSafDataReportOutput(reportOutput: "ReturnData")))
        )
        
        builder.execute(request: getSAFReport) { ihpsDeviceResponse, hpsUpaSafResponse, error in
            if let error = error {
                print(error)
            } else {
                if let _ = ihpsDeviceResponse {
                    print("IHPSDeviceResponse : \(ihpsDeviceResponse!) \n\n")
                }
                
                if let _ = hpsUpaSafResponse {
                    print("HpsUpaSafResponse : \(hpsUpaSafResponse!) \n\n")
                }
            }
        }
    }
}
