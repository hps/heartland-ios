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

    // MARK: Init
    public init(_ gatewayConfig: GMSConfiguration?, delegate: GMSClientAppDelegate, entryModes: [EntryMode], terminalType: TerminalType) {
        self.gatewayConfig = gatewayConfig
        self.delegate = delegate
        self.transactionType = .unknown
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
                GMSManager.shared.start(transaction: transaction, entryModes: self.entryModes, delegate: self)
            }
        case .creditAdjust:
            if let transaction = builder.buildRequest() as? TipAdjustTransaction {
                GMSManager.shared.start(transaction: transaction, entryModes: self.entryModes, delegate: self)
            }
        case .creditAuth:
            if let transaction = builder.buildRequest() as? AuthTransaction {
                GMSManager.shared.start(transaction: transaction, entryModes: self.entryModes, delegate: self)
            }
        case .creditCapture:
            if let transaction = builder.buildRequest() as? CaptureTransaction {
                GMSManager.shared.start(transaction: transaction, entryModes: self.entryModes, delegate: self)
            }
        case .creditReturn:
            if let transaction = builder.buildRequest() as? ReturnTransaction {
                GMSManager.shared.start(transaction: transaction, entryModes: self.entryModes, delegate: self)
            }
        case .creditReversal:
            if let transaction = builder.buildRequest() as? ReversalTransaction {
                GMSManager.shared.start(transaction: transaction, entryModes: self.entryModes, delegate: self)
            }
        case .creditSale:
            if let transaction = builder.buildRequest() as? SaleTransaction {
                GMSManager.shared.start(transaction: transaction, entryModes: self.entryModes, delegate: self)
            }
        case .creditVoid:
            guard let original = builder.buildRequest() as? VoidTransaction else {
                return;
            }
            let transaction = GPTransaction(fromId: original.gatewayTransactionId)
            let builder = transaction?.voidTransaction()
            
            builder?.execute({ (gatewayResponse, gatewayError) in
                if (gatewayError != nil) {
                    self.delegate.onError(gatewayError! as NSError)
                    return
                }
                
                let response = HpsTerminalResponse()
                response.transactionId = gatewayResponse?.transactionId()
                response.deviceResponseCode = "Success"
                
                self.delegate.onTransactionComplete(TransactionResult.success.rawValue, response: response)
            })
        default:
            break;
        }
    }

    public func confirmAmount(amount: Decimal) {
      GMSManager.shared.confirm(amount: amount)
    }

    public func selectAID(aid: AID) {
      GMSManager.shared.select(aid: aid)
    }
}

extension GMSWrapper: SearchDelegate {

    // MARK: SearchDelegate
    public func deviceFound(terminalInfo: TerminalInfo) {
        delegate.deviceFound(HpsTerminalInfo.init(fromTerminalInfo: terminalInfo))
    }

    public func onSearchComplete() {
        delegate.searchComplete()
    }

    public func onError(error: SearchError) {
        delegate.onError(NSError.init(fromSearchError: error));
    }
}

extension GMSWrapper: ConnectionDelegate {

    // MARK: ConnectionDelegate
    public func onConnected(terminalInfo: TerminalInfo) {
        selectedTerminal = HpsTerminalInfo.init(fromTerminalInfo: terminalInfo)
        delegate.deviceConnected()//(selectedTerminal)
    }

    public func onDisconnected(terminalInfo: TerminalInfo) {
        selectedTerminal = nil
        delegate.deviceDisconnected()
    }

    public func configuringTerminal(state: TransactionState) {
        delegate.deviceConnected()
    }

    public func onError(error: ConnectionError) {
        delegate.onError(NSError.init(fromConnectionError: error));
    }
}

extension GMSWrapper: TransactionDelegate {

    // MARK: TransactionDelegate
    public func onState(state: TransactionState) {
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
        data.clientTransactionIdUUID = response?.transactionId
        
        if let uintValue = response?.approvedAmount {
            data.approvedAmount = GMSResponseHelper.uintToDecimal(uintValue)
        }

        if let b = self.builder {
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
        delegate.onError(NSError.init(fromTransactionError: error));
    }
}
