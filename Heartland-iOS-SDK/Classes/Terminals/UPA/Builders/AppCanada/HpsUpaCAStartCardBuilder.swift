//
//  HpsUpaCAStartCardBuilder.swift
//  Heartland-iOS-SDK
//

import Foundation

public class HpsUpaAppCanadaStartCardBuilder {
    private var upaDevice: HpsUpaDevice

    public init(with device: HpsUpaDevice) {
        upaDevice = device
    }

    public func execute<T: Codable>(request: T,
                        response: @escaping (IHPSDeviceResponse?, HpsUpaCAStartCardResponse?, Error?) -> Void) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        
        let json = try? encoder.encode(request)

        guard let json else { return }
        print(" JSON: \(String(data: json, encoding: .utf8))")
        
        upaDevice.processTransaction(withJSONString: String(data: json, encoding: .utf8),
                                     withResponseBlock: { deviceResponse, jsonDeviceResponse, error in
                                         var hpsUpaAppCanadaStartCardResponse: HpsUpaCAStartCardResponse?
                                         if let jsonDeviceResponse,
                                            let jsonData = jsonDeviceResponse.data(using: .utf8) {
                                             hpsUpaAppCanadaStartCardResponse = try? JSONDecoder().decode(HpsUpaCAStartCardResponse.self,
                                                                                                 from: jsonData)
                                         }

                                         response(deviceResponse, hpsUpaAppCanadaStartCardResponse, error)
                                     })
        
        
    }
}
