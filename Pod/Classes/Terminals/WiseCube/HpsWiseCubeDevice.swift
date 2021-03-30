import Foundation

@objcMembers
public class HpsWiseCubeDevice : GMSDevice, IWiseCubeDeviceInterface {    
    public override func initialize() {
        guard let config = self.config else { return }
        let entryModes: [EntryMode] = [
            .contact,
            .contactless,
            .manual
        ]
        self.gmsWrapper = GMSWrapper(GMSConfiguration.fromHpsConnectionConfig(config), delegate: self, entryModes: entryModes, terminalType: .bbpos_wisecube)
        self.scan()
    }
}
