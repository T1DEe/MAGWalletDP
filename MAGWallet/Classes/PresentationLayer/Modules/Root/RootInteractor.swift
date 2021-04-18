//
//  RootRootInteractor.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

class RootInteractor {
    weak var output: RootInteractorOutput!
    var authEventProxy: AuthEventDelegateHandler!
    var authFacade: AuthFacade!
    var publicDataService: PublicDataService!
    let splashTime = Constants.Settings.timeoutIntervalForSplash
}

// MARK: - RootInteractorInput

extension RootInteractor: RootInteractorInput {
    func bindToEvents() {
        authEventProxy.delegate = self
    }

    func startCountingSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + splashTime) { [weak self] in
            self?.output.shoudShowAuth()
        }
    }

    func isAuthorized() -> Bool {
        return authFacade.hashOfPin != nil
    }
    
    func makeLogout() {
        authFacade.clear()                  //clear hash of pin and all secure data
        publicDataService.clear()           //clear all public data
        output.didLogout()
    }
}

extension RootInteractor: AuthEventDelegate {
    func didLogoutAction() {
        makeLogout()
    }

    func didAuthAction() {
        output.didAuth()
    }
}
