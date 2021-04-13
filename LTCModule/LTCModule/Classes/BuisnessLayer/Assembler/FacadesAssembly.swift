//
//  FacadesAssembly.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule
import Swinject

final class FacadesAssembly: Assembly {
    func assemble(container: Container) {
        container.register([LTCNetworkConfigurable].self) { resolver in
            // swiftlint:disable force_unwrapping
            [
                resolver.resolve(LTCAuthService.self)!,
                resolver.resolve(LTCTransferService.self)!,
                resolver.resolve(LTCUpdateService.self)!
            ]
            // swiftlint:enable force_unwrapping
        }
        
        container.register(LTCNetworkFacade.self) { resolver in
            // swiftlint:disable force_unwrapping
            let networks = resolver.resolve([LTCNetworkConfigurable].self)!
            let adapters: [LTCNetworkType: LTCNetworkAdapter] = [
                .testnet: resolver.resolve(LTCNetworkAdapter.self, argument: "TestNet")!,
                .mainnet: resolver.resolve(LTCNetworkAdapter.self, argument: "MainNet")!
            ]
            let storageService = resolver.resolve(PublicDataService.self)
            // swiftlint:enable force_unwrapping
            let facade = LTCNetworkFacadeImp(
                networks: networks,
                adapters: adapters,
                storageService: storageService,
                currentNetwork: Constants.LTCConstants.LTCNetwork,
                useOnlyDefault: Constants.LTCConstants.LTCUseOnlyDefaultNetwork
            )
            return facade
        }
        .inObjectScope(.container)
        
        container.register(LTCNotificationFacade.self) { resolver in
            // swiftlint:disable force_unwrapping
            let adapters: [LTCNetworkType: LTCNetworkAdapter] = [
                .testnet: resolver.resolve(LTCNetworkAdapter.self, argument: "TestNet")!,
                .mainnet: resolver.resolve(LTCNetworkAdapter.self, argument: "MainNet")!
            ]
            // swiftlint:enable force_unwrapping
            let facade = LTCNotificationFacadeImp(
                adapters: adapters
            )
            facade.authService = resolver.resolve(LTCAuthService.self)
            facade.subscribeService = resolver.resolve(LTCSubscribeService.self)
            facade.notificationService = resolver.resolve(NotificationService.self)
            return facade
        }
        .inObjectScope(.container)
    }
}
