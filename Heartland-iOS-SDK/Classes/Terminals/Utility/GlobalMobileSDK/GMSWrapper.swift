import Foundation
import GlobalMobileSDK
import GlobalPaymentsApi

@objcMembers
public class GMSWrapper: NSObject {
    // MARK: Variables

    private var gatewayConfig: GMSConfiguration?
    private unowned let delegate: GMSClientAppDelegate
    private var selectedTerminal: HpsTerminalInfo?
    private var aids: [AID]?
    private var entryModes: [EntryMode]
    private var transactionType: HpsTransactionType
    private var builder: GMSBaseBuilder?
    private var currentState: TransactionState = .unknown

    var terminalOTADelegate: GMSClientTerminalOTAManagerDelegate?

    // MARK: Init

    public init(_ gatewayConfig: GMSConfiguration?, delegate: GMSClientAppDelegate, entryModes: [EntryMode], terminalType: TerminalType) {
        self.gatewayConfig = gatewayConfig
        self.delegate = delegate
        transactionType = .unknown
        self.entryModes = entryModes

        if let config = gatewayConfig {
            try! GMSManager.shared.configure(gatewayConfig: config.asPorticoConfig(terminalType: terminalType))
        }
    }

    // MARK: External

    public func searchDevices() {
        GMSManager.shared.search(delegate: self)
    }

    public func cancelSearch() {
        GMSManager.shared.cancelSearch()
    }

    public func cancelTransaction() {
        GMSManager.shared.cancelTransaction()
    }

    public func connectDevice(_ device: HpsTerminalInfo) {
        GMSManager.shared.connect(terminalInfo: device.gmsTerminalInfo, delegate: self)
    }

    public func disconnect() {
        selectedTerminal = nil
        GMSManager.shared.disconnect()
    }

    public func startTransaction(_ builder: GMSBaseBuilder, withTransactionType transactionType: HpsTransactionType) {
        self.transactionType = transactionType
        self.builder = builder
        switch transactionType {
        case .batchClose:
            if let transaction = builder.buildRequest() as? BatchCloseTransaction {
                GMSManager.shared.start(transaction: transaction, entryModes: entryModes, delegate: self)
            }
        case .creditAdjust:
            if let transaction = builder.buildRequest() as? TipAdjustTransaction {
                GMSManager.shared.start(transaction: transaction, entryModes: entryModes, delegate: self)
            }
        case .creditAuth:
            if let transaction = builder.buildRequest() as? AuthTransaction {
                GMSManager.shared.start(transaction: transaction, entryModes: entryModes, delegate: self)
            }
        case .creditCapture:
            if let transaction = builder.buildRequest() as? CaptureTransaction {
                GMSManager.shared.start(transaction: transaction, entryModes: entryModes, delegate: self)
            }
        case .creditReturn:
            if let transaction = builder.buildRequest() as? ReturnTransaction {
                GMSManager.shared.start(transaction: transaction, entryModes: entryModes, delegate: self)
            }
        case .creditReversal:
            if let transaction = builder.buildRequest() as? ReversalTransaction {
                GMSManager.shared.start(transaction: transaction, entryModes: entryModes, delegate: self)
            }
        case .creditSale:
            if let transaction = builder.buildRequest() as? SaleTransaction {
                GMSManager.shared.start(transaction: transaction, entryModes: entryModes, delegate: self)
            }
        case .creditVoid:
            guard let original = builder.buildRequest() as? VoidTransaction else {
                return
            }
            let transaction = GPTransaction(fromId: original.gatewayTransactionId)
            let builder = transaction?.voidTransaction()

            builder?.execute { gatewayResponse, gatewayError in
                if gatewayError != nil {
                    self.delegate.onError(gatewayError! as NSError)
                    return
                }

                let response = HpsTerminalResponse()
                response.transactionId = gatewayResponse?.transactionId()
                response.deviceResponseCode = gatewayResponse?.responseCode
                response.deviceResponseMessage = gatewayResponse?.responseMessage
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate.onTransactionComplete(TransactionResult.success.rawValue, response: response)
                }
                
            }
        default:
            break
        }
    }

    public func confirmAmount(amount: Decimal) {
        GMSManager.shared.confirm(amount: amount)
    }
    
    public func confirmSurcharge(_ builder: GMSBaseBuilder, withTransactionType transactionType: HpsTransactionType) {
        self.transactionType = transactionType
        self.builder = builder
        switch transactionType {
        case .creditAuth:
            if let transaction = builder.buildRequest() as? AuthTransaction {
                GMSManager.shared.confirmSurcharge(transaction: transaction, delegate: self)
            }
        case .creditCapture:
            if let transaction = builder.buildRequest() as? CaptureTransaction {
                GMSManager.shared.confirmSurcharge(transaction: transaction, delegate: self)
            }
        case .creditSale:
            if let transaction = builder.buildRequest() as? SaleTransaction {
                GMSManager.shared.confirmSurcharge(transaction: transaction, delegate: self)
            }
        default:
            break
        }
        
    }

    public func selectAID(aid: AID) {
        GMSManager.shared.select(aid: aid)
    }
    
    public func isDeviceConnected() -> Bool {
        return GMSManager.shared.terminalConnected
    }
}

