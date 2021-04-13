//
//  ApplicationModuleModuleAssembler.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject
import UIKit

class ApplicationModuleModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(ApplicationModuleInteractor.self) { (resolver, presenter: ApplicationModulePresenter) in
            let interactor = ApplicationModuleInteractor()
            interactor.output = presenter
            interactor.snackBarsHandler = resolver.resolve(SnackBarsEventProxy.self)
            interactor.sensitiveDataDelegateHandler = resolver.resolve(SensitiveDataEventProxy.self)
            interactor.sensitiveDataKeysCore = resolver.resolve(SensitiveDataKeysCoreComponent.self)
            interactor.settingsConfiguration = resolver.resolve(LTCSettingsConfiguration.self)
            interactor.authService = resolver.resolve(LTCAuthService.self)
            interactor.updateService = resolver.resolve(LTCUpdateService.self)
            interactor.applicationAssembler = resolver.resolve(ApplicationAssembler.self)
            interactor.networkFacade = resolver.resolve(LTCNetworkFacade.self)
            interactor.notificationFacade = resolver.resolve(LTCNotificationFacade.self)

            return interactor
        }
        
        container.register(ApplicationModuleRouter.self) { resolver in
            let router = ApplicationModuleRouter()
            router.applicationAssembler = resolver.resolve(ApplicationAssembler.self)
            return router
        }
        
        container.register(ApplicationModuleModuleInput.self) { resolver in
            let presenter = ApplicationModulePresenter()
            presenter.interactor = resolver.resolve(ApplicationModuleInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(ApplicationModuleRouter.self)
            return presenter
        }
    }
}
