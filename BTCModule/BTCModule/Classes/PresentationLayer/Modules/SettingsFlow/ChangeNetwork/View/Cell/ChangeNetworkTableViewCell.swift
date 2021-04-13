//
//  ChangeNetworkTableViewCell.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

final class ChangeNetworkTableViewCell: UITableViewCell {
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectionImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.font = R.font.poppinsMedium(size: 17)
        nameLabel.textColor = R.color.dark()
    }
}
