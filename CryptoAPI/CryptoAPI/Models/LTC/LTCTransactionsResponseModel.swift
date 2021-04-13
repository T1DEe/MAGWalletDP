//
//  LTCTransactionsResponseModel.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public struct LTCTransactionsResponseModel {
    public let blockHeightOfHash: Int
    public let skip: Int
    public let limit: Int
    public let fromAddress: String?
    public let toAddress: String?
    public let items: [LTCTransactionByHashResponseModel]
}

extension LTCTransactionsResponseModel: Codable {
    enum CodingKeys: String, CodingKey {
        case blockHeightOfHash = "block_height_or_hash"
        case skip
        case limit
        case fromAddress = "from"
        case toAddress = "to"
        case items
    }
}
