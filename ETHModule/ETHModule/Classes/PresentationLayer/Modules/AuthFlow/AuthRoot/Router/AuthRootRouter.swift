//
//  AuthRootAuthRootRouter.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import SharedUIModule
import UIKit

class AuthRootRouter: AuthRootRouterInput {
	weak var view: UIViewController?
    var applicationAssembler: ApplicationAssembler!
    
    func presentAuthFlowSelection(output: AuthFlowSelectionModuleOutput, needShowBack: Bool) {
        let module = AuthFlowSelectionModuleConfigurator().configureModule(assembler: applicationAssembler)
        module.output = output
        module.needShowBack = needShowBack
        let screen = module.viewController
        
        let baseNavController = BaseNavigationController()
        let navController = screen.wrapToNavigationController(baseNavController)
        view?.addChildController(child: navController)
    }
}
