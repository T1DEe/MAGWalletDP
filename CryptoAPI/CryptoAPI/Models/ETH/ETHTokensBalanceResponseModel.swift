//
//  ETHTokensBalanceResponseModel.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public struct ETHTokensBalanceResponseModel: Codable {
    public let items: [ETHTokenBalanceResponseModel]
    public let count: Int
}

public struct ETHTokenBalanceResponseModel: Codable {
    public let address: String
    public let balance: String
    public let holder: String
}
