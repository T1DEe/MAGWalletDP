//
//  AuthFacadeImp.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule

final class AuthFacadeImp: AuthFacade {
    var protectedStorage: StorageCore!
    var sensitiveDataService: SensitiveDataService!
    var fingerprintAccessService: FingerprintAccessService!
    var cryptoCore: CryptoCoreComponent!
    
    var hashOfPin: String? {
        return protectedStorage.get(key: Constants.Keys.pinHash)
    }
    
    func changePin(newPin: String, oldPin: String) throws {
        try sensitiveDataService.redecryptSensitiveData(newPass: newPin, oldPass: oldPin)
        try storePin(pin: newPin)
    }
    
    func verify(pin: String) -> Bool {
        return cryptoCore.hash(string: pin) == hashOfPin
    }
    
    func storePin(pin: String) throws {
        let pinHash = cryptoCore.hash(string: pin)
        fingerprintAccessService.setFingerprintString(string: pin, result: nil)
        try protectedStorage.set(key: Constants.Keys.pinHash, value: pinHash)
    }
    
    func clear() {
        fingerprintAccessService.clear()
        protectedStorage.remove(key: Constants.Keys.pinHash)
        sensitiveDataService.clear()
    }
}
