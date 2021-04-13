//
//  AutoblockTableViewCell.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

final class AutoblockTableViewCell: UITableViewCell {
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var clockImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        timeLabel.font = R.font.poppinsMedium(size: 17)
        timeLabel.textColor = R.color.dark()
    }
}
