//
//  ChangeNetworkScreenModels.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

enum NetworkType: Int, Codable, CaseIterable {
    case mainnet
    case testnet
}

struct ChangeNetworkScreenNetworkModel {
    let name: String
    let isSelected: Bool
    let identifiableNetwork: IdentifiableNetwork
}

struct ChangeNetworkScreenSectionModel {
    var headerTitle: String
    let networkModels: [ChangeNetworkScreenNetworkModel]
    let network: NetworkConfigurable
}

struct ChangeNetworkScreenModel {
    let sections: [ChangeNetworkScreenSectionModel]
}
