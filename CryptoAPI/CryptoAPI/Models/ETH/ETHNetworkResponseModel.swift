//
//  ETHNetworkResponseModel.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public struct ETHNetworkResponseModel {
    public let lastBlock: Int
    public let countTransactions: String
    public let hashRate: Int
    public let gasPrice: String
    public let difficulty: Int
}

extension ETHNetworkResponseModel: Codable {
    enum CodingKeys: String, CodingKey {
        case lastBlock = "last_block"
        case countTransactions = "count_transactions"
        case hashRate = "hashrate"
        case gasPrice = "gas_price"
        case difficulty
    }
}
