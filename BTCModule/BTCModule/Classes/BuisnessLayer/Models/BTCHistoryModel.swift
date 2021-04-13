//
//  BTCHistoryModel.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

struct BTCHistoryModel {
    let id: String
    let date: String
    let amount: String
    let amountFormatted: NSAttributedString
    let isReceiving: Bool
    let fromAddress: String
    let toAddress: String
    let fee: String
}
