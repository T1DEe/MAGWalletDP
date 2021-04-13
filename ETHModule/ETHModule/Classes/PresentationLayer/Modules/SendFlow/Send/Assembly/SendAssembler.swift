//
//  SendAssembler.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject
import UIKit

class SendModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(SendInteractor.self) { (resolver, presenter: SendPresenter) in
            let interactor = SendInteractor()
            interactor.output = presenter
            interactor.snackBarsActionHandler = resolver.resolve(SnackBarsEventProxy.self)
            interactor.sensitiveDataActionHandler = resolver.resolve(SensitiveDataEventProxy.self)
            interactor.sensitiveDataKeysCore = resolver.resolve(SensitiveDataKeysCoreComponent.self)
            interactor.settingsConfiguration = resolver.resolve(ETHSettingsConfiguration.self)
            interactor.authService = resolver.resolve(ETHAuthService.self)
            interactor.transferService = resolver.resolve(ETHTransferService.self)
            interactor.updateService = resolver.resolve(ETHUpdateService.self)
            
            return interactor
        }
        
        container.register(SendRouter.self) { (resolver, viewController: SendViewController) in
            let router = SendRouter()
            router.view = viewController
            router.applicationAssempler = resolver.resolve(ApplicationAssembler.self)
            
            return router
        }
        
        container.register(SendModuleInput.self) { resolver in
            let presenter = SendPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(SendViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping
            presenter.view = viewController
            presenter.interactor = resolver.resolve(SendInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(SendRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(SendViewController.self) { (_, presenter: SendPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.send.sendViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
