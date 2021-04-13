//
//  SnackBarRootAssembler.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject
import UIKit

class SnackBarRootModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(SnackBarRootInteractor.self) { (_, presenter: SnackBarRootPresenter) in
            let interactor = SnackBarRootInteractor()
            interactor.output = presenter
            //interactor.globalSnackBarsActionHandler = resolver.resolve(SnackBarEventProxy.self)
            
            return interactor
        }
        
        container.register(SnackBarRootRouter.self) { ( _, viewController: SnackBarRootViewController) in
            let router = SnackBarRootRouter()
            router.view = viewController
            
            return router
        }
        
        container.register(SnackBarRootModuleInput.self) { resolver in
            let presenter = SnackBarRootPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(SnackBarRootViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping

            presenter.view = viewController
            presenter.interactor = resolver.resolve(SnackBarRootInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(SnackBarRootRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(SnackBarRootViewController.self) { ( _, presenter: SnackBarRootPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController: SnackBarRootViewController! = R.storyboard.snackBarsRoot.snackBarRootViewController()
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
