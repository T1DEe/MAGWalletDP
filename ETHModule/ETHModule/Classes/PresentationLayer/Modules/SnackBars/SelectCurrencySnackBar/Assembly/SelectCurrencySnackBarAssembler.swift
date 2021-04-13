//
//  SelectCurrencySnackBarAssembler.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject
import UIKit

class SelectCurrencySnackBarModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(SelectCurrencySnackBarInteractor.self) { ( _, presenter: SelectCurrencySnackBarPresenter) in
            let interactor = SelectCurrencySnackBarInteractor()
            interactor.output = presenter
            
            return interactor
        }
        
        container.register(SelectCurrencySnackBarRouter.self) { (_, viewController: SelectCurrencySnackBarViewController) in
            let router = SelectCurrencySnackBarRouter()
            router.view = viewController
            
            return router
        }
        
        container.register(SelectCurrencySnackBarModuleInput.self) { resolver in
            let presenter = SelectCurrencySnackBarPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(SelectCurrencySnackBarViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping

            presenter.view = viewController
            presenter.interactor = resolver.resolve(SelectCurrencySnackBarInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(SelectCurrencySnackBarRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(SelectCurrencySnackBarViewController.self) { (_, presenter: SelectCurrencySnackBarPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.snackBar.selectCurrencySnackBarViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
