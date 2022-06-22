import Foundation
import GlobalMobileSDK

@objc
public class HpsTerminalInfo: NSObject {
    internal var gmsTerminalInfo: GMSTerminalInfo
    @objc public var name: String = ""
    @objc public var descriptionText: String = ""
    @objc public var connected: Bool = false
    @objc public var terminalType: String = ""
    @objc public var identifier: UUID = UUID()
    
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
