//
//  ProxyAssembly.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject

final class ProxyAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AuthEventProxy.self) {_ in
            let proxy = AuthEventProxyImp()
            return proxy
        }
        .inObjectScope(.container)

        container.register(SnackBarsEventProxy.self) {_ in
            let proxy = SnackBarsEventProxyImp()
            return proxy
        }
        .inObjectScope(.container)
        
        container.register(FirebaseTokenEventProxy.self) {_ in
            let proxy = FirebaseTokenEventProxyImp()
            return proxy
        }.inObjectScope(.container)
        
        container.register(ReachabilityEventProxy.self) {_ in
            let proxy = ReachabilityEventProxyImp()
            return proxy
        }.inObjectScope(.container)
    }
}
