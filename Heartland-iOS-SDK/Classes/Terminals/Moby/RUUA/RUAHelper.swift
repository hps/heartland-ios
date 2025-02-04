//
//  RUAHelper.swift
//  MobiPay
//
//

import Foundation
import RUA_BLE
//import RuaWrapper

enum MainMobyTransaction {
    case auth
    case credit
    case refund
    case void
    case reversal
    case capture
}

//["Moby3000","RP45BT","Moby5500","Moby8500"]
enum ReaderDeviceType: String,CaseIterable{
    //case Moby3000 = "Moby3000"
    case RP45BT = "RP45BT"
    case Moby5500 = "Moby5500"
    case Moby8500 = "Moby8500"
    
    init?(id: Int) {
        switch id {
        case 1: self = .RP45BT
        case 2: self = .Moby8500
        case 3: self = .Moby5500
            /*case 4: self = .Moby3000*/
        default: return nil
        }
    }
    
    static func toRuaDeviceType(enumString: String) -> RUADeviceType{
        switch enumString {
        case "RP45BT": return RUADeviceTypeRP45BT
        case "Moby5500": return RUADeviceTypeMOBY5500
        case "Moby8500": return RUADeviceTypeMOBY8500
        default: return RUADeviceTypeUnknown
        }
    }
}

enum PairingStatus {
    case Failed
    case NotSupported
    case Succeeded
    case Cancelled
}

enum KeyMappingStubMode: String,CaseIterable{
    case None = "No stub"
    case Stub1 = "Stub 1"
    case Stub2 = "Stub 2"
}

public class RuaDevice: NSObject,Identifiable{
    @objc public var deviceName: String
    @objc public var deviceIdentifier: String
    
    init(deviceName: String, deviceSerialNumber: String) {
        self.deviceName = deviceName
        self.deviceIdentifier = deviceSerialNumber
    }
}

@available(iOS 13.0, *)
class RUAHelper: NSObject {
    
    private var ruaDeviceManager: RUADeviceManager?
    private var selectedRUADevice: RUADevice? = nil
    private var currentPublicKeyIndex: Int = 0
    private var configVersion: String = "PayPal1.0"
    private var connectedDeviceSerialNumber: String? = nil
    var discoveredRUADevices = [RUADevice]()
    @Published var deviceLists = [HpsTerminalInfo]()
    private var initialized = false
    
    private var rkiIsExecuted = false
    
    var currentKeyMappingInfoMode = KeyMappingStubMode.None
    
    var isConnectedToDevice = false
    
    private var stateJson: [String:AnyObject]
    
    private var loggerBlock: ((String) -> Void)?
    private var searchBlock : ([RuaDevice]) -> Void = {_ in }
    private var initilalizeCompletionBlock : (String?,String?) -> Void = {_,_ in }
    private var releaseCompletionBlock : (Bool) -> Void = {_ in }
    private var readerStateFileCompletionBlock : (String?) -> Void = {_ in}
    private var appIdSelectionBlock : ([RUAApplicationIdentifier]) -> Void = {_ in}
    
    @Published var showLoadingScreen: Bool = false
    
    private(set) var mobyDevice: HpsMobyDevice?
    
    private var launchTransactionAfterSetup = false
    private var hardwareType : String? = nil
    
    public static let sharedInstance = RUAHelper()
    
    private var connectingFinishBlock: ((Bool?) -> Void) = {_ in }
    
    public var mainTransaction: MainMobyTransaction = .credit
    @Published public var terminalRefNumber: String?
    public var clientTransactionId: String?
    @Published public var transactionId: String?
    @Published public var statusText: String = String.empty
    @Published public var deviceResponseCode: String = String.empty
    @Published public var message: String = String.empty
    @Published public var success: Bool = false
    @Published public var showMessage: Bool = false
    @Published public var isProcessing: Bool = false
    @Published public var status: String = "PROCESSING"
    @Published public var receiptImage: UIImage?
    
    let headerDetail = ReceiptHelperDetail(headerTitle: "HPS Test",
                                           headerAddress: "1 Heartland Way",
                                           headerAddressComplement: "Jeffersonville, IN 47136",
                                           headerPhone: "888-798-3133",
                                           description: "Merchandise")
    
    private override init()  {
        RUA.setProductionMode(false)
        RUA.enableDebugLogMessages(false)
        ruaDeviceManager = RUA.getDeviceManager(RUADeviceTypeMOBY5500)
        stateJson = [String:AnyObject]()
    }
    
