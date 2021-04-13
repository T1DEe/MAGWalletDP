//
//  BTCAuthServiceImp.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

class BTCAuthServiceImp: BTCAuthService {
    var btcCoreComponent: BTCCoreComponent!
    var storageService: PublicDataService!
    var currentNetwork: BTCNetworkType!
    
    var hasWallets: Bool {
        guard let wallets = try? loadWalletsForNetwork() else {
            return false
        }
        return !wallets.isEmpty
    }
    
    func getSeed() throws -> String {
        do {
            let seed = try btcCoreComponent.generateSeed()
            return seed.joined(separator: " ")
        } catch {
            throw BTCWalletAuthError.invalidSeed
        }
    }
    
    func verifySeed(_ seed: String) -> Bool {
        let seed = seed.components(separatedBy: " ")
        let isValid = btcCoreComponent.verifySeed(seed)
        return isValid
    }
    
    func obtainPrivateKey(seed: String) throws -> String {
        let seed = seed.components(separatedBy: " ")
        do {
            let privateKey = try btcCoreComponent.getPrivateKey(seed: seed, networkType: currentNetwork)
            return privateKey
        } catch {
            throw BTCWalletAuthError.invalidKey
        }
    }
    
    func createWallet(seed: String) throws -> BTCWallet {
        let seed = seed.components(separatedBy: " ")
        do {
            let address = try btcCoreComponent.getAddress(seed: seed, networkType: currentNetwork)
            let wallet = BTCWallet(address: address, network: currentNetwork)
            return wallet
        } catch {
            throw BTCWalletAuthError.invalidSeed
        }
    }
    
    func getWallets() throws -> [BTCWallet] {
        return try loadWalletsForNetwork()
    }
    
    func getAllWallets() throws -> [BTCWallet] {
        return try loadWallets()
    }
    
    func getCurrentWallet() throws -> BTCWallet {
        let wallets = try loadWalletsForNetwork()
        if let selectesWallet = wallets.first(where: { $0.isCurrent }) {
            return selectesWallet
        }
        
        if let firstWallet = wallets.first {
            return firstWallet
        }
        
        throw BTCWalletAuthError.walletDoesntExist
    }
    
    func isWalletExist(_ wallet: BTCWallet) -> Bool {
        return isWalletAdded(wallet)
    }
    
    func saveWallet(_ wallet: BTCWallet, makeCurrent: Bool) throws {
        guard !isWalletAdded(wallet) else {
            throw BTCWalletAuthError.alreadyExist
        }
        
        wallet.isCurrent = makeCurrent
        
        if var wallets = try? loadWallets() {
            if makeCurrent {
                wallets.forEach { $0.isCurrent = false }
            }
            wallets.append(wallet)
            try saveWallets(wallets)
        } else {
            try saveWallets([wallet])
        }
    }
    
    func selectWallet(_ wallet: BTCWallet) throws {
        let wallets = try loadWallets()
        guard isWalletAdded(wallet) else {
            throw BTCWalletAuthError.walletDoesntExist
        }
        
        wallets.forEach { $0.isCurrent = $0 == wallet }
        try saveWallets(wallets)
    }
    
    func deleteWallet(_ wallet: BTCWallet) throws {
        var wallets = try loadWallets()
        guard isWalletAdded(wallet) else {
            throw BTCWalletAuthError.walletDoesntExist
        }
        
        wallets.removeAll { $0 == wallet }
        if wallet.isCurrent {
            wallets.first?.isCurrent = true
        }
        try saveWallets(wallets)
    }
    
    func clear() throws {
        do {
            try storageService.removePublicData(key: Constants.AuthConstants.savedWalletsKey)
        } catch {
            throw BTCWalletAuthError.walletDoesntExist
        }
    }
    
    // MARK: - Private
    
    private func isWalletAdded(_ wallet: BTCWallet) -> Bool {
        guard let savedWallets = try? loadWallets() else {
            return false
        }
        
        return savedWallets.contains(wallet)
    }
    
    private func saveWallets(_ wallets: [BTCWallet]) throws {
        try storageService.setPublicData(key: Constants.AuthConstants.savedWalletsKey, data: wallets)
    }
    
    private func loadWallets() throws -> [BTCWallet] {
        guard let wallets = try? storageService.obtainPublicData(key: Constants.AuthConstants.savedWalletsKey, type: [BTCWallet].self) else {
            throw BTCWalletAuthError.walletDoesntExist
        }
        return wallets
    }
    
    private func loadWalletsForNetwork() throws -> [BTCWallet] {
        do {
            let wallets = try loadWallets()
            return wallets.filter { $0.network == currentNetwork }
        } catch let error {
            throw error
        }
    }
}

extension BTCAuthServiceImp: BTCNetworkConfigurable {
    func configure(with networkAdapter: BTCNetworkAdapter) {
        // Not used
    }
    
    func configure(with networkType: BTCNetworkType) {
        currentNetwork = networkType
    }
}
