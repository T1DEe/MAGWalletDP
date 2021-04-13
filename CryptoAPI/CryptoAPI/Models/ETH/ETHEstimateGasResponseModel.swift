//
//  ETHEstimateGasResponseModel.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public struct ETHEstimateGasResponseModel {
    public let estimateGas: Int
    public let gasPrice: String
    public let nonce: Int
}

extension ETHEstimateGasResponseModel: Codable {
    enum CodingKeys: String, CodingKey {
        case estimateGas = "estimate_gas"
        case gasPrice = "gas_price"
        case nonce
    }
}
