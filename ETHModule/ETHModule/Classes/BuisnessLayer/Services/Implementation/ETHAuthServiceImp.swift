//
//  ETHAuthFacadeImp.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule

final class ETHAuthServiceImp: ETHAuthService {
    var ethCoreComponent: ETHCoreComponent!
    var storageService: PublicDataService!
    var currentNetwork: ETHNetworkType!

    var hasWallets: Bool {
        guard let wallets = try? loadWalletsForNetwork() else {
            return false
        }
        return !wallets.isEmpty
    }
    
    func getWallets() throws -> [ETHWallet] {
        return try loadWalletsForNetwork()
    }
    
    func getAllWallets() throws -> [ETHWallet] {
        return try loadWallets()
    }
    
    func getCurrentWallet() throws -> ETHWallet {
        let wallets = try loadWalletsForNetwork()
        if let selectesWallet = wallets.first(where: { $0.isCurrent }) {
            return selectesWallet
        }
        
        if let firstWallet = wallets.first {
            return firstWallet
        }
        
        throw ETHWalletAuthError.walletDoesntExist
    }
    
    func isWalletExist(_ wallet: ETHWallet) -> Bool {
        return isWalletAdded(wallet)
    }
    
    func saveWallet(_ wallet: ETHWallet, makeCurrent: Bool) throws {
        guard !isWalletAdded(wallet) else {
            throw ETHWalletAuthError.alreadyExist
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
    
    func selectWallet(_ wallet: ETHWallet) throws {
        let wallets = try loadWallets()
        guard isWalletAdded(wallet) else {
            throw ETHWalletAuthError.walletDoesntExist
        }
        
        wallets.forEach { $0.isCurrent = $0 == wallet }
        try saveWallets(wallets)
    }
    
    func deleteWallet(_ wallet: ETHWallet) throws {
        var wallets = try loadWallets()
        guard isWalletAdded(wallet) else {
            throw ETHWalletAuthError.walletDoesntExist
        }
        
        wallets.removeAll { $0 == wallet }
        if wallet.isCurrent {
            wallets.first?.isCurrent = true
        }
        try saveWallets(wallets)
    }
    
    func obtainPrivateKey(seed: String) throws -> String {
        let keystore = try ethCoreComponent.createKeystore(seed: seed)
        let address = ethCoreComponent.getAddress(keystore: keystore)
        let privateKey: String = try ethCoreComponent.getPrivateKey(keystore: keystore, address: address)
        return privateKey
    }

    func getSeed() -> String {
        return ethCoreComponent.generateSeed()
    }
    
    func verifySeed(_ seed: String) -> Bool {
        return ethCoreComponent.verifySeed(seed)
    }
    
    func createWallet(seed: String) throws -> ETHWallet {
        guard verifySeed(seed) else {
            throw ETHWalletAuthError.invalidSeed
        }
        
        do {
            let keystore = try ethCoreComponent.createKeystore(seed: seed)
            let address = ethCoreComponent.getAddress(keystore: keystore)
            let wallet = ETHWallet(address: address, network: currentNetwork)
            
            return wallet
        } catch {
            throw ETHWalletAuthError.invalidData
        }
    }
    
    func clear() {
        try? storageService.removePublicData(key: Constants.AuthConstants.savedWalletsKey)
    }
    
    // MARK: Private
    
    private func isWalletAdded(_ wallet: ETHWallet) -> Bool {
        guard let savedWallets = try? loadWallets() else {
            return false
        }
        
        return savedWallets.contains(wallet)
    }
    
    private func saveWallets(_ wallets: [ETHWallet]) throws {
        try storageService.setPublicData(key: Constants.AuthConstants.savedWalletsKey, data: wallets)
    }
    
    private func loadWallets() throws -> [ETHWallet] {
        guard let wallet = try? storageService.obtainPublicData(key: Constants.AuthConstants.savedWalletsKey, type: [ETHWallet].self) else {
            throw ETHWalletAuthError.walletDoesntExist
        }
        return wallet
    }
    
    private func loadWalletsForNetwork() throws -> [ETHWallet] {
        do {
            let wallets = try loadWallets()
            return wallets.filter { $0.network == currentNetwork }
        } catch let error {
            throw error
        }
    }
}

extension ETHAuthServiceImp: ETHNetworkConfigurable {
    func configure(with networkAdapter: ETHNetworkAdapter) {
        // Not used
    }
    func configure(with networkType: ETHNetworkType) {
        currentNetwork = networkType
    }
}
