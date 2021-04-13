//
//  LTCAuthService.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

enum LTCWalletAuthError: Error {
    case walletDoesntExist
    case alreadyExist
    case invalidSeed
    case invalidKey
}

protocol LTCAuthService: LTCNetworkConfigurable {
    var hasWallets: Bool { get }
    
    func getSeed() throws -> String
    func verifySeed(_ seed: String) -> Bool
    func obtainPrivateKey(seed: String) throws -> String
    func createWallet(seed: String) throws -> LTCWallet
    func getWallets() throws -> [LTCWallet]
    func getAllWallets() throws -> [LTCWallet]
    func getCurrentWallet() throws -> LTCWallet
    func isWalletExist(_ wallet: LTCWallet) -> Bool
    func saveWallet(_ wallet: LTCWallet, makeCurrent: Bool) throws
    func selectWallet(_ wallet: LTCWallet) throws
    func deleteWallet(_ wallet: LTCWallet) throws
    func clear() throws
}
