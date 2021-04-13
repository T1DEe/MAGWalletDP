//
//  ApplicationModuleRouter.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class ApplicationModuleRouter: ApplicationModuleRouterInput {
    weak var view: UIViewController?
    var applicationAssembler: ApplicationAssembler!
}

extension ApplicationModuleRouter {
    func getFlow(type: FlowType, output: ApplicationModulesOutputs) -> SubflowModule {
        switch type {
        case .auth(let needShowBack):
            let module = AuthRootModuleConfigurator().configureModule(assembler: applicationAssembler)
            module.output = output
            module.needShowBack = needShowBack
            return module
            
        case .main(let needShowBack):
            let module = MainModuleConfigurator().configureModule(assembler: applicationAssembler)
            module.output = output
            module.needShowBack = needShowBack
            return module

        case .send(let entity):
            let module = SendModuleConfigurator().configureModule(assembler: applicationAssembler)
            if let entity = entity as? ScanEntity {
                module.entity = entity
            }
            module.output = output
            return module

        case .settings:
            let module = SettingsModuleConfigurator().configureModule(assembler: applicationAssembler)
            module.output = output
            return module
        }
    }
}
