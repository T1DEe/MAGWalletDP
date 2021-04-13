//
//  AuthCreateAndCopyAuthCreateAndCopyAssembler.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject
import UIKit

class AuthCreateAndCopyModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(AuthCreateAndCopyInteractor.self) { ( resolver, presenter: AuthCreateAndCopyPresenter) in
            let interactor = AuthCreateAndCopyInteractor()
            interactor.output = presenter
            interactor.authService = resolver.resolve(LTCAuthService.self)
            interactor.snackBarsActionHandler = resolver.resolve(SnackBarsEventProxy.self)
            interactor.authActionHandler = resolver.resolve(AuthEventProxy.self)
            interactor.sensitiveDataActionHandler = resolver.resolve(SensitiveDataEventProxy.self)
            interactor.sensitiveDataKeysCore = resolver.resolve(SensitiveDataKeysCoreComponent.self)
            interactor.notificationFacade = resolver.resolve(LTCNotificationFacade.self)
            
            return interactor
        }
        
        container.register(AuthCreateAndCopyRouter.self) { (resolver, viewController: AuthCreateAndCopyViewController) in
            let router = AuthCreateAndCopyRouter()
            router.view = viewController
            router.applicationAssembler = resolver.resolve(ApplicationAssembler.self)
            
            return router
        }
        
        container.register(AuthCreateAndCopyModuleInput.self) { resolver in
            let presenter = AuthCreateAndCopyPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(AuthCreateAndCopyViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping
            presenter.view = viewController
            presenter.interactor = resolver.resolve(AuthCreateAndCopyInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(AuthCreateAndCopyRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(AuthCreateAndCopyViewController.self) { (_, presenter: AuthCreateAndCopyPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.auth.authCreateAndCopyViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
