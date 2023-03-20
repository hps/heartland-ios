import Foundation
import GlobalMobileSDK

@objc
public class GMSTransactionResponse: NSObject {
    var transactionResult: TransactionResult?
    var transactionId: String
    var gatewayTransactionId: String?
    var gatewayResponseText: String?
    var approvedAmount: Decimal?
    var transactionDescription: String
    var transactionType: HpsTransactionType?

    init(transactionResult: TransactionResult?, transactionId: String, gatewayTransactionId: String?, gatewayResponseText: String?, approvedAmount: Decimal?, transactionDescription: String) throws {
        self.transactionResult = transactionResult
        self.transactionId = transactionId
        self.gatewayTransactionId = gatewayTransactionId
        self.gatewayResponseText = gatewayResponseText
        self.approvedAmount = approvedAmount
        self.transactionDescription = transactionDescription
    }

    init(fromAuthResponse authResponse: AuthResponse) {
        transactionResult = authResponse.transactionResult
        transactionId = authResponse.transactionId
        gatewayTransactionId = authResponse.gatewayTransactionId
        gatewayResponseText = authResponse.gatewayResponseText
        if let approvedAmount = authResponse.approvedAmount {
            self.approvedAmount = Decimal(approvedAmount)
        }
        transactionDescription = authResponse.transactionDescription
        transactionType = .creditAuth
    }

    init(fromSaleResponse saleResponse: SaleResponse) {
        transactionResult = saleResponse.transactionResult
        transactionId = saleResponse.transactionId
        gatewayTransactionId = saleResponse.gatewayTransactionId
        gatewayResponseText = saleResponse.gatewayResponseText
        if let approvedAmount = saleResponse.approvedAmount {
            self.approvedAmount = Decimal(approvedAmount)
        }
        transactionDescription = saleResponse.transactionDescription
        transactionType = .creditSale
    }
}
