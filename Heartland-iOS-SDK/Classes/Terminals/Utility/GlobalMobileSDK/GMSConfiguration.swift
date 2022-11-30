import Foundation
import GlobalMobileSDK

@objcMembers
public class GMSConfiguration: NSObject {
    private var config: HpsConnectionConfig?
    
    public override init() {
    }

    public init(config: HpsConnectionConfig) {
        self.config = config
    }

    public func asPorticoConfig(terminalType: TerminalType) -> PorticoConfig {
        var config = PorticoConfig()
        if let c = self.config {
            config.username = c.username
            config.password = c.password
            config.licenseId = c.licenseID
            config.siteId = c.siteID
            config.deviceId = c.deviceID
            config.developerId = c.developerID
            config.versionNumber = c.versionNumber
            config.environment = c.isProduction ? .production : .certification
            if c.timeout > 0 {
                config.timeout = Int32(c.timeout)
            }

            if c.terminalOnlineProcessTimeout > 0 {
                config.terminalOnlineProcessTimeout = UInt(c.terminalOnlineProcessTimeout)
            }
        }
        config.merchantName = ""
        config.merchantNumber = ""
        config.merchantAddress = ""
        config.acknowledgement = ""
        config.signatureAgreement = ""
        config.terminalType = terminalType
        return config
    }
    
    public static func fromHpsConnectionConfig(_ config: HpsConnectionConfig) -> GMSConfiguration {
        return GMSConfiguration(config: config)
    }
}
