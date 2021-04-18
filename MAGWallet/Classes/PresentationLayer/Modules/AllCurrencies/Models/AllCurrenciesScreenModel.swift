//
//  AllCurrenciesScreenModel.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule
import UIKit

protocol AllCurrenciesScreenModel {
    var additionObject: AccountInfo? { get set }
}

class AllCurrenciesScreenSingleModel: AllCurrenciesScreenModel {
    weak var additionObject: AccountInfo?
    let currency: AllCurrenciesScreenCurrencyModel
    var balance: AllCurrenciesScreenAmountModel
    var rate: AllCurrenciesScreenAmountModel
    
    init(currency: AllCurrenciesScreenCurrencyModel, balance: AllCurrenciesScreenAmountModel, rate: AllCurrenciesScreenAmountModel) {
        self.currency = currency
        self.balance = balance
        self.rate = rate
    }
}

class AllCurrenciesScreenDuoModel: AllCurrenciesScreenModel {
    weak var additionObject: AccountInfo?
    let firstCurrency: AllCurrenciesScreenCurrencyModel
    var firstBalance: AllCurrenciesScreenAmountModel
    var firstRate: AllCurrenciesScreenAmountModel
    let secondCurrency: AllCurrenciesScreenCurrencyModel
    var secondBalance: AllCurrenciesScreenAmountModel
    var secondRate: AllCurrenciesScreenAmountModel
    
    init(firstCurrency: AllCurrenciesScreenCurrencyModel, firstBalance: AllCurrenciesScreenAmountModel,
         secondCurrency: AllCurrenciesScreenCurrencyModel, secondBalance: AllCurrenciesScreenAmountModel,
         firstRate: AllCurrenciesScreenAmountModel, secondRate: AllCurrenciesScreenAmountModel) {
        self.firstCurrency = firstCurrency
        self.firstBalance = firstBalance
        self.secondCurrency = secondCurrency
        self.secondBalance = secondBalance
        self.firstRate = firstRate
        self.secondRate = secondRate
    }
}

class AllCurrenciesScreenEmptyModel: AllCurrenciesScreenModel {
    weak var additionObject: AccountInfo?
    let currency: AllCurrenciesScreenCurrencyModel
    
    init(currency: AllCurrenciesScreenCurrencyModel) {
        self.currency = currency
    }
}

struct AllCurrenciesScreenCurrencyModel {
    let icon: UIImage?
    let name: String
}

struct AllCurrenciesScreenAmountModel {
    let amount: String
    let symbol: String
}
