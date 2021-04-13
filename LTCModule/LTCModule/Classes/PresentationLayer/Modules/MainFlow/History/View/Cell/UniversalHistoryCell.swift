//
//  UniversalHistoryCell.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import UIKit

class UniversalHistoryCell: HistoryItemCell {
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        config()
    }
    
    func config() {
        rateLabel.font = R.font.poppinsMedium(size: 12)
        rateLabel.textColor = R.color.dark()?.withAlphaComponent(0.5)
    }
}
