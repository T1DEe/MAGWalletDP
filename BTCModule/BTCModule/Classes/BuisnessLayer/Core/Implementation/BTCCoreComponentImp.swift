//
//  BTCCoreComponentImp.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

enum BTCCoreError: Error {
    case wrongWords
    case keychainError
    case seedGenerationError
    case wrongKey
    case addressGeneration
    case transactionGenerating
    case keychainGeneration
}

class BTCCoreComponentImp: BTCCoreComponent {
    func generateSeed() throws -> [String] {
        guard let randomData = BTCCreateRandomBytesOfLength(16)  else {
            throw BTCCoreError.seedGenerationError
        }
        
        let entropy = Data(bytesNoCopy: randomData, count: 16, deallocator: .free)
        guard let mnemonic = BTCMnemonic(entropy: entropy, password: nil, wordListType: .english) else {
            throw BTCCoreError.wrongWords
        }
        guard let seed = mnemonic.words as? [String] else {
            throw BTCCoreError.wrongWords
        }
        
        mnemonic.clear()
        
        return seed
    }
    
    func generateKey(seed: [String], networkType: BTCNetworkType) throws -> BTCKey {
        guard let mnemonic = BTCMnemonic(words: seed, password: nil, wordListType: .unknown) else {
            throw BTCCoreError.wrongWords
        }
        
        var path: String
        switch networkType {
        case .mainnet:
            path = Constants.BTCConstants.BTCDerivationPathMainnet
            
        case .testnet:
            path = Constants.BTCConstants.BTCDerivationPathTestnet
        }
        
        guard let keychain = mnemonic.keychain.derivedKeychain(withPath: path),
            let key = keychain.key else {
                throw BTCCoreError.keychainError
        }
        
        mnemonic.clear()
        keychain.clear()
        
        return key
    }
    
    func verifySeed(_ seed: [String]) -> Bool {
        if let _ = BTCMnemonic(words: seed, password: nil, wordListType: .unknown) {
            return true
        }
        return false
    }
    
    func getAddress(seed: [String], networkType: BTCNetworkType) throws -> String {
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
    
    func getPrivateKey(seed: [String], networkType: BTCNetworkType) throws -> String {
        let key = try generateKey(seed: seed, networkType: networkType)
        
        let privateKey = key.privateKey.hex()
        key.clear()
        
        if let privateKey = privateKey {
            return privateKey
        }
        
        throw BTCCoreError.keychainGeneration
    }
    
    func getPrivateKeyData(seed: [String], networkType: BTCNetworkType) throws -> Data {
        let key = try generateKey(seed: seed, networkType: networkType)
        
        let privateKeyNSData = key.privateKey
        key.clear()
        
        guard let privateKeyData = privateKeyNSData as Data? else {
            throw BTCCoreError.keychainError
        }
        
        return privateKeyData
    }
    
    func calculateTransactionFee(
        amount: Int,
        feePerKb: Int,
        unspentOutputs: [BTCTransactionOutput],
        networkType: BTCNetworkType
    ) throws -> Int {
        let randomFromSeed = try generateSeed()
        let fromAddressString = try getAddress(seed: randomFromSeed, networkType: networkType)
        let randomToSeed = try generateSeed()
        let toAddressString = try getAddress(seed: randomToSeed, networkType: networkType)
        
        guard let toAddress = BTCAddress(string: toAddressString),
            let fromAddress = BTCAddress(string: fromAddressString) else {
                throw BTCCoreError.addressGeneration
        }
        
        let privateKey = try generateKey(seed: randomFromSeed, networkType: networkType)
        
        let amount = BTCAmount(amount)
        let feePerKb = BTCAmount(feePerKb)
        var fee = feePerKb
        
        let maxFee = Int(pow(Double(10), Double(Constants.BTCConstants.BTCDecimal)))
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
        privateKey: BTCKey,
        outputs: [BTCTransactionOutput],
        changeAddress: BTCAddress,
        toAddress: BTCAddress,
        value: BTCAmount,
        fee: BTCAmount,
        checkSignature: Bool
    ) throws -> BTCTransaction? {
        let tx = BTCTransaction()
        tx.fee = fee
        
        var spentCoins = BTCAmount(0)
        
        for txOut in outputs {
            let txIn = BTCTransactionInput()
            txIn.previousHash = txOut.transactionHash
            txIn.previousIndex = txOut.index
            txIn.value = txOut.value
            txIn.signatureScript = txOut.script
            
            tx.addInput(txIn)
            spentCoins += txOut.value
        }
        
        let paymentOutput = BTCTransactionOutput(value: BTCAmount(value), address: toAddress)
        tx.addOutput(paymentOutput)
        
        if spentCoins > (value + fee) {
            let changeValue = spentCoins - (value + fee)
            let changeOutput = BTCTransactionOutput(value: changeValue, address: changeAddress)
            tx.addOutput(changeOutput)
        }
        
        for i in 0..<outputs.count {
            let txOut = outputs[i]
            // swiftlint:disable force_cast
            let txIn = tx.inputs[i] as! BTCTransactionInput
            // swiftlint:enable force_cast
            
            guard let hash = try? tx.signatureHash(for: txOut.script, inputIndex: UInt32(i), hashType: .SIGHASH_ALL) else {
                throw BTCCoreError.transactionGenerating
            }
            
            let sigScript = BTCScript()
            
            let signature = privateKey.signature(forHash: hash)
            var signatureForScript = signature
            let hashTypeData = BTCSignatureHashType.SIGHASH_ALL.rawValue
            var hashType = hashTypeData
            signatureForScript?.append(&hashType, count: 1)
            _ = sigScript?.appendData(signatureForScript)
            _ = sigScript?.appendData(privateKey.publicKey as Data?)
            
            if checkSignature && !privateKey.isValidSignature(signature, hash: hash) {
                throw BTCCoreError.transactionGenerating
            }

            txIn.signatureScript = sigScript
        }
        
        if checkSignature {
            let scriptMachine = BTCScriptMachine(transaction: tx, inputIndex: 0)
            do {
                try scriptMachine?.verify(withOutputScript: outputs[0].script)
            } catch {
                throw BTCCoreError.transactionGenerating
            }

            privateKey.clear()
        }
        
        return tx
    }
    
    func getTransactionHex(transaction: BTCTransaction) -> String? {
        let txHex = transaction.hex
        return txHex
    }
}
