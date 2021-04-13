//
//  WalletWalletAssembler.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject
import UIKit

class WalletModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(WalletInteractor.self) { (resolver, presenter: WalletPresenter) in
            let interactor = WalletInteractor()
            interactor.output = presenter
            interactor.authService = resolver.resolve(LTCAuthService.self)
            interactor.snackBarsActionHandler = resolver.resolve(SnackBarsEventProxy.self)
            interactor.updateService = resolver.resolve(LTCUpdateService.self)
            interactor.ltcUpdateDelegateHandler = resolver.resolve(LTCUpdateEventProxy.self)
            interactor.authEventDelegateHandler = resolver.resolve(AuthEventProxy.self)

            return interactor
        }
        
        container.register(WalletRouter.self) { (resolver, viewController: WalletViewController) in
            let router = WalletRouter()
            router.view = viewController
            router.applicationAssembler = resolver.resolve(ApplicationAssembler.self)
            return router
        }
        
        container.register(WalletModuleInput.self) { resolver in
            let presenter = WalletPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(WalletViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping
            presenter.view = viewController
            presenter.interactor = resolver.resolve(WalletInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(WalletRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(WalletViewController.self) { (_, presenter: WalletPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.main.walletViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
