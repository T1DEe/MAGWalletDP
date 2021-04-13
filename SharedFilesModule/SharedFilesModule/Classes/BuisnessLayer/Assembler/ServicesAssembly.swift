//
//  ServicesAssembly.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject

final class ServicesAssembly: Assembly {
    func assemble(container: Container) {
        container.register(PublicDataService.self) { resolver in
            let service = PublicDataServiceImp()
            service.sharedStorage = resolver.resolve(StorageCore.self, name: "Shared")
            return service
        }
        .inObjectScope(.container)
        
        container.register(FingerprintAccessService.self) { resolver in
            let service = FingerprintAccessServiceImp()
            service.sharedStorage = resolver.resolve(StorageCore.self, name: "Shared")
            return service
        }.inObjectScope(.container)
        
        container.register(NotificationService.self) { resolver in
            let service = NotificationServiceImp()
            service.sharedStorage = resolver.resolve(StorageCore.self, name: "Shared")
            return service
        }.inObjectScope(.container)
    }
}
