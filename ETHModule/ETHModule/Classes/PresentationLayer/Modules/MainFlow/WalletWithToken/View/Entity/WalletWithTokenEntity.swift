//
//  WalletWithTokenEntity.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

struct WalletTokenBalanceEntity {
    let tokenBalanceWithCurrency: NSAttributedString
    let tokenBalanceWithCurrencyCompact: NSAttributedString?
}

struct WalletAddressEntity {
    let address: String
}

struct WalletTokenBalancesStoreModel {
    var balance: String?
    var balanceRate: String?
    var tokenBalance: String?
    var tokenRate: String?
    
    mutating func clearBalance() {
        balance = .none
        balanceRate = .none
    }
    
    mutating func clearToken() {
        tokenBalance = .none
        tokenRate = .none
    }
}
