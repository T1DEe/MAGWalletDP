//
//  OneButtonSnackBarOneButtonSnackBarAssembler.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject
import UIKit

class OneButtonSnackBarModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(OneButtonSnackBarInteractor.self) { ( _, presenter: OneButtonSnackBarPresenter) in
            let interactor = OneButtonSnackBarInteractor()
            interactor.output = presenter
            
            return interactor
        }
        
        container.register(OneButtonSnackBarRouter.self) { (_, viewController: OneButtonSnackBarViewController) in
            let router = OneButtonSnackBarRouter()
            router.view = viewController
            
            return router
        }
        
        container.register(OneButtonSnackBarModuleInput.self) { resolver in
            let presenter = OneButtonSnackBarPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(OneButtonSnackBarViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping
            presenter.view = viewController
            presenter.interactor = resolver.resolve(OneButtonSnackBarInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(OneButtonSnackBarRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(OneButtonSnackBarViewController.self) { (_, presenter: OneButtonSnackBarPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.snackBar.oneButtonSnackBarViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
