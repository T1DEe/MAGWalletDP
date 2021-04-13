//
//  LTCWalletHistoryModel.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

struct LTCWalletHistoryModel {
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
    let inputs: [LTCWalletTransactionInputModel]
    let outputs: [LTCWalletTransactionOutputModel]
}

struct LTCWalletTransactionInputModel {
    let address: String
    let prevTransactionHash: String
    let outputIndex: Int
    let sequenceNumber: Int
    let script: String
}

struct LTCWalletTransactionOutputModel {
    let address: String
    let satoshis: Int
    let script: String
}
