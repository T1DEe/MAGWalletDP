//
//  BTCWallet.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

final class BTCWallet: Codable {
    let address: String
    var isCurrent: Bool
    var network: BTCNetworkType
    
    private (set) var balance = "0"

    init(address: String, network: BTCNetworkType) {
        self.address = address
        self.isCurrent = false
        self.network = network
    }
    
    func setBalance(balance: String) {
        self.balance = balance
    }
}

extension BTCWallet: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(address)
    }
}

extension BTCWallet: Equatable {
    static func == (lhs: BTCWallet, rhs: BTCWallet) -> Bool {
        return rhs.address == lhs.address
    }
}
