//
//  CreatePinCreatePinInteractor.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

class CreatePinInteractor {
    weak var output: CreatePinInteractorOutput!
    var authFacade: AuthFacade!
}

// MARK: - CreatePinInteractorInput

extension CreatePinInteractor: CreatePinInteractorInput {
    func checkPins(firstPin: String, secongPin: String) -> Bool {
        return firstPin == secongPin
    }

    func storePin(pin: String) {
        if let _ = try? authFacade.storePin(pin: pin) {
            output.didStorePin()
        } else {
            output.didFailStorePin()
        }
    }
}
