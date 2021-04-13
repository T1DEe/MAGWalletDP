//
//  CoreComponentAssembly.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import CryptoAPI
import SharedFilesModule
import Swinject

final class CoreComponentAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ETHCoreComponent.self) { _ in
            let core = ETHCoreComponentImp()
            return core
        }
        
        container.register(ETHNetworkAdapter.self) { (resolver, network: String) in
            let core = ETHNetworkAdapterImp()
            core.api = resolver.resolve(CryptoAPI.self, name: network)
            return core
        }.inObjectScope(.transient)
        
        container.register(BytecodeCoreComponent.self) { _ in
            let core = BytecodeCoreComponentImp()
            return core
        }
        
        container.register(CryptoAPI.self, name: "Rinkeby") { _ in
            let authToken = Constants.CryptoApiConstants.authToken
            let settings = Settings(authorizationToken: authToken) { configurator in
                //configurator.workingQueue = DispatchQueue.global()
                //configurator.timeoutIntervalForRequest = 30
                //configurator.timeoutIntervalForResource = 30
                //configurator.sessionConfiguration = URLSessionConfiguration()
                configurator.debugEnabled = false
                configurator.networkType = NetworkType.testnet
            }
            let api = CryptoAPI(settings: settings)
            
            return api
        }.inObjectScope(.container)
        
        container.register(CryptoAPI.self, name: "MainNet") { _ in
            let authToken = Constants.CryptoApiConstants.authToken
            let settings = Settings(authorizationToken: authToken) { configurator in
                //configurator.workingQueue = DispatchQueue.global()
                //configurator.timeoutIntervalForRequest = 30
                //configurator.timeoutIntervalForResource = 30
                //configurator.sessionConfiguration = URLSessionConfiguration()
                configurator.debugEnabled = false
                configurator.networkType = NetworkType.mainnet
            }
            let api = CryptoAPI(settings: settings)
            
            return api
        }.inObjectScope(.container)
        
        container.register(ETHSettingsConfiguration.self) {_ in
            let core = ETHSettingsConfiguration()
            return core
        }.inObjectScope(.container)
        
        container.register(QRCodeCoreComponent.self) {_ in
            let core = QRCodeCoreComponentImp()
            return core
        }
        
        container.register(SensitiveDataKeysCoreComponent.self) {_ in
            let core = SensitiveDataKeysCoreComponentImp()
            return core
        }
    }
}
