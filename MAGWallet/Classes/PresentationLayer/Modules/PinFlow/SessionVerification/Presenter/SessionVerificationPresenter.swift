//
//  PinVerificationSessionVerificationPresenter.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class SessionVerificationPresenter {
    weak var view: SessionVerificationViewInput!
    weak var output: SessionVerificationModuleOutput?

    var interactor: SessionVerificationInteractorInput!
    var router: SessionVerificationRouterInput!
    
    func showFingerpringDialogIfNeeded() {
        guard let biometry = interactor.getAvailableBiometry(), biometry != .none else {
            return
        }
        interactor.getPinFromTouchId()
    }
}

// MARK: - SessionVerificationModuleInput

extension SessionVerificationPresenter: SessionVerificationModuleInput {
    var viewController: UIViewController {
        return view.viewController
    }

    func presentPin(from: UIViewController) {
        view.present(fromViewController: from)
    }
}

// MARK: - SessionVerificationViewOutput

extension SessionVerificationPresenter: SessionVerificationViewOutput {
    func viewIsReady() {
        showFingerpringDialogIfNeeded()
    }

    func actionBack() {
        output?.actionDidCancelVerify()
    }

    func actionEnterPin(_ pin: String) {
        if interactor.verifyPin(pin) == true {
            output?.actionDidSessionVerified()
        } else {
            view.setupErrorState()
        }
    }
    
    func actionForgotPin() {
        router.presentForgotPin(output: self)
    }
}

// MARK: - SessionVerificationInteractorOutput

extension SessionVerificationPresenter: SessionVerificationInteractorOutput {
    func didGetPinFromBiometric(pin: String) {
        if interactor.verifyPin(pin) == true {
            output?.actionDidSessionVerified()
        } else {
            view.setupErrorState()
        }
    }
    
    func didFailGetPinFromBiometric(error: String) {
        print(error)
    }    
}

// MARK: - ForgotPinModuleOutput

extension SessionVerificationPresenter: ForgotPinModuleOutput {
    func actionClear() {
        output?.actionLogout()
    }
}
