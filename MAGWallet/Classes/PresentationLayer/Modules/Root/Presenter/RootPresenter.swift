//
//  RootRootPresenter.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

enum AuthState {
    case unauth
    case auth
}

class RootPresenter {
    weak var view: RootViewInput!
    weak var output: RootModuleOutput?

    var interactor: RootInteractorInput!
    var router: RootRouterInput!

    var authState: AuthState = .unauth

    fileprivate func setupSplash() {
        router.presentSplash()
        interactor.startCountingSplash()
    }
}

// MARK: - RootModuleInput

extension RootPresenter: RootModuleInput {
    var viewController: UIViewController {
        return view.viewController
    }
}

// MARK: - RootViewOutput

extension RootPresenter: RootViewOutput {
    func viewIsReady() {
        setupSplash()
        interactor.bindToEvents()
    }

    func setupAuthStack() {
        if interactor.isAuthorized() {
            router.presentPinVerification(output: self)
        } else {
            router.presentCreatePin(output: self)
        }
    }
}

extension RootPresenter: CreatePinModuleOutput {
    func didCreatePin() {
        router.presentMain(output: self)
    }
}

extension RootPresenter: MainRoutingModuleOutput {
}

extension RootPresenter: PinVerificationModuleOutput {
    func actionDidVerifyPin() {
        router.presentMain(output: self)
    }
    
    func actionCancelVerify() {
    }
    
    func actionLogout() {
        interactor.makeLogout()
    }
}

// MARK: - RootInteractorOutput

extension RootPresenter: RootInteractorOutput {
    func didLogout() {
        authState = .unauth
        setupAuthStack()
    }

    func didAuth() {
        authState = .auth
        router.presentMain(output: self)
    }

    func networkDidChanged() {
        authState = .unauth
        setupAuthStack()
    }

    func shoudShowAuth() {
        setupAuthStack()
        authState = .unauth
    }
}
