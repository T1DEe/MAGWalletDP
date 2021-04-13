//
//  BTCAuthService.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

enum BTCWalletAuthError: Error {
    case walletDoesntExist
    case alreadyExist
    case invalidSeed
    case invalidKey
}

protocol BTCAuthService: BTCNetworkConfigurable {
    var hasWallets: Bool { get }
    
    func getSeed() throws -> String
    func verifySeed(_ seed: String) -> Bool
    func obtainPrivateKey(seed: String) throws -> String
    func createWallet(seed: String) throws -> BTCWallet
    func getWallets() throws -> [BTCWallet]
    func getAllWallets() throws -> [BTCWallet]
    func getCurrentWallet() throws -> BTCWallet
    func isWalletExist(_ wallet: BTCWallet) -> Bool
    func saveWallet(_ wallet: BTCWallet, makeCurrent: Bool) throws
    func selectWallet(_ wallet: BTCWallet) throws
    func deleteWallet(_ wallet: BTCWallet) throws
    func clear() throws
}
