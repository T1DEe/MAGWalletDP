//
//  AllCurrenciesEmptyTableViewCell.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedUIModule
import UIKit

class AllCurrenciesEmptyTableViewCell: UITableViewCell {
    @IBOutlet weak var customContentView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var noAccountLabel: UILabel!
    @IBOutlet weak var addAccountButton: TextButton!
    
    var actionAddAccount: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        config()
        
        selectionStyle = .none
    }
    
    // MARK: Config
    
    private func config() {
        configColors()
        configFonts()
        configLocalization()
        configButton()
    }
    
    func configColors() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        customContentView.backgroundColor = R.color.light()
        customContentView.layer.cornerRadius = 12
        customContentView.layer.masksToBounds = true
        
        nameLabel.textColor = R.color.dark()
        noAccountLabel.textColor = R.color.gray1()
        
        addAccountButton.style = .main
        addAccountButton.colorBackground = R.color.purple()
        addAccountButton.colorAdditionalBackground = R.color.light()
        addAccountButton.colorTitle = R.color.light()
    }
    
    func configFonts() {
        nameLabel.font = R.font.poppinsRegular(size: 16)
        noAccountLabel.font = R.font.poppinsMedium(size: 14)
        addAccountButton.titleFont = R.font.poppinsRegular(size: 17)
    }
    
    func configLocalization() {
        noAccountLabel.text = R.string.localization.allCurrenciesNoAccount()
        addAccountButton.title = R.string.localization.allCurrenciesAddAccount()
    }
    
    func configButton() {
        addAccountButton.touchUpInside = { [weak self] _ in
            self?.actionAddAccount?()
        }
    }
}
