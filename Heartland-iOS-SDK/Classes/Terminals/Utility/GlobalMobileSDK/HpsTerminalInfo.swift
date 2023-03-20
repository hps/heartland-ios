import Foundation
import GlobalMobileSDK

@objcMembers
public class HpsTerminalInfo: NSObject {
    internal var gmsTerminalInfo: GMSTerminalInfo
    public var name: String = ""
    public var descriptionText: String = ""
    public var connected: Bool = false
    public var terminalType: String = ""
    public var identifier: UUID = .init()

    required init(name: String, description: String, connected: Bool, terminalType: String, identifier: UUID) {
        let type = TerminalType(rawValue: terminalType) ?? .none
        gmsTerminalInfo = GMSTerminalInfo(name: name, description: description, connected: connected, terminalType: type, identifier: identifier)
        super.init()
        setProperties(gmsTerminalInfo)
    }

    init(fromTerminalInfo terminalInfo: TerminalInfo) {
        gmsTerminalInfo = terminalInfo as! GMSTerminalInfo
        super.init()
        setProperties(gmsTerminalInfo)
    }

    private func setProperties(_ terminalInfo: GMSTerminalInfo) {
        name = terminalInfo.name
        descriptionText = terminalInfo.description
        connected = terminalInfo.connected
        terminalType = terminalInfo.terminalType.rawValue
        identifier = terminalInfo.identifier
    }
}
