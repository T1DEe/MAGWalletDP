//
//  SensitiveDataServiceImp.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule

final class SensitiveDataServiceImp: SensitiveDataService {
    var protectedStorage: StorageCore!
    var cryptoCore: CryptoCoreComponent!
    
    func redecryptSensitiveData(newPass: String, oldPass: String) throws {
        let map = try obtainStorageMap()
        var newMap = [String: String]()
        for (name, encryptedPass) in map {
            let decryptedPass = try cryptoCore.decrypt(hash: encryptedPass, salt: oldPass)
            let newEncryptedPass = try cryptoCore.encrypt(string: decryptedPass, salt: newPass)
            newMap[name] = newEncryptedPass
        }
        try setStorageMap(map: newMap)
    }
    
    func obtainSensitiveData(pass: String, key: String) throws -> String {
        let map = try obtainStorageMap()
        if let encryptedValue = map[key] {
            let decryptedValue = try cryptoCore.decrypt(hash: encryptedValue, salt: pass)
            return decryptedValue
        } else {
            throw StorageCoreError.resultNotFound
        }
    }
    
    func setSensitiveData(pass: String, key: String, data: String) throws {
        var map = try obtainStorageMap()
        let decryptedValue = try cryptoCore.encrypt(string: data, salt: pass)
        map[key] = decryptedValue
        try setStorageMap(map: map)
    }
    
    func removeSensitiveData(key: String) throws {
        if var map = protectedStorage.get(key: Constants.Keys.walletsDataMap, type: [String: String].self) {
            map[key] = nil
            try setStorageMap(map: map)
        } else {
            throw StorageCoreError.resultNotFound
        }
    }
    
    private func obtainStorageMap() throws -> [String: String] {
        if let map = protectedStorage.get(key: Constants.Keys.walletsDataMap, type: [String: String].self) {
            return map
        } else {
            let map = [String: String]()
            try setStorageMap(map: map)
            return map
        }
    }
    
    private func setStorageMap(map: [String: String]) throws {
        try protectedStorage.set(key: Constants.Keys.walletsDataMap, value: map)
    }
    
    func clear() {
        try? setStorageMap(map: [:])
    }
}
