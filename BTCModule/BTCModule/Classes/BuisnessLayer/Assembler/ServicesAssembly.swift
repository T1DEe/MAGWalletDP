//
//  ServicesAssembly.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject

final class ServicesAssembly: Assembly {
    func assemble(container: Container) {
        container.register(BTCAuthService.self) {resolver in
            let service = BTCAuthServiceImp()
            service.storageService = resolver.resolve(PublicDataService.self)
            service.btcCoreComponent = resolver.resolve(BTCCoreComponent.self)
            return service
        }.inObjectScope(.container)
        
        container.register(BTCUpdateService.self) {resolver in
            let service = BTCUpdateServiceImp()
            service.storageService = resolver.resolve(PublicDataService.self)
            return service
        }.inObjectScope(.container)
        
        container.register(BTCUpdateService.self) {resolver in
            let service = BTCUpdateServiceImp()
            service.storageService = resolver.resolve(PublicDataService.self)
            return service
        }.inObjectScope(.container)
        
        container.register(BTCTransferService.self) {resolver in
            let service = BTCTransferServiceImp()
            service.btcCoreComponent = resolver.resolve(BTCCoreComponent.self)
            return service
        }.inObjectScope(.container)
        
        container.register(BTCSubscribeService.self) { resolver in
            let service = BTCSubscribeServiceImp()
            service.sharedStorage = resolver.resolve(StorageCore.self, name: "Shared")
            return service
        }.inObjectScope(.container)
    }
}
