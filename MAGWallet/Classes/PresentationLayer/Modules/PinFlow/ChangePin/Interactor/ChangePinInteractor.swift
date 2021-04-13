//
//  ChangePinChangePinInteractor.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

class ChangePinInteractor {
    weak var output: ChangePinInteractorOutput!
    var authFacade: AuthFacade!
}

// MARK: - ChangePinInteractorInput

extension ChangePinInteractor: ChangePinInteractorInput {
    func validatePin(_ pin: String) -> Bool {
        return authFacade.verify(pin: pin)
    }

    func changePin(newPin: String, oldPin: String) {
        if let _ = try? authFacade.changePin(newPin: newPin, oldPin: oldPin) {
            output.didChangePin()
        } else {
            output.didFailChangePin()
        }
    }
}
