//
//  CreatePinCreatePinViewController.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedUIModule
import UIKit

class CreatePinViewController: BasePasswordViewController {
    var output: CreatePinViewOutput!
    var passwordString = ""
    var repeatedPasswordString = ""
    let emptyIndicatorPattern = [0, 0, 0, 0, 0, 0]
    @IBOutlet weak var backButton: ImageButton!
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        config()
        output.viewIsReady()
    }

    // MARK: - Configuration

    fileprivate func config() {
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
        titleLabel.text = R.string.localization.createPinCreate()
        subtitleLabel.text = R.string.localization.createPinSubtitle()
    }

    private func configNavigation() {
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func updateTitleAndButtons() {
        var titleText = ""
        var showBackbutton = true
        var showClearbutton = false

        switch (passwordString.count, repeatedPasswordString.count) {
        case (0, _):
            titleText = R.string.localization.createPinCreate()
            showBackbutton = true
            showClearbutton = true

        case (1..<emptyIndicatorPattern.count, _):
            titleText = R.string.localization.createPinCreate()
            showBackbutton = true
            showClearbutton = false

        case (emptyIndicatorPattern.count, 0):
            titleText = R.string.localization.createPinConfirm()
            showBackbutton = false
            showClearbutton = true

        case (emptyIndicatorPattern.count, 1..<emptyIndicatorPattern.count):
            titleText = R.string.localization.createPinConfirm()
            showBackbutton = false
            showClearbutton = false

        case (emptyIndicatorPattern.count, emptyIndicatorPattern.count):
            titleText = R.string.localization.createPinConfirm()
            showBackbutton = false
            showClearbutton = false

        default:
            break
        }

        titleLabel.text = titleText
        clearButton.isHidden = showClearbutton
        backButton.isHidden = showBackbutton
    }

    private func updateControls() {
        updateTitleAndButtons()
        updateIndicatorView()
    }

    private func updateIndicatorWith(_ stringForUpdate: String) {
        var indicatorPattern = emptyIndicatorPattern
        for index in 0..<stringForUpdate.count {
            indicatorPattern[index] = 1
        }
        passwordIndicatorView.setFillingWithPattern(pattern: indicatorPattern)
    }

    private func updateIndicatorView() {
        var stringForUpdate = ""

        switch (passwordString.count, repeatedPasswordString.count) {
        case (0, _):
            stringForUpdate = passwordString
            updateIndicatorWith(stringForUpdate)

        case (1..<emptyIndicatorPattern.count, _):
            stringForUpdate = passwordString
            updateIndicatorWith(stringForUpdate)

        case (emptyIndicatorPattern.count, 0):
            stringForUpdate = repeatedPasswordString
            updateIndicatorWith(stringForUpdate)

        case (emptyIndicatorPattern.count, 1..<emptyIndicatorPattern.count):
            stringForUpdate = repeatedPasswordString
            updateIndicatorWith(stringForUpdate)

        case (emptyIndicatorPattern.count, emptyIndicatorPattern.count):
            stringForUpdate = repeatedPasswordString
            updateIndicatorWith(stringForUpdate)
            return

        default:
            break
        }
    }

    // MARK: - Action

    @IBAction func actionClear(_ sender: Any) {
        switch (passwordString.count, repeatedPasswordString.count) {
        case (1..<emptyIndicatorPattern.count, 0):
            passwordString.remove(at: passwordString.index(before: passwordString.endIndex))

        case (emptyIndicatorPattern.count, 1...emptyIndicatorPattern.count):
            repeatedPasswordString.remove(at: passwordString.index(before: repeatedPasswordString.endIndex))

        default:
            return
        }
        updateControls()
    }

    @IBAction func actionBack(_ sender: Any) {
        output.actionBack()
    }

    // MARK: - PasswordKeyboardViewDelegate

    override func didEnterNumber(_ number: String) {
        switch (passwordString.count, repeatedPasswordString.count) {
        case (0..<emptyIndicatorPattern.count - 1, _):
            passwordString += number
            updateIndicatorWith(passwordString)

        case (0..<emptyIndicatorPattern.count, _):
            passwordString += number
            updateIndicatorWith(passwordString)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [unowned self] in
                self.updateIndicatorWith(self.repeatedPasswordString)
            }

        case (emptyIndicatorPattern.count, 0..<emptyIndicatorPattern.count - 1):
            repeatedPasswordString += number
            updateIndicatorWith(repeatedPasswordString)

        case (emptyIndicatorPattern.count, emptyIndicatorPattern.count - 1):
            repeatedPasswordString += number
            updateIndicatorWith(repeatedPasswordString)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [unowned self] in
                self.output.actionEnterPin(self.passwordString, self.repeatedPasswordString)
            }
            return

        default:
            return
        }
        updateTitleAndButtons()
    }
}

// MARK: - PinViewInput

extension CreatePinViewController: CreatePinViewInput {
    func setupErrorState() {
        passwordIndicatorView.setFailedState()
        repeatedPasswordString.removeAll()
        clearButton.isHidden = true
        setFailedState()
        view.layoutIfNeeded()
    }

    func setupInitialState() {
        titleLabel.text = R.string.localization.createPinCreate()
        passwordIndicatorView.skipViewState(force: true)
        repeatedPasswordString.removeAll()
        passwordString.removeAll()
        clearButton.isHidden = true
        backButton.isHidden = true
    }
}
