//
//
//  ProximityReaderViewModel.swift
//  Heartland-iOS-SDK
//
    

import Foundation
import UIKit
import os

#if canImport(ProximityReader)
import ProximityReader

@available(iOS 16.0, *)

class ProximityReaderViewModel: ObservableObject {
    @Published var status: String = "Not Ready"
    @Published var readerID: String = ""
    @Published var statusOK: Bool = false
    @Published var formattedVasResultString: String = ""
    @Published var info: String = ""
    @Published var trxShow: Bool = false
    @Published var paymentShow: Bool = false
    @Published var vasShow: Bool = false
    @Published var trxStatus: String = ""
    @Published var trxResult: String = ""
    
    var currentAuthResult: (status: String, amount: Decimal, transactionId: String)?

    private var currentPaymentData: PaymentCardReadResult?
    private var currentReadError: PaymentCardReaderSession.ReadError?
    private var reader: PaymentCardReader?
    private var session: PaymentCardReaderSession?
    private var activity: ActivityReporter?

    private var lastPspTokenUsed = PaymentCardReader.Token(rawValue: "")

    private var notificationCenterObservers = [Any]()
    private var inBackground: Bool = true

    init() {
        reader = makeReader()
        activity = ActivityReporter()
    }

    var isTapToPayAvailable: Bool {
        return true
    }

    /// Links to a merchant's account.
    ///
    /// This demonstrates how to link a merchant's account. In a production
    /// implementation you would perform this step only once per merchant.
    func linkAccount() {
        let token = TokenProvider.shared.buildToken()
        Task {
            do {
               try await reader?.linkAccount(using: token)
                DispatchQueue.main.async {
                    self.status = "Account Linked"
                    self.statusOK = true
                }
            } catch {
                await handlePaymentCardReaderError(error)
            }
        }
    }

