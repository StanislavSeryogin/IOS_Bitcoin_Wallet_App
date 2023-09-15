//
//  ContentView.swift
//  IOS Bitcoin Wallet App
//
//  Created by Stanislav Seryogin on 14.09.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = WalletViewModel()
    @State var recipientAddress: String = ""
    @State var sendAmount: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Bitcoin Address")
                .font(.headline)
            
            HStack {
                Text(viewModel.receiveAddress)
                    .padding(.all, 10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                Button(action: {
                    UIPasteboard.general.string = viewModel.receiveAddress
                }) {
                    Image(systemName: "doc.on.doc")
                }
                .buttonStyle(BorderlessButtonStyle())
                .accessibility(label: Text("Copy Address"))
            }
            
            TextField("Recipient Address", text: $recipientAddress)
            TextField("Amount", text: $sendAmount)

            Text("Balance: \(viewModel.balance)")
            Text("Balance: \(viewModel.lastBlockInfo)")



            
            Button(action: {
                viewModel.refreshBalance() 
            }) {
                Text("Refresh")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            Button(action: viewModel.sendTransaction) {
                Text("Send")
            }


        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
