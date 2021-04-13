//
//  BTCCoreComponent.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

protocol BTCCoreComponent {
    func generateSeed() throws -> [String]
    func generateKey(seed: [String], networkType: BTCNetworkType) throws -> BTCKey
    func verifySeed(_ seed: [String]) -> Bool
    func getAddress(seed: [String], networkType: BTCNetworkType) throws -> String
    func getPrivateKey(seed: [String], networkType: BTCNetworkType) throws -> String
    func getPrivateKeyData(seed: [String], networkType: BTCNetworkType) throws -> Data
    
    func calculateTransactionFee(
        amount: Int,
        feePerKb: Int,
        unspentOutputs: [BTCTransactionOutput],
        networkType: BTCNetworkType
    ) throws -> Int
    
    func createTransaction(
        privateKey: BTCKey,
        outputs: [BTCTransactionOutput],
        changeAddress: BTCAddress,
        toAddress: BTCAddress,
        value: BTCAmount,
        fee: BTCAmount,
        checkSignature: Bool
    ) throws -> BTCTransaction?
    
    func getTransactionHex(transaction: BTCTransaction) -> String?
}
