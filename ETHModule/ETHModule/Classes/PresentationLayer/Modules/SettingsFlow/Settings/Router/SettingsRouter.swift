//
//  SettingsSettingsRouter.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class SettingsRouter: SettingsRouterInput {
	weak var view: UIViewController?
    var applicationAssembler: ApplicationAssembler!

    func presentLogout(output: LogoutModuleOutput) {
        guard let view = view else {
            return
        }
        
        let module = LogoutModuleConfigurator().configureModule(assembler: applicationAssembler)
        module.output = output
        view.navigationController?.pushViewController(module.viewController, animated: true)
    }
    
    func presentExport(brainkey: String) {
        guard let view = view else {
            return
        }
        let module = ExportBrainkeyModuleConfigurator().configureModule(assembler: applicationAssembler)
        module.presentBrainkey(brainkey: brainkey, from: view)
    }
    
    func presentAutoblock(output: AutoblockModuleOutput) {
        guard let view = view else {
            return
        }
        
        let module = AutoblockModuleConfigurator().configureModule(assembler: applicationAssembler)
        module.output = output
        view.navigationController?.pushViewController(module.viewController, animated: true)
    }

    func presentAccounts(output: AccountsModuleOutput) {
        guard let view = view else {
            return
        }

        let module = AccountsModuleConfigurator().configureModule(assembler: applicationAssembler)
        module.output = output
        view.navigationController?.pushViewController(module.viewController, animated: true)
    }
    
    func presentChangeNetwork(output: ChangeNetworkModuleOutput) {
        guard let view = view else {
            return
        }
        
        let module = ChangeNetworkModuleConfigurator().configureModule(assembler: applicationAssembler)
        module.output = output
        view.navigationController?.pushViewController(module.viewController, animated: true)
    }
    
    func getButtonSnackBar() -> ButtonSnackBarModuleInput {
        return ButtonSnackBarModuleConfigurator().configureModule(applicationAssembler: applicationAssembler)
    }
    
    func getOneButtonSnackBar() -> OneButtonSnackBarModuleInput {
        return OneButtonSnackBarModuleConfigurator().configureModule(applicationAssembler: applicationAssembler)
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
