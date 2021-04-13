//
//  Entity.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

struct SendFeeEntity {
    let fee: String
}

struct SendAmountEntity {
    let amount: String?
    let currencyAmount: String?
}

struct SendCurrentBalanceEntity {
    let balance: NSAttributedString
}

struct SendEntity {
    let toAddress: String
    let amount: String
}

struct SendToAddressEntity {
    let toAddress: String?
}

struct SendErrorEntity {
    let amountError: String?
    let feeError: String?
    let toAddressError: String?
}
