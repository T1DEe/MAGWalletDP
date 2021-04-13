//
//  PinVerificationSessionVerificationViewController.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedUIModule
import UIKit

class SessionVerificationViewController: BasePasswordViewController {
    var output: SessionVerificationViewOutput!

    var passwordString = ""
    let emptyIndicatorPattern = [0, 0, 0, 0, 0, 0]
    let tap: UITapGestureRecognizer = UITapGestureRecognizer()
    @IBOutlet weak var backButton: ImageButton!
    @IBOutlet weak var forgotPinButton: UIButton!
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        output.viewIsReady()
    }

    override func configColors() {
        super.configColors()
        backButton.style = .withoutBackground
        backButton.colorAdditionalBackground = R.color.gray1()
        forgotPinButton.setTitleColor(R.color.gray1(), for: .normal)
    }
    
    override func configFonts() {
        super.configFonts()
        forgotPinButton.titleLabel?.font = R.font.poppinsRegular(size: 11)
    }

    // MARK: - Configuration

    fileprivate func config() {
        configViews()
        confitLocalization()
        configButton()
    }
    
    private func configButton() {
        backButton.image = R.image.back()
        backButton.touchUpInside = { [weak self] _ in
            self?.output.actionBack()
        }
    }

    fileprivate func confitLocalization() {
        clearButton.setTitle(R.string.localization.buttonDelete(), for: .normal)
        titleLabel.text = R.string.localization.pinVerificationTitle()
        subtitleLabel.text = R.string.localization.pinVerificationSubtitle()
        forgotPinButton.setTitle(R.string.localization.pinVerificationForgotPin(), for: .normal)
    }

    // MARK: Private

    fileprivate func updateTitleAndButtons() {
        clearButton.isHidden = passwordString.isEmpty
    }

    fileprivate func updateControls() {
        updateTitleAndButtons()
        updateIndicatorView()
    }

    fileprivate func updateIndicatorWith(_ stringForUpdate: String) {
        var indicatorPattern = emptyIndicatorPattern
        for index in 0..<stringForUpdate.count where stringForUpdate.count <= indicatorPattern.count {
            indicatorPattern[index] = 1
        }
        passwordIndicatorView.setFillingWithPattern(pattern: indicatorPattern)
    }

    fileprivate func updateIndicatorView() {
        var stringForUpdate = ""
        stringForUpdate = passwordString
        updateIndicatorWith(stringForUpdate)
    }

    // MARK: - Action

    @IBAction func actionClear(_ sender: Any) {
        passwordString.remove(at: passwordString.index(before: passwordString.endIndex))
        updateControls()
    }

    @IBAction func actionForgotPin(_ sender: Any) {
        output.actionForgotPin()
    }
    
    // MARK: - PasswordKeyboardViewDelegate

    override func didEnterNumber(_ number: String) {
        passwordString += number
        updateIndicatorWith(passwordString)
        if passwordString.count == emptyIndicatorPattern.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [unowned self] in
                self.output.actionEnterPin(self.passwordString)
            }
        }
        updateTitleAndButtons()
    }
}

// MARK: - SessionVerificationViewInput

extension SessionVerificationViewController: SessionVerificationViewInput {
    func setupErrorState() {
        self.clearButton.isHidden = true
        setFailedState()
        passwordString.removeAll()
        updateIndicatorWith("")
        passwordIndicatorView.setFailedState()
        self.view.layoutIfNeeded()
    }
}
