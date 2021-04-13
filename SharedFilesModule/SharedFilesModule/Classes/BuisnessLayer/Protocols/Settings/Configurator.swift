//
//  Configurator.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public final class Configurator {
    public var storage: StorageCore = SharedStorageCore()
    public var protectedStorage: StorageCore = ProtectedStorageCore()
    public var network: Network = .mainnet
    public var additionalCurrency: Currency?
}
