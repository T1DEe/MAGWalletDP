//
//  MainMainRouter.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class MainRouter: MainRouterInput {
	weak var view: UIViewController?
    var historyModule: HistoryModuleInput?
    var walletModule: WalletModuleInput?
    weak var scanController: UIViewController?
    
    var applicationAssempler: ApplicationAssembler!
    
    func obtainRoots(walletOutput: WalletModuleOutput,
                     historyOutput: HistoryModuleOutput) -> MainRootType {
        let history = obtainHistoryModule(output: historyOutput).viewController
        let wallet = obtainWalletModule(output: walletOutput).viewController
        return (wallet, history)
    }
    
    func obtainHistoryModule(output: HistoryModuleOutput) -> HistoryModuleInput {
        if let historyModule = historyModule {
            return historyModule
        }
        let module = HistoryModuleConfigurator().configureModule(assembler: applicationAssempler)
        module.output = output
        historyModule = module
        return module
    }
    
    func obtainWalletModule(output: WalletModuleOutput) -> WalletModuleInput {
        if let walletModule = walletModule {
            return walletModule
        }
        let module = WalletModuleConfigurator().configureModule(applicationAssembler: applicationAssempler)
        module.output = output
        walletModule = module
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
    
    func showHistoryModule() {
        let module = HistoryModuleConfigurator().configureModule(assembler: applicationAssempler)
        view?.navigationController?.pushViewController(module.viewController, animated: true)
    }
}
