//
//  HpsUpaCAVoidBuilder.swift
//  Heartland-iOS-SDK
//
//  Created by Renato Santos on 19/06/2023.
//

import Foundation

public class HpsUpaCAVoidBuilder {
    private var upaDevice: HpsUpaDevice
    
    public var clerkId: String?
    public var ecrId: String?
    public var requestId: String?
    public var tranNo: String?

    public init(with device: HpsUpaDevice) {
        upaDevice = device
    }

    public func execute(response: @escaping (IHPSDeviceResponse?,
                                             HpsUpaCAVoidModelResponse?, Error?) -> Void) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        
        try! self.validateFields()

        let params = HpsUpaCAVoidParams(clerkID: self.clerkId)
        
        let transaction = HpsUpaCAVoidTransaction(tranNo: self.tranNo)

        let data = HpsUpaCommandPayload<HpsUpaCAVoid>(command: HpsUpaCAModelCommand.VOID.rawValue,
                                                      ecrId: self.ecrId,
                                                      requestId: self.requestId,
                                                      data: HpsUpaCAVoid(params: params,
                                                                         transaction: transaction))

        let request = HpsUpaCAModel<HpsUpaCAVoid>(data: data)
        
        let json = try? encoder.encode(request)

        guard let json else { return }
        
        var hpsUpaAppCanadaModelResponse: HpsUpaCAVoidModelResponse?
        upaDevice.processTransaction(withJSONString: String(data: json, encoding: .utf8),
                                     withResponseBlock: { deviceResponse, jsonDeviceResponse, error in
                                         
                                         if let jsonDeviceResponse,
                                            let jsonData = jsonDeviceResponse.data(using: .utf8) {
                                             hpsUpaAppCanadaModelResponse = try? JSONDecoder().decode(HpsUpaCAVoidModelResponse.self,
                                                                                                 from: jsonData)
                                         }

                                         response(deviceResponse, hpsUpaAppCanadaModelResponse, error)
                                     })
        
        
    }
    
    func validateFields() throws {
    
        guard self.requestId != nil else {
            throw HpsUpaCASaleError.missingFieldError("requestId field is mandatory")
        }
        
        guard self.ecrId != nil else {
            throw HpsUpaCASaleError.missingFieldError("requestId field is mandatory")
        }
    }
}
