//
//  CoreComponentAssembly.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject

final class CoreComponentAssembly: Assembly {
    func assemble(container: Container) {
        container.register(StorageCore.self, name: "Protected") {_ in
            let core = ProtectedStorageCore()
            return core
        }
        .inObjectScope(.container)
        
        container.register(StorageCore.self, name: "Shared") {_ in
            let core = SharedStorageCore()
            return core
        }
        .inObjectScope(.container)

        container.register(StorageCore.self, name: "RAM") {_ in
            let core = RAMStorageCore()
            return core
        }
        .inObjectScope(.container)
    }
}
