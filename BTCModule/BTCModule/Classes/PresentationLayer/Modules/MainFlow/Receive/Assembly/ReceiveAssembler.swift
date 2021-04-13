//
//  ReceiveReceiveAssembler.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject
import UIKit

class ReceiveModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(ReceiveInteractor.self) { (resolver, presenter: ReceivePresenter) in
            let interactor = ReceiveInteractor()
            interactor.output = presenter
            interactor.output = presenter
            interactor.qrCodeService = resolver.resolve(QRCodeCoreComponent.self)
            interactor.snackBarsActionHandler = resolver.resolve(SnackBarsEventProxy.self)
            interactor.authService = resolver.resolve(BTCAuthService.self)
            
            return interactor
        }
        
        container.register(ReceiveRouter.self) { (resolver, viewController: ReceiveViewController) in
            let router = ReceiveRouter()
            router.view = viewController
            router.applicationAssembler = resolver.resolve(ApplicationAssembler.self)
            
            return router
        }
        
        container.register(ReceiveModuleInput.self) { resolver in
            let presenter = ReceivePresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(ReceiveViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping
            presenter.view = viewController
            presenter.interactor = resolver.resolve(ReceiveInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(ReceiveRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(ReceiveViewController.self) { (_, presenter: ReceivePresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.main.receiveViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
