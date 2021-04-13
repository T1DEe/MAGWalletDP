//
//  MainMainRouter.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class MainRouter: MainRouterInput {
	weak var view: UIViewController?
    var applicationAssempler: ApplicationAssembler!
    var walletModule: WalletModuleInput?
    var historyModule: HistoryModuleInput?
    weak var scanController: UIViewController?
    
    func obtainRoots(
        walletOutput: WalletModuleOutput,
        historyOutput: HistoryModuleOutput,
        hasAdditionToken: Bool
        ) -> MainRootType {
        let wallet = obtainWalletModule(output: walletOutput, hasAdditionToken: hasAdditionToken).viewController
        let history = obtainHistoryModule(output: historyOutput).viewController
        return (wallet, history)
    }
    
    func obtainWalletModule(output: WalletModuleOutput, hasAdditionToken: Bool) -> WalletModuleInput {
        if let walletModule = walletModule {
            return walletModule
        }
        let module: WalletModuleInput
        if hasAdditionToken {
            module = WalletWithTokenModuleConfigurator().configureModule(applicationAssembler: applicationAssempler)
        } else {
            module = WalletModuleConfigurator().configureModule(applicationAssembler: applicationAssempler)
        }
        module.output = output
        walletModule = module
        return module
    }
    
    func obtainHistoryModule(output: HistoryModuleOutput) -> HistoryModuleInput {
        if let historyModule = historyModule {
            return historyModule
        }
        let module = HistoryModuleConfigurator().configureModule(applicationAssembler: applicationAssempler)
        module.output = output
        historyModule = module
        return module
    }
    
    func presentReceive() {
        guard let view = view else {
            return
        }
        
        let module = ReceiveModuleConfigurator().configureModule(assembler: applicationAssempler)
        view.navigationController?.pushViewController(module.viewController, animated: true)
    }
    
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
    
    func getCurrencySnackBar() -> SelectCurrencySnackBarModuleInput {
        return SelectCurrencySnackBarModuleConfigurator().configureModule(applicationAssembler: applicationAssempler)
    }
}
