//
//  ChangePinChangePinAssembler.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject
import UIKit

class ChangePinModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(ChangePinInteractor.self) { ( resolver, presenter: ChangePinPresenter) in
            let interactor = ChangePinInteractor()
            interactor.output = presenter
            interactor.authFacade = resolver.resolve(AuthFacade.self)

            return interactor
        }

        container.register(ChangePinRouter.self) { (_, viewController: ChangePinViewController) in
            let router = ChangePinRouter()
            router.view = viewController

            return router
        }

        container.register(ChangePinModuleInput.self) { resolver in
            let presenter = ChangePinPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(ChangePinViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping

            presenter.view = viewController
            presenter.interactor = resolver.resolve(ChangePinInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(ChangePinRouter.self, argument: viewController)

            return presenter
        }

        container.register(ChangePinViewController.self) { (_, presenter: ChangePinPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.pin.changePinViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
