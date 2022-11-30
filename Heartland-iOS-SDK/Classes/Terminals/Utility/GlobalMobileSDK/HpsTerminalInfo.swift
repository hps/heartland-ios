import Foundation
import GlobalMobileSDK

@objcMembers
public class HpsTerminalInfo: NSObject {
    internal var gmsTerminalInfo: GMSTerminalInfo
    public var name: String = ""
    public var descriptionText: String = ""
    public var connected: Bool = false
    public var terminalType: String = ""
    public var identifier: UUID = UUID()
    
    required init(name: String, description: String, connected: Bool, terminalType: String, identifier: UUID) {
        let type: TerminalType = TerminalType(rawValue: terminalType) ?? .none
        self.gmsTerminalInfo = GMSTerminalInfo(name: name, description: description, connected: connected, terminalType: type, identifier: identifier)
        super.init()
        self.setProperties(self.gmsTerminalInfo)
    }
    
    init(fromTerminalInfo terminalInfo: TerminalInfo) {
        self.gmsTerminalInfo = terminalInfo as! GMSTerminalInfo
        super.init()
        self.setProperties(self.gmsTerminalInfo)
    }
    
    private func setProperties(_ terminalInfo: GMSTerminalInfo) {
        self.name = terminalInfo.name
        self.descriptionText = terminalInfo.description
        self.connected = terminalInfo.connected
        self.terminalType = terminalInfo.terminalType.rawValue
        self.identifier = terminalInfo.identifier
    }
}
