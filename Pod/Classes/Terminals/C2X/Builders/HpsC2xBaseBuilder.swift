import Foundation

@objc
public protocol IC2xDeviceInterface {
    func processTransactionWithRequest(_ request: HpsC2xBaseBuilder, withTransactionType transactionType: HpsTransactionType)
}

@objcMembers
public class HpsC2xBaseBuilder : NSObject {
    public var transactionType = HpsTransactionType.unknown
    public var device: IC2xDeviceInterface?
    
    public required override init() {
        super.init()
    }
    
    public static func initWithDevice(_ device: IC2xDeviceInterface) -> Self {
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
