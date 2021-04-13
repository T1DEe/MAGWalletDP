//
//  BTCNotificationType.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

enum BTCNotificationType: String, Codable {
    case outgoing
    case incoming
    case balance
}

struct BTCNotificationModel {
    let addresses: [String]
    let token: String
    let types: [BTCNotificationType]
}
