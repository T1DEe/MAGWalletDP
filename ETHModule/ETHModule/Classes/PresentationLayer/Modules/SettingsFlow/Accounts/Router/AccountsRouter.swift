//
//  AccountsAccountsRouter.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class AccountsRouter: AccountsRouterInput {
	weak var view: UIViewController?

    var applicationAssembler: ApplicationAssembler!

    func getButtonSnackBar() -> ButtonSnackBarModuleInput {
        return ButtonSnackBarModuleConfigurator().configureModule(applicationAssembler: applicationAssembler)
    }
}
