//
//  LTCAuthServiceImp.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

class LTCAuthServiceImp: LTCAuthService {
    var ltcCoreComponent: LTCCoreComponent!
    var storageService: PublicDataService!
    var currentNetwork: LTCNetworkType!
    
    var hasWallets: Bool {
        guard let wallets = try? loadWalletsForNetwork() else {
            return false
        }
        return !wallets.isEmpty
    }
    
    func getSeed() throws -> String {
        do {
            let seed = try ltcCoreComponent.generateSeed()
            return seed.joined(separator: " ")
        } catch {
            throw LTCWalletAuthError.invalidSeed
        }
    }
    
    func verifySeed(_ seed: String) -> Bool {
        let seed = seed.components(separatedBy: " ")
        let isValid = ltcCoreComponent.verifySeed(seed)
        return isValid
    }
    
    func obtainPrivateKey(seed: String) throws -> String {
        let seed = seed.components(separatedBy: " ")
        do {
            let privateKey = try ltcCoreComponent.getPrivateKey(seed: seed, networkType: currentNetwork)
            return privateKey
        } catch {
            throw LTCWalletAuthError.invalidKey
        }
    }
    
    func createWallet(seed: String) throws -> LTCWallet {
        let seed = seed.components(separatedBy: " ")
        do {
            let address = try ltcCoreComponent.getAddress(seed: seed, networkType: currentNetwork)
            let wallet = LTCWallet(address: address, network: currentNetwork)
            return wallet
        } catch {
            throw LTCWalletAuthError.invalidSeed
        }
    }
    
    func getWallets() throws -> [LTCWallet] {
        return try loadWalletsForNetwork()
    }
    
    func getAllWallets() throws -> [LTCWallet] {
        return try loadWallets()
    }
    
    func getCurrentWallet() throws -> LTCWallet {
        let wallets = try loadWalletsForNetwork()
        if let selectesWallet = wallets.first(where: { $0.isCurrent }) {
            return selectesWallet
        }
        
        if let firstWallet = wallets.first {
            return firstWallet
        }
        
        throw LTCWalletAuthError.walletDoesntExist
    }
    
    func isWalletExist(_ wallet: LTCWallet) -> Bool {
        return isWalletAdded(wallet)
    }
    
    func saveWallet(_ wallet: LTCWallet, makeCurrent: Bool) throws {
        guard !isWalletAdded(wallet) else {
            throw LTCWalletAuthError.alreadyExist
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
    
    func selectWallet(_ wallet: LTCWallet) throws {
        let wallets = try loadWallets()
        guard isWalletAdded(wallet) else {
            throw LTCWalletAuthError.walletDoesntExist
        }
        
        wallets.forEach { $0.isCurrent = $0 == wallet }
        try saveWallets(wallets)
    }
    
    func deleteWallet(_ wallet: LTCWallet) throws {
        var wallets = try loadWallets()
        guard isWalletAdded(wallet) else {
            throw LTCWalletAuthError.walletDoesntExist
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
            throw LTCWalletAuthError.walletDoesntExist
        }
    }
    
    // MARK: - Private
    
    private func isWalletAdded(_ wallet: LTCWallet) -> Bool {
        guard let savedWallets = try? loadWallets() else {
            return false
        }
        
        return savedWallets.contains(wallet)
    }
    
    private func saveWallets(_ wallets: [LTCWallet]) throws {
        try storageService.setPublicData(key: Constants.AuthConstants.savedWalletsKey, data: wallets)
    }
    
    private func loadWallets() throws -> [LTCWallet] {
        guard let wallets = try? storageService.obtainPublicData(key: Constants.AuthConstants.savedWalletsKey, type: [LTCWallet].self) else {
            throw LTCWalletAuthError.walletDoesntExist
        }
        return wallets
    }
    
    private func loadWalletsForNetwork() throws -> [LTCWallet] {
        do {
            let wallets = try loadWallets()
            return wallets.filter { $0.network == currentNetwork }
        } catch let error {
            throw error
        }
    }
}

extension LTCAuthServiceImp: LTCNetworkConfigurable {
    func configure(with networkAdapter: LTCNetworkAdapter) {
        // Not used
    }
    
    func configure(with networkType: LTCNetworkType) {
        currentNetwork = networkType
    }
}
