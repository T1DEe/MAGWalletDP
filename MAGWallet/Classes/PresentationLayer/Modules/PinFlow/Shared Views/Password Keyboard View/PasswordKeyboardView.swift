//
//  PasswordKeyboardView.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

protocol PasswordKeyboardViewDelegate: NSObjectProtocol {
    func didEnterNumber(_ number: String)
}

class PasswordKeyboardView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: PasswordKeyboardViewDelegate?

    let numbers: [String?] = [
        R.string.localization.passwordKeyboardOneNumber(),
        R.string.localization.passwordKeyboardTwoNumber(),
        R.string.localization.passwordKeyboardThreeNumber(),
        R.string.localization.passwordKeyboardFourNumber(),
        R.string.localization.passwordKeyboardFiveNumber(),
        R.string.localization.passwordKeyboardSixNumber(),
        R.string.localization.passwordKeyboardSevenNumber(),
        R.string.localization.passwordKeyboardEightNumber(),
        R.string.localization.passwordKeyboardNineNumber(),
        nil,
        R.string.localization.passwordKeyboardZeroNumber(),
        nil
    ]

    override func awakeFromNib() {
        super.awakeFromNib()
        configCollection()
    }

    private func configCollection() {
        collectionView.allowsMultipleSelection = true
        collectionView.delaysContentTouches = false
        collectionView.register(R.nib.passwordKeyboardCell)
    }
}

extension PasswordKeyboardView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.passwordKeyboardCell.identifier,
                                                      for: indexPath) as! PasswordKeyboardCell
        // swiftlint:enable force_cast
        cell.delegate = self

        if let number = numbers[indexPath.row] {
            cell.numberLabel.text = number
        } else {
            cell.backView.isHidden = true
            cell.isUserInteractionEnabled = false
        }

        return cell
    }
}

extension PasswordKeyboardView: PasswordKeyboardCellDelegate {
    func didTapCell(_ cell: PasswordKeyboardCell) {
        delegate?.didEnterNumber(cell.numberLabel.text ?? "")
    }
}
