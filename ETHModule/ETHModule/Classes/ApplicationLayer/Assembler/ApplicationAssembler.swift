//
//  ApplicationAssembler.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule
import Swinject

public class ApplicationAssembler {
    private (set) var assembler: Assembler!
    
    static func rootAssembler() -> ApplicationAssembler {
        let sharedAssembrer = SharedFilesModule.ApplicationAssembler.shared.assembler
        let assembler = Assembler([RootAssembly()], parent: sharedAssembrer)
        _ = BusinessLayerAssembly(parent: assembler)
        // swiftlint:disable force_unwrapping
        let rootAssembler = assembler.resolver.resolve(ApplicationAssembler.self)!
        // swiftlint:enable force_unwrapping
        rootAssembler.assembler = assembler
        return rootAssembler
    }
    
    var moduleAssembly: ModuleAssembly {
        // swiftlint:disable force_unwrapping
        return assembler.resolver.resolve(ModuleAssembly.self)!
        // swiftlint:enable force_unwrapping
    }
}

class RootAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ApplicationAssembler.self) { _ in
            ApplicationAssembler()
        }.inObjectScope(.container)
        
        container.register([ConfiguratorProtocol].self) {resolver in
            // swiftlint:disable force_unwrapping
            [
                resolver.resolve(ConfiguratorProtocol.self, name: "Appearance")!
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
    }
}
