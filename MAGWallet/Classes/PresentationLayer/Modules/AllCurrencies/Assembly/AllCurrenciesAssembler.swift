//
//  AllCurrenciesAllCurrenciesAssembler.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject
import UIKit

class AllCurrenciesModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(AllCurrenciesInteractor.self) { (_, presenter: AllCurrenciesPresenter) in
            let interactor = AllCurrenciesInteractor()
            interactor.output = presenter
            return interactor
        }
        
        container.register(AllCurrenciesRouter.self) { (_, viewController: AllCurrenciesViewController!) in
            let router = AllCurrenciesRouter()
            router.view = viewController
            
            return router
        }
        
        container.register(AllCurrenciesModuleInput.self) { resolver in
            let presenter = AllCurrenciesPresenter()
            let viewController: AllCurrenciesViewController! = resolver.resolve(AllCurrenciesViewController.self, argument: presenter)
            presenter.view = viewController
            presenter.interactor = resolver.resolve(AllCurrenciesInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(AllCurrenciesRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(AllCurrenciesViewController.self) { (_, presenter: AllCurrenciesPresenter) in
            let viewController: AllCurrenciesViewController! = R.storyboard.allCurrencies.allCurrenciesViewController()
            viewController.output = presenter
            return viewController
        }
    }
}
