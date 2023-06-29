//
//  HpsUpaCARefundBuilder.swift
//  Heartland-iOS-SDK
//
//  Created by Renato Santos on 19/06/2023.
//

import Foundation

public class HpsUpaCARefundBuilder {
    private var upaDevice: HpsUpaDevice
    
    public var clerkId: String?
    public var ecrId: String?
    public var requestId: String?
    public var totalAmount: String?
    public var invoiceNbr: String?

    public init(with device: HpsUpaDevice) {
        upaDevice = device
    }

    public func execute(response: @escaping (IHPSDeviceResponse?,
                                             HpsUpaCARefundModelResponse?, Error?) -> Void) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        
        try! self.validateFields()

        let params = HpsUpaCAStartRefundParams(clerkID: self.clerkId,
                                               tokenRequest: nil,
                                               tokenValue: nil)
        
        let transaction = HpsUpaCAStartRefundTransaction(totalAmount: self.totalAmount,
                                                         invoiceNbr: self.invoiceNbr)

        let data = HpsUpaCommandPayload<HpsUpaCAStartRefund>(command: HpsUpaCAModelCommand.REFUND.rawValue,
                                                             ecrId: self.ecrId,
                                                             requestId: self.requestId,
                                                             data: HpsUpaCAStartRefund(params: params,
                                                                                       transaction: transaction))

        let request = HpsUpaCAModel<HpsUpaCAStartRefund>(data: data)
        let json = try? encoder.encode(request)

        guard let json else { return }

        upaDevice.processTransaction(withJSONString: String(data: json, encoding: .utf8),
                                     withResponseBlock: { deviceResponse, jsonDeviceResponse, error in
                                         var hpsUpaAppCanadaModelResponse: HpsUpaCARefundModelResponse?
                                         if let jsonDeviceResponse,
                                            let jsonData = jsonDeviceResponse.data(using: .utf8) {
                                             hpsUpaAppCanadaModelResponse = try? JSONDecoder().decode(HpsUpaCARefundModelResponse.self,
                                                                                                 from: jsonData)
                                         }

                                         response(deviceResponse, hpsUpaAppCanadaModelResponse, error)
                                     })
        
        
    }
    
    func validateFields() throws {
        guard self.requestId != nil else {
            throw HpsUpaCASaleError.missingFieldError("requestId field is mandatory")
        }
        
        guard self.totalAmount != nil else {
            throw HpsUpaCASaleError.missingFieldError("baseAmount field is mandatory")
        }
        
        guard self.ecrId != nil else {
            throw HpsUpaCASaleError.missingFieldError("ecrId field is mandatory")
        }
    }
}
