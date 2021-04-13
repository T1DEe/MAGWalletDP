//
//  LTCNetworkResponseModel.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public struct LTCNetworkResponseModel {
    public let lastBlock: String
    public let countTransactions: String
    public let hashRate: String
    public let difficulty: String
    public let estimateFee: String
}

extension LTCNetworkResponseModel: Codable {
    enum CodingKeys: String, CodingKey {
        case lastBlock = "last_block"
        case countTransactions = "count_transactions"
        case hashRate = "hashrate"
        case difficulty
        case estimateFee = "estimate_fee"
    }
}
