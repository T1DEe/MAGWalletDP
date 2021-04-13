//
//  AuthRootAuthRootInteractor.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

class AuthRootInteractor {
    weak var output: AuthRootInteractorOutput!
    var authEventHandler: AuthEventDelegateHandler!
}

// MARK: - AuthRootInteractorInput

extension AuthRootInteractor: AuthRootInteractorInput {
    func bindToEvents() {
        authEventHandler.delegate = self
    }
}

// MARK: - AuthEventProxy

extension AuthRootInteractor: AuthEventDelegate {
    func didAuthCompleted() {
        output.didAuthComplete()
    }
    
    func didNewWalletSelected() {
    }
}
