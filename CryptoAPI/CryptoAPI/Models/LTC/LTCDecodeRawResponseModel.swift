//
//  LTCDecodeRawResponseModel.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public struct LTCDecodeRawResponseModel {
    public let hash: String
    public let version: Int
    public let lockTime: Int
    public let inputs: [LTCDecodeInputResponseModel]
    public let outputs: [LTCDecodeOutputResponseModel]
}

extension LTCDecodeRawResponseModel: Codable {
    enum CodingKeys: String, CodingKey {
        case hash
        case version
        case lockTime = "n_lock_time"
        case inputs
        case outputs
    }
}

public struct LTCDecodeInputResponseModel {
    public let prevTransactionHash: String
    public let outputIndex: Int
    public let sequenceNumber: Int
    public let script: String
}

extension LTCDecodeInputResponseModel: Codable {
    enum CodingKeys: String, CodingKey {
        case prevTransactionHash = "previous_transaction_hash"
        case outputIndex = "output_index"
        case sequenceNumber = "sequence_number"
        case script
    }
}

public struct LTCDecodeOutputResponseModel {
    public let satoshis: Int
    public let script: String
    public let scriptByKey: String
}

extension LTCDecodeOutputResponseModel: Codable {
    enum CodingKeys: String, CodingKey {
        case satoshis
        case script
        case scriptByKey = "script_pub_key"
    }
}
