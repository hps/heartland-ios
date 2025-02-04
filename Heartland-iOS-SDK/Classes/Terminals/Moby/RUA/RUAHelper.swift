//
//  RUAHelper.swift
//  MobiPay
//
//

import Foundation
import RUA_BLE
//import RuaWrapper

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
class RUAHelper: NSObject, RUADeviceSearchListener, RUADeviceStatusHandler, RUAPairingListener {
    
    private var ruaDeviceManager: RUADeviceManager?
    private var selectedRUADevice: RUADevice? = nil
    private var currentPublicKeyIndex: Int = 0
    private var configVersion: String = "PayPal1.0"
    private var connectedDeviceSerialNumber: String? = nil
    var discoveredRUADevices = [RUADevice]()
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
    
    
    private var launchTransactionAfterSetup = false
    private var hardwareType : String? = nil
    
    public static let sharedInstance = RUAHelper()
    
    
    private override init()  {
        RUA.setProductionMode(false)
        RUA.enableDebugLogMessages(false)
        ruaDeviceManager = RUA.getDeviceManager(RUADeviceTypeMOBY8500)
        stateJson = [String:AnyObject]()
    }
    
    func changeDeviceType(){
        ruaDeviceManager = RUA.getDeviceManager(RUADeviceTypeMOBY8500)
    }
    
    func startLoggerBlock(loggerBlock : @escaping (String) -> Void){
        self.loggerBlock = loggerBlock
    }
    
    func stopLoggerBlock(){
        self.loggerBlock = nil
    }
    
    // MARK: Search Devices
    func searchDevice(searchFinishBlock : @escaping ([RuaDevice]) -> Void){
        DispatchQueue.global().async {
            Logger.info("searchDevice")
            self.discoveredRUADevices.removeAll()
            self.searchBlock = searchFinishBlock
            self.ruaDeviceManager?.searchDevices(withLowRSSI: -100, andHighRSSI: -26, andListener: self)
        }
    }
    
    private func releaseRua(){
        ruaDeviceManager?.releaseDevice()
    }
    
    private func getRuaSdkVersion() -> Int{
        return RUA.version()
    }
    
    func initialize(ruaDevice : RuaDevice,
                    initialisationCompletionBlock : @escaping (String?,String?) -> Void,
                    releaseCompletionBlock : @escaping (Bool) -> Void) {
        
        self.initilalizeCompletionBlock = initialisationCompletionBlock
        self.releaseCompletionBlock = releaseCompletionBlock
        
        
//        if let bundle = Bundle(identifier: GMSConfiguration.hearlandIdentifierProjectName) {
//            let sb = UIStoryboard(name: "RuaPairingStoryBoard", bundle: bundle)
//            let pairingView = sb.instantiateViewController(identifier: "PairingViewController") as! PairingViewController
//            
//            if let device = discoveredRUADevices.first(where: { $0.identifier == ruaDevice.deviceIdentifier }) {
//                pairingView.selectedDevice = device
////                pairingView.delegate = self
//                
//                let viewController = UIApplication.shared.windows.first!.rootViewController!
//                viewController.present(pairingView, animated: true)
//            }
//        }
        
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
        Logger.info(message)
    }
    
    func release(){
        DispatchQueue.global().async {
            Logger.info("Release RUA connection")
            self.ruaDeviceManager?.releaseDevice()
        }
    }
    
    // MARK:  Transaction command sending
    
    private func saveSelectedDevice(ruaDevice : RUADevice) {
        do {
            let deviceData = try NSKeyedArchiver.archivedData(withRootObject: ruaDevice, requiringSecureCoding: false)
            UserDefaults.standard.set(deviceData,forKey: "lastUsedDevice")
        } catch {
            Logger.error(error.localizedDescription)
        }
    }
    
