//
//  CreatePinCreatePinPresenter.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class CreatePinPresenter {
    weak var view: CreatePinViewInput!
    weak var output: CreatePinModuleOutput?

    var interactor: CreatePinInteractorInput!
    var router: CreatePinRouterInput!
}

// MARK: - CreatePinModuleInput

extension CreatePinPresenter: CreatePinModuleInput {
    var viewController: UIViewController {
        return view.viewController
    }

    func presentCreatePin(from: UIViewController) {
        view.present(fromViewController: from)
    }
}

// MARK: - CreatePinViewOutput

extension CreatePinPresenter: CreatePinViewOutput {
    func viewIsReady() {
        view.setupInitialState()
    }

    func actionBack() {
        view.setupInitialState()
    }

    func actionEnterPin(_ pin: String, _ repeatedPin: String) {
        if interactor.checkPins(firstPin: pin, secongPin: repeatedPin) == true {
            interactor.storePin(pin: pin)
        } else {
            view.setupErrorState()
        }
    }
}

// MARK: - CreatePinInteractorOutput

extension CreatePinPresenter: CreatePinInteractorOutput {
    func didStorePin() {
        output?.didCreatePin()
    }

    func didFailStorePin() {
        view.setupErrorState()
    }
}
