//
//  HistoryHistoryRouter.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class HistoryRouter: HistoryRouterInput {
	weak var view: UIViewController?
    var applicationAssempler: ApplicationAssembler!
    
    func showDetails(transaction: ETHWalletHistoryEntity, output: HistoryDetailsModuleOutput) {
        let module = HistoryDetailsModuleConfigurator().configureModule(applicationAssembler: applicationAssempler)
        module.output = output
        module.setTransaction(transaction)
        view?.navigationController?.pushViewController(module.viewController, animated: true)
    }
    
    func showDetails(transaction: TokenHistoryEntity, output: HistoryDetailsModuleOutput) {
        let module = HistoryDetailsModuleConfigurator().configureModule(applicationAssembler: applicationAssempler)
        module.output = output
        module.setTransaction(transaction)
        view?.navigationController?.pushViewController(module.viewController, animated: true)
    }
    
    func getCurrencySnackBar() -> SelectCurrencySnackBarModuleInput {
        return SelectCurrencySnackBarModuleConfigurator().configureModule(applicationAssembler: applicationAssempler)
    }
}
