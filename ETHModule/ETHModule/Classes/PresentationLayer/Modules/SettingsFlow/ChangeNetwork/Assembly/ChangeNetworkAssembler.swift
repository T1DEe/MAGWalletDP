//
//  ChangeNetworkAssembler.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject
import UIKit

class ChangeNetworkModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(ChangeNetworkInteractor.self) { ( resolver, presenter: ChangeNetworkPresenter) in
            let interactor = ChangeNetworkInteractor()
            interactor.output = presenter
            interactor.networkFacade = resolver.resolve(ETHNetworkFacade.self)
            interactor.authActionHandler = resolver.resolve(AuthEventProxy.self)
            interactor.authService = resolver.resolve(ETHAuthService.self)
            
            return interactor
        }
        
        container.register(ChangeNetworkRouter.self) { (_, viewController: ChangeNetworkViewController) in
            let router = ChangeNetworkRouter()
            router.view = viewController
            
            return router
        }
        
        container.register(ChangeNetworkModuleInput.self) { resolver in
            let presenter = ChangeNetworkPresenter()
            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(ChangeNetworkViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping
            presenter.view = viewController
            presenter.interactor = resolver.resolve(ChangeNetworkInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(ChangeNetworkRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(ChangeNetworkViewController.self) { (_, presenter: ChangeNetworkPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.settings.changeNetworkViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
