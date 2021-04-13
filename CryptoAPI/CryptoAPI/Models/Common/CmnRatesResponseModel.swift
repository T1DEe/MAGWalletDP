//
//  CmnRatesResponseModel.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public struct CmnRatesResponseModel {
    public let eth: CmnUSDRateResponseModel
}

extension CmnRatesResponseModel: Codable {
    enum CodingKeys: String, CodingKey {
        case eth = "ETH"
    }
}

public struct CmnUSDRateResponseModel {
    public let usd: Double
}

extension CmnUSDRateResponseModel: Codable {
    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}
