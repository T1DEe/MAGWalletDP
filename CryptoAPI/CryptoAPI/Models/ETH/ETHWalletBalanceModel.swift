//
//  ETHBalanceResponseModel.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public struct ETHBalanceResponseModel: Codable {
    public let balance: String
    public let address: String
}
