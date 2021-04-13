//
//  AllCurrenciesDuoTableViewCell.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class AllCurrenciesDuoTableViewCell: UITableViewCell {
    @IBOutlet weak var customContentView: UIView!
    @IBOutlet weak var firstIconImageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var firstAmountLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var secondIconImageView: UIImageView!
    @IBOutlet weak var secondAmountLabel: UILabel!
    @IBOutlet weak var firstRateLabel: UILabel!
    @IBOutlet weak var secondRateLabel: UILabel!
    
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
        
        firstNameLabel.textColor = R.color.dark()
        firstAmountLabel.textColor = R.color.dark()
        secondNameLabel.textColor = R.color.dark()
        secondAmountLabel.textColor = R.color.dark()
        separatorView.backgroundColor = R.color.gray2()
        firstRateLabel.textColor = R.color.gray1()
        secondRateLabel.textColor = R.color.gray1()
    }
    
    func configFonts() {
        firstNameLabel.font = R.font.poppinsRegular(size: 16)
        firstAmountLabel.font = R.font.poppinsMedium(size: 20)
        secondNameLabel.font = R.font.poppinsRegular(size: 16)
        secondAmountLabel.font = R.font.poppinsMedium(size: 20)
        firstRateLabel.font = R.font.poppinsMedium(size: 16)
        secondRateLabel.font = R.font.poppinsMedium(size: 16)
    }
}
