//
//  LTCCoreComponent.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

protocol LTCCoreComponent {
    func generateSeed() throws -> [String]
    func generateKey(seed: [String], networkType: LTCNetworkType) throws -> LTCKey
    func verifySeed(_ seed: [String]) -> Bool
    func getAddress(seed: [String], networkType: LTCNetworkType) throws -> String
    func getPrivateKey(seed: [String], networkType: LTCNetworkType) throws -> String
    func getPrivateKeyData(seed: [String], networkType: LTCNetworkType) throws -> Data
    
    func calculateTransactionFee(
        amount: Int,
        feePerKb: Int,
        unspentOutputs: [LTCTransactionOutput],
        networkType: LTCNetworkType
    ) throws -> Int
    
    func createTransaction(
        privateKey: LTCKey,
        outputs: [LTCTransactionOutput],
        changeAddress: LTCAddress,
        toAddress: LTCAddress,
        value: LTCAmount,
        fee: LTCAmount,
        checkSignature: Bool
    ) throws -> LTCTransaction?
    
    func getTransactionHex(transaction: LTCTransaction) -> String?
}
