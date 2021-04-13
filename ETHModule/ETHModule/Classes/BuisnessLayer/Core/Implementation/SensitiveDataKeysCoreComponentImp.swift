//
//  SensitiveDataKeysCoreComponentImp.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import CryptoSwift
import Foundation

class SensitiveDataKeysCoreComponentImp: SensitiveDataKeysCoreComponent {
    func generateSensitiveSeedKey(wallet: ETHWallet) -> String {
        let addressHash = wallet.address.sha3(CryptoSwift.SHA3.Variant.keccak256)
        return addressHash + " " + Constants.AuthConstants.seedKey
    }
}