    func startLoggerBlock(loggerBlock : @escaping (String) -> Void){
        self.loggerBlock = loggerBlock
    }
    
    func stopLoggerBlock(){
        self.loggerBlock = nil
    }
    
    private func releaseRua(){
        ruaDeviceManager?.releaseDevice()
    }
    
    private func getRuaSdkVersion() -> Int{
        return RUA.version()
    }
    
    func initializeWith(config: HpsConnectionConfig,
                        initialisationCompletionBlock : @escaping (String?,String?) -> Void,
                        releaseCompletionBlock : @escaping (Bool) -> Void) {
        self.initilalizeCompletionBlock = initialisationCompletionBlock
        self.releaseCompletionBlock = releaseCompletionBlock
        
        mobyDevice = HpsMobyDevice(config: config)
        //        mobyDevice?.otaFirmwareUpdateDelegate = self
        mobyDevice?.transactionDelegate = self
        mobyDevice?.deviceDelegate = self
        
    }
    
    func startSearchingDevices(searchFinishBlock : @escaping ([RuaDevice]) -> Void) {
        self.searchBlock = searchFinishBlock
        mobyDevice?.scan()
    }
    
    func connect(_ deviceSelected: RuaDevice,
                 connectingFinishBlock : @escaping (Bool?) -> Void) {
        showLoadingScreen = true
        let device = HpsTerminalInfo.init(name: deviceSelected.deviceName,
                                             description: deviceSelected.description,
                                             connected: mobyDevice?.isConnected() ?? false,
                                             terminalType: deviceSelected.deviceName,
                                             identifier: UUID(uuidString: deviceSelected.deviceIdentifier) ?? UUID())
        self.connectingFinishBlock = connectingFinishBlock
        mobyDevice?.connectDevice(device)
    }
    
    func getDeviceName() -> String{
        var result : String? = nil
        if(self.selectedRUADevice != nil){
            result = self.selectedRUADevice?.name
        }else{
            result =  self.lastSelectedDevice()?.name
        }
        if let resultNottNil = result {
            return resultNottNil
        }
        return "Unknown"
    }
    
    private func logMessage(_ message : String){
        self.loggerBlock?("[SDK RUA]\(message)\n")
        print(message)
    }
    
    func release(){
        showLoadingScreen = true
        DispatchQueue.global().async {
            self.mobyDevice?.disconnectDevice()
        }
    }
    
    // MARK:  Transaction command sending
    
