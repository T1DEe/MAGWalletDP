//
//  PinVerificationSessionVerificationAssembler.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject
import UIKit

class SessionVerificationModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(SessionVerificationInteractor.self) { ( resolver, presenter: SessionVerificationPresenter) in
            let interactor = SessionVerificationInteractor()
            interactor.output = presenter
            interactor.authFacade = resolver.resolve(AuthFacade.self)
            interactor.fingerprintAccessService = resolver.resolve(FingerprintAccessService.self)

            return interactor
        }

        container.register(SessionVerificationRouter.self) { (_, viewController: SessionVerificationViewController) in
            let router = SessionVerificationRouter()
            router.view = viewController

            return router
        }

        container.register(SessionVerificationModuleInput.self) { resolver in
            let presenter = SessionVerificationPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(SessionVerificationViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping

            presenter.view = viewController
            presenter.interactor = resolver.resolve(SessionVerificationInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(SessionVerificationRouter.self, argument: viewController)

            return presenter
        }

        container.register(SessionVerificationViewController.self) { (_, presenter: SessionVerificationPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.pin.sessionVerificationViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
