import Foundation
import GlobalMobileSDK

@objc
public class GMSTransactionResponse: NSObject {
    var transactionResult: TransactionResult?
    var transactionId: UUID
    var gatewayTransactionId: String?
    var gatewayResponseText: String?
    var approvedAmount: Decimal?
    var transactionDescription: String
    var transactionType: HpsTransactionType?
    
    init(transactionResult: TransactionResult?, transactionId: UUID, gatewayTransactionId: String?, gatewayResponseText: String?, approvedAmount: Decimal?, transactionDescription: String) throws {
        self.transactionResult = transactionResult
        self.transactionId = transactionId
        self.gatewayTransactionId = gatewayTransactionId
        self.gatewayResponseText = gatewayResponseText
        self.approvedAmount = approvedAmount
        self.transactionDescription = transactionDescription
    }
    
    init(fromAuthResponse authResponse: AuthResponse) {
        self.transactionResult = authResponse.transactionResult
        self.transactionId = authResponse.transactionId
        self.gatewayTransactionId = authResponse.gatewayTransactionId
        self.gatewayResponseText = authResponse.gatewayResponseText
        if let approvedAmount = authResponse.approvedAmount {
            self.approvedAmount = Decimal(approvedAmount)
        }
        self.transactionDescription = authResponse.transactionDescription
        self.transactionType = .creditAuth
    }
    
    init(fromSaleResponse saleResponse: SaleResponse) {
        self.transactionResult = saleResponse.transactionResult
        self.transactionId = saleResponse.transactionId
        self.gatewayTransactionId = saleResponse.gatewayTransactionId
        self.gatewayResponseText = saleResponse.gatewayResponseText
        if let approvedAmount = saleResponse.approvedAmount {
            self.approvedAmount = Decimal(approvedAmount)
        }
        self.transactionDescription = saleResponse.transactionDescription
        self.transactionType = .creditSale
    }
}
