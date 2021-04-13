//
//  WalletWalletViewController.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedUIModule
import UIKit

class WalletViewController: UIViewController {
    var output: WalletViewOutput!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var balanceTextLabel: UILabel!
    @IBOutlet weak var balanceValueLabel: UILabel!
    @IBOutlet weak var balanceRateLabel: UILabel!
    @IBOutlet weak var qrcodeButton: ImageButton!
    @IBOutlet weak var settingsButton: ImageButton!
    @IBOutlet weak var copyButton: ImageButton!
    @IBOutlet weak var accountNameView: UIView!
    @IBOutlet weak var accountInfoLabel: UILabel!
    @IBOutlet weak var balanceCompactLabel: UILabel!
    @IBOutlet weak var backButton: ImageButton!
    @IBOutlet weak var navGradientView: UIView!
    @IBOutlet weak var compactBalanceLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var balanceTextTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var balanceValueTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var accountNameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var balanceRateTopConstraint: NSLayoutConstraint!
    
    let balanceCompactAlphaRange = (40...CGFloat(ContainerOffsetsConstant.topOffset + 40))
    let tokenBalanceRange = (CGFloat(155)...CGFloat(ContainerOffsetsConstant.walletAnimationHeight))
    let balanceTitleRange = (CGFloat(178)...CGFloat(ContainerOffsetsConstant.walletAnimationHeight))
    let rateRange = (CGFloat(109)...CGFloat(ContainerOffsetsConstant.walletAnimationHeight))
    var isFirstAppear: Bool = true
    
    // MARK: Life - cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewIsReadyToShow()
    }
    
    // MARK: - Configuration
    
    private func config() {
        configBackground()
        configColors()
        configFonts()
        configLocalization()
        configAccountInfo()
        configButtons()
        configNavGradientView()
    }
    
    private func configFonts() {
        balanceTextLabel.font = R.font.poppinsMedium(size: 12)
        balanceValueLabel.font = R.font.poppinsMedium(size: 34)
        accountInfoLabel.font = R.font.poppinsMedium(size: 14)
        balanceRateLabel.font = R.font.poppinsMedium(size: 14)
    }
    
    private func configColors() {
        backButton.style = .withoutBackground
        backButton.colorAdditionalBackground = R.color.gray1()

        balanceTextLabel.textColor = R.color.gray1()
        balanceValueLabel.textColor = R.color.dark()
        accountInfoLabel.textColor = R.color.blue()
        
        qrcodeButton.style = .withoutBackground
        qrcodeButton.colorAdditionalBackground = R.color.gray1()
        
        settingsButton.style = .withoutBackground
        settingsButton.colorAdditionalBackground = R.color.gray1()
        
        balanceRateLabel.textColor = R.color.dark()?.withAlphaComponent(0.5)
    }
    
    private func configLocalization() {
        balanceTextLabel.text = R.string.localization.mainFlowWalletTitle()
    }
    
    private func configButtons() {
        qrcodeButton.image = R.image.qrcode()
        qrcodeButton.touchUpInside = { [weak self] _ in
            self?.actionQRCode()
        }
        settingsButton.image = R.image.settings()
        settingsButton.touchUpInside = { [weak self] _ in
            self?.actionSettings()
        }
        copyButton.image = R.image.copy()
        copyButton.touchUpInside = { [weak self] _ in
            self?.actionCopy()
        }
        backButton.image = R.image.backIcon()
        backButton.touchUpInside = { [weak self] _ in
            self?.output.actionBack()
        }
    }
    
    private func configBackground() {
        view.backgroundColor = R.color.light()
    }
    
    private func configAccountInfo() {
        accountNameView.layer.cornerRadius = 4
        accountNameView.layer.borderColor = R.color.gray2()?.cgColor
        accountNameView.layer.borderWidth = 1
        accountNameView.backgroundColor = R.color.gray2()?.withAlphaComponent(0.3)
    }

    private func configNavGradientView() {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.colors = [
                           UIColor.white.withAlphaComponent(0.0).cgColor,
                           UIColor.white.withAlphaComponent(1.0).cgColor
        ]
        gradient.frame = navGradientView.bounds
        navGradientView.layer.mask = gradient
    }
    
    // MARK: - Private
    
    private func setupBalanceCompactState(height: CGFloat) {
        compactBalanceLeadingConstraint.constant = backButton.isHidden ? 16 : 50
        if height < balanceCompactAlphaRange.lowerBound {
            balanceCompactLabel.alpha = 1
        } else if height > balanceCompactAlphaRange.upperBound {
            balanceCompactLabel.alpha = 0
        } else {
            let fillDiff = balanceCompactAlphaRange.upperBound - height
            let rangeValue = abs(balanceCompactAlphaRange.upperBound - balanceCompactAlphaRange.lowerBound)
            balanceCompactLabel.alpha = fillDiff / rangeValue
        }
    }
    
    private func setupAccountNameViewState(height: CGFloat) {
        if height > ContainerOffsetsConstant.walletAnimationHeight {
            accountNameTopConstraint.constant = 137
        } else {
            accountNameTopConstraint.constant = height - 88
        }
    }
    
    private func setupBalanceState(height: CGFloat) {
        if height > ContainerOffsetsConstant.walletAnimationHeight {
            balanceValueTopConstraint.constant = 26
        } else if tokenBalanceRange.contains(height) {
            balanceValueTopConstraint.constant = height - 199
        } else {
            balanceValueTopConstraint.constant = -42
        }
    }
    
    // How it works:
    // 1. Pin your view or label top constraint to NavView bottom = [value]
    // 2. Use [value] if height > ContainerOffsetsConstant.walletAnimationHeight
    // 3. Use height - [magic constant] where [magic constant] is your range lowerBound + 42
    // 4. Else use constant for just hide your view or label under the NavView
    private func setupRateState(height: CGFloat) {
        if height > ContainerOffsetsConstant.walletAnimationHeight {
            balanceRateTopConstraint.constant = 74
        } else if rateRange.contains(height) {
            balanceRateTopConstraint.constant = height - 151
        } else {
            balanceRateTopConstraint.constant = -42
        }
    }
    
    private func setupBalanceTitleState(height: CGFloat) {
        if height > ContainerOffsetsConstant.walletAnimationHeight {
            balanceTextTopConstraint.constant = 5
        } else if balanceTitleRange.contains(height) {
            balanceTextTopConstraint.constant = height - 220
        } else {
            balanceTextTopConstraint.constant = -20
        }
    }

    // MARK: - Actions
    
    private func actionSettings() {
        output.actionSettings()
    }
    
    private func actionQRCode() {
        output.actionQRcode()
    }
    
    private func actionCopy() {
        output.actionCopy(text: accountInfoLabel.text ?? "")
    }
}

// MARK: - WalletViewInput

extension WalletViewController: WalletViewInput {
    func setupButtonState(isBackButtonHidden: Bool) {
        backButton.isHidden = isBackButtonHidden
    }

    func setupState(entity: WalletEntity) {
        balanceValueLabel.attributedText = entity.balanceWithCurrency
        balanceCompactLabel.attributedText = entity.balanceWithCurrencyCompact
        accountInfoLabel.text = entity.address
  	}
    
    func setupState(height: CGFloat) {
        setupBalanceCompactState(height: height)
        setupAccountNameViewState(height: height)
        setupBalanceState(height: height)
        setupBalanceTitleState(height: height)
        setupRateState(height: height)
    }
    
    func setupBalanceRate(entity: WalletBalanceRateEntity) {
        balanceRateLabel.text = entity.symbol + entity.rate
    }
}
