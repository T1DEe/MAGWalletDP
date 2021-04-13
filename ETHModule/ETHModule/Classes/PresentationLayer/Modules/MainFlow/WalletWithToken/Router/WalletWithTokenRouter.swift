//
//  WalletWithTokenWalletWithTokenRouter.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class WalletWithTokenRouter: WalletWithTokenRouterInput {
	weak var view: UIViewController?
    var applicationAssembler: ApplicationAssembler!

    func getOneButtonSnackBar() -> OneButtonSnackBarModuleInput {
        return OneButtonSnackBarModuleConfigurator().configureModule(applicationAssembler: applicationAssembler)
    }
}
