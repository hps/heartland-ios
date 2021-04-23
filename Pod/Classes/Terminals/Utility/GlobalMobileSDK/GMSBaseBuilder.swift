import Foundation

@objcMembers
public class GMSBaseBuilder : NSObject {
    public let transactionType: HpsTransactionType
    public let device: GMSDeviceInterface
    
    internal init(transactionType: HpsTransactionType, device: GMSDeviceInterface) {
        self.transactionType = transactionType
        self.device = device
        super.init()
    }
    
    public func execute() {
        device.processTransactionWithRequest(self, withTransactionType: self.transactionType)
    }

    public func buildRequest() -> Transaction? {
        return nil
    }

    public func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        return HpsTerminalResponse()
    }
}
