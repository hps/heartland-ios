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
        self.gmsWrapper = .init(
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
        if let wrapper = self.gmsWrapper {
            isScanning = true
            wrapper.searchDevices()
        }
    }
    
    public func stopScan() {
        if let wrapper = self.gmsWrapper {
            wrapper.cancelSearch()
        }
    }
    public func getDeviceInfo() {}
    public func connectDevice(_ device: HpsTerminalInfo) {
        if let wrapper = self.gmsWrapper {
            wrapper.connectDevice(device)
        }
    }
    public func processTransactionWithRequest(_ builder: GMSBaseBuilder, withTransactionType transactionType: HpsTransactionType) {
        if let wrapper = self.gmsWrapper {
            wrapper.startTransaction(builder, withTransactionType: transactionType)
        }
    }
    public func confirmAmount(_ amount: Decimal) {
        if let wrapper = self.gmsWrapper {
            wrapper.confirmAmount(amount: amount)
        }
    }
    public func confirmApplication(_ application: AID) {
        if let wrapper = self.gmsWrapper {
            wrapper.selectAID(aid: application)
        }
    }
    public func cancelTransaction() {
        if let wrapper = self.gmsWrapper {
            wrapper.cancelTransaction()
        }
    }

    // mark: GMSClientAppDelegate

    public func deviceConnected() {
        self.deviceDelegate?.onConnected() //:(HpsTerminalInfo *)terminalInfo];
    }

    public func deviceDisconnected() {
        self.deviceDelegate?.onDisconnected()
    }

    public func searchComplete() {
        targetTerminalId = nil
        isScanning = false
        self.deviceDelegate?.onBluetoothDeviceList(self.peripherals)
    }

    public func deviceFound(_ device: NSObject) {
        guard let terminal = device as? HpsTerminalInfo else {
            return
        }
        
        terminalsById[terminal.identifier] = terminal
        
        if targetTerminalId == terminal.identifier {
            stopScan()
        }
    }

    public func onStatus(_ status: HpsTransactionStatus) {
        self.transactionDelegate?.onStatusUpdate(status)
    }


    public func onTransactionCancelled() {
        self.transactionDelegate?.onTransactionCancelled()
    }


    public func onTransactionComplete(_ result: String, response: HpsTerminalResponse) {
        self.transactionDelegate?.onTransactionComplete(response)
    }


    public func requestAIDSelection(_ applications: Array<AID>) {
        self.transactionDelegate?.onConfirmApplication(applications)
    }


    public func requestAmountConfirmation(_ amount: Decimal) {
        self.transactionDelegate?.onConfirmAmount(amount)
    }


    public func requestPostalCode(_ maskedPan: String, expiryDate: String, cardholderName: String) {
    }


    public func requestSaFApproval() {
    }

    public func onError(_ error: NSError) {
        self.transactionDelegate?.onTransactionError(error)
    }
}

// MARK: Firmware Update
extension GMSDevice {
    public func getAllVersionsForC2X() {
        gmsWrapper?.terminalOTADelegate = self
        gmsWrapper?.requestAvailableOTAVersionsListFor(type: .firmware)
    }
    
    public func requestUpdateVersionForC2X() {
        gmsWrapper?.terminalOTADelegate = self
        gmsWrapper?.requestToStartUpdateFor(type: .firmware)
    }
    
    public func requestTerminalVersionData() {
        gmsWrapper?.terminalOTADelegate = self
        gmsWrapper?.requestTerminalVersionData()
    }
    
    public func setVersionDataFor(versionString: String) {
        gmsWrapper?.terminalOTADelegate = self
        gmsWrapper?.setVersionDataFor(versionString: versionString)
    }
}

extension GMSDevice: GMSClientTerminalOTAManagerDelegate {
    public func terminalVersionDetails(info: [AnyHashable : Any]?) {
        otaFirmwareUpdateDelegate?.onTerminalVersionDetails(info: info)
    }
    
    public func terminalOTAResult(resultType: GlobalMobileSDK.TerminalOTAResult,
                                  info: [String : AnyObject]?, error: Error?) {
        otaFirmwareUpdateDelegate?.terminalOTAResult(resultType: resultType, info: info, error: error)
    }
    
    public func listOfVersionsFor(type: GlobalMobileSDK.TerminalOTAUpdateType, results: [Any]?) {
        otaFirmwareUpdateDelegate?.listOfVersionsFor(results: results)
    }
    
    public func otaUpdateProgress(percentage: Float) {
        otaFirmwareUpdateDelegate?.otaUpdateProgress(percentage: percentage)
    }
    
    public func onReturnSetTargetVersion(resultType: GlobalMobileSDK.TerminalOTAResult,
                                         type: GlobalMobileSDK.TerminalOTAUpdateType, message: String) {
        otaFirmwareUpdateDelegate?.onReturnSetTargetVersion(message: message)
    }
}
