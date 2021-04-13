//
//  FingerprintAccessServiceImp.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import KeychainAccess
import LocalAuthentication

public final class FingerprintAccessServiceImp: FingerprintAccessService {
    // swiftlint:disable force_unwrapping
    let keychain = Keychain(service: Bundle.main.bundleIdentifier!).accessibility(.whenUnlockedThisDeviceOnly)
    // swiftlint:enable force_unwrapping
    private var aIsOn: Bool?
    var completion : ((() throws -> String) -> Void)?
    var settersCompletion : ((() throws -> Void) -> Void)?
    var sharedStorage: StorageCore!

    public var isEnabled: Bool {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return true
        }

        return false
    }

    public var isOn: Bool {
        get {
            if aIsOn == nil {
                let isOn = (sharedStorage.get(key: Constants.SharedKeys.isFingerprintOn) ?? "true") == "true" ? true : false
                aIsOn = isOn
            }
            let bool: Bool! = aIsOn
            return bool
        }
        set {
            try? sharedStorage.set(key: Constants.SharedKeys.isFingerprintOn, value: String(newValue))
            aIsOn = newValue
        }
    }

    public var biometryType: BiometryType {
        if isTouchIdSupported() {
            return .touchId
        } else if isFaceIdSupported() {
            return .faceId
        }
        return .none
    }

    public func fingerprintString(result: @escaping (() throws -> String) -> Void) {
        completion = result

        if isOn == false {
            self.completion? { throw FingerprintError.noFingerprint }
            return
        }

        DispatchQueue.global().async { [unowned self] in
            do {
                let password = try self.keychain
                    .authenticationPrompt("")
                    .get(Constants.Keys.fingerprint)

                if let password = password {
                    self.completion? { password }
                } else {
                    self.completion? { throw FingerprintError.noFingerprint }
                }

                self.completion = nil
            } catch _ {
                self.completion? { throw FingerprintError.noFingerprint }
                self.completion = nil
            }
        }
    }

    public func setFingerprintString(string: String, result: ((() throws -> Void) -> Void)?) {
        settersCompletion = result

        DispatchQueue.global().async { [unowned self] in
            do {
                try self.keychain.remove(Constants.Keys.fingerprint)
                try self.keychain
                    .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .touchIDAny)
                    .set(string, key: Constants.Keys.fingerprint)

                self.settersCompletion? { }
                self.settersCompletion = nil
            } catch _ {
                self.settersCompletion? { throw FingerprintError.noFingerprint }
                self.settersCompletion = nil
            }
        }
    }

    fileprivate func isTouchIdSupported() -> Bool {
        let context = LAContext()
        if #available(iOS 11.0, *) {
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                return context.biometryType == .touchID
            }
        } else if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            return true
        }
        return false
    }

    fileprivate func isFaceIdSupported() -> Bool {
        let context = LAContext()
        if #available(iOS 11.0, *) {
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                return context.biometryType == .faceID
            }
        }
        return false
    }

    public func clear() {
        try? keychain.remove(Constants.Keys.fingerprint)
        sharedStorage.remove(key: Constants.SharedKeys.isFingerprintOn)
    }
    
    public init() {}
}
