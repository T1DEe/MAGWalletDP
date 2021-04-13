//
//  ETHAuthFacade.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule

enum ETHWalletAuthError: Swift.Error, Equatable {
    /// Indicates that removed wallet doesnt exist
    case walletDoesntExist
    
    /// Indicates that added wallet already exist
    case alreadyExist
    
    /// Indicates that seed is not correct
    case invalidSeed
    
    /// Indicates that data is not correct
    case invalidData
}

/// Typealias for closure with result and error for Auth
typealias ETHAuthCompletionHndler<T> = (_ result: Result<T, ETHWalletAuthError>) -> Void

protocol ETHAuthService: ETHNetworkConfigurable, Clearable {
    //indicate is there at least one wallet stored
    var hasWallets: Bool { get }

    //get all wallets if exists
    func getWallets() throws -> [ETHWallet]
    func getAllWallets() throws -> [ETHWallet]
    
    //get current wallet if exists
    func getCurrentWallet() throws -> ETHWallet
    
    func isWalletExist(_ wallet: ETHWallet) -> Bool
    func saveWallet(_ wallet: ETHWallet, makeCurrent: Bool) throws
    func selectWallet(_ wallet: ETHWallet) throws
    func deleteWallet(_ wallet: ETHWallet) throws

    //get new seed for registration wallet
    func getSeed() -> String
    
    //indicate seed is right
    func verifySeed(_ seed: String) -> Bool
    
    //returns private key from seed
    func obtainPrivateKey(seed: String) throws -> String
    
    //add new wallet with seed
    func createWallet(seed: String) throws -> ETHWallet 
}
