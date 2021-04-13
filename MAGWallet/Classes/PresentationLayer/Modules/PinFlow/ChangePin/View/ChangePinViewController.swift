//
//  ChangePinChangePinViewController.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedUIModule
import UIKit

class ChangePinViewController: BasePasswordViewController {
    var output: ChangePinViewOutput!
    var passwordString = ""
    let emptyIndicatorPattern = [0, 0, 0, 0, 0, 0]
    @IBOutlet weak var backButton: ImageButton!
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        output.viewIsReady()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = R.string.localization.changePinOldTitle()
    }

    // MARK: - Configuration

    private func config() {
        configViews()
        confitLocalization()
        configNavigation()
        configButton()
    }

    override func configColors() {
        super.configColors()
        backButton.style = .withoutBackground
        backButton.colorAdditionalBackground = R.color.gray1()
    }
    
    private func configButton() {
        backButton.image = R.image.back()
        backButton.touchUpInside = { [weak self] _ in
            self?.output.actionBack()
        }
    }

    private func confitLocalization() {
        clearButton.setTitle(R.string.localization.buttonDelete(), for: .normal)
    }

    private func configNavigation() {
        titleLabel.text = R.string.localization.changePinOldTitle()
        navigationItem.setHidesBackButton(true, animated: true)
    }

    // MARK: Private
    private func updateTitleAndButtons() {
        var showBackbutton = false

        if passwordString.isEmpty {
            showBackbutton = true
        } else {
            showBackbutton = false
        }

        clearButton.isHidden = showBackbutton
    }

    private func updateControls() {
        updateTitleAndButtons()
        updateIndicatorView()
    }

    private func updateIndicatorView() {
        var indicatorPattern = emptyIndicatorPattern
        for index in 0..<passwordString.count {
            indicatorPattern[index] = 1
        }
        passwordIndicatorView.setFillingWithPattern(pattern: indicatorPattern)
    }

    // MARK: - Action

    @IBAction func actionClear(_ sender: Any) {
        if passwordString.isEmpty == false {
            passwordString.remove(at: passwordString.index(before: passwordString.endIndex))
        }
        updateControls()
    }

    // MARK: - PasswordKeyboardViewDelegate

    override func didEnterNumber(_ number: String) {
        if passwordString.count < emptyIndicatorPattern.count - 1 {
            passwordString += number
        } else if passwordString.count < emptyIndicatorPattern.count {
            passwordString += number
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let self = self else {
                    return
                }
                self.output.actionEnterPin(self.passwordString)
            }
        }

        updateControls()
    }
}

// MARK: - ChangePinViewInput

extension ChangePinViewController: ChangePinViewInput {
    func setupInitialState() {
        titleLabel.text = R.string.localization.changePinOldTitle()
        subtitleLabel.text = R.string.localization.changePinOldSubtitle()
        passwordString = ""
        updateControls()
    }

    func setupNewStep() {
        titleLabel.text = R.string.localization.changePinNewTitle()
        subtitleLabel.text = R.string.localization.changePinNewSubtitle()
        passwordString = ""
        updateControls()
    }

    func setupRepeateNewStep() {
        titleLabel.text = R.string.localization.changePinNewRepeateTitle()
        subtitleLabel.text = R.string.localization.changePinNewRepeateSubtitle()
        passwordString = ""
        updateControls()
    }

    func setupFailedStateAndOld() {
        titleLabel.text = R.string.localization.changePinOldTitle()
        subtitleLabel.text = R.string.localization.changePinOldSubtitle()
        setFailedState()
        passwordString = ""
        passwordIndicatorView.setFailedState()
        updateTitleAndButtons()
    }
}
