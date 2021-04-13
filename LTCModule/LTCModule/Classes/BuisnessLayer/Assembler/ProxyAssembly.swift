//
//  ProxyAssembly.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject

final class ProxyAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SnackBarsEventProxy.self) {_ in
            let proxy = SnackBarsEventProxyImp()
            return proxy
        }
        .inObjectScope(.container)

        container.register(LTCUpdateEventProxy.self) {_ in
            let proxy = LTCUpdateEventProxyImp()
            return proxy
        }.inObjectScope(.container)
        
        container.register(AuthEventProxy.self) {_ in
            let proxy = AuthEventProxyImp()
            return proxy
        }
        .inObjectScope(.container)
        
        container.register(SensitiveDataEventProxy.self) {_ in
            let proxy = SensitiveDataEventProxyImp()
            return proxy
        }
        .inObjectScope(.container)
    }
}
