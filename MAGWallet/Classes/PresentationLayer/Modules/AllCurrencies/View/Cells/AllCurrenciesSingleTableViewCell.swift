//
//  AllCurrenciesSingleTableViewCell.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class AllCurrenciesSingleTableViewCell: UITableViewCell {
    @IBOutlet weak var customContentView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        config()
        selectionStyle = .none
    }
    
    // MARK: Config
    
    private func config() {
        configColors()
        configFonts()
    }
    
    func configColors() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        customContentView.backgroundColor = R.color.light()
        customContentView.layer.cornerRadius = 12
        customContentView.layer.masksToBounds = true
        
        nameLabel.textColor = R.color.dark()
        amountLabel.textColor = R.color.dark()
        rateLabel.textColor = R.color.gray1()
    }
    
    func configFonts() {
        nameLabel.font = R.font.poppinsRegular(size: 16)
        amountLabel.font = R.font.poppinsMedium(size: 20)
        rateLabel.font = R.font.poppinsMedium(size: 16)
    }
}
