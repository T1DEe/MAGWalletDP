//
//  BCHPushNotificationsResponseModel.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public struct BCHPushNotificationsResponseModel: Codable {
    public let addresses: [String]
    public let token: String
    public let types: [CryptoNotificationType]
}
