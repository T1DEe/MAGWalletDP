//
//  CurrencyModels.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public enum Currencies {
    public static let usd = Currency(id: Constants.USDCurrency.symbol,
                                     name: Constants.USDCurrency.name,
                                     symbol: Constants.USDCurrency.symbol,
                                     decimals: Constants.USDCurrency.decimals,
                                     isToken: false)
}
