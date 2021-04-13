//
//  WalletEntity.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//
import Foundation

struct WalletEntity {
    let address: String
    let balanceWithCurrency: NSAttributedString
    let balanceWithCurrencyCompact: NSAttributedString?
}

struct WalletBalancesStoreModel {
    var balance: String?
    var balanceRate: String?
}

struct WalletBalanceRateEntity {
    let rate: String
    let symbol: String
}

struct WalletBalanceEntity {
    let balanceWithCurrency: NSAttributedString
}

struct WalletBalanceWithRateModel: Equatable {
    let balance: String
    let rate: String
}
