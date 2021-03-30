import Foundation

@objcMembers
public class HpsC2xDevice : GMSDevice, IC2xDeviceInterface {
    public override func initialize() {
        guard let config = self.config else { return }
        let entryModes: [EntryMode] = [
            .contact,
            .chipFallback,
            .msr,
            .manual
        ]
        self.gmsWrapper = GMSWrapper(GMSConfiguration.fromHpsConnectionConfig(config), delegate: self, entryModes: entryModes, terminalType: .bbpos_c2x)
        self.scan()
    }
}
