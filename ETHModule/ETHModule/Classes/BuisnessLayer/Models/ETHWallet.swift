//
//  ETHModule.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

final class ETHWallet: Codable {
    let address: String
    var isCurrent: Bool
    var network: ETHNetworkType
    
    private (set) var balance = Amount(value: "0", decimals: Constants.ETHConstants.ETHDecimal)

    init(address: String, network: ETHNetworkType) {
        self.address = address
        self.isCurrent = false
        self.network = network
    }
    
    func setBalance(balance: Amount) {
        self.balance = balance
    }
}

extension ETHWallet: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(address)
    }
}

extension ETHWallet: Equatable {
    static func == (lhs: ETHWallet, rhs: ETHWallet) -> Bool {
        return rhs.address == lhs.address
    }
}
