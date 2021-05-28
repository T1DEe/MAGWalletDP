//
//  SequreStorageCoreImp.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import KeychainAccess

public final class ProtectedStorage: KeyValueStoring {
    // swiftlint:disable force_unwrapping
    let keychain = Keychain(service: Bundle.main.bundleIdentifier!).accessibility(.whenUnlockedThisDeviceOnly)
    // swiftlint:enable force_unwrapping
    // MARK: - KeyValueStoring
    public func getData(key: String) -> Data? {
        do {
            let value = try keychain.getData(key)
            return value
        } catch let error {
            print("error: \(error)")
            return nil
        }
    }
    public func set(key: String, value: Data) {
        do {
            try keychain.set(value, key: key)
        } catch let error {
            print("error: \(error)")
        }
    }
    public func get(key: String) -> String? {
        do {
            let value = try keychain.get(key)
            return value
        } catch let error {
            print("error: \(error)")
            return nil
        }
    }
    public func set(key: String, value: String) {
        do {
            try keychain.set(value, key: key)
        } catch let error {
            print("error: \(error)")
        }
    }
    public func remove(key: String) {
        do {
            try keychain.remove(key)
        } catch let error {
            print("error: \(error)")
        }
    }
}
