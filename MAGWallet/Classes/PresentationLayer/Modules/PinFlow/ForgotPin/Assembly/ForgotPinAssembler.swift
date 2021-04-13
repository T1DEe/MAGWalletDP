//
//  ForgotPinAssembler.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject
import UIKit

class ForgotPinModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(ForgotPinInteractor.self) { ( _, presenter: ForgotPinPresenter) in
            let interactor = ForgotPinInteractor()
            interactor.output = presenter
            
            return interactor
        }
        
        container.register(ForgotPinRouter.self) { (_, viewController: ForgotPinViewController!) in
            let router = ForgotPinRouter()
            router.view = viewController
            
            return router
        }
        
        container.register(ForgotPinModuleInput.self) { resolver in
            let presenter = ForgotPinPresenter()
            let viewController: ForgotPinViewController! = resolver.resolve(ForgotPinViewController.self, argument: presenter)
            presenter.view = viewController
            presenter.interactor = resolver.resolve(ForgotPinInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(ForgotPinRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(ForgotPinViewController.self) { (_, presenter: ForgotPinPresenter) in
            let viewController: ForgotPinViewController! = R.storyboard.pin.forgotPinViewController()
            viewController.output = presenter
            return viewController
        }
    }
}
