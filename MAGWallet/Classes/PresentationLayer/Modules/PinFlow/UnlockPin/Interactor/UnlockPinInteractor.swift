//
//  PinVerificationUnlockPinInteractor.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

class UnlockPinInteractor {
    weak var output: UnlockPinInteractorOutput!
    var authFacade: AuthFacade!
    var fingerprintAccessService: FingerprintAccessService!
}

// MARK: - UnlockPinInteractorInput

extension UnlockPinInteractor: UnlockPinInteractorInput {
    func getPinFromTouchId() {
        fingerprintAccessService.fingerprintString { [weak self] handler in
            do {
                let pin = try handler()
                DispatchQueue.main.async {
                    self?.output.didGetPinFromBiometric(pin: pin)
                }
            } catch let error {
                DispatchQueue.main.async {
                    self?.output.didFailGetPinFromBiometric(error: error.localizedDescription)
                }
            }
        }
    }
    
    func getAvailableBiometry() -> BiometryType? {
        guard fingerprintAccessService.isEnabled, fingerprintAccessService.isOn else {
            return nil
        }
        return fingerprintAccessService.biometryType
    }
    
    func verifyPin(_ pin: String) -> Bool {
        return authFacade.verify(pin: pin)
    }
}
