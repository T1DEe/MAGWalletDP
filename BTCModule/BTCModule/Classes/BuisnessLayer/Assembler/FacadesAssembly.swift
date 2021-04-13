//
//  FacadesAssembly.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule
import Swinject

final class FacadesAssembly: Assembly {
    func assemble(container: Container) {
        container.register([BTCNetworkConfigurable].self) { resolver in
            // swiftlint:disable force_unwrapping
            [
                resolver.resolve(BTCAuthService.self)!,
                resolver.resolve(BTCTransferService.self)!,
                resolver.resolve(BTCUpdateService.self)!
            ]
            // swiftlint:enable force_unwrapping
        }
        
        container.register(BTCNetworkFacade.self) { resolver in
            // swiftlint:disable force_unwrapping
            let networks = resolver.resolve([BTCNetworkConfigurable].self)!
            let adapters: [BTCNetworkType: BTCNetworkAdapter] = [
                .testnet: resolver.resolve(BTCNetworkAdapter.self, argument: "TestNet")!,
                .mainnet: resolver.resolve(BTCNetworkAdapter.self, argument: "MainNet")!
            ]
            let storageService = resolver.resolve(PublicDataService.self)
            // swiftlint:enable force_unwrapping
            let facade = BTCNetworkFacadeImp(
                networks: networks,
                adapters: adapters,
                storageService: storageService,
                currentNetwork: Constants.BTCConstants.BTCNetwork,
                useOnlyDefault: Constants.BTCConstants.BTCUseOnlyDefaultNetwork
            )
            return facade
        }
        .inObjectScope(.container)
        
        container.register(BTCNotificationFacade.self) { resolver in
            // swiftlint:disable force_unwrapping
            let adapters: [BTCNetworkType: BTCNetworkAdapter] = [
                .testnet: resolver.resolve(BTCNetworkAdapter.self, argument: "TestNet")!,
                .mainnet: resolver.resolve(BTCNetworkAdapter.self, argument: "MainNet")!
            ]
            // swiftlint:enable force_unwrapping
            let facade = BTCNotificationFacadeImp(
                adapters: adapters
            )
            facade.authService = resolver.resolve(BTCAuthService.self)
            facade.subscribeService = resolver.resolve(BTCSubscribeService.self)
            facade.notificationService = resolver.resolve(NotificationService.self)
            return facade
        }
        .inObjectScope(.container)
    }
}
