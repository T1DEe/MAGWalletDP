//
//  WalletWithTokenWalletWithTokenAssembler.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject
import UIKit

class WalletWithTokenModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(WalletWithTokenInteractor.self) { ( resolver, presenter: WalletWithTokenPresenter) in
            let interactor = WalletWithTokenInteractor()
            interactor.output = presenter
            interactor.snackBarsActionHandler = resolver.resolve(SnackBarsEventProxy.self)
            interactor.settingsConfiguration = resolver.resolve(ETHSettingsConfiguration.self)
            interactor.authService = resolver.resolve(ETHAuthService.self)
            interactor.updateService = resolver.resolve(ETHUpdateService.self)
            interactor.ethUpdateDelegateHandler = resolver.resolve(ETHUpdateEventProxy.self)
            interactor.authEventDelegateHandler = resolver.resolve(AuthEventProxy.self)
            
            return interactor
        }
        
        container.register(WalletWithTokenRouter.self) { ( resolver, viewController: WalletWithTokenViewController) in
            let router = WalletWithTokenRouter()
            router.view = viewController
            router.applicationAssembler = resolver.resolve(ApplicationAssembler.self)
            return router
        }
        
        container.register(WalletModuleInput.self, name: "Token") { resolver in
            let presenter = WalletWithTokenPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(WalletWithTokenViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping
            presenter.view = viewController
            presenter.interactor = resolver.resolve(WalletWithTokenInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(WalletWithTokenRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(WalletWithTokenViewController.self) { (_, presenter: WalletWithTokenPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.main.walletWithTokenViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
