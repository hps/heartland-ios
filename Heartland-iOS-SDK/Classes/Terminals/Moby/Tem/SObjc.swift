//import Foundation
//
//class SObjc {
//    
//    private var temCommunicationManager: TemCommunicationManager
//    
//    init() {
//        temCommunicationManager = TemCommunicationManager()
//    }
//    
//    static let sharedInstance: SObjc = {
//        let instance = SObjc()
//        return instance
//    }()
//    
//    func createSandbox(applicationId: String,
//                       applicationVersion: String,
//                       ip: String,
//                       port: Int,
//                       callingMethod: Int,
//                       authorizedActivities: Int,
//                       offlineInstallMode: Int,
//                       contractNumber: String,
//                       SSL: Int,
//                       certClient: String,
//                       keyClient: String,
//                       certServ: String,
//                       resultBlock: @escaping (SandboxStatus) -> Void) {
//        temCommunicationManager.initTem(withIp: ip, andport: Int32(port), andResultBlock: resultBlock)
//    }
//    
//    func createReaderContext(readerStateJson: String,
//                             completionBlock: @escaping (Int) -> Void) {
//        temCommunicationManager.createReaderContext(readerStateJson) { value in
//            completionBlock(Int(value))
//        }
//    }
//    
//    func updateReaderJsonState(readerStateJson: String,
//                               completionBlock: @escaping (Int) -> Void) {
//        temCommunicationManager.updateReaderStateJson(readerStateJson) { value in
//            completionBlock(Int(value))
//        }
//    }
//    
//    func performCall(reasonForCalling: ReasonForCalling,
//                     completionBlock: @escaping (Int) -> Void) {
//        if reasonForCalling == .MANUAL {
//            temCommunicationManager.poll() { value in
//                completionBlock(Int(value))
//            }
//        } else {
//            temCommunicationManager.reportFirmwareStatus { value in
//                completionBlock(Int(value))
//            }
//        }
//    }
//    
//    func isUpdateAvailable(deviceSerialNumber: String,
//                           resultBlock: @escaping (Bool) -> Void) {
//        temCommunicationManager.isUpdateAvailable(deviceSerialNumber, andResultBlock: resultBlock)
//    }
//    
//    func getUpdateFilePath(deviceSerialNumber: String,
//                           resultBlock: @escaping (String) -> Void) {
//        temCommunicationManager.getUpdateFilePath(deviceSerialNumber, andResultBlock: resultBlock)
//    }
//    
//    func getRkiFileName(deviceSerialNumber: String,
//                        resultBlock: @escaping (String) -> Void) {
//        temCommunicationManager.getRkiFileName(deviceSerialNumber, andResultBlock: resultBlock)
//    }
//}
