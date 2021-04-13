//
//  ForgotPinViewController.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedUIModule
import UIKit

class ForgotPinViewController: UIViewController {
    var output: ForgotPinViewOutput!

    @IBOutlet weak var backButton: ImageButton!
    @IBOutlet weak var clearButton: TextButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstSubtitleLabel: UILabel!
    @IBOutlet weak var secondSubtitleLabel: UILabel!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        config()
    }
    
    // MARK: - Configuration
    
    fileprivate func config() {
        configBackButton()
        configLocalization()
        configColors()
        configFonts()
        configClearButton()
    }
    
    func configLocalization() {
        titleLabel.text = R.string.localization.pinForgotTitle()
        firstSubtitleLabel.text = R.string.localization.pinForgotFirstSubtitle()
        secondSubtitleLabel.text = R.string.localization.pinForgotSecondSubtitle()
        clearButton.title = R.string.localization.pinForgotClearButton()
    }
    
    func configColors() {
        view.backgroundColor = R.color.gray2()
        titleLabel.textColor = R.color.dark()
        firstSubtitleLabel.textColor = R.color.gray1()
        secondSubtitleLabel.textColor = R.color.gray1()
        
        backButton.style = .withoutBackground
        backButton.colorAdditionalBackground = R.color.gray1()
        
        clearButton.style = .additional
        clearButton.colorBackground = R.color.blue()
        clearButton.colorAdditionalBackground = R.color.light()
        clearButton.colorTitle = R.color.light()
    }
    
    func configFonts() {
        titleLabel.font = R.font.poppinsMedium(size: 22)
        firstSubtitleLabel.font = R.font.poppinsRegular(size: 14)
        secondSubtitleLabel.font = R.font.poppinsRegular(size: 14)
        clearButton.titleFont = R.font.poppinsRegular(size: 17)
    }
    
    func configBackButton() {
        backButton.image = R.image.back()
        backButton.touchUpInside = { [weak self] _ in
            self?.output.actionBack()
        }
    }
    
    func configClearButton() {
        clearButton.touchUpInside = { [weak self] _ in
            self?.output.actionClear()
        }
    }
}

// MARK: - ForgotPinViewInput

extension ForgotPinViewController: ForgotPinViewInput {
	func setupInitialState() {
  	}
}
