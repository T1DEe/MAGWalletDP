//
//  LTCCurrency.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule

enum LTCCurrency {
    static let ltcCurrency: Currency = Currency(id: Constants.LTCConstants.LTCSymbol,
                                                name: Constants.LTCConstants.LTCName,
                                                symbol: Constants.LTCConstants.LTCSymbol,
                                                decimals: Constants.LTCConstants.LTCDecimal,
                                                isToken: false)
}