    private func saveSelectedDevice(ruaDevice : RUADevice) {
        do {
            let deviceData = try NSKeyedArchiver.archivedData(withRootObject: ruaDevice, requiringSecureCoding: false)
            UserDefaults.standard.set(deviceData,forKey: "lastUsedDevice")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func lastSelectedDevice() -> RUADevice? {
        var ruaDevice : RUADevice?
        let lastDeviceSaveData = UserDefaults.standard.data(forKey: "lastUsedDevice")
        guard let lastDeviceData = lastDeviceSaveData else {return nil}
        
        do {
            try ruaDevice = NSKeyedUnarchiver.unarchivedObject(ofClass: RUADevice.self, from: lastDeviceData)
        } catch {
            print(error.localizedDescription)
        }
        return ruaDevice
    }
    
    // MARK:  RUADeviceSearchListener delegate methods
    
    func getPrefix(ruaDeviceType : RUADeviceType)-> String{
        switch ruaDeviceType {
        case RUADeviceTypeRP45BT : return "RP450"
        case RUADeviceTypeMOBY5500 : return "MOB55"
        case RUADeviceTypeMOBY8500 : return "MOB85"
        default : return ""
        }
    }
    
    func discoveredDevice(_ reader: RUADevice!) {
        print("Find device \(reader.name ?? "")")
        guard reader.name != nil else {
            return
        }
        discoveredRUADevices.append(reader)
    }
    
    func discoveryComplete() {
        print("On discovery complete")
        self.searchBlock(discoveredRUADevices.map { (ruaDevice) -> RuaDevice in
            RuaDevice(deviceName: ruaDevice.name, deviceSerialNumber: ruaDevice.identifier)
        })
    }
    
    // MARK:  RUADeviceStatusHandler delegate methods

    func getHardwareType() -> ReaderDeviceType?{
        guard let ht = hardwareType else {
            return nil
        }
        if(ht.contains("MOB85")){
            return ReaderDeviceType.Moby8500
        }else if(ht.contains("MOB55")){
            return ReaderDeviceType.Moby5500
        }
        return nil
    }
    
    func getReaderVersionInfo(completionBlock : @escaping (RUAReaderVersionInfo?) -> Void){
        self.ruaDeviceManager?.getConfigurationManager().readVersion({ _, _ in
            
        }, response: { response in
            let dictionnary = response?.responseData as? Dictionary<Int,Any>
            let readerVersionInfo : RUAReaderVersionInfo? = dictionnary?[RUAParameter.readerVersionInfo.rawValue] as? RUAReaderVersionInfo
            completionBlock(readerVersionInfo)
        })
    }
    
    func updateFirmwareSmartMode(fromFilePath : String,toFilePath : String,readerVersion : RUAReaderVersionInfo?,responseBlock : @escaping (Bool) -> Void){
        RUA.repackageUNSFile(fromFilePath, toFilePath: toFilePath, andReaderVersion: readerVersion,withResponse:  { ruaResponse in
            responseBlock(ruaResponse?.responseCode == RUAResponseCodeSuccess)
        })
    }
    
    func updateFirmware(firmwareFilePath : String,updateCompletionBlock : @escaping () -> Void,progressionBlock : @escaping (String) -> Void){
        ruaDeviceManager?.enableFirmwareUpdateMode({ ruaReponseUpdateMode in
            self.ruaDeviceManager?.updateFirmware(firmwareFilePath, progress: { progress, message in
                if let messageNotNil = message {
                    progressionBlock(messageNotNil)
                }
                print("Update Firmware progression : \(progress) <==> \(message)")
            }, response: { ruaReponseFirmwareUpdate in
                updateCompletionBlock()
            })
        })
    }
    
    
    func generateJsonFile(readerStateFileCompletionBlock : @escaping (String?) -> Void){
        self.readerStateFileCompletionBlock = readerStateFileCompletionBlock
        let readCapabilitiesBuffer : NSMutableString = ""
        readCapabilities(readCapabilitiesBuffer: readCapabilitiesBuffer)
    }
    
    private func readCapabilities(readCapabilitiesBuffer : NSMutableString){
        ruaDeviceManager?.getConfigurationManager().getReaderCapabilities({ _, _ in
            
        }, response: { ruaResponse in
            let dictionnary = ruaResponse?.responseData as? Dictionary<Int,String>
            let terminalCapabilities = dictionnary?[RUAParameter.terminalCapabilities.rawValue]
            readCapabilitiesBuffer.append(",\"TerminalCapabilities\": \"\(terminalCapabilities ?? "")\",\n")
            let interfaceDeviceSerialNumber = dictionnary?[RUAParameter.interfaceDeviceSerialNumber.rawValue]
            readCapabilitiesBuffer.append("\"InterfaceDeviceSerialNumber\": \"\(interfaceDeviceSerialNumber ?? "")\"\n }")
            self.readVersion(readCapabilitiesBuffer: readCapabilitiesBuffer)
        })
    }
    
    
    private func loadHardwareType(){
        self.ruaDeviceManager?.getConfigurationManager().readVersion({ _, _ in
            
        }, response: { ruaResponse in
            let dictionnary = ruaResponse?.responseData as? Dictionary<Int,Any>
            if let readerVersionInfo : RUAReaderVersionInfo = dictionnary?[RUAParameter.readerVersionInfo.rawValue] as? RUAReaderVersionInfo {
                self.hardwareType = readerVersionInfo.hardwareType
            }
            guard let selectedDevice = self.selectedRUADevice else {return }
            
            self.ruaDeviceManager?.getConfigurationManager().getReaderCapabilities({ ruaProgressMessage, additionalMessage in
                print("\(ruaProgressMessage.rawValue) -> \(additionalMessage ?? "")")
            }, response: { ruaReponse in
                self.logMessage("[onConnected][Response]\(ruaReponse?.toString() ?? "")")
                let dictionnary = ruaReponse?.responseData as? Dictionary<Int,String>
                self.connectedDeviceSerialNumber = dictionnary?[RUAParameter.interfaceDeviceSerialNumber.rawValue]
                self.initilalizeCompletionBlock(selectedDevice.name,self.connectedDeviceSerialNumber)
                self.isConnectedToDevice = true
            })
        })
    }
    
    func enableRKIMode(_ groupName : String,_ completionBLock : @escaping (Bool) -> Void){
        self.ruaDeviceManager?.getConfigurationManager().enableRKIMode({ ruaResponse in
            self.triggerRKIWithGroupName(groupName: groupName,completionBLock)
        })
    }
    
    func triggerRKIWithGroupName(groupName : String,_ completionBLock : @escaping (Bool) -> Void){
        self.ruaDeviceManager?.getConfigurationManager().triggerRKI(withGroupName: groupName, response: { ruaResponse in
            if(ruaResponse?.responseCode == RUAResponseCodeSuccess){
                self.logMessage("[triggerRKIWithGroupName][Response]\(ruaResponse?.toString() ?? "")")
                self.readKeyMappingInfo(groupName,completionBLock)
            }else{
                completionBLock(false)
            }
        })
    }
    
    func readKeyMappingInfo(_ groupName : String,_ completionBLock : @escaping (Bool ) -> Void){
        self.ruaDeviceManager?.getConfigurationManager().readKeyMapping({ progressMessage, aditionnalMessage in
            
        }, response: { ruaResponse in
            let dictionnary = ruaResponse?.responseData as? Dictionary<Int,Any>
            if let readerVersionInfo : RUAKeyMappingInfo = dictionnary?[RUAParameter.keyMappingInfo.rawValue] as? RUAKeyMappingInfo {
                print(readerVersionInfo.toString())
                if(!self.rkiIsExecuted){
                    self.rkiIsExecuted = true
                    self.enableRKIMode(groupName,completionBLock)
                }else{
                    self.rkiIsExecuted = false
                    completionBLock(true)
                }
            }else{
                self.rkiIsExecuted = false
                completionBLock(true)
            }
        })
    }
    
    private func readVersion(readCapabilitiesBuffer : NSMutableString){
        self.ruaDeviceManager?.getConfigurationManager().readVersion({ _, _ in
            
        }, response: { ruaResponse in
            var readVersionBuffer : String = ""
            let dictionnary = ruaResponse?.responseData as? Dictionary<Int,Any>
            
            
            if let readerVersionInfo : RUAReaderVersionInfo = dictionnary?[RUAParameter.readerVersionInfo.rawValue] as? RUAReaderVersionInfo {
                self.hardwareType = readerVersionInfo.hardwareType
                readVersionBuffer.append(readerVersionInfo.toString())
            }
            if let readerVersion : RUAReaderVersionInfo = dictionnary?[RUAParameter.readerVersion.rawValue] as? RUAReaderVersionInfo {
                readVersionBuffer.append(readerVersion.toString())
            }
            readVersionBuffer = readVersionBuffer.replacingLastOccurrenceOfString("}", with: String(readCapabilitiesBuffer))
            
            let data = readVersionBuffer.data(using: .utf8)
            do {
                var jsonArray = try JSONSerialization.jsonObject(with: data!, options : .allowFragments) as? [String:AnyObject]
                let userFileVersion = jsonArray?["user_file_version"] as? [Dictionary<String,Any>]
                jsonArray?.removeValue(forKey: "user_file_version")
                jsonArray?["user_file_version"]  = userFileVersion?[0] as AnyObject
                
                self.stateJson["ReaderVersionInfo"] = jsonArray as AnyObject?
                print("jsonArray")
            } catch let error as NSError {
                print(error)
            }
            self.readFirmwareChecksumInfo()
        })
    }
    
    private func readFirmwareChecksumInfo(){
        ruaDeviceManager?.getConfigurationManager().getChecksumFor(.staticSoftware, response: { ruaResponse in
            let dictionnary = ruaResponse?.responseData as? Dictionary<Int,Any>
            if let firmwareChecksumInfo = dictionnary?[RUAParameter.firmwareChecksumInfo.rawValue] as? String {
                self.stateJson["FirmwareChecksumInfo"] = firmwareChecksumInfo.toJsonObject() as AnyObject?
            }
            self.readCertificateFilesVersionResponse()
        })
    }
    
    private func readCertificateFilesVersionResponse(){
        ruaDeviceManager?.getConfigurationManager().readCertificateFilesVersion({ _, _ in}, response: { ruaResponse in
            let dictionnary = ruaResponse?.responseData as? Dictionary<Int,Any>
            if let readCertificateFilesVersionInfo = dictionnary?[RUAParameter.readCertificateFilesVersionInfo.rawValue] as? RUACertificateFilesVersionInfo {
                self.stateJson["CertificateFilesVersionInfo"] = readCertificateFilesVersionInfo.toString().toJsonObject() as AnyObject?
            }
            self.readKeyMapping()
        })
        
    }
    
    private func readKeyMapping(){
        ruaDeviceManager?.getConfigurationManager().readKeyMapping({ _, _ in }, response: { ruaResponse in
            switch self.currentKeyMappingInfoMode {
            case .Stub1:
                self.stateJson["KeyMappingInfo"] =  "{\"dukpt_keys\": [{\"ksn\": \":FFFFFF00060000000000\",\"key_name\":\":2015-K-F01-ED00\",\"encrypted_value\":\":AE002F3EF2FB9B624F2644ECB0D43529\"},{\"ksn\": \":FFFFFF00080000000000\",\"key_name\": \":2015-K-F03-BD00\",\"encrypted_value\": \":8BAE75AD1AF8FCB733AEAF97944E5B9C\"}]}".toJsonObject() as AnyObject?
            case .Stub2:
                self.stateJson["KeyMappingInfo"] =  "{\"dukpt_keys\": [{\"ksn\": \":FFFFFF00560000000000\",\"key_name\":\":2015-K-F51-ED00\",\"encrypted_value\":\":12345678901234567890123456789012\"},{\"ksn\": \":FFFFFF00580000000000\",\"key_name\": \":2015-K-F53-BD00\",\"encrypted_value\": \":ABCDEFGHIJKLMNOPABCDEFGHIJKLMNOP\"}]}".toJsonObject() as AnyObject?
            default:
                let dictionnary = ruaResponse?.responseData as? Dictionary<Int,Any>
                if let keyMappingInfo = dictionnary?[RUAParameter.keyMappingInfo.rawValue] as? RUAKeyMappingInfo  {
                    self.stateJson["KeyMappingInfo"] = keyMappingInfo.toString().toJsonObject() as AnyObject?
                }
            }
            self.readDeviceStatistics()
        })
    }
    
    
    
    private func readDeviceStatistics(){
        ruaDeviceManager?.getDeviceStatistics({ ruaResponse in
            let dictionnary = ruaResponse?.responseData as? Dictionary<Int,Any>
            guard let dictionnaryNotNill = dictionnary else {
                return
            }
            var dictionnaryConverted = Dictionary<String,Any>()
            for key in dictionnaryNotNill.keys{
                dictionnaryConverted["\(key)"] = dictionnaryNotNill[key]
            }
            
            self.stateJson["DeviceStatistics"] = dictionnaryConverted as AnyObject?
            self.stateJson["MobileInfo"] = self.generateMobileInfo() as AnyObject?
            
            do {
                let data1 = try JSONSerialization.data(withJSONObject: self.stateJson, options: JSONSerialization.WritingOptions.prettyPrinted)
                let convertedString = String(data: data1, encoding: String.Encoding.utf8) as NSString? ?? ""
                self.readerStateFileCompletionBlock(convertedString as String)
            } catch {
                print("Error: ", error)
            }
            
            
        })
    }
    
    private func generateMobileInfo() -> Dictionary<String,String>{
        var result = Dictionary<String,String>()
        result["OS"] = "IOS"
        result["MobileModel"] = "Iphone 12 mini"
        result["MobileSdkVersion"] = "IOS"
        result["MobileManufacturer"] = "Apple"
        result["TerminalId"] = self.connectedDeviceSerialNumber ?? ""
        result["ApplicationID"] = "atos-worldline.Heartland-iOS-SDK"
        if let versionName = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            result["ApplicationVersionName"] = versionName
        }
        if let versionCode = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            result["ApplicationVersionCode"] = versionCode
        }
        
        return result
    }
    
