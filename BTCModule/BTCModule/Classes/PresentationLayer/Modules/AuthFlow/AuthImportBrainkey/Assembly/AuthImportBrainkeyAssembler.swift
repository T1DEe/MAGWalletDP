//
//  AuthImportBrainkeyAuthImportBrainkeyAssembler.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject
import UIKit

class AuthImportBrainkeyModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(AuthImportBrainkeyInteractor.self) { ( resolver, presenter: AuthImportBrainkeyPresenter) in
            let interactor = AuthImportBrainkeyInteractor()
            interactor.output = presenter
            interactor.authService = resolver.resolve(BTCAuthService.self)
            interactor.snackBarsActionHandler = resolver.resolve(SnackBarsEventProxy.self)
            interactor.authActionHandler = resolver.resolve(AuthEventProxy.self)
            interactor.sensitiveDataActionHandler = resolver.resolve(SensitiveDataEventProxy.self)
            interactor.sensitiveDataKeysCore = resolver.resolve(SensitiveDataKeysCoreComponent.self)
            
            return interactor
        }
        
        container.register(AuthImportBrainkeyRouter.self) { (resolver, viewController: AuthImportBrainkeyViewController) in
            let router = AuthImportBrainkeyRouter()
            router.view = viewController
            router.applicationAssembler = resolver.resolve(ApplicationAssembler.self)
            
            return router
        }
        
        container.register(AuthImportBrainkeyModuleInput.self) { resolver in
            let presenter = AuthImportBrainkeyPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(AuthImportBrainkeyViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping
            presenter.view = viewController
            presenter.interactor = resolver.resolve(AuthImportBrainkeyInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(AuthImportBrainkeyRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(AuthImportBrainkeyViewController.self) { (_, presenter: AuthImportBrainkeyPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.auth.authImportBrainkeyViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
