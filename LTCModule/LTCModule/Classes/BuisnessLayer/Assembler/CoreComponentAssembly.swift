//
//  CoreComponentAssembly.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import CryptoAPI
import SharedFilesModule
import Swinject

final class CoreComponentAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LTCCoreComponent.self) { _ in
            let core = LTCCoreComponentImp()
            return core
        }
        .inObjectScope(.container)
        
        container.register(LTCNetworkAdapter.self) { (resolver, network: String) in
            let core = LTCNetworkAdapterImp()
            core.api = resolver.resolve(CryptoAPI.self, name: network)
            return core
        }.inObjectScope(.transient)
        
        container.register(LTCSettingsConfiguration.self) {_ in
            let core = LTCSettingsConfiguration()
            return core
        }.inObjectScope(.container)
        
        container.register(QRCodeCoreComponent.self) {_ in
            let core = QRCodeCoreComponentImp()
            return core
        }.inObjectScope(.container)
        
        container.register(CryptoAPI.self, name: "TestNet") { _ in
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
        
        container.register(SensitiveDataKeysCoreComponent.self) {_ in
            let core = SensitiveDataKeysCoreComponentImp()
            return core
        }.inObjectScope(.container)
    }
}
