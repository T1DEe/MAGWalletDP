//
//  ServicesAssembly.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject

final class ServicesAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AuthFacade.self) { resolver in
            let service = AuthFacadeImp()
            service.protectedStorage = resolver.resolve(StorageCore.self, name: "Protected")
            service.sensitiveDataService = resolver.resolve(SensitiveDataService.self)
            service.fingerprintAccessService = resolver.resolve(FingerprintAccessService.self)
            service.cryptoCore = resolver.resolve(CryptoCoreComponent.self)
            return service
        }
        .inObjectScope(.container)
        
        container.register(FirebaseService.self) { resolver in
            let service = FirebaseServiceImp()
            service.sharedStorage = resolver.resolve(StorageCore.self, name: "Shared")
            service.firebaseTokenActionHandler = resolver.resolve(FirebaseTokenEventProxy.self)
            return service
        }
        .inObjectScope(.container)
        
        container.register(SensitiveDataService.self) { resolver in
            let service = SensitiveDataServiceImp()
            service.protectedStorage = resolver.resolve(StorageCore.self, name: "Shared")
            service.cryptoCore = resolver.resolve(CryptoCoreComponent.self)
            return service
        }
        .inObjectScope(.container)
        
        container.register(ReachabilityService.self) { resolver in
            let service = ReachabilityServiceImp()
            service.reachabilityActionHandler = resolver.resolve(ReachabilityEventProxy.self)
            return service
        }
        .inObjectScope(.container)
    }
}
