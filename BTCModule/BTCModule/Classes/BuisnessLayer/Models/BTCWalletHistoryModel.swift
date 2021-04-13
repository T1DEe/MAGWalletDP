//
//  BTCWalletHistoryModel.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

struct BTCWalletHistoryModel {
    let blockHeight: Int
    let blockHash: String
    let blockTime: String
    let mempoolTime: String?
    let fee: Int
    let size: Int
    let transactionIndex: Int
    let lockTime: Int
    let value: Int
    let hash: String
    let inputCount: Int
    let outputCount: Int
    let inputs: [BTCWalletTransactionInputModel]
    let outputs: [BTCWalletTransactionOutputModel]
}

struct BTCWalletTransactionInputModel {
    let address: String
    let prevTransactionHash: String
    let outputIndex: Int
    let sequenceNumber: Int
    let script: String
}

struct BTCWalletTransactionOutputModel {
    let address: String
    let satoshis: Int
    let script: String
}
