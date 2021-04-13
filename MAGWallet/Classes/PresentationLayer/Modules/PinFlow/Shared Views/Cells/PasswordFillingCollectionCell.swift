//
//  PasswordFillingCollectionCell.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

enum FilledState {
    case filled
    case unFilled
    case failed
}

class PasswordFillingCollectionCell: UICollectionViewCell {
    @IBOutlet weak var fillImage: UIImageView!
    private var state: FilledState = .unFilled

    override func awakeFromNib() {
        super.awakeFromNib()

        unfillView()
    }

    func setFill(fill: Bool) {
        let newState: FilledState = fill ? .filled : .unFilled

        switch (state, newState) {
        case (.filled, .filled), (.unFilled, .unFilled): break
        case (.unFilled, .filled): fillView()
        case (.filled, .unFilled): unfillView()
        case (.failed, .unFilled): unfillView()
        case (.failed, .filled): fillView()

        default:
            break
        }
    }

    func fillFailedState() {
        let toImage = R.image.pin_full()
        fillImage.tintColor = R.color.pink()
        changeImageAnimated(toImage, needRecoloring: false)
        state = .failed
    }

    fileprivate func fillView() {
        let toImage = R.image.pin_full()
        fillImage.tintColor = R.color.dark()
        changeImageAnimated(toImage, needRecoloring: true)
        state = .filled
    }

    fileprivate func unfillView() {
        let toImage = R.image.pin_empty()
        fillImage.tintColor = R.color.dark()
        changeImageAnimated(toImage, needRecoloring: true)
        state = .unFilled
    }

    fileprivate func changeImageAnimated(_ toImage: UIImage?, needRecoloring: Bool) {
        let newImage = needRecoloring ? toImage?.withRenderingMode(.alwaysTemplate) : toImage
        UIView.transition(with: fillImage,
                          duration: 0.1,
                          options: .transitionCrossDissolve,
                          animations: { self.fillImage.image = newImage },
                          completion: nil)
    }
}
