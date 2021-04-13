//
//  SplashSplashAssembler.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject
import UIKit

class SplashModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(SplashInteractor.self) { ( _, presenter: SplashPresenter) in
            let interactor = SplashInteractor()
            interactor.output = presenter

            return interactor
        }

        container.register(SplashRouter.self) { (_, viewController: SplashViewController) in
            let router = SplashRouter()
            router.view = viewController

            return router
        }

        container.register(SplashModuleInput.self) { resolver in
            let presenter = SplashPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(SplashViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping

            presenter.view = viewController
            presenter.interactor = resolver.resolve(SplashInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(SplashRouter.self, argument: viewController)

            return presenter
        }

        container.register(SplashViewController.self) { (_, presenter: SplashPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.splash.splashViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
