//
//  ETHTransfersResponseModel.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public struct ETHTransfersResponseModel: Codable {
    public let addresses: [String]
    public let skip: Int
    public let limit: Int
    public let items: [ETHTransferResponseModel]
    public let count: Int
}

public struct ETHTransferResponseModel {
    public let blockNumber: Int?
    public let utc: String
    public let from: String
    public let gas: Int
    public let hash: String
    public let to: String?
    public let value: String
    public let gasPrice: String
    public let isInternal: Bool
    public let input: String?
    public let status: Bool?
}

extension ETHTransferResponseModel: Codable {
    enum CodingKeys: String, CodingKey {
        case blockNumber = "block_number"
        case utc
        case from
        case gas
        case hash
        case to
        case value
        case gasPrice = "gas_price"
        case isInternal = "internal"
        case input
        case status
    }
}
