//
//
//  TapOnPhoneView.swift
//  Heartland-iOS-SDK
//


import SwiftUI

struct TapToPayView: View {
    @StateObject var model: TapToPayViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack(alignment: .firstTextBaseline) {
                        Label("Transaction: ", systemImage: "creditcard")
                            .font(.headline)
                        Spacer()
                        Picker("", selection: $model.transactionTypePicker) {
                            ForEach(TTPTransactionType.allCases) { type in
                                Text(type.name).tag(type)
                                    .foregroundColor(.blue)
                            }
                        }
                        .foregroundColor(.blue)
                    }
                }
                
                Section {
                    HStack(alignment: .center) {
                        CurrencyAmount(title: "", amount: $model.amount)
                            .font(.system(size: 36))
                            .padding(20)
                            .frame(height: 100)
                    }
                }
                
                Section {
                    HStack(alignment: .center) {

                        Button(action: {
                            //Reader will be executed from Model
                        }, label: {
                            Text("Request Payment")
                                .foregroundColor(.green)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .font(.body)
                        })
                        .frame(alignment: .trailing)

                    }
                    .padding(.top, 2)
                }
            }
        }
    }
}

struct TapToPayView_Previews: PreviewProvider {
    static var previews: some View {
        TapToPayView(model: TapToPayViewModel())
    }
}

struct CurrencyAmount: View {
    let title: String
    @Binding var amount: Decimal
    let prompt: String = ""
    
    var body: some View {
        TextField(
            title,
            value: $amount,
            format: .currency(code: "USD"),
            prompt: Text(prompt))
        .multilineTextAlignment(.center)
    }
}
