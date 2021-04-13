//
//  LTCAddressOutHistoryResponseModel.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public struct LTCAddressOutHistoryResponseModel: Codable {
    public let skip: Int
    public let limit: Int
    public let count: Int
    public let items: [LTCTransactionByHashResponseModel]
}
