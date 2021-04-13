//
//  HistoryDetailsHistoryDetailsAssembler.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject
import UIKit

class HistoryDetailsModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(HistoryDetailsInteractor.self) { (resolver, presenter: HistoryDetailsPresenter) in
            let interactor = HistoryDetailsInteractor()
            interactor.output = presenter
            interactor.ltcAuthFacade = resolver.resolve(LTCAuthService.self)
            interactor.networkFacade = resolver.resolve(LTCNetworkFacade.self)
            
            return interactor
        }
        
        container.register(HistoryDetailsRouter.self) { (_, viewController: HistoryDetailsViewController) in
            let router = HistoryDetailsRouter()
            router.view = viewController
            
            return router
        }
        
        container.register(HistoryDetailsModuleInput.self) { resolver in
            let presenter = HistoryDetailsPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(HistoryDetailsViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping
            presenter.view = viewController
            presenter.interactor = resolver.resolve(HistoryDetailsInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(HistoryDetailsRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(HistoryDetailsViewController.self) { (_, presenter: HistoryDetailsPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.historyDetails.historyDetailsViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
