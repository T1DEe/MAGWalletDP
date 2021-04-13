//
//  LTCAddressOutInfoResponseModel.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public struct LTCAddressOutInfoResponseModel: Codable {
    public let address: String
    public let balance: LTCAddressBalanceResponseModel
}

public struct LTCAddressBalanceResponseModel: Codable {
    public let spent: String
    public let unspent: String
    public let confirmed: String
    public let unconfirmed: String
}