    private func lastSelectedDevice() -> RUADevice? {
        var ruaDevice : RUADevice?
        let lastDeviceSaveData = UserDefaults.standard.data(forKey: "lastUsedDevice")
        guard let lastDeviceData = lastDeviceSaveData else {return nil}
        
        do {
            try ruaDevice = NSKeyedUnarchiver.unarchivedObject(ofClass: RUADevice.self, from: lastDeviceData)
        } catch {
            Logger.error(error.localizedDescription)
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
        Logger.info("Find device \(reader.name ?? "")")
        guard reader.name != nil else {
            return
        }
        discoveredRUADevices.append(reader)
    }
    
    func discoveryComplete() {
        Logger.info("On discovery complete")
        /*for device in discoveredRUADevices {
         guard let deviceName = device.name else { continue }
         if(deviceName.starts(with: "MOB85")){
         selectedRUADevice = device
         //initialize()
         //startTransaction(isSetupActivate: true)
         break
         }
         }*/
        self.searchBlock(discoveredRUADevices.map { (ruaDevice) -> RuaDevice in
            RuaDevice(deviceName: ruaDevice.name, deviceSerialNumber: ruaDevice.identifier)
        })
    }
    
    // MARK:  RUADeviceStatusHandler delegate methods
    
    func onError(_ message: String!) {
        Logger.info("On error \(message ?? "")")
        self.initilalizeCompletionBlock(nil,nil)
        
    }
    
    func beep(){
        
        ruaDeviceManager?.getConfigurationManager().generateBeep({ ruaProgressMessage, additionalMessage in
            
        }, response: { ruaReponse in
            
        })
    }
    
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
                Logger.info("Update Firmware progression : \(progress) <==> \(message)")
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
                Logger.debug("\(ruaProgressMessage.rawValue) -> \(additionalMessage ?? "")")
            }, response: { ruaReponse in
                self.logMessage("[onConnected][Response]\(ruaReponse?.toString() ?? "")")
                let dictionnary = ruaReponse?.responseData as? Dictionary<Int,String>
                self.connectedDeviceSerialNumber = dictionnary?[RUAParameter.interfaceDeviceSerialNumber.rawValue]
                self.initilalizeCompletionBlock(selectedDevice.name,self.connectedDeviceSerialNumber)
                self.isConnectedToDevice = true
                self.beep()
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
                Logger.info(readerVersionInfo.toString())
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
                Logger.info("jsonArray")
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
    
    func onConnected() {
        Logger.info("On connected")
        loadHardwareType()
    }
    
    func onDisconnected() {
        Logger.info("OnDisconnected")
        selectedRUADevice = nil
        isConnectedToDevice = false
        rkiIsExecuted = false
        releaseCompletionBlock(false)
    }
    
    // MARK:  Sdk configuration management
    
    
    // MARK: Pairing Listener
    
    func onPairSucceeded() {
        print("paired success")
    }
    
    func onPairNotSupported() {
        print(" not suppoted")
    }
    
    func onPairFailed() {
        print(" paired failed")
    }
    
    func onLedPairSequenceConfirmation(_ ledSequence: [Any]!, confirmationCallback: (any RUALedPairingConfirmationCallback)!) {
            print("onLedPairSequenceConfirmation")
//            _ledConfirmationCb = confirmationCallback;
//            [self showPairingView:ledSequence];
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
    
    // MARK: Start Transaction
    func startTransaction(mobyDevice: HpsMobyDevice, completion: @escaping ([AnyHashable: Any]) -> Void) {
        getTransactionManager()?.send(RUACommand.commandEMVStartTransaction,
                                      withParameters: self.getEMVStartTransactionParameters(300) as [AnyHashable: Any],
                                      progress:{
            (messageType:RUAProgressMessage, additionalMessage:String!) -> Void in
            
            print(messageType.rawValue)
            if let additionalMessage {
                print(additionalMessage)
            }
            
        }, response: { (ruaResponse:RUAResponse!) -> Void in
            print("RUA RESPONSE")
            print(ruaResponse)
            print(ruaResponse.responseType)
            print(ruaResponse.cardType)
            print(ruaResponse?.responseCode)
            print(ruaResponse.additionalErrorDetails)
            print(ruaResponse.responseData)
            
            completion(ruaResponse.responseData)
            
            if ruaResponse.responseCode == RUAResponseCodeError {
                print(" ERROR ")
                print(ruaResponse.errorCode)
                print(ruaResponse.additionalErrorDetails)
                print(ruaResponse.debugDescription)
                self.sendEMVTransactionDataCommand()
                return
            }
            
            if(ruaResponse.responseCode == RUAResponseCodeSuccess || ruaResponse.errorCode == RUAErrorCodeNonCertifiedEMVKernelConfiguration) {
                if(ruaResponse.responseType == RUAResponseTypeMagneticCardData ||
                   ruaResponse.responseType == RUAResponseTypeContactLessEMVOnlineDOL ||
                   ruaResponse.responseType == RUAResponseTypeContactLessEMVResponseDOL){
                    self.sendEMVCompleteTransactionCommand()
                }
                else if(ruaResponse.responseType == RUAResponseTypeListOfApplicationIdentifiers){
                    
                    let listOfApplicationIdentifiers = ruaResponse.listOfApplicationIdentifiers
                    
                    let view = UIAlertController(title: "Select application for your card", 
                                                 message: "Make your choice",
                                                 preferredStyle: .actionSheet)
                    for appID: RUAApplicationIdentifier in listOfApplicationIdentifiers as? [RUAApplicationIdentifier] ?? [] {
                        let ok = UIAlertAction(title: appID.applicationLabel, 
                                               style: .default,
                                               handler: { action in
                            
                            view.dismiss(animated: true)
                            self.selectApplicationIdentifier(appID)
                            
                        })
                        view.addAction(ok)
                    }
                    let cancel = UIAlertAction(title: "Cancel", 
                                               style: .cancel,
                                               handler: { action in
                                                })
                    view.addAction(cancel)
                    UIApplication.shared.windows.first?.rootViewController?.present(view,
                                                                                    animated: true,
                                                                                    completion: nil)
                } else if (ruaResponse.responseType == RUAResponseTypeContactQuickChipEMVResponseDOL){
                    // do nothig as transaction is complete in quick chip mode
                    print(ruaResponse.responseType)
                    print(ruaResponse.responseCode)
                } else if (
                    ruaResponse.responseType == RUAResponseTypeContactLessEMVOnlineDOL ||
                    ruaResponse.responseType == RUAResponseTypeContactLessEMVResponseDOL) {
                    self.ruaDeviceManager?.getTransactionManager().send(RUACommand.commandEMVCompleteTransaction,
                                                                        withParameters: nil,
                                                                        progress: { progressResponse, stringResponse in
                        print(" RESPONSE DEEP RESPONSE ")
                        print(progressResponse)
                        print(stringResponse)
                    }, response: { ruaResponse in
                        print("RUA RESPONSE DEEP RESPONSE")
                        print(ruaResponse?.description)
                        print(ruaResponse?.errorCode)
                        print(ruaResponse?.responseCode)
                        print(ruaResponse?.responseData)
                    })
                    
                }
                else {
                    self.sendEMVTransactionDataCommand()
                }
            }
            else{
                self.sendEMVTransactionStopCommand()
            }
            
        })
    }
    
    func loadDictionaryFromEMVTransactionConfigsJSON() -> Dictionary<String, AnyHashable>?{
        var provisioningFile : String?
        let jsonDictionary = Dictionary<String, AnyHashable>()
        provisioningFile = getFile("EMVTransactionParameters", "json")
        guard let provisioningFileNotNil = provisioningFile else {
            print("Cannot find EMVTransactionParameters.json")
            return jsonDictionary;
        }
        do{
            let data = try Data(contentsOf: URL(fileURLWithPath: provisioningFileNotNil), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? Dictionary<String, AnyHashable>{
                return jsonResult     // do stuff
            }
        } catch {
            print( error.localizedDescription)
        }
        return jsonDictionary;
    }
    
    private func getContactlessList() -> [RUAApplicationIdentifier]{
        let jsonDictionaryFromEMV = loadDictionaryFromJSON()
        var result : [RUAApplicationIdentifier] = []
        
        guard let jsonArray = jsonDictionaryFromEMV?["aids"] as? Array<AnyHashable> else { return result }
        
        let dictionaryParsedFromJson = jsonArray[0] as! Dictionary<String,AnyHashable>
        let dictionnaryAppId = dictionaryParsedFromJson["contactless_list"] as? Array<AnyHashable>
        guard let dictionnaryAppIdNotNil = dictionnaryAppId else{
            return result
        }
        for appId in dictionnaryAppIdNotNil {
            let key = appId as! Dictionary<String, String>
            let ruaAppId = RUAApplicationIdentifier()
            
            ruaAppId.rid = key["rid"]
            ruaAppId.pix = key["pix"]
            ruaAppId.terminalApplicationVersion = key["terminal_application_version"]
            ruaAppId.lowestSupportedICCApplicationVersion = key["lowest_supported_icc_application_version"]
            ruaAppId.priorityIndex = key["priority_index"]
            ruaAppId.applicationSelectionFlags = key["application_selection_flags"]
            ruaAppId.tlvData = key["tlv_data"]
            result.append(ruaAppId)
        }
        return result
    }
    
    private func getAmountDolsList() -> [NSNumber]{
        let jsonDictionaryFromEMV = loadDictionaryFromJSON()
        var result : [NSNumber] = []
        
        guard let jsonArray = jsonDictionaryFromEMV?["processor_profile_config_list"] as? Array<AnyHashable> else { return result }
        
        let dictionaryParsedFromJson = jsonArray[0] as! Dictionary<String,AnyHashable>
        let dictionnaryDols = dictionaryParsedFromJson["dols"] as? Dictionary<String,AnyHashable>
        guard let dictionnaryDolsNotNil = dictionnaryDols else{
            return result
        }
        let amountDols = dictionnaryDolsNotNil["Amount"] as? Array<String>
        guard let amountDolsNotNil = amountDols else{
            return result
        }
        for amount in amountDolsNotNil {
            result.append(NSNumber(value:RUAEnumerationHelper.ruaParameter_(toEnumeration: amount).rawValue))
        }
        return result
    }
    
    private func getOnlineDolsList() -> [NSNumber]{
        let jsonDictionaryFromEMV = loadDictionaryFromJSON()
        var result : [NSNumber] = []
        
        guard let jsonArray = jsonDictionaryFromEMV?["processor_profile_config_list"] as? Array<AnyHashable> else { return result }
        
        let dictionaryParsedFromJson = jsonArray[0] as! Dictionary<String,AnyHashable>
        let dictionnaryDols = dictionaryParsedFromJson["dols"] as? Dictionary<String,AnyHashable>
        guard let dictionnaryDolsNotNil = dictionnaryDols else{
            return result
        }
        let onlineDols = dictionnaryDolsNotNil["Online"] as? Array<String>
        guard let onlineDolsNotNil = onlineDols else{
            return result
        }
        for online in onlineDolsNotNil {
            result.append(NSNumber(value:RUAEnumerationHelper.ruaParameter_(toEnumeration: online).rawValue))
        }
        return result
    }
    
    private func getResponseDolsList() -> [NSNumber]{
        let jsonDictionaryFromEMV = loadDictionaryFromJSON()
        var result : [NSNumber] = []
        
        guard let jsonArray = jsonDictionaryFromEMV?["processor_profile_config_list"] as? Array<AnyHashable> else { return result }
        
        let dictionaryParsedFromJson = jsonArray[0] as! Dictionary<String,AnyHashable>
        let dictionnaryDols = dictionaryParsedFromJson["dols"] as? Dictionary<String,AnyHashable>
        guard let dictionnaryDolsNotNil = dictionnaryDols else{
            return result
        }
        let responseDols = dictionnaryDolsNotNil["Response"] as? Array<String>
        guard let responseDolsNotNil = responseDols else{
            return result
        }
        for response in responseDolsNotNil {
            result.append(NSNumber(value:RUAEnumerationHelper.ruaParameter_(toEnumeration: response).rawValue))
        }
        return result
    }
    
    private func getContactlessOnlineDolsList() -> [NSNumber]{
        let jsonDictionaryFromEMV = loadDictionaryFromJSON()
        var result : [NSNumber] = []
        
        guard let jsonArray = jsonDictionaryFromEMV?["processor_profile_config_list"] as? Array<AnyHashable> else { return result }
        
        let dictionaryParsedFromJson = jsonArray[0] as! Dictionary<String,AnyHashable>
        let dictionnaryDols = dictionaryParsedFromJson["dols"] as? Dictionary<String,AnyHashable>
        guard let dictionnaryDolsNotNil = dictionnaryDols else{
            return result
        }
        let onlineDols = dictionnaryDolsNotNil["ContactlessOnline"] as? Array<String>
        guard let onlineDolsNotNil = onlineDols else{
            return result
        }
        for online in onlineDolsNotNil {
            result.append(NSNumber(value:RUAEnumerationHelper.ruaParameter_(toEnumeration: online).rawValue))
        }
        return result
    }
    
    private func getContactlessResponseDolsList() -> [NSNumber]{
        let jsonDictionaryFromEMV = loadDictionaryFromJSON()
        var result : [NSNumber] = []
        
        guard let jsonArray = jsonDictionaryFromEMV?["processor_profile_config_list"] as? Array<AnyHashable> else { return result }
        
        let dictionaryParsedFromJson = jsonArray[0] as! Dictionary<String,AnyHashable>
        let dictionnaryDols = dictionaryParsedFromJson["dols"] as? Dictionary<String,AnyHashable>
        guard let dictionnaryDolsNotNil = dictionnaryDols else{
            return result
        }
        let responseDols = dictionnaryDolsNotNil["ContactlessResponse"] as? Array<String>
        guard let responseDolsNotNil = responseDols else{
            return result
        }
        for response in responseDolsNotNil {
            result.append(NSNumber(value:RUAEnumerationHelper.ruaParameter_(toEnumeration: response).rawValue))
        }
        return result
    }
    
    private func getPublicKeys() -> [RUAPublicKey]{
        let jsonDictionaryFromEMV = loadDictionaryFromJSON()
        var result : [RUAPublicKey] = []
        
        guard let jsonArray = jsonDictionaryFromEMV?["processor_profile_config_list"] as? Array<AnyHashable> else { return result }
        
        var dictionaryParsedFromJson = jsonArray[0] as! Dictionary<String,AnyHashable>
        let dictionnaryPublicKeys = dictionaryParsedFromJson["public_keys"] as? Array<AnyHashable>
        guard let dictionnaryPublicKeysNotNil = dictionnaryPublicKeys else{
            return result
        }
        for publicKey in dictionnaryPublicKeysNotNil {
            let key = publicKey as! Dictionary<String, String>
            let ruaKey = RUAPublicKey()
            ruaKey.rid = key["rid"]
            ruaKey.caPublicKeyIndex = key["ca_public_key_index"]
            ruaKey.publicKey = key["public_key"]
            ruaKey.exponentOfPublicKey = key["exponent_of_public_key"]
            ruaKey.checksum = key["checksum"]
            result.append(ruaKey)
        }
        return result
    }
    
    private func getEMVStartTransactionParametersFromConfigFile() -> Dictionary<Int,String> {
        let jsonDictionaryFromEMV = loadDictionaryFromEMVTransactionConfigsJSON()
        var dictionaryParsedFromJson = Dictionary<Int,String>()
        
        let keyName = "MOBY5500EMVStartTransactionParameters"
        guard let jsonDictionnary = jsonDictionaryFromEMV?[keyName] as? Dictionary<String,String> else { return dictionaryParsedFromJson }
        for (key,value) in jsonDictionnary {
            dictionaryParsedFromJson[RUAEnumerationHelper.ruaParameter_(toEnumeration: key).rawValue] = value
        }
        return dictionaryParsedFromJson
    }
    
    
    func getEMVStartTransactionParameters(_ transactionAmount: Int) -> Dictionary<Int,String>{
        var transactionParameters = self.getEMVStartTransactionParametersFromConfigFile()
        let currentLocale = Locale.init(identifier: "en_US_POSIX")
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyMMdd"
        dateFormat.locale = currentLocale
        let dateFormatted = dateFormat.string(from: Date())
        
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HHmmss"
        timeFormat.locale = currentLocale
        let timeFormatted = timeFormat.string(from: Date())
        
        
        transactionParameters[RUAParameter.amountAuthorizedBinary.rawValue] = String(format: "%08X",transactionAmount)
        transactionParameters[RUAParameter.amountAuthorizedNumeric.rawValue] = String(format: "%012d",transactionAmount)
        transactionParameters[RUAParameter.transactionDate.rawValue] = dateFormatted
        transactionParameters[RUAParameter.transactionTime.rawValue] = timeFormatted
        
        // To enable quick chip mode
        if (true) {
            transactionParameters[RUAParameter.enableUSQuickChipMode.rawValue] = "01"
        }
        
        print("EMVStartTransactionParameters:")
        for key in transactionParameters.keys {
            let value = transactionParameters[key] as? NSString
            print("\(key):\(value ?? "")" as NSString)
            print("\(key):\(value ?? "")" as NSString)
            
        }
        return transactionParameters
    }
    
    func getEMVFinalAppSelectionParameters(_ applicationIdentifier:RUAApplicationIdentifier?) -> NSDictionary{
        let transactionParameters = NSMutableDictionary()
        if(applicationIdentifier != nil) {
            transactionParameters.setObject(applicationIdentifier!.aid, forKey: NSNumber(value: RUAParameter.applicationIdentifier.rawValue))
        } else {
            transactionParameters.setObject("A0000000041010", forKey: NSNumber(value: RUAParameter.applicationIdentifier.rawValue))
        }
        return transactionParameters;
    }
    
    private func getTerminalActionCodes() -> Dictionary<String,AnyHashable>? {
        let jsonDictionnary = self.loadDictionaryFromEMVTransactionConfigsJSON()
        return jsonDictionnary?["TerminalActionCode"] as? Dictionary<String, AnyHashable>
    }
    
    
    
    private func getEMVTransactionDataParameters() -> Dictionary<Int,String> {
        let jsonDictionaryFromEMV = loadDictionaryFromEMVTransactionConfigsJSON()
        var dictionaryParsedFromJson = Dictionary<Int,String>()
        guard let jsonDictionary = jsonDictionaryFromEMV else{
            return dictionaryParsedFromJson
        }
        let keyName = "MOBY5500EMVTransactionDataParameters"
        guard let jsonDictionnary = jsonDictionary[keyName] as? Dictionary<String,String> else { return dictionaryParsedFromJson }
        for (key,value) in jsonDictionnary {
            dictionaryParsedFromJson[RUAEnumerationHelper.ruaParameter_(toEnumeration: key).rawValue] = value
        }
        
        dictionaryParsedFromJson[RUAParameter.terminalActionCodeDefault.rawValue] = "0000000000"
        dictionaryParsedFromJson[RUAParameter.terminalActionCodeDenial.rawValue] = "0000000000"
        dictionaryParsedFromJson[RUAParameter.terminalActionCodeOnline.rawValue] = "0000000000"
        
        return dictionaryParsedFromJson
    }
    
    
    private func getEMVTransactionCompleteParameters() -> Dictionary<Int,String> {
        let jsonDictionaryFromEMV = loadDictionaryFromEMVTransactionConfigsJSON()
        var dictionaryParsedFromJson = Dictionary<Int,String>()
        guard let jsonDictionary = jsonDictionaryFromEMV else{
            return dictionaryParsedFromJson
        }
        let keyName = "MOBY5500EMVTransactionCompleteParameters"
        guard let jsonDictionnary = jsonDictionary[keyName] as? Dictionary<String,String> else { return dictionaryParsedFromJson }
        for (key,value) in jsonDictionnary {
            dictionaryParsedFromJson[RUAEnumerationHelper.ruaParameter_(toEnumeration: key).rawValue] = value
        }
        return dictionaryParsedFromJson
    }
    
    private func readLocalJsonFile(forName name: String) -> Data? {
        do {
            let bundlePath = getFile(name, "json")
            if let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    
    func loadDictionaryFromJSON() -> Dictionary<String, Any>?{
        let provisioningFileContentData : Data?
        let filename : String
        //        if(RUADeviceTypeRP750x == selectedDeviceType || RUADeviceTypeMOBY8500 == selectedDeviceType || RUADeviceTypeMOBY6500 == selectedDeviceType){
        //            filename = "provisioning_8500";
        //        }else {
        //            filename = "provisioning_5500";
        //        }
        filename = "provisioning_5500";
        provisioningFileContentData = readLocalJsonFile(forName: filename)
        
        if (provisioningFileContentData != nil) {
            var jsonDictionary : [String: Any]?
            do{
                jsonDictionary = try JSONSerialization.jsonObject(with: provisioningFileContentData!) as? Dictionary<String, Any>
            }catch{
                print(NSString(format: "Cannot serialize json due to %@", error.localizedDescription))
                return nil;
            }
            return jsonDictionary;
            
            
        }else{
            print("Cannot find json");
            return nil;
        }
    }
    
    func selectApplicationIdentifier(_ selectedAID: RUAApplicationIdentifier){
        guard let tmgr:RUATransactionManager = self.ruaDeviceManager?.getTransactionManager() else {
            return
        }
        tmgr.send(RUACommand.commandEMVFinalApplicationSelection, withParameters: self.getEMVFinalAppSelectionParameters(selectedAID) as! [AnyHashable: Any], progress:{ (messageType:RUAProgressMessage, addtionalMessage:String!) -> Void in
            print(RUAEnumerationHelper.ruaProgressMessage_(toString: messageType)! as NSString)
        }, response: { (ruaResponse:RUAResponse!) -> Void in
            print(ruaResponse)
            if(ruaResponse.responseCode == RUAResponseCodeSuccess){
                self.sendEMVTransactionDataCommand()
            }
            else{
                self.sendEMVTransactionStopCommand()
            }
            
        })
    }
    
    func sendEMVTransactionDataCommand(){
        guard let tmgr:RUATransactionManager = self.ruaDeviceManager?.getTransactionManager() else {
            return
        }
        tmgr.send(RUACommand.commandEMVTransactionData,
                  withParameters: self.getEMVTransactionDataParameters()as! [AnyHashable: Any],
                  progress:{
            (messageType:RUAProgressMessage, addtionalMessage:String!) -> Void in
            print(messageType)
        }, response: { (ruaResponse:RUAResponse!) -> Void in
            print(ruaResponse)
            if(ruaResponse.responseCode == RUAResponseCodeSuccess){
                if (ruaResponse.responseType == RUAResponseTypeContactEMVResponseDOL || ruaResponse.responseType == RUAResponseTypeMagneticCardData) {
                    self.sendEMVTransactionStopCommand()
                }
                else if (ruaResponse.responseType == RUAResponseTypeContactEMVOnlineDOL) {
                    self.sendEMVCompleteTransactionCommand()
                }
            }
            else{
                self.sendEMVTransactionStopCommand()
            }
            
        })
    }
    
    func sendEMVTransactionStopCommand(){
        guard let tmgr:RUATransactionManager = self.ruaDeviceManager?.getTransactionManager() else {
            return
        }
        tmgr.send(RUACommand.commandEMVTransactionStop, withParameters: nil,
                  progress:{
            (messageType:RUAProgressMessage, addtionalMessage:String!) -> Void in
            print(messageType)
        }, response: { (ruaResponse:RUAResponse!) -> Void in
            print(ruaResponse)
        })
    }
    
    func sendEMVCompleteTransactionCommand(){
        guard let tmgr:RUATransactionManager = self.ruaDeviceManager?.getTransactionManager() else {
            return
        }
        tmgr.send(RUACommand.commandEMVCompleteTransaction, withParameters: self.getEMVTransactionCompleteParameters()as! [AnyHashable: Any], progress:{ (messageType:RUAProgressMessage, addtionalMessage:String!) -> Void in
            print(messageType)
        }, response: { (ruaResponse:RUAResponse!) -> Void in
            print(ruaResponse)
            self.sendEMVTransactionStopCommand()
        })
    }
    
    private func getFile(_ file: String, _ ext: String) -> String {
        if let bundle = Bundle(identifier: GMSConfiguration.hearlandIdentifierProjectName) {
            return bundle.path(forResource: file, ofType: ext) ?? String.empty
        } else {
            return String.empty
        }
    }
}

//@available(iOS 13.0, *)
//extension RUAHelper: ConnectionListener {
//    func onDeviceConnectionFailed() {
//        print(" onDeviceConnectionFailed ")
//        self.releaseCompletionBlock(false)
//    }
//    
//    func onDeviceConnectionCancelled() {
//        print(" onDeviceConnectionCancelled ")
//        self.releaseCompletionBlock(false)
//    }
//    
//    func onDeviceConnected() {
//        print("On Device Conected")
//        self.releaseCompletionBlock(true)
//    }
//}
