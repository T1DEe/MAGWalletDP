//
//  BTCAccountsCell.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

protocol BTCAccountsCellDelegate: class {
    func didDeleteAccount(_ account: AccountsScreenAccountModel)
}

class BTCAccountsCell: UITableViewCell {
    @IBOutlet weak var selectedIcon: UIImageView!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var currencyAmountLabel: UILabel!

    weak var delegate: BTCAccountsCellDelegate?
    var account: AccountsScreenAccountModel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func actionDeleteAccount(_ sender: Any) {
        guard let account = account else {
            return
        }
        delegate?.didDeleteAccount(account)
    }
}
