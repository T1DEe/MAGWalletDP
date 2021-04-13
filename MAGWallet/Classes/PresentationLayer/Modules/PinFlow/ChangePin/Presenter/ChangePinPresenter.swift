//
//  ChangePinChangePinPresenter.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

private enum ChangePinProcess {
    case old
    case new
    case repeateNew
}

class ChangePinPresenter {
    weak var view: ChangePinViewInput!
    weak var output: ChangePinModuleOutput?

    var interactor: ChangePinInteractorInput!
    var router: ChangePinRouterInput!

    private var state: ChangePinProcess = .old
    private var newPin: String?
    private var oldPin: String?

    private func processOld(pin: String) {
        if interactor.validatePin(pin) {
            oldPin = pin
            state = .new
            updateView()
        } else {
            loseScore()
        }
    }

    private func processNew(pin: String) {
        newPin = pin
        state = .repeateNew
        updateView()
    }

    private func loseScore() {
        state = .old
        newPin = nil

        updateView()
    }

    private func skipScore() {
        oldPin = nil
        newPin = nil
        state = .old
        view.setupInitialState()
    }

    private func processRepeateNew(pin: String) {
        if pin == newPin {
            changePin()
        } else {
            loseScore()
        }
    }

    private func changePin() {
        guard let oldPin = oldPin, let newPin = newPin else {
            loseScore()
            return
        }
        interactor.changePin(newPin: newPin, oldPin: oldPin)
    }

    private func exit() {
        output?.didCancelChangePin()
    }

    // MARK: - Update
    private func updateView() {
        switch state {
        case .old:
            view.setupFailedStateAndOld()

        case .new:
            view.setupNewStep()

        case .repeateNew:
            view.setupRepeateNewStep()
        }
    }
}

// MARK: - ChangePinModuleInput

extension ChangePinPresenter: ChangePinModuleInput {
    var viewController: UIViewController {
        return view.viewController
    }

    func presentChangePin(from: UIViewController) {
    }
}

// MARK: - ChangePinViewOutput

extension ChangePinPresenter: ChangePinViewOutput {
    func viewIsReady() {
        view.setupInitialState()
    }

    func actionBack() {
        exit()
    }

    func actionEnterPin(_ pin: String) {
        switch state {
        case .old:
            processOld(pin: pin)

        case .new:
            processNew(pin: pin)

        case .repeateNew:
            processRepeateNew(pin: pin)
        }
    }
}

// MARK: - ChangePinInteractorOutput

extension ChangePinPresenter: ChangePinInteractorOutput {
    func needDismiss() {
        view.dissmiss()
    }

    func didChangePin() {
        output?.didChangePin()
    }

    func didFailChangePin() {
    }
}
