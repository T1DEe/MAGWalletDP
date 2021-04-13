//
//  LTCNetworkType.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

enum LTCNetworkType: Int, Codable, CaseIterable {
    case mainnet
    case testnet
}

extension LTCNetworkType: IdentifiableNetwork {
    var name: String {
        switch self {
        case .mainnet:
            return R.string.localization.settingsChangeNetworkMainnet()
            
        case .testnet:
            return R.string.localization.settingsChangeNetworkTestnet()
        }
    }
}
