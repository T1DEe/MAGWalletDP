//
//  ApplicationAssembler.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule
import Swinject

public class ApplicationAssembler {
    public let assembler: Assembler
    public static let shared = ApplicationAssembler()

    private init() {
        let sharedAssembrer = SharedFilesModule.ApplicationAssembler.shared.assembler
        let assembler = Assembler([RootAssembly()], parent: sharedAssembrer)
        _ = BusinessLayerAssembly(parent: assembler)
        self.assembler = assembler
    }
}

class RootAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UIWindow.self) { _ in UIWindow(frame: UIScreen.main.bounds) }.inObjectScope(.container)

        container.register(ApplicationAssembler.self) { _ in
            ApplicationAssembler.shared
        }

        container.register([ConfiguratorProtocol].self) {resolver in
            // swiftlint:disable force_unwrapping
            [
                resolver.resolve(ConfiguratorProtocol.self, name: "Firebase")!,
                resolver.resolve(ConfiguratorProtocol.self, name: "Appearance")!,
                resolver.resolve(ConfiguratorProtocol.self, name: "Application")!,
                resolver.resolve(ConfiguratorProtocol.self, name: "Reachability")!
            ]
            // swiftlint:enable force_unwrapping
        }

        container.register(ModuleAssembly.self) {resolver in
            // swiftlint:disable force_unwrapping
            let assembler = resolver.resolve(ApplicationAssembler.self)!
            return ModuleAssembly(parent: assembler.assembler)
            // swiftlint:enable force_unwrapping
        }
            .inObjectScope(.container)

        container.register(ConfiguratorProtocol.self, name: "Appearance") { _ in
            let configurator = AppearanceConfigurator()
            return configurator
        }

        container.register(ConfiguratorProtocol.self, name: "Application") { _ in
            let configurator = ApplicationConfigurator()
            return configurator
        }
        
        container.register(ConfiguratorProtocol.self, name: "Firebase") { resolver in
            let configurator = FirebaseConfigurator()
            configurator.firebaseService = resolver.resolve(FirebaseService.self)
            return configurator
        }
        
        container.register(ConfiguratorProtocol.self, name: "Reachability") { resolver in
            let configurator = ReachabilityConfigurator()
            configurator.reachabilityService = resolver.resolve(ReachabilityService.self)
            return configurator
        }
    }
}
