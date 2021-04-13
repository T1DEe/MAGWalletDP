//
//  AuthImportBrainkeyAuthImportBrainkeyRouter.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class AuthImportBrainkeyRouter: AuthImportBrainkeyRouterInput {
	weak var view: UIViewController?
    var applicationAssembler: ApplicationAssembler!
    
    func getButtonSnackBar() -> ButtonSnackBarModuleInput {
        return ButtonSnackBarModuleConfigurator().configureModule(applicationAssembler: applicationAssembler)
    }
}
