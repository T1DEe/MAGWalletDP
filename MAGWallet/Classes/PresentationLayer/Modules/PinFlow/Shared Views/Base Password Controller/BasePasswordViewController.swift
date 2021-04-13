//
//  BaseBasswordViewController.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SnapKit
import UIKit

class BasePasswordViewController: UIViewController, PasswordKeyboardViewDelegate {
    var passwordIndicatorView: PasswordFillView!
    var keyboardInputView: PasswordKeyboardView!

    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    let passwordFillViewHeight = 52
    let passwordFillViewWidth = 208

    let keyboardViewHeight = 384
    let keyboardViewWidth = 281
    var wasNavigationBarHidded: Bool?

    private let errorAnimationDuration: TimeInterval = 1
    let keyboardView: PasswordKeyboardView! = R.nib.passwordKeyboardView.firstView(owner: nil)

    // MARK: Lifecycle

    // MARK: - Configuration

    func configViews() {
        configIndicatorView()
        configKeyboardView()
        configColors()
        configFonts()
        clearButton.isHidden = true
    }

    func configFonts() {
        clearButton.titleLabel?.font = R.font.poppinsRegular(size: 16)
        titleLabel.font = R.font.poppinsMedium(size: 22)
        subtitleLabel.font = R.font.poppinsRegular(size: 16)
    }

    func configColors() {
        view.backgroundColor = R.color.gray2()
        titleLabel.textColor = R.color.dark()
        subtitleLabel.textColor = R.color.gray1()
        clearButton.setTitleColor(R.color.dark(), for: .normal)
    }

    func configKeyboardView() {
        keyboardView.delegate = self
        self.keyboardInputView = keyboardView
        view.addSubview(keyboardView)

        if view.frame.size.width == 320 { //if screen size 4inch
            keyboardView.snp.makeConstraints { make in
                make.width.equalTo(keyboardViewWidth)
                make.height.equalTo(keyboardViewHeight)
                make.centerX.equalTo(view.snp.centerX)
                make.centerY.equalToSuperview().multipliedBy(1.3)
            }
            let scaleFactor = view.frame.size.width / 375
            keyboardView.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        } else {
            keyboardView.snp.makeConstraints { make in
                make.width.equalTo(keyboardViewWidth)
                make.height.equalTo(keyboardViewHeight)
                make.centerX.equalTo(view.snp.centerX)
                make.top.greaterThanOrEqualTo(passwordIndicatorView.snp.bottom).offset(26.0)
                make.top.lessThanOrEqualTo(passwordIndicatorView.snp.bottom).offset(36.0)
                make.centerY.equalToSuperview().multipliedBy(1.1).priority(999)
            }
        }
    }

    func configIndicatorView() {
        let contentView = UIView()
        view.addSubview(contentView)

        contentView.snp.makeConstraints { maker in
            maker.top.equalTo(subtitleLabel.snp.bottom).offset(25)
            maker.width.equalTo(view.snp.width)
            maker.centerX.equalTo(view.snp.centerX)
        }

        let passwordFillView: PasswordFillView! = R.nib.passwordFillView.firstView(owner: nil)

        contentView.addSubview(passwordFillView)
        passwordFillView.collectionView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
        }
        passwordFillView.snp.makeConstraints { make in
            make.width.equalTo(passwordFillViewWidth)
            make.height.equalTo(passwordFillViewHeight)
            make.centerX.equalTo(contentView.snp.centerX)
        }
        passwordIndicatorView = passwordFillView
    }

    func didEnterNumber(_ number: String) { }

    func setFailedState() { }
}
