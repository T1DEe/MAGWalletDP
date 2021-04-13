//
//  SettingsSettingsAssembler.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject
import UIKit

class SettingsModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(SettingsInteractor.self) { (resolver, presenter: SettingsPresenter) in
            let interactor = SettingsInteractor()
            interactor.output = presenter
            interactor.fingerprintAccessService = resolver.resolve(FingerprintAccessService.self)
            interactor.flowNotificationFacade = resolver.resolve(FlowNotificationFacade.self)
            interactor.snackBarsActionHandler = resolver.resolve(SnackBarsEventProxy.self)
            return interactor
        }
        
        container.register(SettingsRouter.self) { ( _, viewController: SettingsViewController) in
            let router = SettingsRouter()
            router.view = viewController
            return router
        }
        
        container.register(SettingsModuleInput.self) { resolver in
            let presenter = SettingsPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(SettingsViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping
            presenter.view = viewController
            presenter.interactor = resolver.resolve(SettingsInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(SettingsRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(SettingsViewController.self) { (_, presenter: SettingsPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.settings.settingsViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
