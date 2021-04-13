//
//  MultiAccountsModuleAssembler.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject
import UIKit

class MultiAccountsModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(MultiAccountsInteractor.self) { ( resolver, presenter: MultiAccountsPresenter) in
            let interactor = MultiAccountsInteractor()
            interactor.output = presenter
            interactor.snackBarsActionHandler = resolver.resolve(SnackBarsEventProxy.self)
            interactor.flowNotificationFacade = resolver.resolve(FlowNotificationFacade.self)
            
            return interactor
        }
        
        container.register(MultiAccountsRouter.self) { (_, viewController: MultiAccountsViewController!) in
            let router = MultiAccountsRouter()
            router.view = viewController
            
            return router
        }
        
        container.register(MultiAccountsModuleInput.self) { resolver in
            let presenter = MultiAccountsPresenter()
            let viewController: MultiAccountsViewController! = resolver.resolve(MultiAccountsViewController.self, argument: presenter)
            presenter.view = viewController
            presenter.interactor = resolver.resolve(MultiAccountsInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(MultiAccountsRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(MultiAccountsViewController.self) { (_, presenter: MultiAccountsPresenter) in
            let viewController: MultiAccountsViewController! = R.storyboard.settings.multiAccountsViewController()
            viewController.output = presenter
            return viewController
        }
    }
}
