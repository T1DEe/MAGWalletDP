//
//  CurrencyBalance.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public protocol CurrencyBalance {
    var balance: String { get }
    var decimals: Int { get }
    var symbol: String { get }
}
