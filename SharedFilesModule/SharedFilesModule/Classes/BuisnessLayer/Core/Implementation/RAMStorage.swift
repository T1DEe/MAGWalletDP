//
//  RAMStorage.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

final class RAMStorage: KeyValueStoring {
    var dataStorage = [String: Data]()
    var stringStorage = [String: String]()
    
    // MARK: - KeyValueStoring
    func getData(key: String) -> Data? {
        return dataStorage[key]
    }
    
    func set(key: String, value: Data) {
        dataStorage[key] = value
    }
    
    func get(key: String) -> String? {
        return stringStorage[key]
    }
    
    func set(key: String, value: String) {
        stringStorage[key] = value
    }
    
    func remove(key: String) {
        dataStorage[key] = nil
        stringStorage[key] = nil
    }
}
