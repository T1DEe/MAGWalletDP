//
//  WalletHistoryItem.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

struct ETHWalletInternalTransaction {
    let id: String
    let value: String
    let to: String
    let from: String
}

struct ETHWalletHistoryEntity {
    let hash: String
    let isConfirmed: Bool
    let isReceive: Bool
    let creationFullDate: String
    let fromAddress: String
    let toAddress: String?
    let value: String
    let gasUsed: String
    let gasPrice: String
    let nonce: Int
    let blockNumber: Int
    let `internal`: Bool
    let internalTransaction: ETHWalletInternalTransaction?
}

struct ETHWalletTokenHistoryEntity {
    let type: String
    let executeAddress: String
    let fromAddress: String
    let toAddress: String
    let value: String
    let address: String
    let blockNumber: Int
    let transactionHash: String
    let transactionIndex: Int
    let timestamp: String
}

extension ETHWalletHistoryEntity: Equatable {
    static func == (lhs: ETHWalletHistoryEntity, rhs: ETHWalletHistoryEntity) -> Bool {
        if lhs.hash != rhs.hash {
            return false
        }

        return true
    }
}
