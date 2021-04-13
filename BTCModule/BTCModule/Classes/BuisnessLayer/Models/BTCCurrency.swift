//
//  BTCCurrency.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

enum BTCCurrency {
    static let btcCurrency: Currency = Currency(id: Constants.BTCConstants.BTCSymbol,
                                                name: Constants.BTCConstants.BTCName,
                                                symbol: Constants.BTCConstants.BTCSymbol,
                                                decimals: Constants.BTCConstants.BTCDecimal,
                                                isToken: false)
}
