//
//  ETHCoreComponentImp.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import BigInt
import web3swift

enum ETHCoreComponentError: Error {
    case transactionEncode
}

final class ETHCoreComponentImp: ETHCoreComponent {
    let password = Constants.AuthConstants.keystorePass
    
    func generateSeed() -> String {
        let mnemonic = Mnemonics(entropySize: .b128, language: .english)
        return mnemonic.string
    }
    
    func verifySeed(_ seed: String) -> Bool {
        if let _ = try? Mnemonics(seed, language: .english) {
            return true
        }
        return false
    }

    func createKeystore(seed: String) throws -> BIP32Keystore {
        let mnemonic = try Mnemonics(seed, language: .english)
        let keystore = try BIP32Keystore(mnemonics: mnemonic)
        return keystore
    }
    
    func getAddress(keystore: BIP32Keystore) -> String {
        return keystore.addresses[0].address
    }
    
    func createTx(toAddress: String,
                  fromAddress: String,
                  keystore: BIP32Keystore,
                  nonce: Int,
                  gasPrice: Int,
                  gasLimit: Int,
                  value: Int, type: ETHNetworkType) throws -> String {
        let account = Address(fromAddress)
        var transaction = EthereumTransaction(nonce: BigUInt(nonce),
                                              gasPrice: BigUInt(gasPrice),
                                              gasLimit: BigUInt(gasLimit),
                                              to: Address(toAddress),
                                              value: BigUInt(value),
                                              data: Data(),
                                              v: 1, r: 0, s: 0)

        try Web3Signer.signTX(transaction: &transaction,
                              keystore: keystore,
                              account: account,
                              password: password)
        
        let network = convertTypes(type)
    
        guard let txHex = transaction.encode(forSignature: true, chainId: network)?.hex else {
            throw ETHCoreComponentError.transactionEncode
        }
        
        return txHex
    }
    
    func getPrivateKey(keystore: BIP32Keystore, address: String) throws -> String {
        let account = Address(address)
        let privateKey = try keystore.UNSAFE_getPrivateKeyData(password: password, account: account)
        return privateKey.hex
    }
    
    func getPrivateKey(keystore: BIP32Keystore, address: String) throws -> Data {
        let account = Address(address)
        let privateKey = try keystore.UNSAFE_getPrivateKeyData(password: password, account: account)
        return privateKey
    }
    
    private func convertTypes(_ networkType: ETHNetworkType) -> NetworkId {
        switch networkType {
        case .mainnet:
            return .mainnet

        case .ropsten:
            return .ropsten

        case .rinkeby:
            return .rinkeby

        case .kovan:
            return .kovan
        }
    }
}
