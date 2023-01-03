//
//  HpsUpaStartCardTransactionBuilder.swift
//  Heartland-iOS-SDK
//

import Foundation

public class HpsUpaStartCardTransactionBuilder {
    private var upaDevice: HpsUpaDevice
    
    init (with device: HpsUpaDevice) {
        self.upaDevice = device
    }
    
    public func execute(request: HpsUpaStartCard, response: @escaping (IHPSDeviceResponse?, Error?) -> Void) {
        let encoder = JSONEncoder()
        
        let json = try? encoder.encode(request)
        
        guard let json else { return }
        
        upaDevice.processTransaction(withJSONString: String(data: json, encoding: .utf8),
                                     withResponseBlock: response)
    }
}
