import Foundation

@objcMembers
public class GMSDevice: NSObject, GMSClientAppDelegate, GMSDeviceInterface {
    
    public var gmsWrapper: GMSWrapper?
    public var deviceDelegate: GMSDeviceDelegate?
    public weak var deviceScanObserver: GMSDeviceScanObserver?
    public var transactionDelegate: GMSTransactionDelegate?
    public var targetTerminalId: UUID?
    public private(set) var terminalsById = [UUID: HpsTerminalInfo]()
    public var otaFirmwareUpdateDelegate: GMSDeviceFirmwareUpdateDelegate?

    public private(set) var isScanning = false {
        didSet {
            if oldValue != isScanning {
                deviceScanObserver?.deviceDidUpdateScanState(to: isScanning)
            }
        }
    }

    internal init(config: HpsConnectionConfig, entryModes: [EntryMode], terminalType: TerminalType) {
        super.init()
        gmsWrapper = .init(
            .fromHpsConnectionConfig(config),
            delegate: self,
            entryModes: entryModes,
            terminalType: terminalType
        )
    }

    public var peripherals: NSMutableArray {
        NSMutableArray(array: Array(terminalsById.values))
    }

    public var terminals: [HpsTerminalInfo] {
        peripherals as? [HpsTerminalInfo] ?? []
    }

    public func scan() {
        if let wrapper = gmsWrapper {
            isScanning = true
            wrapper.searchDevices()
        }
    }

    public func stopScan() {
        if let wrapper = gmsWrapper {
            wrapper.cancelSearch()
        }
    }

    public func getDeviceInfo() {}
    public func connectDevice(_ device: HpsTerminalInfo) {
        if let wrapper = gmsWrapper {
            wrapper.connectDevice(device)
        }
    }

    public func processTransactionWithRequest(_ builder: GMSBaseBuilder, withTransactionType transactionType: HpsTransactionType) {
        if let wrapper = gmsWrapper {
            
            wrapper.startTransaction(builder, withTransactionType: transactionType)
        }
    }

    public func confirmAmount(_ amount: Decimal) {
        if let wrapper = gmsWrapper {
            wrapper.confirmAmount(amount: amount)
        }
    }
    
    public func confirmSurcharge(_ confirmSurcharge: Bool) {
        if let wrapper = gmsWrapper {
            wrapper.confirmSurcharge(confirmSurcharge)
        }
    }

    public func confirmApplication(_ application: AID) {
        if let wrapper = gmsWrapper {
            wrapper.selectAID(aid: application)
        }
    }

    public func cancelTransaction() {
        if let wrapper = gmsWrapper {
            wrapper.cancelTransaction()
        }
    }

    // MARK: GMSClientAppDelegate

    public func deviceConnected() {
        deviceDelegate?.onConnected() //: (HpsTerminalInfo *)terminalInfo];
    }

    public func deviceDisconnected() {
        deviceDelegate?.onDisconnected()
    }

    public func searchComplete() {
        targetTerminalId = nil
        isScanning = false
        deviceDelegate?.onBluetoothDeviceList(peripherals)
    }

    public func deviceFound(_ device: NSObject) {
        guard let terminal = device as? HpsTerminalInfo else {
            return
        }

        terminalsById[terminal.identifier] = terminal

        if targetTerminalId == nil || targetTerminalId == terminal.identifier {
            stopScan()
        }
    }

    public func onStatus(_ status: HpsTransactionStatus) {
        transactionDelegate?.onStatusUpdate(status)
    }

    public func onTransactionCancelled() {
        transactionDelegate?.onTransactionCancelled()
    }

    public func onTransactionComplete(_: String, response: HpsTerminalResponse) {
        transactionDelegate?.onTransactionComplete(response)
    }

    public func requestAIDSelection(_ applications: [AID]) {
        transactionDelegate?.onConfirmApplication(applications)
    }

    public func requestAmountConfirmation(_ amount: Decimal) {
        transactionDelegate?.onConfirmAmount(amount)
    }
    
    public func onTransactionWaitingForSurchargeConfirmation(result: HpsTransactionStatus, response: HpsTerminalResponse) {
        transactionDelegate?.onTransactionWaitingForSurchargeConfirmation(result: result, response: response)
    }
    

    public func requestPostalCode(_: String, expiryDate _: String, cardholderName _: String) {}

    public func requestSaFApproval() {}

    public func onError(_ error: NSError) {
        transactionDelegate?.onTransactionError(error)
    }
    
    public func isConnected() -> Bool {
        if let gmsWrapper = gmsWrapper {
            return gmsWrapper.isDeviceConnected()
        }
        return false
    }
}

// MARK: Firmware Update

public extension GMSDevice {
    func getAllVersionsForC2X() {
        gmsWrapper?.terminalOTADelegate = self
        gmsWrapper?.requestAvailableOTAVersionsListFor(type: .firmware)
    }

    func requestUpdateVersionForC2X() {
        gmsWrapper?.terminalOTADelegate = self
        gmsWrapper?.requestToStartUpdateFor(type: .firmware)
    }
    
    func requestUpdateConfigForDevice() {
        gmsWrapper?.terminalOTADelegate = self
        gmsWrapper?.requestToStartUpdateFor(type: .config)
    }

    func requestTerminalVersionData() {
        gmsWrapper?.terminalOTADelegate = self
        gmsWrapper?.requestTerminalVersionData()
    }

    func setVersionDataFor(versionString: String) {
        gmsWrapper?.terminalOTADelegate = self
        gmsWrapper?.setVersionDataFor(versionString: versionString)
    }
    
    func setRemoteKeyInjection() {
        gmsWrapper?.terminalOTADelegate = self
        gmsWrapper?.requestToStartUpdateFor(type: .keyInjection)
    }
}

extension GMSDevice: GMSClientTerminalOTAManagerDelegate {
    public func terminalVersionDetails(info: [AnyHashable: Any]?) {
        otaFirmwareUpdateDelegate?.onTerminalVersionDetails(info: info)
    }

    public func terminalOTAResult(resultType: GlobalMobileSDK.TerminalOTAResult,
                                  info: [String: AnyObject]?, error: Error?)
    {
        otaFirmwareUpdateDelegate?.terminalOTAResult(resultType: resultType, info: info, error: error)
    }

    public func listOfVersionsFor(type _: GlobalMobileSDK.TerminalOTAUpdateType, results: [Any]?) {
        otaFirmwareUpdateDelegate?.listOfVersionsFor(results: results)
    }

    public func otaUpdateProgress(percentage: Float) {
        otaFirmwareUpdateDelegate?.otaUpdateProgress(percentage: percentage)
    }

    public func onReturnSetTargetVersion(resultType _: GlobalMobileSDK.TerminalOTAResult,
                                         type _: GlobalMobileSDK.TerminalOTAUpdateType, message: String)
    {
        otaFirmwareUpdateDelegate?.onReturnSetTargetVersion(message: message)
    }
}
