//
//  WalletEntity.swift
//  LTCModule
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

struct WalletBalanceEntity {
    let balanceWithCurrency: NSAttributedString
}

struct WalletAddressEntity {
    let address: String
}

struct WalletBalanceRateEntity {
    let rate: String
    let symbol: String
}

struct BalanceWithRateModel: Equatable {
    let balance: String
    let rate: String
}

struct BalancesAndRatesStoreModel {
    var balance: String?
    var balanceRate: String?
}
