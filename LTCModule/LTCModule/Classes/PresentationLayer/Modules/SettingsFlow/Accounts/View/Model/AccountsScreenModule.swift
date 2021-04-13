//
//  AccountsScreenModule.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

struct AccountsScreenModel {
    let accounts: [AccountsScreenAccountModel]
}

struct AccountsScreenAccountModel {
    let wallet: LTCWallet
    let isCurrent: Bool
    let balance: NSAttributedString?
}
