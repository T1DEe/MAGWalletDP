//
//  AccountsCell.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

protocol AccountWithTokenDelegate: class {
    func didDelete(sectionIndex: Int, cellIndex: Int)
}

class AccountsCell: UITableViewCell {
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var tokenAmountLabel: UILabel!
    @IBOutlet weak var selectedIcon: UIImageView!
    @IBOutlet weak var amountSpacingConstraint: NSLayoutConstraint!
    
    weak var delegate: AccountWithTokenDelegate?
    var sectionIndex: Int?
    var cellIndex: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func actionDelete(_ sender: Any) {
        guard let section = sectionIndex, let cell = cellIndex else {
            return
        }
        delegate?.didDelete(sectionIndex: section, cellIndex: cell)
    }
    
    func setNoTokenLayout() {
        amountSpacingConstraint.constant = 0
    }
}
