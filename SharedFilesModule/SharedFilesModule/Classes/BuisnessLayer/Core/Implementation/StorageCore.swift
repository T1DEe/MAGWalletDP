//
//  StorageCore.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public protocol StorageCore {
    var storage: KeyValueStoring { get set }
    
    func get<T>(key: String, type: T.Type) -> T? where T: Decodable
    func get(key: String) -> String?
    func set<T: Codable>(key: String, value: T) throws
    func remove(key: String)
}

extension StorageCore {
    public func get<T>(key: String, type: T.Type) -> T? where T: Decodable {
        if let data = storage.getData(key: key) {
            do {
                return try JSONDecoder().decode(type, from: data)
            } catch {
                return nil
            }
        }
        
        return nil
    }
    
    public func get(key: String) -> String? {
        if let string = storage.get(key: key) {
            return string
        }
        return nil
    }
    
    public func set<T: Codable>(key: String, value: T) throws {
        if let string = value as? String {
            try storage.set(key: key, value: string)
        } else if let data = try? JSONEncoder().encode(value) {
            try storage.set(key: key, value: data)
        } else {
            throw StorageCoreError.typeNotSupported
        }
    }
    
    public func remove(key: String) {
        storage.remove(key: key)
    }
}