extension GMSWrapper: SearchDelegate {
    // MARK: SearchDelegate

    public func deviceFound(terminalInfo: TerminalInfo) {
        delegate.deviceFound(HpsTerminalInfo(fromTerminalInfo: terminalInfo))
    }

    public func onSearchComplete() {
        delegate.searchComplete()
    }

    public func onError(error: SearchError) {
        delegate.onError(NSError(fromSearchError: error))
    }
}

extension GMSWrapper: ConnectionDelegate {
    // MARK: ConnectionDelegate

    public func onConnected(terminalInfo: TerminalInfo) {
        selectedTerminal = HpsTerminalInfo(fromTerminalInfo: terminalInfo)
        delegate.deviceConnected() // (selectedTerminal)
    }

    public func onDisconnected(terminalInfo _: TerminalInfo) {
        selectedTerminal = nil
        delegate.deviceDisconnected()
    }

    public func configuringTerminal(state _: TransactionState) {
        delegate.deviceConnected()
    }

    public func onError(error: ConnectionError) {
        delegate.onError(NSError(fromConnectionError: error))
    }
}

extension GMSWrapper: TransactionDelegate {
   
    // MARK: TransactionDelegate

    public func onState(state: TransactionState) {
        print(" GMSWrapper - onState ")
        currentState = state
        delegate.onStatus(HpsTransactionStatus.fromTransactionState(state))
    }

    public func requestAIDSelection(aids: [AID]) {
        delegate.requestAIDSelection(aids)
    }

    public func requestAmountConfirmation(amount: Decimal?) {
        delegate.requestAmountConfirmation(amount ?? 0)
    }

    public func requestPostalCode(maskedPan: String, expiryDate: String, cardholderName: String?) {
        delegate.requestPostalCode(maskedPan, expiryDate: expiryDate, cardholderName: cardholderName ?? "")
    }

    public func requestSaFApproval() {
        delegate.requestSaFApproval()
    }

    public func onTransactionComplete(result: TransactionResult, response: TransactionResponse?) {
        var data = HpsTerminalResponse()

        data.transactionId = response?.gatewayTransactionId
        data.clientTransactionId = response?.transactionId

        if let uintValue = response?.approvedAmount {
            data.approvedAmount = GMSResponseHelper.uintToDecimal(uintValue)
        }

        if let b = builder {
            data = b.mapResponse(data, result, response)
        }

        if result == .success && currentState == .reversalInProgress {
            data.deviceResponseCode = "reversed"
        }

        delegate.onTransactionComplete(result.rawValue, response: data)
    }

    public func onTransactionCancelled() {
        delegate.onTransactionCancelled()
    }

    public func onError(error: TransactionError) {
        if error.isStartError {
            onTransactionStartFailed(withError: error)
        } else {
            delegate.onError(.init(fromTransactionError: error))
        }
    }
    
