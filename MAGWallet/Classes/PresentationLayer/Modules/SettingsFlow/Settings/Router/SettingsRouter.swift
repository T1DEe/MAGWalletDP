//
//  SettingsSettingsRouter.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class SettingsRouter: SettingsRouterInput {
	weak var view: UIViewController?
    
    func presentLogout(output: LogoutModuleOutput) {
        guard let view = view else {
            return
        }
        
        let module = LogoutModuleConfigurator().configureModule()
        module.output = output
        view.navigationController?.pushViewController(module.viewController, animated: true)
    }
    
    func presentAutoblock(output: AutoblockModuleOutput) {
        guard let view = view else {
            return
        }
        
        let module = AutoblockModuleConfigurator().configureModule()
        module.output = output
        view.navigationController?.pushViewController(module.viewController, animated: true)
    }
    
    func presentMultiAccounts(output: MultiAccountsModuleOutput, accountsHolders: [AccountInfo]) {
        guard let view = view else {
            return
        }

        let module = MultiAccountsModuleConfigurator().configureModule()
        module.output = output
        module.accountsHolders = accountsHolders
        view.navigationController?.pushViewController(module.viewController, animated: true)
    }
    
    func presentChangeNetwork(output: ChangeNetworkModuleOutput, networks: [NetworkConfigurable]) {
        guard let view = view else {
            return
        }
        
        let module = ChangeNetworkModuleConfigurator().configureModule()
        module.output = output
        module.networks = networks
        view.navigationController?.pushViewController(module.viewController, animated: true)
    }
    
    func getButtonSnackBar() -> ButtonSnackBarModuleInput {
        return ButtonSnackBarModuleConfigurator().configureModule()
    }
    
    func getOneButtonSnackBar() -> OneButtonSnackBarModuleInput {
        return OneButtonSnackBarModuleConfigurator().configureModule()
    }
    
    func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl) { success in
                print("Open settings:", success)
            }
        }
    }
}
