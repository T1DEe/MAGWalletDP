//
//  PinVerificationUnlockPinPresenter.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class UnlockPinPresenter {
    weak var view: UnlockPinViewInput!
    weak var output: UnlockPinModuleOutput?

    var interactor: UnlockPinInteractorInput!
    var router: UnlockPinRouterInput!
        
    func showFingerpringDialogIfNeeded() {
        guard let biometry = interactor.getAvailableBiometry(), biometry != .none else {
            return
        }
        interactor.getPinFromTouchId()
    }
}

// MARK: - UnlockPinModuleInput

extension UnlockPinPresenter: UnlockPinModuleInput {
    var viewController: UIViewController {
        return view.viewController
    }

    func presentPin(from: UIViewController) {
        view.present(fromViewController: from)
    }
}

// MARK: - UnlockPinViewOutput

extension UnlockPinPresenter: UnlockPinViewOutput {
    func viewIsReady() {
        showFingerpringDialogIfNeeded()
    }

    func actionBack() {
        output?.actionCancelVerify()
    }

    func actionEnterPin(_ pin: String) {
        if interactor.verifyPin(pin) == true {
            output?.actionDidVerifyPin(pin: pin)
        } else {
            view.setupErrorState()
        }
    }
}

// MARK: - UnlockPinInteractorOutput

extension UnlockPinPresenter: UnlockPinInteractorOutput {
    func didGetPinFromBiometric(pin: String) {
        if interactor.verifyPin(pin) == true {
            output?.actionDidVerifyPin(pin: pin)
        } else {
            view.setupErrorState()
        }
    }
    
    func didFailGetPinFromBiometric(error: String) {
        print(error)
    }
}
