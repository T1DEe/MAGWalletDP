//
//  HistoryDetailsScreenModel.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

struct HistoryDetailsScreenModel {
    let date: String
    let amount: NSAttributedString
    let isConfirmed: Bool
    let details: [HistoryDetailsDetailScreenModel]
}

protocol HistoryDetailsDetailScreenModel {
    var title: String { get }
}

struct HistoryDetailsAmountDetailScreenModel: HistoryDetailsDetailScreenModel {
    var title: String
    let amountValue: NSAttributedString
}

struct HistoryDetailsTextDetailScreenModel: HistoryDetailsDetailScreenModel {
    var title: String
    let value: String
}
