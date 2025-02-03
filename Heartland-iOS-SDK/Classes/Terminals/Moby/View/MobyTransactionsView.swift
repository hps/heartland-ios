//
//  MobyTransactionsView.swift
//  Heartland-iOS-SDK
//
//  Created by Renato Santos on 05/09/2024.
//

import SwiftUI

@available(iOS 16.0, *)
private struct MobyTransactionsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    
    private init() {
    
    }
    
    @State private var clientTransaction: String = String.empty
    @State private var terminalReferenceNumber: String = String.empty
    @State private var amount: String = "10.00"
    @State private var gratuityAmount: String = "0.00"
    @State private var invoiceNumber: String = String.empty
    
    @State private var allowDuplicates = false
    @State private var allowPartialAuth = false
    @State private var enableSurcharge = false
    
    @State private var isTransactioning = false
    @State private var showMessage: Bool = false
    @State private var status: String = String.empty
    @State private var image: UIImage?
    @State private var showReceiptDialog: Bool = false
    
    private var uiImage = UIImage(named: "Moby5500")
    
    private func initScreen() {
        isTransactioning = false
        invoiceNumber = String.empty
        clientTransaction = String.empty
        amount = "10.00"
        gratuityAmount = "0.00"
    }
    
    @available(iOS 16.0, *)
    public var body: some View {
        // OVERLAY RECEIPT
        
        VStack {
            if self.isTransactioning {
                ZStack {
                    VStack {
                        Text(self.status)
                            .font(.largeTitle)
                        
                        ProgressView()
                            .foregroundColor(.green)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                .background(Color.black.opacity(0.7))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            } else {
                if self.showReceiptDialog, let image = self.image {
                    
                    ZStack {
                        
                        VStack {
                            Divider()
                            HStack {
                                Button("") {
                                    
                                }
                                Spacer()
                                Text("Receipt")
                                Spacer()
                                Button("Close") {
                                    self.showReceiptDialog = false
                                }
                            }
                            Divider()
                            
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 300, height: 500)
                                .aspectRatio(contentMode: .fit)
                            
                        }
                        .frame(width: 500, height: 500)
                        .padding(16)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(.black)
                    .opacity(0.5)
                    
                    Divider()
                }
                else {
                    Text("Moby Transaction")
                        .font(.title)
                        .bold()
                    
                    Divider()
                    
                    ScrollView {
                        VStack {
                            Text("Client Transaction")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            TextField(.init("Client Transaction - OPTIONAL"), text: $clientTransaction)
                                .textContentType(.name)
                                .keyboardType(.default)
                                .padding(.vertical, 8)
                            
                            Text("Amount")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            TextField(.init("Amount"), text: $amount)
                                .textContentType(.creditCardNumber)
                                .keyboardType(.decimalPad)
                                .padding(.vertical, 8)
                            
                            Text("Gratuity Amount")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            TextField(.init("Gratuity Amount - OPTIONAL"), text: $gratuityAmount)
                                .textContentType(.creditCardNumber)
                                .keyboardType(.decimalPad)
                                .padding(.vertical, 8)
                            
                            Text("Invoice Number")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            TextField(.init("Invoice Number - OPTIONAL"), text: $invoiceNumber)
                                .textContentType(.creditCardNumber)
                                .keyboardType(.numberPad)
                                .padding(.vertical, 8)
                            
                            HStack {
                                
                                Toggle("Allow duplicates", isOn: $allowDuplicates)
                                    .frame(maxWidth: 250, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            
                            HStack {
                                
                                Toggle("Allow Partial Auth", isOn: $allowPartialAuth)
                                    .frame(maxWidth: 250, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            
                            
                            HStack {
                                
                                Toggle("Enable Surcharge", isOn: $enableSurcharge)
                                    .frame(maxWidth: 250, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                    .disabled(true)
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            
                            Divider()
                            
                            Button {
                                self.initScreen()
                            } label: {
                                Text("Reset Screen")
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 4)
                            .frame(height: 50)
                            .disabled(isTransactioning)
                            
                            Divider()
                            
                            Button {
                                guard let device = RUAHelper.sharedInstance.mobyDevice else {
                                    print("NO DEVICE CONNECTED")
                                    return
                                }
                                
                                let builder = HpsMobyCreditSaleBuilder(device: device)
                                builder.amount = NSDecimalNumber(string: amount)
                                builder.allowPartialAuth = NSNumber(value: allowPartialAuth)
                                builder.cpcReq = true
                                builder.isSurchargeEnabled = false
                                builder.allowDuplicates = NSNumber(value: self.allowDuplicates)
                                RUAHelper.sharedInstance.mainTransaction = .credit
                                isTransactioning = true
                                builder.execute()
                            } label: {
                                Text("Credit Sale")
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 4)
                            .frame(height: 50)
                            .disabled(isTransactioning)
                            
                            Button {
                                // PERFORM CREDIT ADJUST
                                guard let device = RUAHelper.sharedInstance.mobyDevice else {
                                    print("NO DEVICE CONNECTED")
                                    return
                                }
                                let amountString = NSDecimalNumber(string: amount)
                                let builder = HpsMobyCreditAdjustBuilder(device: device)
                                builder.amount = amountString
                                
                                let gratuity = NSDecimalNumber(string: gratuityAmount)
                                builder.gratuity = gratuity
                                
                                builder.allowPartialAuth = NSNumber(value: allowPartialAuth)
                                builder.transactionId = clientTransaction
                                builder.referenceNumber = self.terminalReferenceNumber
                                RUAHelper.sharedInstance.mainTransaction = .credit
                                isTransactioning = true
                                builder.execute()
                            } label: {
                                Text("Credit Adjust")
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 4)
                            .frame(height: 50)
                            .disabled(isTransactioning)
                            
                            Button {
                                guard let device = RUAHelper.sharedInstance.mobyDevice else {
                                    print("NO DEVICE CONNECTED")
                                    return
                                }
                                let amountString = NSDecimalNumber(string: amount)
                                let builder = HpsMobyCreditAuthBuilder(device: device)
                                builder.amount = amountString
                                
                                builder.allowPartialAuth = NSNumber(value: allowPartialAuth)
                                builder.allowDuplicates = NSNumber(value: self.allowDuplicates)
                                builder.isSurchargeEnabled = false
                                RUAHelper.sharedInstance.mainTransaction = .auth
                                isTransactioning = true
                                builder.execute()
                            } label: {
                                Text("Credit Auth")
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 4)
                            .frame(height: 50)
                            .disabled(isTransactioning)
                            
                            Button {
                                // PERFORM CREDIT CAPTURE
                                guard let device = RUAHelper.sharedInstance.mobyDevice else {
                                    print("NO DEVICE CONNECTED")
                                    return
                                }
                                let amountString = NSDecimalNumber(string: amount)
                                let builder = HpsMobyCreditCaptureBuilder(device: device)
                                builder.amount = amountString
                                
                                builder.allowPartialAuth = NSNumber(value: allowPartialAuth)
                                builder.allowDuplicates = NSNumber(value: self.allowDuplicates)
                                builder.isSurchargeEnabled = false
                                builder.transactionId = clientTransaction
                                builder.referenceNumber = self.terminalReferenceNumber
                                RUAHelper.sharedInstance.mainTransaction = .capture
                                isTransactioning = true
                                builder.execute()
                            } label: {
                                Text("Credit Capture")
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 4)
                            .frame(height: 50)
                            .disabled(isTransactioning)
                            
                            Button {
                                // PERFORM CREDIT RETURN
                                guard let device = RUAHelper.sharedInstance.mobyDevice else {
                                    print("NO DEVICE CONNECTED")
                                    return
                                }
                                let amountString = NSDecimalNumber(string: amount)
                                let builder = HpsMobyCreditReturnBuilder(device: device)
                                builder.amount = amountString
                                builder.allowPartialAuth = NSNumber(value: allowPartialAuth)
                                builder.transactionId = clientTransaction
                                isTransactioning = true
                                builder.execute()
                            } label: {
                                Text("Credit Return")
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 4)
                            .frame(height: 50)
                            .disabled(isTransactioning)
                            
                            Button {
                                // PERFORM CREDIT REVERSAL
                                guard let device = RUAHelper.sharedInstance.mobyDevice else {
                                    print("NO DEVICE CONNECTED")
                                    return
                                }
                                let amountString = NSDecimalNumber(string: amount)
                                let builder = HpsMobyCreditReversalBuilder(device: device)
                                builder.amount = amountString
                                builder.allowPartialAuth = NSNumber(value: allowPartialAuth)
                                builder.transactionId = clientTransaction
                                isTransactioning = true
                                builder.execute()
                                
                            } label: {
                                Text("Credit Reversal")
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 4)
                            .frame(height: 50)
                            .disabled(isTransactioning)
                            
                            
                            
                            Button {
                                // PERFORM CREDIT VOID
                                guard let device = RUAHelper.sharedInstance.mobyDevice else {
                                    print("NO DEVICE CONNECTED")
                                    return
                                }
                                let builder = HpsMobyCreditVoidBuilder(device: device)
                                builder.transactionId = clientTransaction
                                isTransactioning = true
                                builder.execute()
                            } label: {
                                Text("Credit Void")
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 4)
                            .frame(height: 50)
                            .disabled(isTransactioning)
                            
                            Button {
                                // PERFORM BATCH CLOSE
                                guard let device = RUAHelper.sharedInstance.mobyDevice else {
                                    print("NO DEVICE CONNECTED")
                                    return
                                }
                                let builder = HpsMobyBatchCloseBuilder(device: device)
                                isTransactioning = true
                                builder.execute()
                            } label: {
                                Text("Batch Close")
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 4)
                            .frame(height: 50)
                            .disabled(isTransactioning)
                            
                            Button {
                                // PERFORM GIFT CARD
                            } label: {
                                Text("Gift Card")
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 4)
                            .frame(height: 50)
                            .disabled(isTransactioning)
                            
                            Button {
                                // PERFORM UPLOAD SAF
                            } label: {
                                Text("Upload SAF")
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 4)
                            .frame(height: 50)
                            .disabled(isTransactioning)
                            
                            Button {
                                // PERFORM FORCE SAF
                            } label: {
                                Text("Force SAF: Off")
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 4)
                            .frame(height: 50)
                            .disabled(isTransactioning)
                            
                            Button {
                                // PERFORM CANCEL
                                self.presentationMode.wrappedValue.dismiss()
                            } label: {
                                Text("Cancel")
                                    .font(.title)
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 4)
                            .frame(height: 50)
                            .foregroundColor(.red)
                            .disabled(isTransactioning)
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        Spacer()
                    }
                }
            }
        }
        .padding(16)
        .onReceive(RUAHelper.sharedInstance.$transactionId) { value in
            guard let value = value else { return }
            self.clientTransaction = value
        }
        .onReceive(RUAHelper.sharedInstance.$terminalRefNumber) { referenceNumber in
            guard let referenceNumber = referenceNumber else { return }
            self.terminalReferenceNumber = referenceNumber
        }
        .onReceive(RUAHelper.sharedInstance.$showMessage, perform: { action in
            self.showMessage = action
        })
        .onReceive(RUAHelper.sharedInstance.$isProcessing, perform: { isProcessing in
            self.isTransactioning = isProcessing
        })
        .onReceive(RUAHelper.sharedInstance.$status, perform: { status in
            self.status = status
        })
        .alert(
            Text(RUAHelper.sharedInstance.success ? "Success" : "Failure"),
            isPresented: $showMessage
        ) {
            VStack {
                Button("Got it!") {
                    self.showMessage = false
                }
                if let image = self.image {
                    Button("Print Receipt") {
                        self.showReceiptDialog = true
                    }
                }
            }
        } message: {
            VStack {
                Text(RUAHelper.sharedInstance.message)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        .onReceive(RUAHelper.sharedInstance.$receiptImage, perform: { image in
            self.image = image
        })
    }
}

//@available(iOS 16.0, *)
//#Preview {
//    MobyTransactionsView()
//}
