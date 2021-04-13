//
//  SplashSplashViewController.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    var output: SplashViewOutput!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        output.viewIsReady()
    }

    // MARK: Configuration
    private func config() {
        configLocalization()
        configFonts()
        configColors()
    }

    private func configLocalization() {
        subtitleLabel.text = R.string.localization.splashScreenSubtitle()
        titleLabel.text = R.string.localization.splashScreenTitle()
    }

    private func configFonts() {
        subtitleLabel.font = R.font.poppinsRegular(size: 16)
        titleLabel.font = R.font.poppinsMedium(size: 34)
    }

    private func configColors() {
        view.backgroundColor = R.color.gray2()
        subtitleLabel.textColor = R.color.gray1()
        titleLabel.textColor = R.color.dark()
    }
}

// MARK: - SplashViewInput

extension SplashViewController: SplashViewInput {
    func setupInitialState() {
    }
}