    func readCapabilities(){
        self.ruaDeviceManager?.getConfigurationManager().getReaderCapabilities({ _, _ in
            
        }, response: { ruaResponse in
            let dictionnary = ruaResponse?.responseData as? Dictionary<Int,String>
            
            let interfaceDeviceSerialNumber = dictionnary?[RUAParameter.interfaceDeviceSerialNumber.rawValue]
            self.connectedDeviceSerialNumber = interfaceDeviceSerialNumber
        })
    }
}

extension RUAResponse{
    func toString() -> String {
        var returnStr = ""
        
        returnStr.append(String(format : "%@:%@,\n",RUAEnumerationHelper.ruaParameter_(toString: RUAParameter.command),RUAEnumerationHelper.ruaCommand_(toString: command)))
        returnStr.append(String(format : "%@:%@,\n",RUAEnumerationHelper.ruaParameter_(toString: RUAParameter.responseCode),RUAEnumerationHelper.ruaResponseCode_(toString: responseCode)))
        returnStr.append(String(format : "%@:%@,\n",RUAEnumerationHelper.ruaParameter_(toString: RUAParameter.responseType),RUAEnumerationHelper.ruaResponseType_(toString: responseType)))
        
        if(responseCode == RUAResponseCodeError){
            returnStr.append(String(format : "%@:%@,\n",RUAEnumerationHelper.ruaParameter_(toString: RUAParameter.errorCode),RUAEnumerationHelper.ruaErrorCode_(toString: errorCode)))
            if(additionalErrorDetails != nil){
                returnStr.append(String(format : "%@:%@,\n",RUAEnumerationHelper.ruaParameter_(toString: RUAParameter.errorDetails),additionalErrorDetails))
            }
        }
        
        if(responseData != nil){
            if let responseDataNotNull = responseData {
                for (key,value) in responseDataNotNull {
                    if let param = value as? RUAParameter {
                        returnStr.append(String(format : "%@:%@,\n",RUAEnumerationHelper.ruaParameter_(toString: param),key as CVarArg))
                    }
                    
                }
            }
            
        }
        return returnStr;
    }
    
}

