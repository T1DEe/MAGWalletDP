//
//  RatesHistoryResponseModel.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public struct RatesHistoryResponseModel: Codable {
    public let symbol: String
    public let rates: [CoinRateHistoryResponseModel]
}

public struct CoinRateHistoryResponseModel {
    public let createdAt: String
    public let rate: CoinRateResponseModel
}

extension CoinRateHistoryResponseModel: Codable {
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case rate
    }
}
