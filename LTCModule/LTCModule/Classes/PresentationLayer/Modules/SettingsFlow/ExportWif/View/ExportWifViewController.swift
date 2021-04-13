//
//  ExportBrainkeyViewController.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedUIModule
import UIKit

class ExportBrainkeyViewController: UIViewController {
    var output: ExportBrainkeyViewOutput!

    @IBOutlet weak var backButton: ImageButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: TextView!
    @IBOutlet weak var copyButton: TextButton!
    
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
        copyButton.titleFont = R.font.poppinsRegular(size: 17)
        textView.font = R.font.poppinsMedium(size: 14)
        textView.errorFont = R.font.poppinsMedium(size: 12)
    }
    
    private func configColors() {
        view.backgroundColor = R.color.gray2()
        titleLabel.textColor = R.color.dark()

        copyButton.style = .additional
        copyButton.colorBackground = R.color.blue()
        copyButton.colorAdditionalBackground = R.color.light()
        copyButton.colorTitle = R.color.light()
        
        backButton.style = .withoutBackground
        backButton.colorAdditionalBackground = R.color.gray1()
        
        textView.highlightColor = R.color.purple()
        textView.errorColor = R.color.pink()
        textView.mainColor = R.color.gray1()
        textView.textColor = R.color.dark()
    }
    
    private func configLocalization() {
        titleLabel.text = R.string.localization.exportWifSaveBrainkeyTitle()
        copyButton.title = R.string.localization.exportWifScreenCopyButtonTitle()
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
        
        backButton.touchUpInside = { [weak self] _ in
            self?.output.actionBack()
        }
    }
}

// MARK: - ExportBrainkeyViewInput

extension ExportBrainkeyViewController: ExportBrainkeyViewInput {
    func setupInitialState(brainkey: String) {
        textView.setText(brainkey)
      }
}
