//
//  AllCurrenciesAllCurrenciesRouter.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class AllCurrenciesRouter: AllCurrenciesRouterInput {
	weak var view: UIViewController?
    
    func presentSettings(output: SettingsModuleOutput, accountsHolders: [AccountInfo], networks: [NetworkConfigurable]) {
        guard let view = view else {
            return
        }
        let module = SettingsModuleConfigurator().configureModule()
        module.output = output
        module.accountsHolders = accountsHolders
        module.networks = networks
        view.navigationController?.pushViewController(module.viewController, animated: true)
    }
}
