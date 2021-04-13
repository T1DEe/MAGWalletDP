//
//  PasswordKeyboardCell.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

protocol PasswordKeyboardCellDelegate: class {
    func didTapCell(_ cell: PasswordKeyboardCell)
}

class PasswordKeyboardCell: UICollectionViewCell {
    @objc dynamic var customTextColor: UIColor? {
        get { return numberLabel.textColor }
        set { numberLabel.textColor = newValue }
    }

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    private var cellTextColor: UIColor?
    @IBOutlet weak var button: HightlightButton!

    weak var delegate: PasswordKeyboardCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        config()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height / 3
    }

    // MARK: - Configuration

    private func config() {
        configButton()
        configColors()
        configFont()
    }

    private func configButton() {
        button.delegate = self
    }

    private func configColors() {
        numberLabel.textColor = R.color.dark()
    }

    private func configFont() {
        numberLabel.font = R.font.poppinsRegular(size: 36)
    }

    // MARK: - Actions

    @IBAction func actionButtonPressed(_ sender: Any) {
        delegate?.didTapCell(self)
    }
}

extension PasswordKeyboardCell: HightlightButtonDelegate {
    func didHighlight(_ button: UIButton) {
        backgroundColor = R.color.blue()?.withAlphaComponent(0.32)
    }

    func didUnhighlight(_ button: UIButton) {
        backgroundColor = .clear
    }
}
