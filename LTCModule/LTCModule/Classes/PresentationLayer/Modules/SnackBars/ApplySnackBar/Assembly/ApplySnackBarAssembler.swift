//
//  ApplySnackBarApplySnackBarAssembler.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject
import UIKit

class ApplySnackBarModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(ApplySnackBarInteractor.self) { ( _, presenter: ApplySnackBarPresenter) in
            let interactor = ApplySnackBarInteractor()
            interactor.output = presenter
            
            return interactor
        }
        
        container.register(ApplySnackBarRouter.self) { (_, viewController: ApplySnackBarViewController) in
            let router = ApplySnackBarRouter()
            router.view = viewController
            
            return router
        }
        
        container.register(ApplySnackBarModuleInput.self) { resolver in
            let presenter = ApplySnackBarPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(ApplySnackBarViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping
            presenter.view = viewController
            presenter.interactor = resolver.resolve(ApplySnackBarInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(ApplySnackBarRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(ApplySnackBarViewController.self) { (_, presenter: ApplySnackBarPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.snackBars.applySnackBarViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
