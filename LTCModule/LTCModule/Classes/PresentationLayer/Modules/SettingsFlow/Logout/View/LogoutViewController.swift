//
//  LogoutLogoutViewController.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedUIModule
import UIKit

class LogoutViewController: UIViewController {
    var output: LogoutViewOutput!
    @IBOutlet weak var logoutButton: TextButton!
    @IBOutlet weak var cancelButton: TextButton!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitileLabel: UILabel!
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
        configTitleText()
    }
    
    private func configFonts() {
        titleLabel.font = R.font.poppinsMedium(size: 22)
        subtitileLabel.font = R.font.poppinsRegular(size: 16)
        cancelButton.titleFont = R.font.poppinsRegular(size: 17)
        logoutButton.titleFont = R.font.poppinsRegular(size: 17)
    }
    
    private func configTitleText() {
        titleLabel.attributedText = getTitleString()
    }
    
    private func configButton() {
        backButton.image = R.image.backIcon()
        backButton.style = .withoutBackground
        backButton.colorAdditionalBackground = R.color.gray1()
        backButton.touchUpInside = { [weak self] _ in
            self?.output.actionCancel()
        }
    }
    
    private func configColors() {
        view.backgroundColor = R.color.gray2()
        titleLabel.textColor = R.color.dark()
        subtitileLabel.textColor = R.color.gray1()
        
        cancelButton.style = .main
        cancelButton.colorBackground = R.color.purple()
        cancelButton.colorAdditionalBackground = R.color.light()
        cancelButton.colorTitle = R.color.light()
        
        logoutButton.style = .additional
        logoutButton.colorBackground = R.color.blue()
        logoutButton.colorAdditionalBackground = R.color.light()
        logoutButton.colorTitle = R.color.light()
    }
    
    private func configLocalization() {
        titleLabel.text = R.string.localization.settingsFlowLogoutScreenInfoTitle()
        subtitileLabel.text = R.string.localization.settingsFlowLogoutScreenInfoSubtitle()
        logoutButton.title = R.string.localization.settingsFlowLogoutScreenConfirmButton()
        cancelButton.title = R.string.localization.settingsFlowLogoutScreenCancelButton()
    }
    
    private func configActions() {
        cancelButton.touchUpInside = { [weak self] _ in
            self?.output.actionCancel()
        }
        
        logoutButton.touchUpInside = { [weak self] _ in
            self?.output.actionConfirm()
        }
    }
    
    // MARK: Private
    
    private func getTitleString() -> NSAttributedString {
        let text1 = NSMutableAttributedString(
            string: R.string.localization.settingsFlowLogoutScreenInfoTitle1() + " ",
            attributes: [
                NSAttributedString.Key.font: R.font.poppinsMedium(size: 22) ?? UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: R.color.dark() ?? .blue
            ]
        )
        
        let text2 = NSMutableAttributedString(
            string: R.string.localization.settingsFlowLogoutScreenInfoTitle2() + " ",
            attributes: [
                NSAttributedString.Key.font: R.font.poppinsMedium(size: 22) ?? UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: R.color.blue() ?? .blue
            ]
        )
        
        let text3 = NSMutableAttributedString(
            string: R.string.localization.settingsFlowLogoutScreenInfoTitle3(),
            attributes: [
                NSAttributedString.Key.font: R.font.poppinsMedium(size: 22) ?? UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: R.color.dark() ?? .blue
            ]
        )
        text1.append(text2)
        text1.append(text3)
        return text1
    }
}

// MARK: - LogoutViewInput

extension LogoutViewController: LogoutViewInput {
    func setupInitialState() {
      }
}
