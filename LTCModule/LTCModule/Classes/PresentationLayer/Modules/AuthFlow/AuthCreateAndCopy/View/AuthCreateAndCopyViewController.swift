//
//  AuthCreateAndCopyAuthCreateAndCopyViewController.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedUIModule
import UIKit

class AuthCreateAndCopyViewController: UIViewController {
    var output: AuthCreateAndCopyViewOutput!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var textView: TextView!
    @IBOutlet weak var backButton: ImageButton!
    @IBOutlet weak var copyButton: TextButton!
    @IBOutlet weak var continueButton: TextButton!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        output.viewIsReady()
    }
    
    // MARK: Config
    
    private func config() {
        configFonts()
        configColors()
        configLocalization()
        configActions()
        configButton()
        configTextView()
    }
    
    private func configFonts() {
        titleLabel.font = R.font.poppinsMedium(size: 22)
        subtitleLabel.font = R.font.poppinsRegular(size: 16)
        copyButton.titleFont = R.font.poppinsRegular(size: 17)
        continueButton.titleFont = R.font.poppinsRegular(size: 17)
        textView.font = R.font.poppinsMedium(size: 14)
        textView.errorFont = R.font.poppinsMedium(size: 12)
    }
    
    private func configColors() {
        view.backgroundColor = R.color.gray2()
        titleLabel.textColor = R.color.dark()
        subtitleLabel.textColor = R.color.gray1()
        
        copyButton.style = .main
        copyButton.colorBackground = R.color.purple()
        copyButton.colorAdditionalBackground = R.color.light()
        copyButton.colorTitle = R.color.light()
        
        continueButton.style = .additional
        continueButton.colorBackground = R.color.blue()
        continueButton.colorAdditionalBackground = R.color.light()
        continueButton.colorTitle = R.color.light()
        
        textView.highlightColor = R.color.purple()
        textView.errorColor = R.color.pink()
        textView.mainColor = R.color.gray1()
        textView.textColor = R.color.dark()
        
        backButton.style = .withoutBackground
        backButton.colorAdditionalBackground = R.color.gray1()
    }
    
    private func configLocalization() {
        titleLabel.text = R.string.localization.authCopyTitle()
        subtitleLabel.text = R.string.localization.authCopySubtitle()
        copyButton.title = R.string.localization.authCopyCopyButtonTitle()
        continueButton.title = R.string.localization.authCopyContinueButtonTitle()
    }
    
    private func configButton() {
        backButton.image = R.image.backIcon()
    }
    
    private func configTextView() {
        textView.isUserInteractionEnabled = false
    }
    
    private func configActions() {
        copyButton.touchUpInside = { [weak self] _ in
            self?.output.actionCopy()
        }
        
        continueButton.touchUpInside = { [weak self] _ in
            self?.output.actionContinue()
        }
        
        backButton.touchUpInside = { [weak self] _ in
            self?.output.actionBack()
        }
    }
}

// MARK: - AuthCreateAndCopyViewInput

extension AuthCreateAndCopyViewController: AuthCreateAndCopyViewInput {
    func setupInitialState(seed: String) {
        textView.setText(seed)
    }
}
