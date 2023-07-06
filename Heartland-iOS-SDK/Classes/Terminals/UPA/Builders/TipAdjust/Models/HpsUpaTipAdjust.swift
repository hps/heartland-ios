//
//  HpsUpaTipAdjust.swift
//  Heartland-iOS-SDK
//

import Foundation

// MARK: - HpsUpaTipAdjust

public struct HpsUpaTipAdjust: Codable {
    public let message: String?
    public let data: HpsUpaTipAdjustData?

    public init(message: String?, data: HpsUpaTipAdjustData?) {
        self.message = message
        self.data = data
    }
}

// MARK: - HpsUpaTipAdjustData

public struct HpsUpaTipAdjustData: Codable {
    public let command, EcrId, requestId: String?
    public let data: HpsUpaTipAdjustItem?

    public init(command: String?, EcrId: String?, requestId: String?, data: HpsUpaTipAdjustItem?) {
        self.command = command
        self.EcrId = EcrId
        self.requestId = requestId
        self.data = data
    }
}

// MARK: - HpsUpaTipAdjustItem

public struct HpsUpaTipAdjustItem: Codable {
    public let params: HpsUpaTipAdjustParams?
    public let transaction: HpsUpaTipAdjustTransaction?

    public init(params: HpsUpaTipAdjustParams?, transaction: HpsUpaTipAdjustTransaction?) {
        self.params = params
        self.transaction = transaction
    }
}

// MARK: - HpsUpaTipAdjustParams

public struct HpsUpaTipAdjustParams: Codable {
    public let clerkId: String?
    public let directMktInvoiceNbr: String?
    public let directMktShipMonth: String?
    public let directMktShipDay: String?

    public init(clerkId: String?, directMktInvoiceNbr: String?,
                directMktShipMonth: String?, directMktShipDay: String?) {
        self.clerkId = clerkId
        self.directMktInvoiceNbr = directMktInvoiceNbr
        self.directMktShipMonth = directMktShipMonth
        self.directMktShipDay = directMktShipDay
    }
}

// MARK: - HpsUpaTipAdjustTransaction

public struct HpsUpaTipAdjustTransaction: Codable {
    public let tipAmount, tranNo, invoiceNbr, referenceNumber: String?

    public init(tipAmount: String?, tranNo: String?,
                invoiceNbr: String?, referenceNumber: String?) {
        self.tipAmount = tipAmount
        self.tranNo = tranNo
        self.invoiceNbr = invoiceNbr
        self.referenceNumber = referenceNumber
    }
}
