//
//  MainRoutingMainRoutingRouter.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SafariServices
import SharedFilesModule
import UIKit

class MainRoutingRouter: MainRoutingRouterInput {
    weak var view: UIViewController?
    
    func getSnackBarsRoot() -> SnackBarRootModuleInput {
        return SnackBarRootModuleConfigurator().configureModule()
    }
    
    func getUnlockPinModule(output: UnlockPinModuleOutput) -> UnlockPinModuleInput {
        let module = UnlockPinModuleConfigurator().configureModule()
        module.output = output
        return module
    }
    
    func getChangePinModule(output: ChangePinModuleOutput) -> ChangePinModuleInput {
        let module = ChangePinModuleConfigurator().configureModule()
        module.output = output
        return module
    }
    
    func getSessionVerification(output: SessionVerificationModuleOutput) -> SessionVerificationModuleInput {
        let module = SessionVerificationModuleConfigurator().configureModule()
        module.output = output
        return module
    }
    
    func getAllCurrencies(
        output: AllCurrenciesModuleOutput,
        accounts: [AccountInfo],
        networks: [NetworkConfigurable]
    ) -> AllCurrenciesModuleInput {
        let module = AllCurrenciesModuleConfigurator().configureModule()
        module.accounts = accounts
        module.networks = networks
        module.output = output
        return module
    }

    func getSafariVC(url: URL) -> SFSafariViewController {
        let safariVC = SFSafariViewController(url: url)
        return safariVC
    }
}
