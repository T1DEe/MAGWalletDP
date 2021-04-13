//
//  AddAccountHeaderCell.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

protocol AddAccountDelegate: class {
    func didAddAccount(sectionIndex: Int)
}

class AddAccountHeaderCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    weak var delegate: AddAccountDelegate?
    var secionIndex: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func actionAddAccount(_ sender: Any) {
        guard let index = secionIndex else {
            return
        }
        delegate?.didAddAccount(sectionIndex: index)
    }
}
