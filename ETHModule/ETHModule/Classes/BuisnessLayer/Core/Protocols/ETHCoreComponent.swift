//
//  ETHCoreComponent.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import web3swift

protocol ETHCoreComponent {
    func generateSeed() -> String
    func verifySeed(_ seed: String) -> Bool
    func createKeystore(seed: String) throws -> BIP32Keystore
    func getAddress(keystore: BIP32Keystore) -> String
    func createTx(toAddress: String,
                  fromAddress: String,
                  keystore: BIP32Keystore,
                  nonce: Int,
                  gasPrice: Int,
                  gasLimit: Int,
                  value: Int,
                  type: ETHNetworkType) throws -> String
    func getPrivateKey(keystore: BIP32Keystore, address: String) throws -> String
    func getPrivateKey(keystore: BIP32Keystore, address: String) throws -> Data 
}
