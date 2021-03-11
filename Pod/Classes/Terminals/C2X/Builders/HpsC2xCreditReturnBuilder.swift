import Foundation

@objcMembers
public class HpsC2xCreditReturnBuilder : HpsC2xBaseBuilder {
    public var amount: NSDecimalNumber?
    public var referenceNumber: String?
    public var transactionId: String?
    
    public required init() {
        super.init()
        self.transactionType = .creditReturn
    }
    
    public override func buildRequest() -> Transaction? {
        // Create GlobalMobileSDK tranaction model
        let total: Decimal? = self.amount as Decimal?
        let posReferenceNumber: String? = self.referenceNumber
        let transactionId: String? = self.transactionId

        return ReturnTransaction.returnWithReference(total: total,
                                                     tax: nil,
                                                     tip: nil,
                                                     taxCategory: nil,
                                                     gatewayTransactionId: transactionId ?? "",
                                                     posReferenceNumber: posReferenceNumber,
                                                     invoiceNumber: nil,
                                                     operatingUserId: nil)
    }

    public override func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        let resp = response as ReturnResponse
        var deviceResponseCode = result.rawValue

        if let respText = resp?.gatewayResponseText {
            deviceResponseCode = respText
        }

        data.entryMethod = HpsC2xEnums.cardDataSourceTypeToString(resp?.cardDataSourceType)
        data.approvalCode = resp?.authCode
        data.maskedCardNumber = resp?.maskedPan
        data.responseText = resp?.gatewayResponseText
        data.deviceResponseCode = deviceResponseCode
        data.terminalRefNumber = resp?.posReferenceNumber
//        data.transactionType = HpsC2xEnums.transactionTypeToString(resp?.transactionType)
        data.applicationId = resp?.aid
        data.applicationName = resp?.applicationLabel
        data.cardholderName = resp?.cardholderName
        data.applicationCrytptogram = resp?.applicationCryptogram
        data.terminalVerficationResult = resp?.tvr

        if let decimalValue = resp?.tip {
            data.tipAmount = NSNumber(nonretainedObject: decimalValue)
        }

        if let decimalValue = resp?.total {
            data.transactionAmount = NSNumber(nonretainedObject: decimalValue)
        }
        
        return data
    }
}
