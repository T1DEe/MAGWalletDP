//
//  ExportBrainkeyAssembler.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject
import UIKit

class ExportBrainkeyModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(ExportBrainkeyInteractor.self) { (resolver, presenter: ExportBrainkeyPresenter) in
            let interactor = ExportBrainkeyInteractor()
            interactor.output = presenter
            interactor.snackBarsActionHandler = resolver.resolve(SnackBarsEventProxy.self)
            return interactor
        }
        
        container.register(ExportBrainkeyRouter.self) { (resolver, viewController: ExportBrainkeyViewController) in
            let router = ExportBrainkeyRouter()
            router.view = viewController
            router.applicationAssembler = resolver.resolve(ApplicationAssembler.self)
            return router
        }
        
        container.register(ExportBrainkeyModuleInput.self) { resolver in
            let presenter = ExportBrainkeyPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(ExportBrainkeyViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping
            presenter.view = viewController
            presenter.interactor = resolver.resolve(ExportBrainkeyInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(ExportBrainkeyRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(ExportBrainkeyViewController.self) { (_, presenter: ExportBrainkeyPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.settings.exportBrainkeyViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
