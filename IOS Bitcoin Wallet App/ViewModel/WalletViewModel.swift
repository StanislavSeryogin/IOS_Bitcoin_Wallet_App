//
//  WalletViewModel.swift
//  IOS Bitcoin Wallet App
//
//  Created by Stanislav Seryogin on 14.09.2023.
//

import SwiftUI
import BitcoinKit
import BitcoinCore
import HdWalletKit

class WalletViewModel: ObservableObject {
    @Published var receiveAddress: String = ""
    @Published var balance: String = ""
    @Published var lastBlockInfo: String = ""
    
    var bitcoinKit: BitcoinKit.Kit?
    
    init() {
        setupBitcoinKit()
    }
    
    func setupBitcoinKit() {
        let words = ["mnemonic", "phrase", "words"]
        let passphrase: String = ""
        let seed = Mnemonic.seed(mnemonic: words, passphrase: passphrase)!
        
        do {
            bitcoinKit = try BitcoinKit.Kit(
                seed: seed,
                purpose: .bip84,
                walletId: "unique_wallet_id",
                syncMode: .full,
                networkType: .testNet, 
                confirmationsThreshold: 3,
                logger: nil
            )
            
            bitcoinKit?.delegate = self
            bitcoinKit?.start()
            
            receiveAddress = bitcoinKit?.receiveAddress() ?? "Error Generating Address"
            
        } catch {
            print("Error setting up BitcoinKit: \(error)")
        }
    }
    
    func refreshBalance() {
        guard let bitcoinKit = bitcoinKit else {
            print("BitcoinKit not initialized!")
            return
        }
        
        let currentBalance = bitcoinKit.balance
        DispatchQueue.main.async {
            self.balance = "\(currentBalance) satoshis"
        }
    }

    
    func sendTransaction() {
        refreshBalance()
    }
}

extension WalletViewModel: BitcoinCoreDelegate {
    
    private func balanceUpdated(balance: Int) {
        DispatchQueue.main.async {
            self.balance = "\(balance) satoshis"
        }
    }
    
    func lastBlockInfoUpdated(lastBlockInfo: BlockInfo) {
        DispatchQueue.main.async {
            self.lastBlockInfo = "Height: \(lastBlockInfo.height), Timestamp: \(String(describing: lastBlockInfo.timestamp))"
        }
    }
}
