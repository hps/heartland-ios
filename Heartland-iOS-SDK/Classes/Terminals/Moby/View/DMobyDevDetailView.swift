//
//  ContentView.swift
//  Heartland-iOS-SDK
//
//

import SwiftUI
import TemLibrary
import System
import Heartland_iOS_SDK
import TemLibrary
import RUA_BLE

let sandbox  = SObjc.getInstance()

@available(iOS 16.0, *)
struct DMobyDeviceDetailView: View {
    
    var ruaHelper : RUADDeviceHelper = RUADDeviceHelper.sharedInstance
    
    var deviceSelected: RUADevice
    
    var textPadding : CGFloat = 5
    @State private var showToastMessage = false
    @State private var showToastLoading = false
    
    @State private var selection = DKeyMappingStubMode.None
    
    @State private var isConnectedToReader = false
    @State private var isInitTem = false
    @State private var isSandboxCreated = false
    @State private var isUpdateAvailable = false
    @State private var isRkiAvailable = false
    @State private var isRkiSuccess = false
    
    @State private var isSmartUpdateEnable = false
    
    @State private var toastMessage = ""
    @State private var loadingMessage = ""
    @State private var progressMessage = ""
    @State private var connectionMessage = "Disconnected"
    
    @State var deviceSerialNumber : String = ""
    
    @State var config: Configurations
    
    private let fileUtils = FileUtils()
    
    init(deviceSelected : RUADevice){
        config = Configurations()
        self.deviceSelected = deviceSelected
    }
    
