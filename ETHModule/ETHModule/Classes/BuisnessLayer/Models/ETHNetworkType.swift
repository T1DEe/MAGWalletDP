//
//  ETHNetworkType.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

enum ETHNetworkType: Int, Codable, CaseIterable {
    case mainnet
    case ropsten
    case rinkeby
    case kovan
}

extension ETHNetworkType {
    static var usable: [ETHNetworkType] {
        return [.mainnet, .rinkeby]
    }
}

extension ETHNetworkType: IdentifiableNetwork {
    var name: String {
        switch self {
        case .mainnet:
            return R.string.localization.settingsChangeNetworkMainnet()
            
        case .rinkeby:
            return R.string.localization.settingsChangeNetworkRinkeby()
            
        case .kovan:
            return R.string.localization.settingsChangeNetworkKovan()
            
        case .ropsten:
            return R.string.localization.settingsChangeNetworkRopsten()
        }
    }
}
