//
//  HpsUpaSendSafResponse.swift
//  Heartland-iOS-SDK
//

import Foundation

import Foundation

public struct HpsUpaSafResponse: Codable {
    public let message: String?
    public let data: HpsUpaResponsePayload<HpsUpaSafResponseData>?

    public init(message: String?, data: HpsUpaResponsePayload<HpsUpaSafResponseData>?) {
        self.message = message
        self.data = data
    }
}

public struct HpsUpaSafResponseData: Codable {
    public let multipleMessage: String?
    public let terminalId: String?
    public let terminalNumber: String?
    public let safDetails: [HpsUpaSafDetail]?

    enum CodingKeys: String, CodingKey {
        case multipleMessage
        case safDetails = "SafDetails"
        case terminalId
        case terminalNumber
    }

    public init(multipleMessage: String?, terminalId: String?, terminalNumber: String?, safDetails: [HpsUpaSafDetail]?) {
        self.multipleMessage = multipleMessage
        self.terminalId = terminalId
        self.terminalNumber = terminalNumber
        self.safDetails = safDetails
    }
}

public struct HpsUpaSafDetail: Codable {
    public let safType, safCount: String?
    public let safTotal: String?
    public let safRecords: [HpsUpaSafRecord]?

    enum CodingKeys: String, CodingKey {
        case safTotal = "SafTotal"
        case safType = "SafType"
        case safCount = "SafCount"
        case safRecords = "SafRecords"
    }

    public init(safType: String?, safCount: String?, safTotal: String?, safRecords: [HpsUpaSafRecord]?) {
        self.safType = safType
        self.safCount = safCount
        self.safTotal = safTotal
        self.safRecords = safRecords
    }
}

public struct HpsUpaSafRecord: Codable {
    public let totalAmount: String?
    public let authorizedAmount: String?
    public let tranNo: String?
    public let transactionTime: String?
    public let transactionType: String?
    public let maskedPan: String?
    public let cardType: String?
    public let cardAquisition: String?
    public let approvalCode: String?
    public let responseCode: String?
    public let responseText: String?
    public let referenceNumber: String?
    public let safReferenceNumber: String?
    public let hostTimeout: String?
    public let baseAmount: String?
    public let taxAmount: String?
    public let tipAmount: String?
    public let requestAmount: String?
    public let invoiceNbr: String?
    public let clerkId: String?
    public let surcharge: String?

    public init(totalAmount: String?, authorizedAmount: String?, tranNo: String?, transactionTime: String?, transactionType: String?, maskedPan: String?, cardType: String?, cardAquisition: String?, approvalCode: String?, responseCode: String?, responseText: String?, referenceNumber: String?, safReferenceNumber: String?, hostTimeout: String?, baseAmount: String?, taxAmount: String?, tipAmount: String?, requestAmount: String?, invoiceNbr: String?, clerkId: String?, surcharge: String?) {
        self.totalAmount = totalAmount
        self.authorizedAmount = authorizedAmount
        self.tranNo = tranNo
        self.transactionTime = transactionTime
        self.transactionType = transactionType
        self.maskedPan = maskedPan
        self.cardType = cardType
        self.cardAquisition = cardAquisition
        self.approvalCode = approvalCode
        self.responseCode = responseCode
        self.responseText = responseText
        self.referenceNumber = referenceNumber
        self.safReferenceNumber = safReferenceNumber
        self.hostTimeout = hostTimeout
        self.baseAmount = baseAmount
        self.taxAmount = taxAmount
        self.tipAmount = tipAmount
        self.requestAmount = requestAmount
        self.invoiceNbr = invoiceNbr
        self.clerkId = clerkId
        self.surcharge = surcharge
    }
}
