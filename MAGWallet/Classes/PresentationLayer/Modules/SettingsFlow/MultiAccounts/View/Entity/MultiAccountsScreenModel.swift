//
//  MultiAccountsScreenModel.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

struct MultiAccountsScreenHeaderModel {
    var title: String
    var needButton: Bool
}

struct MultiAccountsScreenAccountModel {
    let accountName: String
    let isCurrent: Bool
    let balance: NSAttributedString?
    let tokentBalance: NSAttributedString?
}

struct MultiAccountsScreenSectionModel {
    let headerModel: MultiAccountsScreenHeaderModel
    let accounts: [MultiAccountsScreenAccountModel]
    let accountsHolder: AccountInfo
}

struct MultiAccountsScreenModel {
    let sections: [MultiAccountsScreenSectionModel]
}
