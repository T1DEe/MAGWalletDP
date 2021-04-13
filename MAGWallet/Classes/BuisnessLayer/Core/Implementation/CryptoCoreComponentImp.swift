//
//  CryptoCoreComponentImp.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import CryptoSwift
import SharedFilesModule

final class CryptoCoreComponentImp: CryptoCoreComponent {
    let ivector = "1234567891011121"

    func hash(string: String) -> String {
        return string.sha3(CryptoSwift.SHA3.Variant.keccak256)
    }
    
    func encrypt(string: String, salt: String) throws -> String {
        do {
            let longKey = salt.sha256()
            let indexOfEnd = longKey.index(longKey.startIndex, offsetBy: 32)
            let key = String(longKey[..<indexOfEnd])

            let enc = try AES(key: key, iv: ivector).encrypt(Array(string.utf8))
            let encriptedString = enc.toBase64()

            if let encriptedString = encriptedString {
                return encriptedString
            } else {
                throw CryptoError.encryptionFailed
            }
        } catch {
            throw CryptoError.encryptionFailed
        }
    }

    func decrypt(hash: String, salt: String) throws -> String {
        do {
            let longKey = salt.sha256()
            let indexOfEnd = longKey.index(longKey.startIndex, offsetBy: 32)
            let key = String(longKey[..<indexOfEnd])
            let arrayBytes = Array(base64: hash)

            let dec = try AES(key: key, iv: ivector).decrypt(arrayBytes)
            let decriptedString = dec.reduce("") { $0 + String(format: "%c", $1) }
            if decriptedString.isEmpty == false {
                return decriptedString
            } else {
                throw CryptoError.decryptionFailed
            }
        } catch {
            throw CryptoError.decryptionFailed
        }
    }
}
