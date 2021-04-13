//
//  LTCWallet.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

final class LTCWallet: Codable {
    let address: String
    var isCurrent: Bool
    var network: LTCNetworkType
    
    private (set) var balance = "0"

    init(address: String, network: LTCNetworkType) {
        self.address = address
        self.isCurrent = false
        self.network = network
    }
    
    func setBalance(balance: String) {
        self.balance = balance
    }
}

extension LTCWallet: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(address)
    }
}

extension LTCWallet: Equatable {
    static func == (lhs: LTCWallet, rhs: LTCWallet) -> Bool {
        return rhs.address == lhs.address
    }
}
