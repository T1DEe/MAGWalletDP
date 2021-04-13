//
//  ETHDecodeRawResponseModel.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public struct ETHDecodeRawResponseModel {
    public let nonce: Int
    public let gasPrice: String
    public let gasLimit: String
    public let to: String
    public let value: String
    public let data: String
    public let v: Int
    public let r: String
    public let s: String
}

extension ETHDecodeRawResponseModel: Codable {
    enum CodingKeys: String, CodingKey {
        case nonce
        case gasPrice = "gas_price"
        case gasLimit = "gas_limit"
        case to
        case value
        case data
        case v
        case r
        case s
    }
}
