//
//
//  TapToPayViewModel.swift
//  Heartland-iOS-SDK
//
    

import Foundation

@available(iOS 16.0, *)
enum TTPTransactionType: Int, CaseIterable, Identifiable {
    case sale, refund, verification

    var name: String {
        switch self {
        case .sale:
            return "Sale"
        case .refund:
            return "Refund"
        case .verification:
            return "Verification"
        }
    }
    
    var id: Int { self.rawValue }
}

@available(iOS 16.0, *)
enum TTPReaderMode: Int, CaseIterable, Identifiable {
    /// A value that represents a payment.
    case paymentOnly
    // A value that represents a Value Added Service (VAS) such as a loyalty program, a ticket, and so on, or a payment.
    case vasOrPayment
    // A value that represents a VAS and a payment.
    case vasAndPayment
    // A value that represents only a VAS.
    case vasOnly

    /// A computed property you can use to get text representations of the names of the operand cases.
    var name: String {
        switch self {
        case .paymentOnly:
            return "Payment Only"
        case .vasOrPayment:
            return "VAS Or Payment"
        case .vasAndPayment:
            return "VAS And Payment"
        case .vasOnly:
            return "VAS Only"
        }
    }

    /// An identifier that enables this enumeration to conform to the identifiable protocol.
    var id: Int { self.rawValue }
}

@available(iOS 16.0, *)
class TapToPayViewModel: ObservableObject {
    @Published var transactionTypePicker = TTPTransactionType.sale
    @Published var amount: Decimal = 0
}
