import Foundation

@objcMembers
public class HpsWiseCubeDevice: GMSDevice, IWiseCubeDeviceInterface {
    public init(config: HpsConnectionConfig) {
        super.init(
            config: config,
            entryModes: [
                .contact,
                .contactless,
                .manual,
                .quickChip
            ],
            terminalType: .bbpos_wisecube
        )
    }
}
