import Foundation
import GlobalMobileSDK

@objcMembers
public class HpsC2xDevice : GMSDevice, IC2xDeviceInterface {
    public init(config: HpsConnectionConfig) {
        super.init(
            config: config,
            entryModes: [
                .contact,
                .chipFallback,
                .contactless,
                .msr,
                .manual
            ],
            terminalType: .bbpos_c2x
        )
    }
}
