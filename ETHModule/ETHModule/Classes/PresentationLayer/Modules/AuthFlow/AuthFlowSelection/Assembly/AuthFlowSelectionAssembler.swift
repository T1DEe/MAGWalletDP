//
//  AuthFlowSelectionAuthFlowSelectionAssembler.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject
import UIKit

class AuthFlowSelectionModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(AuthFlowSelectionInteractor.self) { ( _, presenter: AuthFlowSelectionPresenter) in
            let interactor = AuthFlowSelectionInteractor()
            interactor.output = presenter
            
            return interactor
        }
        
        container.register(AuthFlowSelectionRouter.self) { (resolver, viewController: AuthFlowSelectionViewController) in
            let router = AuthFlowSelectionRouter()
            router.view = viewController
            router.applicationAssembler = resolver.resolve(ApplicationAssembler.self)
            
            return router
        }
        
        container.register(AuthFlowSelectionModuleInput.self) { resolver in
            let presenter = AuthFlowSelectionPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(AuthFlowSelectionViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping
            presenter.view = viewController
            presenter.interactor = resolver.resolve(AuthFlowSelectionInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(AuthFlowSelectionRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(AuthFlowSelectionViewController.self) { (_, presenter: AuthFlowSelectionPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.authValid.authFlowSelectionViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
