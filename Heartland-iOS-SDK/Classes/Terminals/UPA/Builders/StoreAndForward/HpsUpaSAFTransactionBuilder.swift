//
//  HpsUpaSAFTransactionBuilder.swift
//  Heartland-iOS-SDK
//

import Foundation

public class HpsUpaSAFTransactionBuilder {
    private var upaDevice: HpsUpaDevice
    
    public init(with device: HpsUpaDevice) {
        upaDevice = device
    }
    
    public func execute(request: HpsUpaGetSaf, response: @escaping (IHPSDeviceResponse?, HpsUpaSafResponse?, Error?) -> Void) {
        executeCodable(request: request, response: response)
    }
    
    public func execute(request: HpsUpaSendSaf, response: @escaping (IHPSDeviceResponse?, HpsUpaSafResponse?, Error?) -> Void) {
        executeCodable(request: request, response: response)
    }
    
    private func executeCodable(request: Codable, response: @escaping (IHPSDeviceResponse?, HpsUpaSafResponse?, Error?) -> Void) {
        let encoder = JSONEncoder()
        
        let json = try? encoder.encode(request)
        
        guard let json else { return }
        
        upaDevice.processTransaction(withJSONString: String(data: json, encoding: .utf8),
                                     withResponseBlock: { deviceResponse, jsonDeviceResponse, error in
            var hpsUpaSendSafResponse: HpsUpaSafResponse?
            if let jsonDeviceResponse, let jsonData = jsonDeviceResponse.data(using: .utf8) {
                hpsUpaSendSafResponse = try? JSONDecoder().decode(HpsUpaSafResponse.self, from: jsonData)
            }
            
            response(deviceResponse, hpsUpaSendSafResponse, error)
        })
    }
}

public extension HpsUpaSAFTransactionBuilder {
    
    func execute(request: HpsUpaDeleteSaf, response: @escaping (IHPSDeviceResponse?, HpsUpaDeleteSafResponse?, Error?) -> Void) {
        let encoder = JSONEncoder()
        
        let json = try? encoder.encode(request)
        
        guard let json else { return }
        
        upaDevice.processTransaction(withJSONString: String(data: json, encoding: .utf8),
                                     withResponseBlock: { deviceResponse, jsonDeviceResponse, error in
            
            var hpsUpaDeleteSafResponse: HpsUpaDeleteSafResponse?
            if let jsonDeviceResponse, let jsonData = jsonDeviceResponse.data(using: .utf8) {
                hpsUpaDeleteSafResponse = try? JSONDecoder().decode(HpsUpaDeleteSafResponse.self, from: jsonData)
            }
            
            response(deviceResponse, hpsUpaDeleteSafResponse, error)
        })
        
    }
    
}
