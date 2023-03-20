//
//  HpsUpaTipAdjustBuilder.swift
//  Heartland-iOS-SDK
//

import Foundation

public class HpsUpaTipAdjustBuilder {
    private var upaDevice: HpsUpaDevice

    public init(with device: HpsUpaDevice) {
        upaDevice = device
    }

    public func execute(request: HpsUpaLineItemDisplay, response: @escaping (IHPSDeviceResponse?, String?, Error?) -> Void) {
        let encoder = JSONEncoder()

        let json = try? encoder.encode(request)

        guard let json else { return }

        upaDevice.processTransaction(withJSONString: String(data: json, encoding: .utf8),
                                     withResponseBlock: response)
    }
}
