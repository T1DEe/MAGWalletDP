//
//  ServicesAssembly.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject

final class ServicesAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LTCAuthService.self) {resolver in
            let service = LTCAuthServiceImp()
            service.storageService = resolver.resolve(PublicDataService.self)
            service.ltcCoreComponent = resolver.resolve(LTCCoreComponent.self)
            return service
        }.inObjectScope(.container)
        
        container.register(LTCUpdateService.self) {resolver in
            let service = LTCUpdateServiceImp()
            service.storageService = resolver.resolve(PublicDataService.self)
            return service
        }.inObjectScope(.container)
        
        container.register(LTCUpdateService.self) {resolver in
            let service = LTCUpdateServiceImp()
            service.storageService = resolver.resolve(PublicDataService.self)
            return service
        }.inObjectScope(.container)
        
        container.register(LTCTransferService.self) {resolver in
            let service = LTCTransferServiceImp()
            service.ltcCoreComponent = resolver.resolve(LTCCoreComponent.self)
            return service
        }.inObjectScope(.container)
        
        container.register(LTCSubscribeService.self) { resolver in
            let service = LTCSubscribeServiceImp()
            service.sharedStorage = resolver.resolve(StorageCore.self, name: "Shared")
            return service
        }.inObjectScope(.container)
    }
}
