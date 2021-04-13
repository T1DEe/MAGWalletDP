//
//  SplashSplashPresenter.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class SplashPresenter {
    weak var view: SplashViewInput!
    weak var output: SplashModuleOutput?

    var interactor: SplashInteractorInput!
    var router: SplashRouterInput!
}

// MARK: - SplashModuleInput

extension SplashPresenter: SplashModuleInput {
    var viewController: UIViewController {
        return view.viewController
    }
}

// MARK: - SplashViewOutput

extension SplashPresenter: SplashViewOutput {
    func viewIsReady() {
    }
}

// MARK: - SplashInteractorOutput

extension SplashPresenter: SplashInteractorOutput {
}
