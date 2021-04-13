//
//  ProxyAssembly.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject

final class ProxyAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SessionExpireEventProxy.self) {resolver in
            let proxy = SessionExpireEventProxyImp()
            proxy.sharedStorage = resolver.resolve(StorageCore.self, name: "Shared")
            return proxy
        }.inObjectScope(.container)
    }
}
