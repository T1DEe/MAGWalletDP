//
//  ButtonSnackBarButtonSnackBarViewController.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedUIModule
import UIKit

class ButtonSnackBarViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var twoButtonsView: UIView!
    @IBOutlet weak var leftButton: TextButton!
    @IBOutlet weak var rightButton: TextButton!
    @IBOutlet weak var centerButtonView: UIView!
    @IBOutlet weak var centerButton: TextButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var buttonsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorIconWidthConstraint: NSLayoutConstraint!

    private let titleLeftDefault: CGFloat = 6
    private let errorIconWidthDefault: CGFloat = 20

    var output: ButtonSnackBarViewOutput!

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        config()

        output.viewIsReady()
    }

    // MARK: - Config

    private func config() {
        confgiColors()
        configFonts()
        configActions()
    }

    private func confgiColors() {
        containerView.backgroundColor = R.color.purple()
        titleLabel.textColor = R.color.light()
        messageLabel.textColor = R.color.light()?.withAlphaComponent(0.8)

        leftButton.style = .popup
        leftButton.colorBackground = R.color.light()
        leftButton.colorAdditionalBackground = R.color.light()
        leftButton.colorTitle = R.color.light()

        rightButton.style = .popup
        rightButton.colorBackground = R.color.light()
        rightButton.colorAdditionalBackground = R.color.light()
        rightButton.colorTitle = R.color.light()

        centerButton.style = .popup
        centerButton.colorBackground = R.color.light()
        centerButton.colorAdditionalBackground = R.color.light()
        centerButton.colorTitle = R.color.light()
    }

    private func configFonts() {
        titleLabel.font = R.font.poppinsMedium(size: 17)
        messageLabel.font = R.font.poppinsMedium(size: 14)
        leftButton.titleFont = R.font.poppinsRegular(size: 17)
        rightButton.titleFont = R.font.poppinsRegular(size: 17)
        centerButton.titleFont = R.font.poppinsRegular(size: 17)
    }

    private func configActions() {
        leftButton.touchUpInside = { [weak self] _ in
            self?.output.actionLeftButton()
        }

        rightButton.touchUpInside = { [weak self] _ in
            self?.output.actionRightButton()
        }

        centerButton.touchUpInside = { [weak self] _ in
            self?.output.actionCenterButton()
        }
    }

    // MARK: – Private

    private func setupOneButtonState() {
        centerButtonView.alpha = 1.0
        twoButtonsView.alpha = 0.0
    }

    private func setupTwoButtonsState() {
        centerButtonView.alpha = 0.0
        twoButtonsView.alpha = 1.0
    }

    private func configErroState(_ isError: Bool) {
        titleLeftConstraint.constant = isError ? titleLeftDefault : 0.0
        errorIconWidthConstraint.constant = isError ? errorIconWidthDefault : 0.0
    }
}

// MARK: - ButtonSnackBarViewInput

extension ButtonSnackBarViewController: ButtonSnackBarViewInput {
    func setupInitialState(model: ButtonSnackBarModel) {
        titleLabel.text = model.title
        messageLabel.text = model.message
        configErroState(model.isError)
        switch (model.leftButtonTitle, model.rightButtonTitle, model.centerButtonTitle) {
        case (nil, nil, nil):
            buttonsHeightConstraint.constant = 0.0
            centerButtonView.isHidden = true
            twoButtonsView.isHidden = true

        case (let leftText, let rightText, nil):
            setupTwoButtonsState()
            leftButton.title = leftText
            rightButton.title = rightText

        case (nil, nil, let centerText):
            setupOneButtonState()
            centerButton.title = centerText

        case (_, _, _):
            assert(false, "all button titles can`t be not nil")
        }
      }
}
