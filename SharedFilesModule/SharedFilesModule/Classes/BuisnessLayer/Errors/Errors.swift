//
//  GlobalError.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

// MARK: Глобальные ошибки, которые могут прийти из модуля

public enum GlobalError {
    case noInternetConnection
    case apiNotAvailable
}

public enum CurrencyInfoError: Error {
    case globalError(GlobalError)
    case notAuthorized
}

public enum ModuleFlowError: Error {
    case notAuthorized
}

public enum AccountInfoError: Error {
    case notAuthorized
    case accountNotExist
    case noToken
    case innerError
    case notSupported // method not supported in module
}

public enum FingerprintError: Error, Equatable {
    /// Indicates that there is no fingerprint or face id
    case noFingerprint
}

public enum StorageCoreError: Error {
    case accessCanceled
    case accessDenied
    case codableError
    case storageError
    case resultNotFound
    case typeNotSupported
}

public enum CryptoError: Error, Equatable {
    /// Indicates that encryption Failed
    case encryptionFailed
    /// Indicates that decryption Failed
    case decryptionFailed
}
