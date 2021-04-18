//
//  RootRootAssembler.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject
import UIKit

class RootModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(RootInteractor.self) { ( resolver, presenter: RootPresenter) in
            let interactor = RootInteractor()
            interactor.output = presenter
            interactor.authEventProxy = resolver.resolve(AuthEventProxy.self)
            interactor.authFacade = resolver.resolve(AuthFacade.self)
            interactor.publicDataService = resolver.resolve(PublicDataService.self)

            return interactor
        }

        container.register(RootRouter.self) { (_, viewController: RootViewController) in
            let router = RootRouter()
            router.view = viewController

            return router
        }

        container.register(RootModuleInput.self) { resolver in
            let presenter = RootPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(RootViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping

            presenter.view = viewController
            presenter.interactor = resolver.resolve(RootInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(RootRouter.self, argument: viewController)

            return presenter
        }

        container.register(RootViewController.self) { (_, presenter: RootPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.root.rootViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
