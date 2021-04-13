//
//  SendRouter.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class SendRouter: SendRouterInput {
    weak var view: UIViewController?
    var applicationAssempler: ApplicationAssembler!
    weak var scanController: UIViewController?

    func presentScan(output: ScanModuleOutput) {
        guard scanController == nil else {
            return
        }
        
        guard let view = view else {
            return
        }
        
        let module = ScanModuleConfigurator().configureModule(assembler: applicationAssempler)
        module.output = output
        scanController = module.viewController
        view.navigationController?.pushViewController(module.viewController, animated: true)
    }
    
    func getOneButtonSnackBar() -> OneButtonSnackBarModuleInput {
        return OneButtonSnackBarModuleConfigurator().configureModule(applicationAssembler: applicationAssempler)
    }
    
    func getCurrencySnackBar() -> SelectCurrencySnackBarModuleInput {
        return SelectCurrencySnackBarModuleConfigurator().configureModule(applicationAssembler: applicationAssempler)
    }
}
