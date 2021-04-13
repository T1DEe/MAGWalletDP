//
//  SidebarScreenModel.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

enum SettingsElementType {
    case changePin
    case autoblock
    case changeNetwork
    case multiAccounts
    case logout
    case touchId(Bool)
    case faceId(Bool)
    case notifications(Bool)
}

struct SettingsEntity {
    let elements: [SettingsElementType]
}
