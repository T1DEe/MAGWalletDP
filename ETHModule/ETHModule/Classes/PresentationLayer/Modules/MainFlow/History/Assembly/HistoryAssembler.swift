//
//  HistoryHistoryAssembler.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject
import UIKit

class HistoryModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(HistoryInteractor.self) { (resolver, presenter: HistoryPresenter) in
            let interactor = HistoryInteractor()
            interactor.output = presenter
            interactor.ethUpdateFacade = resolver.resolve(ETHUpdateService.self)
            interactor.ethAuthFacade = resolver.resolve(ETHAuthService.self)
            interactor.settingsConfiguration = resolver.resolve(ETHSettingsConfiguration.self)
            interactor.ethUpdateActionHandler = resolver.resolve(ETHUpdateEventProxy.self)
            interactor.authEventDelegateHandler = resolver.resolve(AuthEventProxy.self)
            interactor.snackBarsActionHandler = resolver.resolve(SnackBarsEventProxy.self)
            
            return interactor
        }
        
        container.register(HistoryRouter.self) { ( resolver, viewController: HistoryViewController) in
            let router = HistoryRouter()
            router.view = viewController
            router.applicationAssempler = resolver.resolve(ApplicationAssembler.self)
            return router
        }
        
        container.register(HistoryModuleInput.self) { resolver in
            let presenter = HistoryPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(HistoryViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping
            presenter.view = viewController
            presenter.interactor = resolver.resolve(HistoryInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(HistoryRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(HistoryViewController.self) { (_, presenter: HistoryPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.main.historyViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
