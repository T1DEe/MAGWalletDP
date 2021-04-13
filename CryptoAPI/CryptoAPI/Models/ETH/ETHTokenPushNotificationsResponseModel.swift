//
//  ETHTokenPushNotificationsResponseModel.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public struct ETHTokenPushNotificationsResponseModel: Codable {
    public let addresses: [String]
    public let tokenAddress: String
    public let token: String
    public let types: [CryptoNotificationTokenType]
    
    enum CodingKeys: String, CodingKey {
        case addresses
        case tokenAddress = "token_address"
        case token
        case types
    }
}
