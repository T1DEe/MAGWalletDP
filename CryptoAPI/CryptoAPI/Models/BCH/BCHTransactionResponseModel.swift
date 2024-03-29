//
//  BCHTransactionReceiptResponseModel.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public struct BCHTransactionsResponseModel {
    public let blockHeightOfHash: Int
    public let skip: Int
    public let limit: Int
    public let fromAddress: String
    public let toAddress: String
    public let items: [BCHTransactionByHashResponseModel]
}

extension BCHTransactionsResponseModel: Codable {
    enum CodingKeys: String, CodingKey {
        case blockHeightOfHash = "block_height_or_hash"
        case skip
        case limit
        case fromAddress = "from"
        case toAddress = "to"
        case items
    }
}

public struct BCHTransactionByHashResponseModel {
    public let blockHeight: Int
    public let blockHash: String?
    public let blockTime: String?
    public let mempoolTime: String?
    public let fee: Int
    public let size: Int
    public let transactionIndex: Int
    public let lockTime: Int
    public let value: Int
    public let hash: String
    public let inputCount: Int
    public let outputCount: Int
    public let inputs: [BCHTransactionInputResponseModel]
    public let outputs: [BCHTransactionOutputResponseModel]
}

extension BCHTransactionByHashResponseModel: Codable {
    enum CodingKeys: String, CodingKey {
        case blockHeight = "block_height"
        case blockHash = "block_hash"
        case blockTime = "block_time"
        case mempoolTime = "mempool_time"
        case fee
        case size
        case transactionIndex = "transaction_index"
        case lockTime = "n_lock_time"
        case value
        case hash
        case inputCount = "input_count"
        case outputCount = "output_count"
        case inputs
        case outputs
    }
}

public struct BCHTransactionInputResponseModel {
    public let address: String?
    public let prevTransactionHash: String
    public let outputIndex: Int
    public let sequenceNumber: Int
    public let script: String
}

extension BCHTransactionInputResponseModel: Codable {
    enum CodingKeys: String, CodingKey {
        case address
        case prevTransactionHash = "previous_transaction_hash"
        case outputIndex = "output_index"
        case sequenceNumber = "sequence_number"
        case script
    }
}

public struct BCHTransactionOutputResponseModel: Codable {
    public let address: String?
    public let satoshis: Int
    public let script: String
}
