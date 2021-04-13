//
//  LogoutLogoutAssembler.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject
import UIKit

class LogoutModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(LogoutInteractor.self) { (_, presenter: LogoutPresenter) in
            let interactor = LogoutInteractor()
            interactor.output = presenter
            return interactor
        }
        
        container.register(LogoutRouter.self) { (_, viewController: LogoutViewController) in
            let router = LogoutRouter()
            router.view = viewController
            
            return router
        }
        
        container.register(LogoutModuleInput.self) { resolver in
            let presenter = LogoutPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(LogoutViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping
            presenter.view = viewController
            presenter.interactor = resolver.resolve(LogoutInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(LogoutRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(LogoutViewController.self) { (_, presenter: LogoutPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.settings.logoutViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
