//
//  MainRoutingMainRoutingAssembler.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject
import UIKit

class MainRoutingModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(MainRoutingInteractor.self) { ( resolver, presenter: MainRoutingPresenter) in
            let interactor = MainRoutingInteractor()
            interactor.output = presenter
            interactor.authFacade = resolver.resolve(AuthFacade.self)
            interactor.sensitiveDataService = resolver.resolve(SensitiveDataService.self)
            interactor.authActionHandler = resolver.resolve(AuthEventProxy.self)
            interactor.preventExpireActionHandler = resolver.resolve(SessionExpireEventProxy.self)
            interactor.sessionTimeoutDelegateHandler = resolver.resolve(SessionExpireEventProxy.self)
            interactor.snackBarsHandler = resolver.resolve(SnackBarsEventProxy.self)
            interactor.flowNotificationFacade = resolver.resolve(FlowNotificationFacade.self)
            interactor.reachabilityActionHandler = resolver.resolve(ReachabilityEventProxy.self)
            interactor.firebaseActionHandler = resolver.resolve(FirebaseTokenEventProxy.self)
            interactor.firebaseService = resolver.resolve(FirebaseService.self)
            
            return interactor
        }
        
        container.register(MainRoutingRouter.self) { (_, viewController: MainRoutingViewController) in
            let router = MainRoutingRouter()
            router.view = viewController

            return router
        }
        
        container.register(MainRoutingModuleInput.self) { resolver in
            let presenter = MainRoutingPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(MainRoutingViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping
            presenter.view = viewController
            presenter.interactor = resolver.resolve(MainRoutingInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(MainRoutingRouter.self, argument: viewController)

            return presenter
        }

        container.register(MainRoutingViewController.self) { (_, presenter: MainRoutingPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.mainRouting.mainRoutingViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
