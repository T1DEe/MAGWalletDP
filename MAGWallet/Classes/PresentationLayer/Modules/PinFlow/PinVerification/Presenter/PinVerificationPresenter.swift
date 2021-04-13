//
//  PinVerificationPinVerificationPresenter.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class PinVerificationPresenter {
    weak var view: PinVerificationViewInput!
    weak var output: PinVerificationModuleOutput?

    var interactor: PinVerificationInteractorInput!
    var router: PinVerificationRouterInput!
        
    func showFingerpringDialogIfNeeded() {
        guard let biometry = interactor.getAvailableBiometry(), biometry != .none else {
            return
        }
        interactor.getPinFromTouchId()
    }
}

// MARK: - PinVerificationModuleInput

extension PinVerificationPresenter: PinVerificationModuleInput {
    var viewController: UIViewController {
        return view.viewController
    }

    func presentPin(from: UIViewController) {
        view.present(fromViewController: from)
    }
}

// MARK: - PinVerificationViewOutput

extension PinVerificationPresenter: PinVerificationViewOutput {
    func viewIsReady() {
        showFingerpringDialogIfNeeded()
    }

    func actionBack() {
        output?.actionCancelVerify()
    }

    func actionEnterPin(_ pin: String) {
        if interactor.verifyPin(pin) == true {
            output?.actionDidVerifyPin()
        } else {
            view.setupErrorState()
        }
    }
    
    func actionForgotPin() {
        router.presentForgotPin(output: self)
    }
}

// MARK: - PinVerificationInteractorOutput

extension PinVerificationPresenter: PinVerificationInteractorOutput {
    func didGetPinFromBiometric(pin: String) {
        if interactor.verifyPin(pin) == true {
            output?.actionDidVerifyPin()
        } else {
            view.setupErrorState()
        }
    }
    
    func didFailGetPinFromBiometric(error: String) {
        print(error)
    }
}

// MARK: - ForgotPinModuleOutput

extension PinVerificationPresenter: ForgotPinModuleOutput {
    func actionClear() {
        output?.actionLogout()
    }
}
