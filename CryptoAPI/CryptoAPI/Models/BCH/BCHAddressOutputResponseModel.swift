//
//  BCHAddressOutputResponseModel.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public struct BCHAddressOutputResponseModel {
    public let address: String
    public let isCoinbase: Bool
    public let mintBlockHeight: Int
    public let script: String
    public let value: Int
    public let mintIndex: Int
    public let mintTransactionHash: String
    public let spentBlockHeight: Int
    public let spentTransactionHash: String?
    public let spentIndex: Int
    public let sequenceNumber: Int
    public let mempoolTime: String?
}

extension BCHAddressOutputResponseModel: Codable {
    enum CodingKeys: String, CodingKey {
        case address
        case isCoinbase = "is_coinbase"
        case mintBlockHeight = "mint_block_height"
        case script
        case value
        case mintIndex = "mint_index"
        case mintTransactionHash = "mint_transaction_hash"
        case spentBlockHeight = "spent_block_height"
        case spentTransactionHash = "spent_transaction_hash"
        case spentIndex = "spent_index"
        case sequenceNumber = "sequence_number"
        case mempoolTime = "mempool_time"
    }
}
