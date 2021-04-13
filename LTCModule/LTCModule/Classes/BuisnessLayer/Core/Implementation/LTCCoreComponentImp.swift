//
//  LTCCoreComponentImp.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

enum LTCCoreError: Error {
    case wrongWords
    case keychainError
    case seedGenerationError
    case wrongKey
    case addressGeneration
    case transactionGenerating
    case keychainGeneration
}

class LTCCoreComponentImp: LTCCoreComponent {
    func generateSeed() throws -> [String] {
        guard let randomData = LTCCreateRandomBytesOfLength(16)  else {
            throw LTCCoreError.seedGenerationError
        }
        
        let entropy = Data(bytesNoCopy: randomData, count: 16, deallocator: .free)
        guard let mnemonic = LTCMnemonic(entropy: entropy, password: nil, wordListType: .english) else {
            throw LTCCoreError.wrongWords
        }
        guard let seed = mnemonic.words as? [String] else {
            throw LTCCoreError.wrongWords
        }
        
        mnemonic.clear()
        
        return seed
    }
    
    func generateKey(seed: [String], networkType: LTCNetworkType) throws -> LTCKey {
        guard let mnemonic = LTCMnemonic(words: seed, password: nil, wordListType: .unknown) else {
            throw LTCCoreError.wrongWords
        }
        
        var path: String
        switch networkType {
        case .mainnet:
            path = Constants.LTCConstants.LTCDerivationPathMainnet
            
        case .testnet:
            path = Constants.LTCConstants.LTCDerivationPathTestnet
        }
        
        guard let keychain = mnemonic.keychain.derivedKeychain(withPath: path),
            let key = keychain.key else {
                throw LTCCoreError.keychainError
        }
        
        mnemonic.clear()
        keychain.clear()
        
        return key
    }
    
    func verifySeed(_ seed: [String]) -> Bool {
        if let _ = LTCMnemonic(words: seed, password: nil, wordListType: .unknown) {
            return true
        }
        return false
    }
    
    func getAddress(seed: [String], networkType: LTCNetworkType) throws -> String {
        let key = try generateKey(seed: seed, networkType: networkType)

        var address: String
        switch networkType {
        case .mainnet:
            address = key.address.string
            
        case .testnet:
            address = key.addressTestnet.string
        }
        
        key.clear()
        
        return address
    }
    
    func getPrivateKey(seed: [String], networkType: LTCNetworkType) throws -> String {
        let key = try generateKey(seed: seed, networkType: networkType)
        
        let privateKey = key.privateKey.hex()
        key.clear()
        
        if let privateKey = privateKey {
            return privateKey
        }
        
        throw LTCCoreError.keychainGeneration
    }
    
    func getPrivateKeyData(seed: [String], networkType: LTCNetworkType) throws -> Data {
        let key = try generateKey(seed: seed, networkType: networkType)
        
        let privateKeyNSData = key.privateKey
        key.clear()
        
        guard let privateKeyData = privateKeyNSData as Data? else {
            throw LTCCoreError.keychainError
        }
        
        return privateKeyData
    }
    
    func calculateTransactionFee(
        amount: Int,
        feePerKb: Int,
        unspentOutputs: [LTCTransactionOutput],
        networkType: LTCNetworkType
    ) throws -> Int {
        let randomFromSeed = try generateSeed()
        let fromAddressString = try getAddress(seed: randomFromSeed, networkType: networkType)
        let randomToSeed = try generateSeed()
        let toAddressString = try getAddress(seed: randomToSeed, networkType: networkType)
        
        guard let toAddress = LTCAddress(string: toAddressString),
            let fromAddress = LTCAddress(string: fromAddressString) else {
                throw LTCCoreError.addressGeneration
        }
        
        let privateKey = try generateKey(seed: randomFromSeed, networkType: networkType)
        
        let amount = LTCAmount(amount)
        let feePerKb = LTCAmount(feePerKb)
        var fee = feePerKb
        
        let maxFee = Int(pow(Double(10), Double(Constants.LTCConstants.LTCDecimal)))
        while fee < maxFee {
            let transaction = try? createTransaction(privateKey: privateKey,
                                            outputs: unspentOutputs,
                                            changeAddress: fromAddress,
                                            toAddress: toAddress,
                                            value: amount,
                                            fee: fee,
                                            checkSignature: false)
            
            guard let tx = transaction else {
                return Int(fee)
            }
            
            let validFee = tx.estimatedFee(withRate: feePerKb)
            
            if validFee <= fee {
                fee = validFee
                break
            }
            
            fee += feePerKb
        }
        
        return Int(fee)
    }
    
    func createTransaction(
        privateKey: LTCKey,
        outputs: [LTCTransactionOutput],
        changeAddress: LTCAddress,
        toAddress: LTCAddress,
        value: LTCAmount,
        fee: LTCAmount,
        checkSignature: Bool
    ) throws -> LTCTransaction? {
        let tx = LTCTransaction()
        tx.fee = fee
        
        var spentCoins = LTCAmount(0)
        
        for txOut in outputs {
            let txIn = LTCTransactionInput()
            txIn.previousHash = txOut.transactionHash
            txIn.previousIndex = txOut.index
            txIn.value = txOut.value
            txIn.signatureScript = txOut.script
            
            tx.addInput(txIn)
            spentCoins += txOut.value
        }
        
        let paymentOutput = LTCTransactionOutput(value: LTCAmount(value), address: toAddress)
        tx.addOutput(paymentOutput)
        
        if spentCoins > (value + fee) {
            let changeValue = spentCoins - (value + fee)
            let changeOutput = LTCTransactionOutput(value: changeValue, address: changeAddress)
            tx.addOutput(changeOutput)
        }
        
        for i in 0..<outputs.count {
            let txOut = outputs[i]
            // swiftlint:disable force_cast
            let txIn = tx.inputs[i] as! LTCTransactionInput
            // swiftlint:enable force_cast
            
            guard let hash = try? tx.signatureHash(for: txOut.script, inputIndex: UInt32(i), hashType: ._SIGHASH_ALL) else {
                throw LTCCoreError.transactionGenerating
            }
            
            let sigScript = LTCScript()
            
            let signature = privateKey.signature(forHash: hash)
            var signatureForScript = signature
            let hashTypeData = LTCSignatureHashType._SIGHASH_ALL.rawValue
            var hashType = hashTypeData
            signatureForScript?.append(&hashType, count: 1)
            _ = sigScript?.appendData(signatureForScript)
            _ = sigScript?.appendData(privateKey.publicKey as Data?)
            
            if checkSignature && !privateKey.isValidSignature(signature, hash: hash) {
                throw LTCCoreError.transactionGenerating
            }

            txIn.signatureScript = sigScript
        }
        
        if checkSignature {
            let scriptMachine = LTCScriptMachine(transaction: tx, inputIndex: 0)
            do {
                try scriptMachine?.verify(withOutputScript: outputs[0].script)
            } catch {
                throw LTCCoreError.transactionGenerating
            }

            privateKey.clear()
        }
        
        return tx
    }
    
    func getTransactionHex(transaction: LTCTransaction) -> String? {
        let txHex = transaction.hex
        return txHex
    }
}
