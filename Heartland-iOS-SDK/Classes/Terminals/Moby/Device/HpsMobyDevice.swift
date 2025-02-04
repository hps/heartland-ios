import Foundation
import GlobalMobileSDK
import TemLibrary

@available(iOS 13.0, *)
@objcMembers
public class HpsMobyDevice: GMSDevice, IC2xDeviceInterface {
    
    let ruaHelper: RUADDeviceHelper = RUADDeviceHelper.sharedInstance
    
    var ruaDevice: DRuaDevice?
    
    public init(config: HpsConnectionConfig) {
        super.init(
            config: config,
            entryModes: [
                .contact,
                .chipFallback,
                .contactless,
                .msr,
                .manual,
                .quickChip,
            ],
            terminalType: .ingenico_moby5500
        )
    }
    
    public func searchDevice(searchFinishBlock: @escaping ([DRuaDevice]) -> Void) {
        self.deviceDelegate = ruaHelper
        self.scan()
    }
    
    public func printReceipt(response: HpsTerminalResponse, headerDetail: ReceiptHelperDetail) -> UIImage {
        return ReceiptHelper.createReceiptImage(transaction: response, headerDetail: headerDetail)
    }
}
