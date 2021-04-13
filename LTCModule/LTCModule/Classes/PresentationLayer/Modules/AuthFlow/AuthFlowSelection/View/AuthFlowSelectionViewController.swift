//
//  AuthFlowSelectionAuthFlowSelectionViewController.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedUIModule
import UIKit

class AuthFlowSelectionViewController: UIViewController {
    var output: AuthFlowSelectionViewOutput!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var importButton: TextButton!
    @IBOutlet weak var createButton: TextButton!
    @IBOutlet weak var backButton: ImageButton!
    
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
    }
    
    private func configFonts() {
        titleLabel.font = R.font.poppinsMedium(size: 22)
        subtitleLabel.font = R.font.poppinsRegular(size: 16)
        importButton.titleFont = R.font.poppinsRegular(size: 17)
        createButton.titleFont = R.font.poppinsRegular(size: 17)
    }
    
    private func configColors() {
        view.backgroundColor = R.color.gray2()
        titleLabel.textColor = R.color.dark()
        subtitleLabel.textColor = R.color.gray1()
        
        createButton.style = .main
        createButton.colorBackground = R.color.purple()
        createButton.colorAdditionalBackground = R.color.light()
        createButton.colorTitle = R.color.light()
        
        importButton.style = .additional
        importButton.colorBackground = R.color.blue()
        importButton.colorAdditionalBackground = R.color.light()
        importButton.colorTitle = R.color.light()
    }
    
    private func configLocalization() {
        titleLabel.text = R.string.localization.authFlowSelectionTitle()
        subtitleLabel.text = R.string.localization.authFlowSelectionSubtitle()
        importButton.title = R.string.localization.authFlowSelectionImport()
        createButton.title = R.string.localization.authFlowSelectionCreateNew().capitalized
    }
    
    private func configActions() {
        importButton.touchUpInside = { [weak self] _ in
            self?.output.actionImport()
        }
        
        createButton.touchUpInside = { [weak self] _ in
            self?.output.actionCreateNew()
        }
    }
    
    private func configButton() {
        backButton.image = R.image.backIcon()
        backButton.style = .withoutBackground
        backButton.colorAdditionalBackground = R.color.gray1()
        backButton.touchUpInside = { [weak self] _ in
            self?.output.actionBack()
        }
    }
}

// MARK: - AuthFlowSelectionViewInput

extension AuthFlowSelectionViewController: AuthFlowSelectionViewInput {
    func setupInitialState(showBack: Bool) {
        backButton.isHidden = !showBack
    }
}
