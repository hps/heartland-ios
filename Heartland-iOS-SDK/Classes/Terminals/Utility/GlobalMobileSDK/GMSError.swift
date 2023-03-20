import Foundation
import GlobalMobileSDK

@objc
public enum GMSErrorType: Int {
    case connectionError = 0,
         searchError = 1,
         transactionError = 2
}

extension NSError {
    convenience init(fromConnectionError error: GlobalMobileSDK.ConnectionError) {
        var reason = "unknown"
        switch error {
        case .bluetoothNotSupported:
            reason = "bluetoothNotSupported"
        case .bluetoothPermissionNotGranted:
            reason = "bluetoothPermissionNotGranted"
        case .bluetoothDisabled:
            reason = "bluetoothDisabled"
        case .bluetoothConnectionLost:
            reason = "bluetoothConnectionLost"
        case .devicePoweredOff:
            reason = "devicePoweredOff"
        case .terminalNotConfigured:
            reason = "terminalNotConfigured"
        case .bluetoothConnectionTimeout:
            reason = "bluetoothConnectionTimeout"
        case .alreadyPairedWithAnotherDevice:
            reason = "alreadyPairedWithAnotherDevice"
        @unknown default:
            reason = "unknown"
        }

        self.init(domain: "com.heartlandpaymentsystems.iossdk", code: GMSErrorType.connectionError.rawValue, userInfo: ["reason": reason])
    }

    convenience init(fromSearchError error: GlobalMobileSDK.SearchError) {
        var reason = "unknown"
        switch error {
        case .bluetoothNotSupported:
            reason = "bluetoothNotSupported"
        case .bluetoothPermissionNotGranted:
            reason = "bluetoothPermissionNotGranted"
        case .bluetoothDisabled:
            reason = "bluetoothDisabled"
        case .terminalNotConfigured:
            reason = "terminalNotConfigured"
        @unknown default:
            reason = "unknown"
        }

        self.init(domain: "com.heartlandpaymentsystems.iossdk", code: GMSErrorType.searchError.rawValue, userInfo: ["reason": reason])
    }

    convenience init(fromTransactionError error: GlobalMobileSDK.TransactionError) {
        var reason = "unknown"
        var message: String?
        var errorCode: Int?
        var transactionId: String?
        switch error {
        case .gatewayNotConfigured:
            reason = "gatewayNotConfigured"
        case .terminalNotConfigured:
            reason = "terminalNotConfigured"
        case .bluetoothNotSupported:
            reason = "bluetoothNotSupported"
        case .bluetoothPermissionNotGranted:
            reason = "bluetoothPermissionNotGranted"
        case .bluetoothDisabled:
            reason = "bluetoothDisabled"
        case .bluetoothConnectionLost:
            reason = "bluetoothConnectionLost"
        case .devicePoweredOff:
            reason = "devicePoweredOff"
        case .cardNotRemoved:
            reason = "cardNotRemoved"
        case .terminalNotConnnected:
            reason = "terminalNotConnnected"
        case .transactionNotInProgress:
            reason = "transactionNotInProgress"
        case .transactionNotSupported:
            reason = "transactionNotSupported"
        case .transactionInProgress:
            reason = "transactionInProgress"
        case let .transactionFailed(msg):
            reason = "transactionFailed"
            message = msg
        case let .safTransactionFailed(msg, txnId):
            reason = "safTransactionFailed"
            message = msg
            transactionId = txnId
        case let .terminalFailed(msg, errCode):
            reason = "terminalFailed"
            message = msg
            errorCode = errCode
        case let .missingRequiredValue(msg):
            reason = "missingRequiredValue"
            message = msg
        case let .gatewayPermissionFailed(msg):
            reason = "gatewayPermissionFailed"
            message = msg
        case let .gatewayFailure(msg, errCode):
            reason = "gatewayFailure"
            message = msg
            errorCode = errCode
        case .hostTimeout:
            reason = "hostTimeout"
        case .hostNotReachable:
            reason = "hostNotReachable"
        case .trackReadFailed:
            reason = "trackReadFailed"
        @unknown default:
            reason = "unknown"
        }

        self.init(domain: "com.heartlandpaymentsystems.iossdk", code: GMSErrorType.transactionError.rawValue, userInfo: [
            "reason": reason,
            "message": message ?? "",
            "errorCode": String(errorCode ?? -1),
            "transactionId": transactionId ?? "",
        ])
    }
}
