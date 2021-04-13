//
//  ServicesAssembly.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject

final class ServicesAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ETHTransferService.self) { resolver in
            let service = ETHTransferServiceImp()
            service.ethCoreComponent = resolver.resolve(ETHCoreComponent.self)
            service.bytecodeCoreComponent = resolver.resolve(BytecodeCoreComponent.self)
            return service
        }.inObjectScope(.container)
        
        container.register(ETHUpdateService.self) { resolver in
            let service = ETHUpdateServiceImp()
            service.storageService = resolver.resolve(PublicDataService.self)
            return service
        }.inObjectScope(.container)
        
        container.register(ETHAuthService.self) { resolver in
            let service = ETHAuthServiceImp()
            service.storageService = resolver.resolve(PublicDataService.self)
            service.ethCoreComponent = resolver.resolve(ETHCoreComponent.self)
            return service
        }.inObjectScope(.container)
        
        container.register(ETHSubscribeService.self) { resolver in
            let service = ETHSubscribeServiceImp()
            service.sharedStorage = resolver.resolve(StorageCore.self, name: "Shared")
            return service
        }.inObjectScope(.container)
    }
}
