//
//  PasswordFillView.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class PasswordFillView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var failedLabel: UILabel!

    private var itemsCount = 6
    private var needSkipView = false

    fileprivate let errorAnimationDuration: TimeInterval = 1

    override func awakeFromNib() {
        super.awakeFromNib()
        config()
    }

    func setFillingWithPattern(pattern: [Int]) {
        for index in 0..<pattern.count {
            guard let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? PasswordFillingCollectionCell else {
                break
            }

            cell.setFill(fill: pattern[index] == 1 ? true : false)
            failedLabel.alpha = 0
            needSkipView = false
        }
    }

    private func config() {
        configCollection()
        configLocalization()
        configFont()
        configColors()
    }

    private func configCollection() {
        collectionView.register(R.nib.passwordFillingCollectionCell)
    }

    private func configColors() {
        failedLabel.textColor = R.color.pink()
    }

    private func configFont() {
        failedLabel.font = R.font.poppinsRegular(size: 13)
    }

    private func configLocalization() {
        failedLabel.text = R.string.localization.createPinErrorMatch()
    }

    private func fillAsFailed() {
        for index in 0..<itemsCount {
            guard let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? PasswordFillingCollectionCell else {
                break
            }

            cell.fillFailedState()
        }
    }

    private func runShakeAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        collectionView.layer.add(animation, forKey: "shake")
    }

    private func runErrorAnimation() {
        needSkipView = true
        //self.failedLabel.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + errorAnimationDuration) { [weak self] in
            self?.skipViewState()
        }
    }

    private func shakeAndErrorAnimation() {
        runShakeAnimation()
        runErrorAnimation()
    }

    // MARK: - Public

    func setFailedState() {
        fillAsFailed()
        shakeAndErrorAnimation()
    }

    func skipViewState(force: Bool = false) {
        if needSkipView == false && force == false {
            return
        }

        for index in 0..<itemsCount {
            guard let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? PasswordFillingCollectionCell else {
                break
            }

            cell.setFill(fill: false)
        }
    }
}

extension PasswordFillView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.passwordFillingCollectionCell.identifier, for: indexPath)
        return cell
    }
}
