//
//  AccountsAccountsAssembler.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject
import UIKit

class AccountsModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(AccountsInteractor.self) { ( resolver, presenter: AccountsPresenter) in
            let interactor = AccountsInteractor()
            interactor.output = presenter
            interactor.authService = resolver.resolve(LTCAuthService.self)
            interactor.infoService = resolver.resolve(LTCUpdateService.self)
            interactor.settingsConfiguration = resolver.resolve(LTCSettingsConfiguration.self)
            interactor.snackBarsActionHandler = resolver.resolve(SnackBarsEventProxy.self)
            interactor.authActionHandler = resolver.resolve(AuthEventProxy.self)
            interactor.sensitiveDataActionHandler = resolver.resolve(SensitiveDataEventProxy.self)
            interactor.sensitiveDataKeysCore = resolver.resolve(SensitiveDataKeysCoreComponent.self)
            interactor.networkFacade = resolver.resolve(LTCNetworkFacade.self)
            interactor.notificationFacade = resolver.resolve(LTCNotificationFacade.self)
            
            return interactor
        }
        
        container.register(AccountsRouter.self) { (resolver, viewController: AccountsViewController) in
            let router = AccountsRouter()
            router.view = viewController
            router.applicationAssembler = resolver.resolve(ApplicationAssembler.self)

            return router
        }
        
        container.register(AccountsModuleInput.self) { resolver in
            let presenter = AccountsPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(AccountsViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping
            presenter.view = viewController
            presenter.interactor = resolver.resolve(AccountsInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(AccountsRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(AccountsViewController.self) { (_, presenter: AccountsPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.settings.accountsViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
