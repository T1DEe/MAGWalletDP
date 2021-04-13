//
//  CoreComponentAssembly.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject

final class CoreComponentAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CryptoCoreComponent.self) { _ in
            let core = CryptoCoreComponentImp()
            return core
        }.inObjectScope(.container)
    }
}