    var body: some View {
        ZStack{
            ScrollView {
                Text(connectionMessage)
                    .foregroundColor(isConnectedToReader ? .green : .red)
                VStack(spacing : 5){
                    readerView
                    temView
                    temCallView
                    updateView
                }.padding()
            }
            
            if(showToastLoading){
                VStack(spacing:40){
                    if(!loadingMessage.isEmpty){
                        Text(loadingMessage).foregroundColor(Color.blue).fontWeight(.bold).font(.system(size: 40))
                    }
                    
                    ProgressView {
                        Text("Loading")
                            .foregroundColor(.pink)
                            .bold()
                    }
                    
                    if(!progressMessage.isEmpty){
                        Text(progressMessage).foregroundColor(Color.blue).fontWeight(.bold).font(.system(size: 40))
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.black.opacity(0.9)).edgesIgnoringSafeArea(.all)
            }
        }.navigationBarBackButtonHidden(isConnectedToReader || showToastLoading).navigationBarHidden(showToastLoading)
            .onReceive(ruaHelper.$showLoadingScreen) { showLoadinScreen in
                showToastLoading = showLoadinScreen
            }
        
    }
    
    var readerView: some View {
        VStack{
            Text("Reader").font(.headline.bold()).underline().padding()
            HStack(spacing: 2) {
                
                Button(action: {
                    initConnection()
                   
                }){
                    Text("CONNECT")
                        .padding(textPadding)
                        .foregroundColor(.red)
                }
                .buttonStyle(BlueButtonStyle(width: .infinity))
                .disabled(isConnectedToReader)
                
                Spacer()
                
                Button(action: {
                    releaseDevice()
                }){
                    Text("DISCONNECT")
                        .foregroundStyle(isConnectedToReader ? .red : .orange)
                        .padding(textPadding)
                }
                .buttonStyle(BlueButtonStyle(width: .infinity))
                .disabled(!isConnectedToReader)
            }
            
        }.padding()
            .background(
                RoundedRectangle(cornerRadius: 10).foregroundColor(Color(UIColor.systemBackground))
                    .shadow(color: .gray, radius: 8, x: 2, y: 2)
            )
    }
    
    var temView: some View {
        VStack{
            Text("Tem Configuration").font(.headline.bold()).underline().padding()
            VStack{
                TextField("url", text: $config.temURL).textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("ip", text: $config.temPort).textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    initTem()
                }){ Text("INIT TEM").padding(textPadding) }
                    .buttonStyle(BlueButtonStyle(width: .infinity)).disabled(!isConnectedToReader)
            }
            Button(action: {
                initReaderContext()
            }){ Text("INITIALIZE READER CONTEXT").padding(textPadding) }
                .buttonStyle(BlueButtonStyle(width: .infinity)).disabled(!isSandboxCreated)
        }.padding().background(
            RoundedRectangle(cornerRadius: 10).foregroundColor(Color(UIColor.systemBackground))
                .shadow(color: .gray, radius: 8, x: 2, y: 2)
        )
    }
    
    var temCallView: some View {
        VStack{
            Text("Tem Calling").font(.headline.bold()).underline().padding()
            Button(action: {
                manualCall()
            }){ Text("TEM MANUAL CALL").padding(textPadding) }
                .buttonStyle(BlueButtonStyle(width: .infinity)).disabled(!isInitTem)
            Button(action: {
                reportCall()
            }){ Text("TEM REPORT STATUS").padding(textPadding) }
                .buttonStyle(BlueButtonStyle(width: .infinity)).disabled(!isInitTem)
            HStack {
                Text("Key Mapping Stub : ").underline()
                Picker(selection: $selection.onChange(stubModeChange), label: Text("Stub mode").font(.body.bold())) {
                    Text(DKeyMappingStubMode.None.rawValue).tag(DKeyMappingStubMode.None)
                    Text(DKeyMappingStubMode.Stub1.rawValue).tag(DKeyMappingStubMode.Stub1)
                    Text(DKeyMappingStubMode.Stub2.rawValue).tag(DKeyMappingStubMode.Stub2)
                }
            }.padding().disabled(!isInitTem)
        }.padding().background(
            RoundedRectangle(cornerRadius: 10).foregroundColor(Color(UIColor.systemBackground))
                .shadow(color: .gray, radius: 8, x: 2, y: 2)
        )
    }
    
    var updateView: some View {
        VStack{
            Text("Update").font(.headline.bold()).underline().padding()
            Toggle("Smart update", isOn: $isSmartUpdateEnable)
            Button(action: {
                self.checkRki()
            }){ Text("Check RKI").padding(textPadding) }
                .buttonStyle(BlueButtonStyle(width: .infinity)).disabled(!isRkiAvailable || isRkiSuccess)
            Button(action: {
                performUpdate()
            }){ Text("UPDATE").padding(textPadding) }
                .buttonStyle(BlueButtonStyle(width: .infinity)).disabled(!isUpdateAvailable || (isRkiAvailable && !isRkiSuccess))
#if DOWNGRADE_ENABLE
            if(isConnectedToReader){
                if(ruaHelper.getHardwareType() == ReaderDeviceType.Moby8500){
                    Button(action: {
                        perform8500Downgrade()
                    }){ Text("DOWNGRADE 8500").padding(textPadding) }
                        .buttonStyle(BlueButtonStyle(width: .infinity)).disabled(!isConnectedToReader)
                }
                if(ruaHelper.getHardwareType() == ReaderDeviceType.Moby5500){
                    Button(action: {
                        perform5500Downgrade()
                    }){ Text("DOWNGRADE 5500").padding(textPadding) }
                        .buttonStyle(BlueButtonStyle(width: .infinity)).disabled(!isConnectedToReader)
                }
            }
#endif
            
        }.padding().background(
            RoundedRectangle(cornerRadius: 10).foregroundColor(Color(UIColor.systemBackground))
                .shadow(color: .gray, radius: 8, x: 2, y: 2)
        )
    }
    
    func stubModeChange(_ tag: DKeyMappingStubMode) {
        if(self.ruaHelper.currentKeyMappingInfoMode != tag){
            self.ruaHelper.currentKeyMappingInfoMode = tag
            refreshReaderStateJson()
        }
    }
    
    func initConnection()  {
        showToastLoading = true
        loadingMessage = "Connecting"
        
        ruaHelper.connect(deviceSelected) { isConnected in
            guard let isConnected = isConnected else { return }
            print("connect completion block")
            showToastLoading = ruaHelper.showLoadingScreen
            isConnectedToReader = isConnected
            loadingMessage = isConnectedToReader ? "Connected" : "Disconnected"
            connectionMessage = isConnectedToReader ? "Connected" : "Disconnected"
        }
    }
    
    func releaseDevice(){
        ruaHelper.release()
        showToastLoading = ruaHelper.showLoadingScreen
        loadingMessage = "Disconnecting"
        isConnectedToReader = ruaHelper.isConnectedToDevice
        loadingMessage = isConnectedToReader ? "Connected" : "Disconnected"
        connectionMessage = isConnectedToReader ? "Connected" : "Disconnected"
       
    }
    
    func checkUpdateAvailable() {
        sandbox.isUpdateAvailable(self.deviceSerialNumber) { result in
            toast("Update available : \(result)")
        }
        
    }
    
    func refreshReaderStateJson() {
        showToastLoading = true
        loadingMessage = "Refreshing tem configuration"
        self.ruaHelper.generateJsonFile { readerStateJson in
            guard let readerStateJsonNotNill = readerStateJson else{
                showToastLoading = false
                return
            }
            sandbox.updateReaderJsonState(readerStateJsonNotNill) { success in
                showToastLoading = false
                if(success == 0){
                    toast("Tem configuration refreshed")
                    fileUtils.printContentSandboxFiles()
                }else{
                    toast("Error refreshing tem configuration")
                }
            }
        }
    }
    
    func initReaderContext(){
        showToastLoading = true
        loadingMessage = "Init Reader"
        self.ruaHelper.generateJsonFile { readerStateJson in
            sandbox.createReaderContext(readerStateJson!) { result in
                showToastLoading = false
                loadingMessage = ""
                isInitTem = result == 0
                if(result != 0){
                    toast("Init reader error (\(result))")
                }else{
                    fileUtils.printContentSandboxFiles()
                }
            }
        }
    }
    
    
    func manualCall(){
        showToastLoading = true
        loadingMessage = "Manual Call"
        sandbox.performCall(ReasonForCalling.MANUAL) { result in
            print("Perform call manual result = \(result)")
            showToastLoading = false
            loadingMessage = ""
            if(result != 0){
                toast("An error occured (\(result))")
            }else{
                sandbox.isUpdateAvailable(self.deviceSerialNumber,andResultBlock: { updateAvailable in
                    self.isUpdateAvailable = updateAvailable
                    fileUtils.printSanboxFiles()
                })
                sandbox.getRkiFileName(self.deviceSerialNumber) { rkiFileName in
                    isRkiAvailable = !rkiFileName.isEmpty
                }
            }
        }
    }
    
    
    
    func reportCall(){
        showToastLoading = true
        loadingMessage = "Report Call"
        sandbox.performCall(ReasonForCalling.REPORT) { result in
            showToastLoading = false
            loadingMessage = ""
            if(result != 0){
                toast("An error occured (\(result))")
            }else{
                print("Perform call report result = \(result)")
            }
        }
    }
    
    func perform8500Downgrade(){
        showToastLoading = true
        guard let fileFirmwarePath = fileUtils.getFirmware8500DowngradePath() else {
            return
        }
        ruaHelper.updateFirmware(firmwareFilePath: fileFirmwarePath) {
            showToastLoading = false
            loadingMessage = ""
            progressMessage = ""
        } progressionBlock: { progressMessageResponse in
            let downloaded = Int(progressMessageResponse.split(separator: "/")[0])
            let total = Int(progressMessageResponse.split(separator: "/")[1])
            guard let downloadedNotNill = downloaded,let totalNotNill = total else{
                return
            }
            let percent : Int = (downloadedNotNill * 100 / totalNotNill)
            loadingMessage = "Downgrade"
            progressMessage = "\(percent)%"
        }
    }
    
    func perform5500Downgrade(){
        showToastLoading = true
        guard let fileFirmwarePath = fileUtils.getFirmware5500DowngradePath() else {
            return
        }
        ruaHelper.updateFirmware(firmwareFilePath: fileFirmwarePath) {
            showToastLoading = false
            loadingMessage = ""
            progressMessage = ""
        } progressionBlock: { progressMessageResponse in
            let downloaded = Int(progressMessageResponse.split(separator: "/")[0])
            let total = Int(progressMessageResponse.split(separator: "/")[1])
            guard let downloadedNotNill = downloaded,let totalNotNill = total else{
                return
            }
            let percent : Int = (downloadedNotNill * 100 / totalNotNill)
            loadingMessage = "Downgrade"
            progressMessage = "\(percent)%"
        }
    }
    
    
    func getFileSize(filePath : String) -> UInt64{
        var fileSize : UInt64 = 0
        
        do {
            //return [FileAttributeKey : Any]
            let attr = try FileManager.default.attributesOfItem(atPath: filePath)
            fileSize = attr[FileAttributeKey.size] as! UInt64
            
            //if you convert to NSDictionary, you can get file size old way as well.
            let dict = attr as NSDictionary
            fileSize = dict.fileSize()
        } catch {
            print("Error: \(error)")
        }
        return fileSize
    }
    
    private func getTemporaryPath() -> String{
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        return dirPaths[0].path
    }
    
    func performUpdate(){
        showToastLoading = true
        if(isSmartUpdateEnable){
            sandbox.getUpdateFilePath(self.deviceSerialNumber) { filePath in
                let temporaryPath = getTemporaryPath()
                
                let originalUnsFilePath : String = filePath;
                let repackagedUnsFilePath :String = temporaryPath + "/newUns.uns";
                ruaHelper.getReaderVersionInfo { readerVersionInfo in
                    loadingMessage = "Repackaging smart firmware..."
                    ruaHelper.updateFirmwareSmartMode(fromFilePath: originalUnsFilePath,
                                                      toFilePath: repackagedUnsFilePath,
                                                      readerVersion: readerVersionInfo) { result in
                        
                        let originalSize = getFileSize(filePath: originalUnsFilePath)
                        let repackageSize = getFileSize(filePath: repackagedUnsFilePath)
                        
                        print("Original size = \(originalSize)")
                        print("Repackage size = \(repackageSize)")
                        
                        if(result){
                            showToastLoading = false
                            toast("Successful firmware repackaging")
                            flashFirmware(firmwareFilePath: repackagedUnsFilePath)
                        }else{
                            toast("Error on firmware repackaging")
                            showToastLoading = false
                        }
                        
                    }
                }
            }
            
        } else {
            sandbox.isUpdateAvailable(self.deviceSerialNumber,andResultBlock: { updateAvailable in
                sandbox.getUpdateFilePath(self.deviceSerialNumber) { filePath in
                    flashFirmware(firmwareFilePath: filePath)
                }
            })
        }
    }
    
    func flashFirmware(firmwareFilePath : String){
        showToastLoading = true
        ruaHelper.updateFirmware(firmwareFilePath: firmwareFilePath) {
            showToastLoading = false
            loadingMessage = ""
            progressMessage = ""
        } progressionBlock: { progressMessageResponse in
            let downloaded = Int(progressMessageResponse.split(separator: "/")[0])
            let total = Int(progressMessageResponse.split(separator: "/")[1])
            guard let downloadedNotNill = downloaded,let totalNotNill = total else{
                return
            }
            let percent : Int = (downloadedNotNill * 100 / totalNotNill)
            loadingMessage = "Update"
            progressMessage = "\(percent)%"
        }
    }
    
    
    
    func initTem()  {
        let temporaryPath = getTemporaryPath()
        config.saveConfig()
        
        print("temporaryPath = \(temporaryPath)")
        do{
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            
            sandbox.createSandbox("ntpt3-mpos-client",
                                  andVersion: appVersion ?? "UNKNOWN",
                                  andIp: config.temURL,
                                  andport: Int32(config.temPort) ?? 7047,
                                  andCallingMethod: 5,
                                  andAuthorizedActivities: 7,
                                  andOfflineInstallMode: 1,
                                  andContractNumber: "",
                                  andSSL: 0,
                                  andCertClient: "/ClientCert.pem",
                                  andKeyClient: "/etc/cert/ClientCertKey.pem",
                                  andCertServ: "/etc/cert/ServerCertPub.pem") { sanboxStatus in
                
                switch sanboxStatus{
                case SandboxStatus.InitilisationOk:
                    toast("Sandbox created")
                    isSandboxCreated = true
                case SandboxStatus.AlreadyInitialized :
                    toast("Sandbox already created")
                    isSandboxCreated = true
                default :
                    toast("Sandbox error cration")
                }
            }
        }
    }
    
    private func toast(_ message : String){
        toastMessage = message
        showToastMessage = true
    }
    
    public func updateFirmware(resultCompletionBlock : @escaping () -> Void,progressionBlock : @escaping (String) -> Void){
        sandbox.getUpdateFilePath(self.deviceSerialNumber) { firmwarePath in
            DispatchQueue.global().async { [self] in
                self.ruaHelper.updateFirmware(firmwareFilePath: firmwarePath,
                                              updateCompletionBlock: resultCompletionBlock,
                                              progressionBlock: progressionBlock)
            }
        }
    }
    
    public func downgradeFirmware(firmwarePath : String,resultCompletionBlock : @escaping () -> Void,progressionBlock : @escaping (String) -> Void){
        DispatchQueue.global().async { [self] in
            self.ruaHelper.updateFirmware(firmwareFilePath: firmwarePath,
                                          updateCompletionBlock: resultCompletionBlock,
                                          progressionBlock: progressionBlock)
        }
    }
    
    public func initReader(){
        DispatchQueue.global().async { [self] in
            self.ruaHelper.generateJsonFile { readerStateJson in
                sandbox.createReaderContext(readerStateJson!) { result in
                    showToastLoading = false
                    loadingMessage = ""
                    isInitTem = true
                }
            }
        }
    }
    
    func checkRki(){
        showToastLoading = true
        loadingMessage = "RKI In progress"
        sandbox.getRkiFileName(self.deviceSerialNumber) { rkiFileName in
            ruaHelper.enableRKIMode(rkiFileName) { success in
                //TODO Remove stub value when landi backend was ok
                let stubSuccess = true //success
                showToastLoading = false
                loadingMessage = ""
                isRkiSuccess = stubSuccess
                if(stubSuccess){
                    sandbox.performCall(ReasonForCalling.REPORT) { result in
                        toast("Report status = \(result)")
                    }
                }else{
                    toast("Rki Failed")
                }
                
            }
        }
    }
    
}
