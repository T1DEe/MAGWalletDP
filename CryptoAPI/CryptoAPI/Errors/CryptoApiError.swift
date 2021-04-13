//
//  CryptoApiError.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public enum CryptoApiError: Swift.Error {
    case innerError(Error)
    case customError(CryptoApiTypedError)
    case customErrorList(CryptoApiTypedErrors)
}

public struct CryptoApiTypedErrors: Codable {
    public let errors: [CryptoApiTypedError]
    public let status: Int
}

public struct CryptoApiTypedError: Codable {
    public let message: String
    public let field: String?
    public let value: String?
}