// MARK: Transaction

@available(iOS 13.0, *)
extension RUAHelper {
    
    // MARK: Check if device is ready
    func isDeviceReady() -> Bool {
        return ruaDeviceManager?.isReady() ?? false
    }
    
    // MARK: get transaction manager instance
    private func getTransactionManager() -> RUATransactionManager? {
        return ruaDeviceManager?.getTransactionManager()
    }
    
    private func getFile(_ file: String, _ ext: String) -> String {
        if let bundle = Bundle(identifier: GMSConfiguration.hearlandIdentifierProjectName) {
            return bundle.path(forResource: file, ofType: ext) ?? String.empty
        } else {
            return String.empty
        }
    }
}

@available(iOS 13.0, *)
extension RUAHelper: HpsMobyDeviceDelegate {
    func onConnected() {
        showLoadingScreen = false
        print(" Is Device Connected?: \(mobyDevice?.isConnected())")
        
        self.connectingFinishBlock(mobyDevice?.isConnected())
    }
    
    func onDisconnected() {
        showLoadingScreen = false
        print("Disconnected")
        releaseCompletionBlock(false)
        isConnectedToDevice = false
    }
    
    func onError(_ error: NSError) {
        showLoadingScreen = false
        print(" Error ")
        print(error.localizedDescription)
        print(error)
        self.initilalizeCompletionBlock(nil,nil)
    }
    
