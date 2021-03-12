import Foundation

@objcMembers
public class GMSBaseBuilder : NSObject {
    public var transactionType = HpsTransactionType.unknown
    public var device: GMSDeviceInterface?
    
    public required override init() {
        super.init()
    }
    
    public static func initWithDevice(_ device: GMSDeviceInterface) -> Self {
        let result = self.init()
        result.device = device
        return result
    }
    
    public func execute() {
        if let device = self.device {
            device.processTransactionWithRequest(self, withTransactionType: self.transactionType)
        }
    }

    public func buildRequest() -> Transaction? {
        return nil
    }

    public func mapResponse(_ data: HpsTerminalResponse, _ result: TransactionResult, _ response: TransactionResponse?) -> HpsTerminalResponse {
        return HpsTerminalResponse()
    }
}
