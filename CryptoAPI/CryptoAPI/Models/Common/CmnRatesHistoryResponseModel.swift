//
//  CmnRatesHistoryResponseModel.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public struct CmnRatesHistoryResponseModel {
    public let createdAt: String
    public let rate: CmnUSDRateResponseModel
}

extension CmnRatesHistoryResponseModel: Codable {
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case rate
    }
}
