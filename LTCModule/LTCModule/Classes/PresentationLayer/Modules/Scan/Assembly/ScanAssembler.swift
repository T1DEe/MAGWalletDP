//
//  ScanScanAssembler.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject
import UIKit

class ScanModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(ScanInteractor.self) { ( resolver, presenter: ScanPresenter) in
            let interactor = ScanInteractor()
            interactor.output = presenter
            interactor.snackBarsActionHandler = resolver.resolve(SnackBarsEventProxy.self)
            interactor.transferService = resolver.resolve(LTCTransferService.self)
            return interactor
        }
        
        container.register(ScanRouter.self) { ( resolver, viewController: ScanViewController) in
            let router = ScanRouter()
            router.view = viewController
            router.applicationAssembler = resolver.resolve(ApplicationAssembler.self)

            return router
        }
        
        container.register(ScanModuleInput.self) { resolver in
            let presenter = ScanPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(ScanViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping
            presenter.view = viewController
            presenter.interactor = resolver.resolve(ScanInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(ScanRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(ScanViewController.self) { (_, presenter: ScanPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.scan.scanViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
