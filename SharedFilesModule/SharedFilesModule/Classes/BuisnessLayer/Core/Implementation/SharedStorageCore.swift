//
//  SharedStorageServiceImp.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public final class SharedStorageCore: StorageCore {
    public var storage: KeyValueStoring = SharedStorage()
}
