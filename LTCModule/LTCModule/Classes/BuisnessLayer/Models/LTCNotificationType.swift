//
//  LTCNotificationType.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

enum LTCNotificationType: String, Codable {
    case outgoing
    case incoming
    case balance
}

struct LTCNotificationModel {
    let addresses: [String]
    let token: String
    let types: [LTCNotificationType]
}
