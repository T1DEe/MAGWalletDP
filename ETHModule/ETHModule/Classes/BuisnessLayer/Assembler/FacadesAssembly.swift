//
//  FacadesAssembly.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule
import Swinject

final class FacadesAssembly: Assembly {
    func assemble(container: Container) {
        container.register([ETHNetworkConfigurable].self) { resolver in
            // swiftlint:disable force_unwrapping
            [
                resolver.resolve(ETHAuthService.self)!,
                resolver.resolve(ETHTransferService.self)!,
                resolver.resolve(ETHUpdateService.self)!
            ]
            // swiftlint:enable force_unwrapping
        }
        
        container.register(ETHNetworkFacade.self) { resolver in
            // swiftlint:disable force_unwrapping
            let networks = resolver.resolve([ETHNetworkConfigurable].self)!
            let adapters: [ETHNetworkType: ETHNetworkAdapter] = [
                .rinkeby: resolver.resolve(ETHNetworkAdapter.self, argument: "Rinkeby")!,
                .mainnet: resolver.resolve(ETHNetworkAdapter.self, argument: "MainNet")!
//                .kovan: resolver.resolve(ETHNetworkAdapter.self, argument: "Kovan")!,
//                .ropsten: resolver.resolve(ETHNetworkAdapter.self, argument: "Ropsten")!
            ]
            let storageService = resolver.resolve(PublicDataService.self)
            // swiftlint:enable force_unwrapping
            let facade = ETHNetworkFacadeImp(
                networks: networks,
                adapters: adapters,
                storageService: storageService,
                currentNetwork: Constants.ETHConstants.ETHNetwork,
                useOnlyDefault: Constants.ETHConstants.ETHUseOnlyDefaultNetwork
            )
            return facade
        }
        .inObjectScope(.container)
        
        container.register(ETHNotificationFacade.self) { resolver in            
            // swiftlint:disable force_unwrapping
            let adapters: [ETHNetworkType: ETHNetworkAdapter] = [
                .rinkeby: resolver.resolve(ETHNetworkAdapter.self, argument: "Rinkeby")!,
                .mainnet: resolver.resolve(ETHNetworkAdapter.self, argument: "MainNet")!
//                .kovan: resolver.resolve(ETHNetworkAdapter.self, argument: "Kovan")!,
//                .ropsten: resolver.resolve(ETHNetworkAdapter.self, argument: "Ropsten")!
            ]
            // swiftlint:enable force_unwrapping
            let facade = ETHNotificationFacadeImp(
                adapters: adapters
            )
            facade.authService = resolver.resolve(ETHAuthService.self)
            facade.subscribeService = resolver.resolve(ETHSubscribeService.self)
            facade.notificationService = resolver.resolve(NotificationService.self)
            return facade
        }
        .inObjectScope(.container)
    }
}
