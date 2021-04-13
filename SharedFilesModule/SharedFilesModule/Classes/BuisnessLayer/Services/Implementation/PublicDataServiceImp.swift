//
//  PublicDataServiceImp.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public final class PublicDataServiceImp: PublicDataService {
    var sharedStorage: StorageCore!
    
    public func obtainPublicData<T: Codable>(key: String, type: T.Type) throws -> T {
        let map = try obtainStorageMap()
        if let value = map[key], let dataValue = value.data(using: .utf8) {
            let container = try JSONDecoder().decode([T].self, from: dataValue)
            if let result = container.first {
                return result
            } else {
                throw StorageCoreError.resultNotFound
            }
        } else {
            throw StorageCoreError.resultNotFound
        }
    }
    
    public func setPublicData<T: Codable>(key: String, data: T) throws {
        var map = try obtainStorageMap()
        let dataValue = try JSONEncoder().encode([data])
        map[key] = String(data: dataValue, encoding: .utf8)
        try setStorageMap(map: map)
    }
    
    public func removePublicData(key: String) throws {
        if var map = try? obtainStorageMap() {
            map[key] = nil
            try setStorageMap(map: map)
        } else {
            throw StorageCoreError.resultNotFound
        }
    }
    
    private func setStorageMap(map: [String: String]) throws {
        try sharedStorage.set(key: Constants.Keys.walletsPublicDataMap, value: map)
    }
    
    private func obtainStorageMap() throws -> [String: String] {
        if let map = sharedStorage.get(key: Constants.Keys.walletsPublicDataMap, type: [String: String].self) {
            return map
        } else {
            let map = [String: String]()
            try setStorageMap(map: map)
            return map
        }
    }
    
    public func clear() {
        try? setStorageMap(map: [:])
    }
}
