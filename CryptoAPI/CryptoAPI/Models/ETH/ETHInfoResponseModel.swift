//
//  ETHInfoResponseModel.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public struct ETHInfoResponseModel {
    public let address: String
    public let balance: String
    public let isContract: Bool
    public let type: String
    public let countTransactions: Int
}

extension ETHInfoResponseModel: Codable {
    enum CodingKeys: String, CodingKey {
        case address
        case balance
        case isContract = "is_contract"
        case type
        case countTransactions = "count_transactions"
    }
}
