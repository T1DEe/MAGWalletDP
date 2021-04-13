//
//  SelectCurrencySnackBarTableViewCell.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class SelectCurrencySnackBarTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pointView: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var selectedIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        config()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setDeselected()
    }
    
    private func config() {
        configPointView()
        configFonts()
        configColors()
        configSeparator()
    }
    
    private func configPointView() {
        pointView.layer.masksToBounds = true
        pointView.layer.cornerRadius = 3
        pointView.alpha = 0.5
        pointView.backgroundColor = R.color.light()
    }
    
    private func configFonts() {
        symbolLabel.font = R.font.poppinsMedium(size: 16)
        nameLabel.font = R.font.poppinsRegular(size: 16)
    }
    
    private func configColors() {
        symbolLabel.textColor = R.color.light()
        nameLabel.textColor = R.color.light()?.withAlphaComponent(0.5)
    }
    
    private func configSeparator() {
        separatorView.backgroundColor = R.color.light()?.withAlphaComponent(0.2)
    }
    
    func setLast() {
        separatorView.isHidden = true
    }
    
    func setSeleced() {
        selectedIcon.isHidden = false
    }
    
    func setDeselected() {
        selectedIcon.isHidden = true
    }
}
