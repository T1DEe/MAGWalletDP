//
//  HistoryItemEntity.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

protocol HistoryItemHodler {
    var id: String { get }
//    var historyItem: HistoryItem { get }
    var explorerEntityId: String? { get }
}

struct HistoryItemEntity: HistoryItemHodler {
    let type: String
    let date: String
    let text: NSAttributedString
    let id: String
//    let historyItem: HistoryItem
    let explorerEntityId: String?
}

struct HistorySendEntity: HistoryItemHodler {
    let id: String
    let title: String
    let toName: String
    let text: NSAttributedString
    let date: String
//    let historyItem: HistoryItem
    let isContract: Bool
    let explorerEntityId: String?
}

struct HistoryReceiveEntity: HistoryItemHodler {
    let id: String
    let title: String
    let fromName: String
    let date: String
    let text: NSAttributedString
//    let historyItem: HistoryItem
    let isContract: Bool
    let explorerEntityId: String?
}

struct TokenHistoryEntity {
    let original: ETHWalletTokenHistoryEntity
    let tokenCurrency: Currency
    let isReceive: Bool
}

struct HistoryPaginationStore<HistoryModel, HistoryEntity> {
    private var defaultFrom: Int
    private var defaultLimit: Int
    private var defaultRatesLoaded: Bool
    
    var currentTransactions = [HistoryModel]()
    var originalTransactions = [String: HistoryEntity]()
    var from: Int
    var limit: Int
    var ratesLoaded: Bool
    
    init(from: Int, limit: Int, ratesLoaded: Bool) {
        self.defaultFrom = from
        self.defaultLimit = limit
        self.defaultRatesLoaded = ratesLoaded
        self.from = from
        self.limit = limit
        self.ratesLoaded = ratesLoaded
    }
    
    mutating func clear() {
        currentTransactions.removeAll()
        originalTransactions.removeAll()
        from = defaultFrom
        limit = defaultLimit
        ratesLoaded = defaultRatesLoaded
    }
    
    mutating func appendTransactions(transactions: [HistoryEntity], uniqueIds: [String]) {
        for i in 0..<transactions.count {
            let uniqueId = uniqueIds[i]
            originalTransactions[uniqueId] = transactions[i]
        }
    }
}