    public func onTransactionWaitingForSurchargeConfirmation(result: TransactionResult,
                                                             response: TransactionResponse?) {
        let data = HpsTerminalResponse()
        data.deviceResponseCode = result.rawValue
        let responseMap = HpsTerminalResponse()
        responseMap.responseCode = response?.gatewayResponseCode
        responseMap.responseText = response?.gatewayResponseText
        responseMap.surchargeFee = response?.surchargeFee
        
        delegate.onTransactionWaitingForSurchargeConfirmation(result: .surchargeRequested,
                                                              response: responseMap)
    }
    
}

/*
 Utilities added as a temp work around for inconsistent GlobalMobileSDK behavior.

 Transaction-failing errors are usually returned within response objects passed into
 onTransactionComplete. However, if a card is inserted before a transaction
 starts, for some reason the error (which also ends the transaction attempt) is passed
 through onError instead.

 Should probably have all process-failing errors return in 1 place, but until then we
 have this...
 */

private extension GlobalMobileSDK.TransactionError {
    var isStartError: Bool {
        switch self {
        case .cardNotRemoved: return true
        default: return false
        }
    }
}

private extension HpsTransactionType {
    var asGMSTransactionType: GlobalMobileSDK.TransactionType? {
        switch self {
        case .batchClose: return .BatchClose
        case .creditAdjust: return .TipAdjust
        case .creditAuth: return .Auth
        case .creditCapture: return .Capture
        case .creditReturn: return .Return
        case .creditReversal: return .Reversal
        case .creditSale: return .Sale
        case .creditVoid: return .Void
        case .unknown: return nil
        }
    }
}

private extension GMSWrapper {
    func onTransactionStartFailed(withError gmsError: GlobalMobileSDK.TransactionError) {
        let response = HpsTerminalResponse()
        let error = NSError(fromTransactionError: gmsError)
        let reason = error.userInfo["reason"] as? String
        response.deviceResponseCode = reason
        let gmsTransactionType = builder?.transactionType.asGMSTransactionType
        let transactionType = gmsTransactionType.flatMap(HpsC2xEnums.transactionTypeToString)
        response.transactionType = transactionType
        delegate.onTransactionComplete("", response: response)
    }
}

// MARK: - Firmware Update

public extension GMSWrapper {
    func requestAvailableOTAVersionsListFor(type: TerminalOTAUpdateType) {
        GMSManager.shared.requestAvailableOTAVersionsListFor(type: type, delegate: self)
    }

    func requestToStartUpdateFor(type: TerminalOTAUpdateType) {
        GMSManager.shared.requestToStartUpdateFor(type: type, delegate: self)
    }

    func requestTerminalVersionData() {
        GMSManager.shared.requestTerminalVersionData(delegate: self)
    }

    func setVersionDataFor(versionString: String) {
        GMSManager.shared.setVersionDataFor(type: .firmware, versionString: versionString, delegate: self)
    }
}

// MARK: - TerminalOTAManagerDelegate

extension GMSWrapper: TerminalOTAManagerDelegate {
    public func terminalVersionDetails(info: [AnyHashable: Any]?) {
        terminalOTADelegate?.terminalVersionDetails(info: info)
    }

    public func terminalOTAResult(resultType: GlobalMobileSDK.TerminalOTAResult,
                                  info: [String: AnyObject]?, error: Error?)
    {
        terminalOTADelegate?.terminalOTAResult(resultType: resultType, info: info, error: error)
    }

    public func listOfVersionsFor(type: GlobalMobileSDK.TerminalOTAUpdateType, results: [Any]?) {
        terminalOTADelegate?.listOfVersionsFor(type: type, results: results)
    }

    public func otaUpdateProgress(percentage: Float) {
        terminalOTADelegate?.otaUpdateProgress(percentage: percentage)
    }

    public func onReturnSetTargetVersion(resultType: GlobalMobileSDK.TerminalOTAResult,
                                         type: GlobalMobileSDK.TerminalOTAUpdateType,
                                         message: String)
    {
        terminalOTADelegate?.onReturnSetTargetVersion(resultType: resultType, type: type, message: message)
    }
}
