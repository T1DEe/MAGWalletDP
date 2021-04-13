//
//  AuthRootAuthRootAssembler.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject
import UIKit

class AuthRootModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(AuthRootInteractor.self) { (resolver, presenter: AuthRootPresenter) in
            let interactor = AuthRootInteractor()
            interactor.output = presenter
            interactor.authEventHandler = resolver.resolve(AuthEventProxy.self)
            return interactor
        }
        
        container.register(AuthRootRouter.self) { (resolver, viewController: AuthRootViewController) in
            let router = AuthRootRouter()
            router.view = viewController
            router.applicationAssembler = resolver.resolve(ApplicationAssembler.self)
            
            return router
        }
        
        container.register(AuthRootModuleInput.self) { resolver in
            let presenter = AuthRootPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(AuthRootViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping
            presenter.view = viewController
            presenter.interactor = resolver.resolve(AuthRootInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(AuthRootRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(AuthRootViewController.self) { (_, presenter: AuthRootPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.authValid.authRootViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
