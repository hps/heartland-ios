//
//  HpsUpaCAModel.swift
//  Heartland-iOS-SDK
//

import Foundation

public struct HpsUpaCAModelConstants {
    public static let command: HpsUpaCAModelCommand = .SALE
}

public struct HpsUpaCAModel<T: Codable>: Codable {
    public var message: String
    public let data: HpsUpaCommandPayload<T>?

    public init(message: HpsUpaCAModelMessage = HpsUpaCAModelMessage.MSG,
                data: HpsUpaCommandPayload<T>?) {
        self.message = message.rawValue
        self.data = data
    }
}

public struct HpsUpaCAModelDataSaleDetails: Codable {
    public let params: HpsUpaCAModelParams?
    public let transaction: HpsUpaCAModelTransaction
    public let lodging: HpsUpaCAModelLodging?

    public init(params: HpsUpaCAModelParams?,
                transaction: HpsUpaCAModelTransaction,
                lodging: HpsUpaCAModelLodging?) {
        self.params = params
        self.transaction = transaction
        self.lodging = lodging
    }
    
    var asDictionary: [String: Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({(label:String?, value:Any)-> (String, Any)? in
            guard let label = label else { return nil }
            return (label, value)
        }).compactMap{ $0 })
        return dict
    }
}

public struct HpsUpaCAModelParams: Codable {
    
    /// App Canada Implementation
    
    public var clerkId: String?
    public var tokenRequest: Bool?
    public var tokenValue: String?
    public var cardOnFileIndicator: CardOnFileIndicator?
    public var cardBrandTransId: String?
    public var directMktInvoiceNbr: String?
    public var directMktShipMonth: String?
    public var directMktShipDay: String?

    /// App Canada Init
    public init(clerkId: String?, tokenRequest: Bool?,
                tokenValue: String?, cardOnFileIndicator: CardOnFileIndicator?,
                cardBrandTransId: String?, directMktInvoiceNbr: String?,
                directMktShipMonth: String?, directMktShipDay: String?) {
        
        self.clerkId = clerkId
        self.tokenRequest = tokenRequest
        self.tokenValue = tokenValue
        self.cardOnFileIndicator = cardOnFileIndicator
        self.cardBrandTransId = cardBrandTransId
        self.directMktInvoiceNbr = directMktInvoiceNbr
        self.directMktShipMonth = directMktShipMonth
        self.directMktShipDay = directMktShipDay
    }
    
    var asDictionary: [String: Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({(label:String?, value:Any?)-> (String, Any)? in
            guard let label = label, let value = value else { return nil }
            return (label, value)
        }).compactMap{ $0 })
        return dict
    }
}

public struct HpsUpaCAModelTransaction: Codable {
    public let baseAmount: String?
    public let taxAmount: String?
    public let tipAmount: String?
    public let taxIndicator: String?
    public let disableTax: String?
    
    public let cashBackAmount: String?
    public let invoiceNbr: String?
    public let allowPartialAuth: String?
    public let confirmAmount: String?
    public let disableTip: String?
    public let processCPC: String?
    public let prescriptionAmount: String?
    
    public let clinicAmount: String?
    public let dentalAmount: String?
    public let visionOpticalAmount: String?

    public init(baseAmount: String?, taxAmount: String?, tipAmount: String?, taxIndicator: String?,
                disableTax: String?, cashBackAmount: String?, invoiceNbr: String?, allowPartialAuth: String?,
                confirmAmount: String?, disableTip: String?, processCPC: String?,
                prescriptionAmount: String?, clinicAmount: String?,
                dentalAmount: String?, visionOpticalAmount: String?) {
        
        self.baseAmount = baseAmount
        self.taxAmount = taxAmount
        self.tipAmount = tipAmount
        self.taxIndicator = taxIndicator
        self.disableTax = disableTax
        
        self.cashBackAmount = cashBackAmount
        self.invoiceNbr = invoiceNbr
        self.allowPartialAuth = allowPartialAuth
        self.confirmAmount = confirmAmount
        self.disableTip = disableTip
        self.processCPC = processCPC
        self.prescriptionAmount = prescriptionAmount
        
        self.clinicAmount = clinicAmount
        self.dentalAmount = dentalAmount
        self.visionOpticalAmount = visionOpticalAmount
    }
    
    var asDictionary: [String: Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({(label:String?, value:Any?)-> (String, Any)? in
            guard let label = label, let value = value else { return nil }
            return (label, value)
        }).compactMap{ $0 })
        return dict
    }
}

public struct HpsUpaCAModelLodging: Codable {
    public let folioNumber: String?
    public let stayDuration: String?
    public let checkInDate: String?
    public let checkOutDate: String?
    public let dailyRate: String?
    public let preferredCustomer: String?
    public let cardBrandTransID: String?
    public let extraChargeTypes: String?
    public let extraChargeTotal: String?
    public let advanceDepositType: String?
    public let noShow: String?

    public init(folioNumber: String?, stayDuration: String?, checkInDate: String?, checkOutDate: String?,
                dailyRate: String?, preferredCustomer: String?, cardBrandTransID: String?,
                extraChargeTypes: String?, extraChargeTotal: String?, advanceDepositType: String?, noShow: String?) {
        self.folioNumber = folioNumber
        self.stayDuration = stayDuration
        self.checkInDate = checkInDate
        self.checkOutDate = checkOutDate
        self.dailyRate = dailyRate
        self.preferredCustomer = preferredCustomer
        self.cardBrandTransID = cardBrandTransID
        self.extraChargeTypes = extraChargeTypes
        self.extraChargeTotal = extraChargeTotal
        self.advanceDepositType = advanceDepositType
        self.noShow = noShow
    }
}

