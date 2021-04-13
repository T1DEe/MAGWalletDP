//
//  LTCWalletOutputModel.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

struct LTCWalletOutputModel {
    let address: String
    let isCoibase: Bool
    let mintBlockHeight: Int
    let script: String
    let value: Int
    let mintIndex: Int
    let mintTransactionHash: String
    let spentBlockHeight: Int
    let spentTransactionHash: String
    let spentIndex: Int
    let sequenceNumber: Int
    let mempoolTime: String
}
