//
//  HpsUpaStartCardTransactionBuilder.swift
//  Heartland-iOS-SDK
//

import Foundation

public class HpsUpaStartCardTransactionBuilder {
    private var upaDevice: HpsUpaDevice

    public init(with device: HpsUpaDevice) {
        upaDevice = device
    }

    public func execute(request: HpsUpaStartCard,
                        response: @escaping (IHPSDeviceResponse?, HpsUpaStartCardResponse?, Error?) -> Void) {
        let encoder = JSONEncoder()

        let json = try? encoder.encode(request)

        guard let json else { return }

        upaDevice.processTransaction(withJSONString: String(data: json, encoding: .utf8),
                                     withResponseBlock: { deviceResponse, jsonDeviceResponse, error in
                                         var hpsUpaStartCardResponse: HpsUpaStartCardResponse?
                                         if let jsonDeviceResponse, let jsonData = jsonDeviceResponse.data(using: .utf8) {
                                             hpsUpaStartCardResponse = try? JSONDecoder().decode(HpsUpaStartCardResponse.self, from: jsonData)
                                         }

                                         response(deviceResponse, hpsUpaStartCardResponse, error)
                                     })
    }
}
