//
//  ButtonSnackBarButtonSnackBarAssembler.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject
import UIKit

class ButtonSnackBarModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(ButtonSnackBarInteractor.self) { ( _, presenter: ButtonSnackBarPresenter) in
            let interactor = ButtonSnackBarInteractor()
            interactor.output = presenter
            
            return interactor
        }
        
        container.register(ButtonSnackBarRouter.self) { ( _, viewController: ButtonSnackBarViewController) in
            let router = ButtonSnackBarRouter()
            router.view = viewController
            
            return router
        }
        
        container.register(ButtonSnackBarModuleInput.self) { resolver in
            let presenter = ButtonSnackBarPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(ButtonSnackBarViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping

            presenter.view = viewController
            presenter.interactor = resolver.resolve(ButtonSnackBarInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(ButtonSnackBarRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(ButtonSnackBarViewController.self) { ( _, presenter: ButtonSnackBarPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.snackBar.buttonSnackBarViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
