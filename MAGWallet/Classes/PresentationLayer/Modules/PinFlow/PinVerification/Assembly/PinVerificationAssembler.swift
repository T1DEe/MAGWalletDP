//
//  PinVerificationPinVerificationAssembler.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject
import UIKit

class PinVerificationModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(PinVerificationInteractor.self) { ( resolver, presenter: PinVerificationPresenter) in
            let interactor = PinVerificationInteractor()
            interactor.output = presenter
            interactor.authFacade = resolver.resolve(AuthFacade.self)
            interactor.fingerprintAccessService = resolver.resolve(FingerprintAccessService.self)

            return interactor
        }

        container.register(PinVerificationRouter.self) { (_, viewController: PinVerificationViewController) in
            let router = PinVerificationRouter()
            router.view = viewController

            return router
        }

        container.register(PinVerificationModuleInput.self) { resolver in
            let presenter = PinVerificationPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(PinVerificationViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping

            presenter.view = viewController
            presenter.interactor = resolver.resolve(PinVerificationInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(PinVerificationRouter.self, argument: viewController)

            return presenter
        }

        container.register(PinVerificationViewController.self) { (_, presenter: PinVerificationPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.pin.pinVerificationViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
