//
//  SharedStorage.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public final class SharedStorage: KeyValueStoring {
    // MARK: - KeyValueStoring
    public func getData(key: String) -> Data? {
        return UserDefaults.standard.value(forKey: key) as? Data
    }
    
    public func set(key: String, value: Data) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public func get(key: String) -> String? {
        return UserDefaults.standard.value(forKey: key) as? String
    }
    
    public func set(key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public func remove(key: String) {
        UserDefaults.standard.set(nil, forKey: key)
    }
}
