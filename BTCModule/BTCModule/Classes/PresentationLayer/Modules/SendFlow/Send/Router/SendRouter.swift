//
//  SendSendRouter.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class SendRouter: SendRouterInput {
    weak var view: UIViewController?
    weak var scanController: UIViewController?
    var applicationAssempler: ApplicationAssembler!
    
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
}
