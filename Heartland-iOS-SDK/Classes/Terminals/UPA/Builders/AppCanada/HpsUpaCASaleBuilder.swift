//
//  HpsUpaCASaleBuilder.swift
//  Heartland-iOS-SDK
//

import Foundation

public class HpsUpaCASaleBuilder {
    private var upaDevice: HpsUpaDevice
    
    public var clerkId: String?
    public var ecrId: String?
    public var requestId: String?
    public var baseAmount: String?
    public var tipAmount: String?
    public var taxAmount: String?

    public init(with device: HpsUpaDevice) {
        upaDevice = device
    }

    public func execute(response: @escaping (IHPSDeviceResponse?,
                                             HpsUpaCASaleModelResponse?, Error?) -> Void) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        
        try! self.validateFields()
        
        let params = HpsUpaCAModelParams(clerkId: self.clerkId, tokenRequest: nil, tokenValue: nil,
                                         cardOnFileIndicator: nil, cardBrandTransId: nil,
                                         directMktInvoiceNbr: nil, directMktShipMonth: nil,
                                         directMktShipDay: nil)

        let tx = HpsUpaCAModelTransaction(baseAmount: self.baseAmount, taxAmount: taxAmount,
                                          tipAmount: tipAmount, taxIndicator: nil,
                                          disableTax: nil, cashBackAmount: nil, invoiceNbr: nil,
                                          allowPartialAuth: nil, confirmAmount: nil,
                                          disableTip: nil, processCPC: nil,
                                          prescriptionAmount: nil, clinicAmount: nil, dentalAmount: nil,
                                          visionOpticalAmount: nil)
        
        let data = HpsUpaCommandPayload<HpsUpaCAModelDataSaleDetails>(
            command: HpsUpaCAModelConstants.command.rawValue,
            ecrId: self.ecrId, requestId: self.requestId,
            data: HpsUpaCAModelDataSaleDetails(
                params: params,
                transaction: tx,
                lodging: nil
            )
        )

        let request = HpsUpaCAModel(data: data)
        
        let json = try? encoder.encode(request)

        guard let json else { return }
        var hpsUpaAppCanadaModelResponse: HpsUpaCASaleModelResponse?
        upaDevice.processTransaction(withJSONString: String(data: json, encoding: .utf8),
                                     withResponseBlock: { deviceResponse, jsonDeviceResponse, error in
            
                                         if let jsonDeviceResponse,
                                            let jsonData = jsonDeviceResponse.data(using: .utf8) {
                                             hpsUpaAppCanadaModelResponse = try? JSONDecoder().decode(HpsUpaCASaleModelResponse.self,
                                                                                                      from: jsonData)
                                         }

                                         response(deviceResponse, hpsUpaAppCanadaModelResponse, error)
                                     })
        
        
    }
    
    func validateFields() throws {
        guard self.clerkId != nil else {
            throw HpsUpaCASaleError.missingFieldError("clerkId field is mandatory")
        }
        
        guard self.requestId != nil else {
            throw HpsUpaCASaleError.missingFieldError("requestId field is mandatory")
        }
        
        guard self.baseAmount != nil else {
            throw HpsUpaCASaleError.missingFieldError("baseAmount field is mandatory")
        }
    }
}

enum HpsUpaCASaleError: Error {
    case missingFieldError(String)
}
