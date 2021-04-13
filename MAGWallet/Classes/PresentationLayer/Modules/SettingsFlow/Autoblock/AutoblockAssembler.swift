//
//  AutoblockAutoblockAssembler.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject
import UIKit

class AutoblockModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(AutoblockInteractor.self) { (resolver, presenter: AutoblockPresenter) in
            let interactor = AutoblockInteractor()
            interactor.output = presenter
            interactor.sharedStorage = resolver.resolve(StorageCore.self, name: "Shared")
            interactor.preventExpireActionHandler = resolver.resolve(SessionExpireEventProxy.self)
            
            return interactor
        }
        
        container.register(AutoblockRouter.self) { (_, viewController: AutoblockViewController) in
            let router = AutoblockRouter()
            router.view = viewController
            
            return router
        }
        
        container.register(AutoblockModuleInput.self) { resolver in
            let presenter = AutoblockPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(AutoblockViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping

            presenter.view = viewController
            presenter.interactor = resolver.resolve(AutoblockInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(AutoblockRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(AutoblockViewController.self) { (_, presenter: AutoblockPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.settings.autoblockViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
