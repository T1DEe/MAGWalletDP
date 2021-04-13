//
//  AuthFlowSelectionAuthFlowSelectionRouter.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class AuthFlowSelectionRouter: AuthFlowSelectionRouterInput {
	weak var view: UIViewController?
    var applicationAssembler: ApplicationAssembler!
    
    func presentCreate() {
        guard let view = view else {
            return
        }
        
        let module = AuthCreateAndCopyModuleConfigurator().configureModule(assembler: applicationAssembler)
        view.navigationController?.pushViewController(module.viewController, animated: true)
    }
    
    func presentImport(output: AuthImportBrainkeyModuleOutput) {
        guard let view = view else {
            return
        }
        
        let module = AuthImportBrainkeyModuleConfigurator().configureModule(assembler: applicationAssembler)
        module.output = output
        module.presentFrom(view)
    }
}