    func onBluetoothDeviceList(_ peripherals: NSMutableArray) {
        
        for peripheral in peripherals {
            if let peripheral = peripheral as? HpsTerminalInfo {
                print(peripheral.identifier)
                print(peripheral.name)
                
                self.deviceLists.append(peripheral)
            }
        }
        
        self.searchBlock(deviceLists.map { (ruaDevice) -> RuaDevice in
            RuaDevice(deviceName: ruaDevice.name, deviceSerialNumber: ruaDevice.identifier.uuidString)
        })
    }
}

@available(iOS 13.0, *)
extension RUAHelper: GMSClientAppDelegate {
    func searchComplete() {
        showLoadingScreen = false
        print("searchComplete")
    }
    
    func deviceConnected() {
        showLoadingScreen = false
        print("deviceConnected")
    }
    
    func deviceDisconnected() {
        print("deviceDisconnected")
    }
    
    func deviceFound(_ device: NSObject) {
        print("deviceFound")
    }
    
    func onStatus(_ status: HpsTransactionStatus) {
        print("onStatus")
        mobyDevice?.onStatus(status)
    }
    
    func requestAIDSelection(_ applications: [GlobalMobileSDK.AID]) {
        print("requestAIDSelection")
    }
    
    func requestAmountConfirmation(_ amount: Decimal) {
        print("requestAmountConfirmation")
    }
    
    func requestPostalCode(_ maskedPan: String, expiryDate: String, cardholderName: String) {
        print("requestPostalCode")
    }
    
    func requestSaFApproval() {
        print("requestSaFApproval")
    }
    
    func onTransactionComplete(_ result: String, response: HpsTerminalResponse) {
        print("onTransactionComplete")
        mobyDevice?.onTransactionComplete(result, response: response)
    }
    
    func onTransactionCancelled() {
        print("onTransactionCancelled")
    }
    
    func onTransactionWaitingForSurchargeConfirmation(result: HpsTransactionStatus, response: HpsTerminalResponse) {
        print("onTransactionWaitingForSurchargeConfirmation")
    }
    
    
}

