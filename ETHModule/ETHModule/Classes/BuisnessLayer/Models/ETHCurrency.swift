//
//  ETHCurrency.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

enum ETHCurrency {
    static let ethCurrency: Currency = Currency(id: Constants.ETHConstants.ETHSymbol,
                                                name: Constants.ETHConstants.ETHName,
                                                symbol: Constants.ETHConstants.ETHSymbol,
                                                decimals: Constants.ETHConstants.ETHDecimal,
                                                isToken: false)
}
