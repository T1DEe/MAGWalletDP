//
//  CurrencyRate.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public protocol CurrencyRate {
    var value: String { get }
    var decimals: Int { get }
    var date: Date { get }
}
