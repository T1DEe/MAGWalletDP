//
//  PinVerificationUnlockPinAssembler.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject
import UIKit

class UnlockPinModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(UnlockPinInteractor.self) { ( resolver, presenter: UnlockPinPresenter) in
            let interactor = UnlockPinInteractor()
            interactor.output = presenter
            interactor.authFacade = resolver.resolve(AuthFacade.self)
            interactor.fingerprintAccessService = resolver.resolve(FingerprintAccessService.self)

            return interactor
        }

        container.register(UnlockPinRouter.self) { (_, viewController: UnlockPinViewController) in
            let router = UnlockPinRouter()
            router.view = viewController

            return router
        }

        container.register(UnlockPinModuleInput.self) { resolver in
            let presenter = UnlockPinPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(UnlockPinViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping

            presenter.view = viewController
            presenter.interactor = resolver.resolve(UnlockPinInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(UnlockPinRouter.self, argument: viewController)

            return presenter
        }

        container.register(UnlockPinViewController.self) { (_, presenter: UnlockPinPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.pin.unlockPinViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