@available(iOS 13.0, *)
extension RUAHelper: GMSTransactionDelegate {
    func onStatusUpdate(_ transactionStatus: Heartland_iOS_SDK.HpsTransactionStatus) {
        print("status")
        print(transactionStatus.rawValue)
        
        switch transactionStatus {
        case .waitingForCard, .presentCard, .presentCardAgain, .started:
            statusText = LoadingStatus.WAITING_FOR_CARD.rawValue
            self.isProcessing = true
        case .processing:
            statusText = LoadingStatus.PROCESSING.rawValue
            self.isProcessing = true
        case .complete:
            statusText = LoadingStatus.COMPLETED.rawValue
            self.isProcessing = false
        case .error:
            statusText = LoadingStatus.ERROR.rawValue
            self.isProcessing = false
        case .terminalDeclined:
            statusText = LoadingStatus.DECLINED.rawValue
            self.isProcessing = false
        case .transactionTerminated:
            statusText = LoadingStatus.TERMINATED.rawValue
            self.isProcessing = false
        case .surchargeRequested:
            statusText = "Surcharge Requested"
            self.isProcessing = false
        default:
            statusText = LoadingStatus.PROCESSING.rawValue
            self.isProcessing = true
        }
        
        self.status = self.statusText
        print(self.status)
        
    }
    
    func onConfirmAmount(_ amount: Decimal) {
        print("TO CONFIRM AMOUNT?")
        mobyDevice?.confirmAmount(amount)
    }
    
    func onConfirmApplication(_ applications: [GlobalMobileSDK.AID]) {
        print("TO CONFIRM APPLICATION?")
        if let application = applications.first {
            mobyDevice?.confirmApplication(application)
        }
    }
    
    func onTransactionComplete(_ response: HpsTerminalResponse) {
        print("TRANSACTION COMPLETED?")
        self.deviceResponseCode = response.deviceResponseCode
        print(response.approvalCode)
        print(response.jsonString())
        
        if let responseTransactionId = response.transactionId {
            
            self.terminalRefNumber = response.terminalRefNumber
            self.clientTransactionId = response.clientTransactionId
            
            if mainTransaction != .capture {
                self.transactionId = responseTransactionId
            }
        }
        
        self.isProcessing = false
        
        if let deviceResponseCode = response.deviceResponseCode {
            switch deviceResponseCode {
            case LoadingStatus.APPROVAL.rawValue:
                showDialog(for: .APPROVED(response: response))
            case LoadingStatus.PARTIAL_APPROVAL.rawValue:
                showDialog(for: .APPROVED(response: response))
            case LoadingStatus.DECLINED.rawValue:
                showDialog(for: .DECLINED(response: response))
            case LoadingStatus.CANCELLED.rawValue:
                showDialog(for: .CANCELLED(response: response))
            default:
                self.receiptImage = self.mobyDevice?.printReceipt(response: response,
                                                                  headerDetail: headerDetail)
                if let message = response.responseText {
                    showDialog(for: .MESSAGE(message: message))
                } else if let message = response.deviceResponseMessage {
                    showDialog(for: .MESSAGE(message: message))
                } else {
                    showDialog(for: .MESSAGE(message: "We have faced an issue on trying to perform the transaction"))
                }
            }
        }
        
        
    }
    
    func onTransactionError(_ error: NSError) {
        print("onTransactionError \(error)")
    }
}

