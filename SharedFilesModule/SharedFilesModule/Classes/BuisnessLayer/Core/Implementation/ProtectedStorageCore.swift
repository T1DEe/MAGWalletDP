//
//  ProtectedStorageCore.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public final class ProtectedStorageCore: StorageCore {
    public var storage: KeyValueStoring = ProtectedStorage()
}
