//
//  MainMainAssembler.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject
import UIKit

class MainModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(MainInteractor.self) { ( resolver, presenter: MainPresenter) in
            let interactor = MainInteractor()
            interactor.output = presenter
            interactor.settingsConfiguration = resolver.resolve(LTCSettingsConfiguration.self)
            
            return interactor
        }
        
        container.register(MainRouter.self) { (resolver, viewController: MainViewController) in
            let router = MainRouter()
            router.view = viewController
            router.applicationAssempler = resolver.resolve(ApplicationAssembler.self)
            
            return router
        }
        
        container.register(MainModuleInput.self) { resolver in
            let presenter = MainPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(MainViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping
            presenter.view = viewController
            presenter.interactor = resolver.resolve(MainInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(MainRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(MainViewController.self) { (_, presenter: MainPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.main.mainViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