@available(iOS 13.0, *)
extension RUAHelper {
    private func showDialog(for status: Status) {
        var messageResult = ""
        var isApproved = false
        var issuerMSG = ""
        var issuerCode = ""
        var GWCode = ""
        var GWMSG = ""
        
        switch status {
        case let .APPROVED(response):
            self.receiptImage = self.mobyDevice?.printReceipt(response: response,
                                                              headerDetail: headerDetail)
            guard let responseCode = response.deviceResponseCode else { return }
            
            if let responseIssuerMSG = response.issuerRspMsg {
                issuerMSG = responseIssuerMSG
            }
            if let responseIssuerCode = response.issuerRspCode {
                issuerCode = responseIssuerCode
            }
            
            if let respCode = response.responseCode {
                GWCode = respCode
            }
            
            if let respText = response.responseText {
                GWMSG = respText
            }
            let surchargeFee = (Decimal(string: response.surchargeFee ?? "0") ?? 0) * 100
            let surchargeAmount = NSDecimalNumber(string: response.surchargeAmount ?? "0")
            messageResult = "Response: \nStatus: \(responseCode)\n Amount: \(String(format: "%.2f", response.approvedAmount.doubleValue))\nSurchargeAmount: \(String(format: "%.2f", surchargeAmount.doubleValue))\nSurchargeFee: \(surchargeFee)%\n Issuer Resp.: \(issuerCode)\n Issuer Auth Data: \(issuerMSG)\nGW Code: \(GWCode)\nGW MSG: \(GWMSG)"
            isApproved = true
            
        case let .CANCELLED(response):
            self.receiptImage = self.mobyDevice?.printReceipt(response: response,
                                                              headerDetail: headerDetail)
            guard let deviceResponseMessage = response.deviceResponseMessage else { return }
            var issuerMSG = ""
            var authCode = ""
            if let responseIssuerMSG = response.issuerRspMsg {
                issuerMSG = responseIssuerMSG
            }
            
            if let authCodeResponse = response.issuerRspCode {
                authCode = authCodeResponse
            }
            
            if let respCode = response.responseCode {
                GWCode = respCode
            }
            
            if let respText = response.responseText {
                GWMSG = respText
            }
            
            messageResult = "Response: \nStatus: \(deviceResponseMessage)\n Amount: \(response.approvedAmount!)\n Auth Resp.: \(authCode)\n Issuer Auth Data: \(issuerMSG)\nGW Code: \(GWCode)\nGW MSG: \(GWMSG)"
            isApproved = false
            
        case let .DECLINED(response):
            self.receiptImage = self.mobyDevice?.printReceipt(response: response,
                                                              headerDetail: headerDetail)
            guard let deviceResponseMessage = response.deviceResponseMessage else { return }
            var issuerMSG = ""
            var issuerCode = ""
            if let responseIssuerMSG = response.issuerRspMsg {
                issuerMSG = responseIssuerMSG
            }
            if let authCodeResponse = response.authCodeData {
                issuerCode = authCodeResponse
            }
            
            if let respCode = response.responseCode {
                GWCode = respCode
            }
            
            if let respText = response.responseText {
                GWMSG = respText
            }
            
            messageResult = "Response: \nStatus: \(deviceResponseMessage)\n Amount: \(response.approvedAmount)\n Auth Resp.: \(issuerCode)\n Issuer Auth Data: \(issuerMSG)\nGW Code: \(GWCode)\nGW MSG: \(GWMSG)"
            isApproved = false
            
        case let .MESSAGE(message):
            messageResult = message
            isApproved = (message.uppercased().contains(LoadingStatus.SUCCESS.rawValue))
        }
        showTextDialog(messageResult, isApproved)
    }
    
    func showTextDialog(_ message: String, _ success: Bool = false) {
        self.message = message
        self.success = success
        
        self.showMessage = (message.count > 0)
    }
}

public enum LoadingStatus: String {
    case WAIT = "PLEASE WAIT..."
    case CONNECTING = "Connecting to C2X Device..."
    case WAITING_FOR_CARD = "WAITING FOR CARD..."
    case PROCESSING = "PROCESSING..."
    case CANCELLED
    case DECLINED
    case COMPLETED
    case ERROR
    case TERMINATED
    case PARTIAL_APPROVAL = "PARTIAL APPROVAL"
    case APPROVAL
    case DEVICE_NOT_CONNECTED_ALERT = "You must have a connected device to proceed."
    case NOT_TRANSACTION_ID = "You Must have a valid Transaction ID for this action."
    case CONNECTED_DEVICE = "Device connected."
    case DEVICE_NOT_CONNECTED = "Device not connected."
    case AMOUNT_SHOULD_BE_LARGER_THAN_ZERO = "You must inform an amount to proceed."
    case NEW_VERSION_AVAILABLE = "New Version Available"
    case YOU_ARE_UPDATED = "You're updated!"
    case OK_BUTTON = "Ok"
    case PROGRESS = "\nProgress: "
    case MESSAGE_FIRMWARE_ALREADY_UPDATED = "Your device firmware version is: %@.\nWe have a new firmware version availabe: %@.\nHit 'Update Firmware' to start the process."
    case YOU_ALREADY_HAVE_LAST_UPDATED_VERSION = "You're already have the last version: %@."
    case TAKING_TOO_MUCH_TO_RESPOND = "The server is taking too long to respond. Try again later."
    case SUCCESS_UPDATED = "Updated! Please, wait a few seconds. Device will be restarted."
    case YOUVE_GOT_IT_TITLE = "Yes!"
    case SOMETHING_WENT_WRONG = "Something wen wrong. Please, try update it again."
    case AMOUNT_SHOULD_BE_HIGHER_THAN_HEALTHCARE_TOTAL = "Transaction Amount should be higher than healthcare total."
    case SUCCESS = "SUCCESS"
    
}

public enum Status {
    case APPROVED(response: HpsTerminalResponse)
    case CANCELLED(response: HpsTerminalResponse)
    case DECLINED(response: HpsTerminalResponse)
    case MESSAGE(message: String)
}