    /// Prepares the model to execute transactions.
    ///
    /// You need to call this function in order to ensure you obtain a valid and active session.
    /// `ProximityReader` validates if the current reader is ready for a transaction. Typically,
    /// when the reader is already ready, `prepare()` returns immediately with success.
    /// A best practice is to have only one active reader and one active session.
    ///
    /// Call this function when the app becomes `.active` from the `.background` state.
    /// Typically, you call this function while observing the app's lifecycle events
    func prepare() {
        self.status = "PREPARING"
        self.statusOK = false
        
        let token = TokenProvider.shared.buildToken()

        Task {
            do {
                let readerID = try await reader?.readerIdentifier ?? ""

                if #available(iOS 16.0, *) {
                    session = try await reader?.prepare(using: token)
                } else {
                    // Devices running iOS versions before 16.0, must implement this API.
                    session = try await reader?.prepare(using: token) { progress in
                         DispatchQueue.main.async {
                             self.status = "CONFIGURING - \(progress)%."
                         }
                    }
                }

                activity?.lastSession = session
                activity?.rid = readerID

                DispatchQueue.main.async {
                    self.readerID = String(readerID.prefix(16) + "...")
                    self.status = "Tap to Pay on iPhone is READY."
                    self.statusOK = true
                }

            } catch {
                await handlePaymentCardReaderError(error)
            }
        }
    }

    /// Resets the model and reestablishes the payment reader session.
    ///
    /// This function demonstrates how do clean up and reestablish a reader and session.
    /// In practice, the system manages the lifecycle of the objects, including the `PaymentCardReader`,
    /// efficiently and, as long as the `PaymentCardReader` isn't manually set to `nil` or destroyed,
    /// your `prepare()` implementation returns success immediately. Forcing a cleanup directly
    /// impacts the performance of subsequent call to `prepare()`  which could take several
    /// seconds to re-establish full session.
    func cleanup() {
        session = nil
        self.status = "Not Ready"
        self.statusOK = false
        self.lastPspTokenUsed = PaymentCardReader.Token(rawValue: "")
        
        reader = makeReader() // Get new reader.
    }

    /// Pays the amount you specify.
    ///
    /// An example implementation that demonstrates processing a typical payment transaction.
    ///
    /// - Parameter:
    ///      - amount: A decimal amount that represents a payment the network should process.
    func pay(_ amount: Decimal, transactionType: TTPTransactionType, readerMode: TTPReaderMode) {
        Task {
            guard let session = session else {
                self.currentReadError = .noReaderSession
                await displayReadResultOrError()
                return
            }

            do {
                var readData: Any?

                if transactionType == .verification {
                    let request = PaymentCardVerificationRequest(currencyCode: "USD")
                    if #available(iOS 16.0, *) {
                        readData = try await session.readPaymentCard(request)
                    } else {
                        readData = try await session.readPaymentCard(request) { [weak self] event in
                            self?.reportSessionEvent(event.name)
                        }
                    }
                } else {
                    // This section demonstrates a typical payment transaction.
                    // As long as you have an active session, you can successfully
                    // call `readPaymentCard()` anytime.
                    //
                    // On rare occasions, that depend on validity period of your
                    // `PaymentCardReader.Token` from Payment Service Provider (PSP)
                    // and how long the application has been in foreground (for example,
                    // without ever calling `prepare()`), you may get an error when the
                    // token has expired.
                    //
                    // It's a best practice is to check for this specific error
                    // condition and obtain a new token from PSP.
                    // ( see `catch` section below)
                    let type: PaymentCardTransactionRequest.TransactionType = transactionType == .sale ? .purchase : .refund

                    if readerMode == .paymentOnly {
                        let request = PaymentCardTransactionRequest(amount: amount,
                                                                    currencyCode: "USD",
                                                                    for: type)
                        if #available(iOS 16.0, *) {
                            readData = try await session.readPaymentCard(request)
                        } else {
                            readData = try await session.readPaymentCard(request) { [weak self] event in
                                self?.reportSessionEvent(event.name)
                            }
                        }
                    }

                    // This section demonstrates how to use VAS (vas read only
                    // or vas read combined with payment card read).
                    else if readerMode == .vasOnly {
                        let vasRequest = VASRequest()
                        if #available(iOS 16.0, *) {
                            readData = try await session.readVAS(vasRequest)
                        } else {
                            readData = try await session.readVAS(vasRequest) { [weak self] event in
                                self?.reportSessionEvent(event.name)
                            }
                        }
                    } else {
                        let paymentRequest = PaymentCardTransactionRequest(amount: amount,
                                                                           currencyCode: "USD",
                                                                           for: type)
                        let vasRequest = VASRequest() // VASRequest.Merchant were defined at the reader level
                        let stopOnVASResult = readerMode == .vasOrPayment ? true : false
                        if #available(iOS 16.0, *) {
                            readData = try await session.readPaymentCard(paymentRequest,
                                                                         vasRequest: vasRequest,
                                                                         stopOnVASResult: stopOnVASResult)
                        } else {
                            readData = try await session.readPaymentCard(paymentRequest,
                                                                         vasRequest: vasRequest,
                                                                         stopOnVASResult: stopOnVASResult) { [weak self] event in
                                self?.reportSessionEvent(event.name)
                            }
                        }
                    }
                }

                // Handling of read results for each type of read.
                var transactionId = ""

                // Payment Card results
                if let payment = readData as? PaymentCardReadResult {
                    // Payment processing: This is where you deliver the payment
                    // result to the PSP backend for payment authorization.
                    self.currentPaymentData = payment
                    transactionId = payment.id

                    self.currentAuthResult = ("APPROVED", amount, transactionId)

                // VAS results
                } else if let (pay, vas) = readData as? (PaymentCardReadResult?, VASReadResult?) {
                    self.currentPaymentData = pay
                    let vasEntries = vas?.entries ?? []
                    self.formattedVasResultString = self.formatVasResults(vasEntries)
                    transactionId =  pay?.id ?? (vas?.id ?? "")
                    self.currentAuthResult = ("APPROVED", amount, transactionId)
                } else if let vasOnly = readData as? VASReadResult {
                    self.formattedVasResultString = self.formatVasResults(vasOnly.entries)
                    self.currentAuthResult = nil
                    transactionId = vasOnly.id
                }

                // Update the display.
                await displayReadResultOrError()

            } catch {
                if let err = error as? PaymentCardReaderSession.ReadError {
                    self.currentReadError = err
                    handleReadError(err)
                } else {
                    // unexpected error type
                    let error = String(describing: error)
                    print("Unknown and unexpected error returned from PaymentProcessorApi.shared.transaction. Error: \(error).")
                }

                // Update the display.
                await displayReadResultOrError()
            }
        }
    }

    func clearTransactionResult() {
        self.currentPaymentData = nil
        self.currentAuthResult = nil
        self.currentReadError = nil
        self.trxShow = false
        self.paymentShow = false
        self.vasShow = false
        self.trxResult = ""
        self.formattedVasResultString = ""
    }

    // MARK: - Payment activity reporter example

    // This is a simple demonstration of a transaction activity reporter you
    // can implement by subscribing to reader's event stream to notify or log
    // reader activities.
    //
    // These events aren't tied to specific transaction ID (except for the final
    // `.complete` event), therefore the POS app should track active session and
    // current read reference — app's own unique transaction reference —
    // if your use case requires tracking individual events per transaction.
    struct ActivityReporter {

        weak var lastSession: PaymentCardReaderSession?
        var rid: String?

        func report(_ eventName: String, tid: String? = nil) {
            var output: String

            var sessionIdentifier = "no session"
            if let session = self.lastSession {
                // This is the object ID of the PaymentCardReaderSession object.
                sessionIdentifier = ObjectIdentifier(session).debugDescription
            }

            if let tid = tid {
                output = """
                Report {
                    readerID: \(self.rid ?? "no reader id"),
                    sessionID: \(sessionIdentifier),
                    transactionID: \(tid),
                    event: \(eventName)
                }
                """
            } else {
                output = """
                Report {
                    readerID: \(self.rid ?? "no reader id"),
                    sessionID: \(sessionIdentifier),
                    event: \(eventName)
                }
                """
            }
            // Locally log the activity.
            print("\(output)")
        }
    }

    func reportSessionEvent(_ eventName: String) {
        activity?.report(eventName)
    }

    // MARK: - Error handler functions

    // Handling of `PaymentCardReaderError`.
    @MainActor private func handlePaymentCardReaderError(_ error: Error) {

        guard let err = error as? PaymentCardReaderError else {
            // unexpected error type
            print("unexpected error type. Error: \(String(describing: error))")
            return
        }

        switch err {
        /// Errors specific to `prepare()`.
        case .accountNotLinked:
            self.status = "Your account is not linked. Call linkAccount() or ask user to initiate account setup."
            self.info = self.status
            self.statusOK = false

        case .prepareFailed(let reason):
            // It's a best practice log failure reasons to triage issues originating on the remote service.
            self.status = "Unable to prepare. Reason: \(reason ?? "Unknown.")"
            self.info = self.status
            self.statusOK = false

        case .invalidReaderToken(let reason):
            // It's a best practice log failure reasons to triage issues originating on the remote service.
            self.status = "Invalid reader token. Reason: \(reason ?? "Unknown.")"
            self.info = self.status
            self.statusOK = false

        case .osVersionNotSupported:
            self.status = "This iOS version is no longer supported. Update your device."
            self.info = self.status
            self.statusOK = false

        case .deviceBanned(let date):
            /// The service has banned this device temporarily due to abnormal activity.
            if let date = date {
                self.status = "Your device is temporarily banned. Try again at \(date.formatted())."
            } else {
                self.status = "Your device is temporarily banned. Try again later and if this error persists contact support."
            }
            self.info = self.status
            self.statusOK = false

        case .notReady:
            self.status = "Reader not ready."
            self.info = self.status
            self.statusOK = false

        case .readerBusy:
            self.status = "Your reader is busy. Try again a few minutes."
            self.info = self.status
            self.statusOK = false

        case .prepareExpired:
            self.status = "The session expired, call prepare again. (This deprecated in iOS 16 and later)."
            self.info = self.status
            self.statusOK = false

        /// Errors specific to `linkAccount()`.
        case .accountAlreadyLinked:
            self.status = "Account is already linked, proceed with preparing the reader."
            self.info = self.status
            self.statusOK = false

        case .accountLinkingFailed, .accountLinkingCancelled:
            self.status = "Account linking not completed."
            self.info = self.status
            self.statusOK = false

        /// Common reader errors.
        case .tokenExpired:
            self.status = "Your reader token expired. Fetch a new token from your PSP."
            self.info = self.status
            self.statusOK = false

        case .unsupported:
            self.status = "There's a problem with your device, most likely permanent. Contact support."
            self.info = self.status
            self.statusOK = false

        case .notAllowed:
            self.status = "Your app is not allowed to use this API. Check your entitlement."
            self.info = self.status
            self.statusOK = false

        case .backgroundRequestNotAllowed:
            // This error occurs if your app enters the  `.background` state and is still calling additional API.
            self.status = "Calling API from background isn't allowed."
            self.info = self.status
            self.statusOK = false

        default:
            self.status = "\(err.errorName)"
            self.statusOK = false
        }

        self.clearTransactionResult()
    }

    /// Handle read errors.
    ///
    /// This function demonstrates handing of possible read errors and describes
    /// typical causes and solutions.
    ///
    /// Parameter:
    ///  - err: A `PaymentCardReaderSession.ReadError` value.
    func handleReadError(_ err: PaymentCardReaderSession.ReadError) {
        switch err {
        case .readerTokenExpired:
            // You should fetch a new token from PSP and perform `readPaymentCard`
            // with current transaction request to seamlessly allow current transaction to go through.
            print("\(err.errorName)")

        case .noReaderSession:
            // There's no active session. Most likely the app hasn't called
            // `prepare()` upon returning from background; call `prepare()` to fix this issue.
            print("\(err.errorName)")

        case .readNotAllowed:
            /// Your app isn't allowed to call `read()` API. Check the app's entitlements.
            print("\(err.errorName)")

        case .readNotAllowedDuringCall:
            /// The framework doesn't allow the read operations while voice calls are in progress.
            print("\(err.errorName)")

        default:
            print("\(err.errorName)")
        }
    }


    // MARK: - Update display functions

    @MainActor private func displayReadResultOrError() {

        var authStatus = ""
        var vasStatus = ""
        var vasShow = false
        var paymentShow = false
        var trxStatus = ""
        var trxResult = "Unexpected result"
        var errorThrown = false

        if let err = self.currentReadError {
            trxStatus = "❌: \(err.errorName)"
            trxResult = "Transaction not completed\n\n\(err.errorDescription)"
            errorThrown = true
        } else {

            if let authResult = self.currentAuthResult {
                authStatus = (authResult.status == "APPROVED") ? "APPROVED ✅" : "DECLINED 🛑"

                let amount = self.formattedAmount(authResult.amount) ?? "0.00"
                trxResult =
                    """
                    approvedAmount: $ \(amount)
                    transactionId: \(authResult.transactionId)
                    """
                activity?.report("\(authStatus)", tid: authResult.transactionId)
                paymentShow = true
            }

            if !self.formattedVasResultString.isEmpty {
                vasStatus = "VAS ✅"
                vasShow = true
            }
        }

        if errorThrown {
            self.trxStatus = trxStatus
        } else {
            if authStatus.isEmpty && vasStatus.isEmpty {
                self.trxStatus = "❌ The vas/payment is empty."
            } else if authStatus.isEmpty {
                self.trxStatus = "\(vasStatus)"
            } else {
                self.trxStatus = "\(authStatus) | \(vasStatus)"
            }
        }

        self.vasShow = vasShow
        self.paymentShow = paymentShow
        self.trxResult = trxResult

        self.trxShow = true

    }


    private func makeReader() -> PaymentCardReader {
        let vasMerchants: [VASRequest.Merchant] = [VASRequest.Merchant(id: "pass.com.example.test1",
                                                                       url: URL(string: "com.example.test1")!,
                                                                       localizedName: "Loyalty Program")]
        let options = PaymentCardReader.Options(vasMerchants: vasMerchants)
        let reader = PaymentCardReader(options: options)

        if #available(iOS 16.0, *) {
            // The reader events aysnc stream is owned by the `PaymentCardReader`
            // object. The app must not hold a strong reference to the
            // `reader.events` member, nor should the application attempt to
            // cancel the Task that event stream is waiting on.
            //
            // If the app manually cancels Task, the event stream ends and the
            // read no longer receives any events. In order to resume receiving
            // events, you need to create a new reader and subscribe to the new
            // events on the new reader.
            //
            // When the reader object (which owns the events) is destroyed,
            // the event stream automatically ends and Task exits normally.

            let events = reader.events
            Task { @MainActor [weak self] in
                for await event in events {
                    switch event {
                    case .updateProgress(let value):
                        print("Progress: \(value)%")
                        self?.status = "CONFIGURING - \(value)%"
                    case .notReady:
                        print("Reader not ready.")
                        self?.handlePaymentCardReaderError(PaymentCardReaderError.notReady)
                    default:
                        self?.reportEvent(event)
                    }
                }
                print("Event stream: ended.")
            }
        }
        return reader
    }

    @available(iOS 16.0, *)
    private func reportEvent(_ event: PaymentCardReader.Event) {
        print("Event stream: \(event.name).")
        activity?.report(event.name)
    }

    private func reset() {
        cleanup()
        self.statusOK = false
        self.status = "Not Ready"
    }

    private func formattedAmount(_ amount: Decimal) -> String? {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: amount as NSDecimalNumber)
    }

    private func formatVasResults(_ entries: [VASReadResult.ReadEntry]) -> String {

        if entries.isEmpty {
            return "No Vas Data"
        }

        var vasResults = ""
        for entry in entries {
            vasResults.append("merchantId: \(entry.id)\n")
            if let data = entry.customerVASData {
                vasResults.append("customerVASIdentifier: \(data)\n\n")
            } else {
                vasResults.append("Data not found\n\n")
            }
        }
        return vasResults
    }

}
#endif
