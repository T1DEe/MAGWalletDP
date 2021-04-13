//
//  BTCHistoryEntity.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

enum BTCHistoryRateValue {
    case value(String)
    case none
}

struct BTCHistoryEntity {
    let id: String
    let date: String
    let amountFormatted: NSAttributedString
    let isReceiving: Bool
    let rate: String
}
