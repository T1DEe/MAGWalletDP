//
//  HostoryItemCell.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class HostoryItemCell: UITableViewCell {
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    private var selectedBakcground = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainTextLabel.font = R.font.poppinsMedium(size: 12)
        mainTextLabel.textColor = R.color.dark()
        dateLabel.textColor = R.color.dark()?.withAlphaComponent(0.5)
        dateLabel.font = R.font.poppinsMedium(size: 11)
        
        typeImage.layer.cornerRadius = typeImage.frame.width / 2
        typeImage.layer.masksToBounds = true
        
        contentView.backgroundColor = R.color.gray2()
        separatorView.backgroundColor = R.color.gray1()?.withAlphaComponent(0.5)

        selectedBakcground.alpha = 0.0
        selectedBakcground.backgroundColor = R.color.gray1()?.withAlphaComponent(0.1)
        contentView.insertSubview(selectedBakcground, at: 0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.2 : 0.0) {
            self.selectedBakcground.alpha = selected ? 1.0 : 0.0
        }
    }
}
