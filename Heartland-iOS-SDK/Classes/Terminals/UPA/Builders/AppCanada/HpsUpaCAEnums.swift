//
//  HpsUpaCAEnums.swift
//  Heartland-iOS-SDK
//

import Foundation

public enum AccountTypeCA: String, Codable {
    case CHEQUING
    case CHEQUE
    case SAVINGS
    case EPARGNES
    case AHORROS
    
    public var rawValue: String {
        switch self {
        case .CHEQUING:
            return "CHEQUING"
        case .CHEQUE:
            return "CHEQUE"
        case .SAVINGS:
            return "SAVINGS"
        case .EPARGNES:
            return "EPARGNES"
        case .AHORROS:
            return "AHORROS"
        }
    }
}

public enum PinVerified: Int, Codable {
    case YES
    case NO
    
    public var rawValue: Int {
        switch self {
        case .YES:
            return 1
        case .NO:
            return 0
        }
    }
}

public enum CardAcquisition: String, CaseIterable, Identifiable, Codable {
    case NONE
    case MANUAL
    case SWIPE
    case INSERT
    case TAP
    
    public var id: String { self.rawValue }
    
    public var rawValue: String {
        switch self {
        case .NONE:
            return "NONE"
        case .MANUAL:
            return "MANUAL"
        case .SWIPE:
            return "SWIPE"
        case .INSERT:
            return "INSERT"
        case .TAP:
            return "TAP"
        }
    }
}

public enum CardGroup: String, CaseIterable, Identifiable, Codable {
    case Credit
    case Debit
    case EBT
    
    public var id: String { self.rawValue }
    
    public var rawValue: String {
        switch self {
        case .Credit:
            return "Credit"
        case .Debit:
            return "Debit"
        case .EBT:
            return "EBT"
        }
    }
}

public enum TransactionType: String, CaseIterable, Codable {
    case SALE
    case REFUND
    
    public var rawValue: String {
        switch self {
        case .SALE:
            return "Sale"
        case .REFUND:
            return "Refund"
        }
    }
}

public enum CardOnFileIndicator: String, CaseIterable, Codable {
    case CARDHOLDER
    case MERCHANT
    
    public var rawValue: String {
        switch self {
        case .CARDHOLDER:
            return "C"
        case .MERCHANT:
            return "M"
        }
    }
}

public enum HpsUpaCAModelCommand: String, Codable {
    case SALE
    case REFUND
    case VOID
    
    public var rawValue: String {
        switch self {
        case .SALE:
            return "Sale"
        case .REFUND:
            return "Refund"
        case .VOID:
            return "Void"
        }
    }
}

public enum HpsUpaCAModelMessage: String, Codable {
    case MSG
    case ACK
    
    public var rawValue: String {
        switch self {
        case .MSG:
            return "MSG"
        case .ACK:
            return "ACK"
        }
    }
}
