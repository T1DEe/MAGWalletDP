//
//  CreatePinCreatePinAssembler.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject
import UIKit

class CreatePinModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(CreatePinInteractor.self) { ( resolver, presenter: CreatePinPresenter) in
            let interactor = CreatePinInteractor()
            interactor.output = presenter
            interactor.authFacade = resolver.resolve(AuthFacade.self)

            return interactor
        }

        container.register(CreatePinRouter.self) { (_, viewController: CreatePinViewController) in
            let router = CreatePinRouter()
            router.view = viewController

            return router
        }

        container.register(CreatePinModuleInput.self) { resolver in
            let presenter = CreatePinPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(CreatePinViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping

            presenter.view = viewController
            presenter.interactor = resolver.resolve(CreatePinInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(CreatePinRouter.self, argument: viewController)

            return presenter
        }

        container.register(CreatePinViewController.self) { (_, presenter: CreatePinPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.pin.createPinViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
