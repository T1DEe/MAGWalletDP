//
//  WalletWithTokenWalletWithTokenViewController.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedUIModule
import UIKit

class WalletWithTokenViewController: UIViewController {
    var output: WalletWithTokenViewOutput!
    @IBOutlet weak var balanceTextLabel: UILabel!
    @IBOutlet weak var balanceValueLabel: UILabel!
    @IBOutlet weak var qrcodeButton: ImageButton!
    @IBOutlet weak var settingsButton: ImageButton!
    @IBOutlet weak var copyButton: ImageButton!
    @IBOutlet weak var accountNameView: UIView!
    @IBOutlet weak var accountInfoLabel: UILabel!
    @IBOutlet weak var tokenBalanceLabel: UILabel!
    @IBOutlet weak var balanceRateLabel: UILabel!
    @IBOutlet weak var tokenImage: UIImageView!
    @IBOutlet weak var tokenBalanceCompactLabel: UILabel!
    @IBOutlet weak var backButton: ImageButton!
    @IBOutlet weak var navGradientView: UIView!
    @IBOutlet weak var compactBalanceLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var accountNameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tokenBalanceTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var balanceTitleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var balanceRateTopConstraint: NSLayoutConstraint!
    
    let tokenBalanceCompactAlphaRange = (40...CGFloat(ContainerOffsetsConstant.topOffset + 40))
    let stackViewRange = (CGFloat(125)...CGFloat(ContainerOffsetsConstant.walletWithTokenAnimationHeight))
    let tokenBalanceRange = (CGFloat(150)...CGFloat(ContainerOffsetsConstant.walletWithTokenAnimationHeight))
    let balanceTitleRange = (CGFloat(173)...CGFloat(ContainerOffsetsConstant.walletWithTokenAnimationHeight))
    let rateRange = (CGFloat(94)...CGFloat(ContainerOffsetsConstant.walletWithTokenAnimationHeight))
    
    // MARK: - Life cycle
    
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
        configImage()
        configNavGradientView()
    }
    
    private func configFonts() {
        balanceTextLabel.font = R.font.poppinsMedium(size: 12)
        balanceValueLabel.font = R.font.poppinsMedium(size: 18)
        accountInfoLabel.font = R.font.poppinsMedium(size: 14)
        tokenBalanceLabel.font = R.font.poppinsMedium(size: 34)
        balanceRateLabel.font = R.font.poppinsMedium(size: 14)
    }
    
    private func configImage() {
//        tokenImage.image = R.image.echo_small()
    }
    
    private func configColors() {
        backButton.style = .withoutBackground
        backButton.colorAdditionalBackground = R.color.gray1()
        balanceTextLabel.textColor = R.color.gray1()
        balanceValueLabel.textColor = R.color.dark()
        accountInfoLabel.textColor = R.color.blue()
        tokenBalanceLabel.textColor = R.color.dark()
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
    
    // MARK: Private
    
    private func setupTokenBalanceCompactState(height: CGFloat) {
        compactBalanceLeadingConstraint.constant = backButton.isHidden ? 16 : 50
        if height < tokenBalanceCompactAlphaRange.lowerBound {
            tokenBalanceCompactLabel.alpha = 1
        } else if height > tokenBalanceCompactAlphaRange.upperBound {
            tokenBalanceCompactLabel.alpha = 0
        } else {
            let fillDiff = tokenBalanceCompactAlphaRange.upperBound - height
            let rangeValue = abs(tokenBalanceCompactAlphaRange.upperBound - tokenBalanceCompactAlphaRange.lowerBound)
            tokenBalanceCompactLabel.alpha = fillDiff / rangeValue
        }
    }

    private func setupAccountNameViewState(height: CGFloat) {
        if height > ContainerOffsetsConstant.walletAnimationHeight {
            accountNameTopConstraint.constant = 137
        } else {
            accountNameTopConstraint.constant = height - 88
        }
    }

    private func setupStackViewState(height: CGFloat) {
        if height > ContainerOffsetsConstant.walletWithTokenAnimationHeight {
            stackViewTopConstraint.constant = 75
        } else if stackViewRange.contains(height) {
            stackViewTopConstraint.constant = height - 145
        } else {
            stackViewTopConstraint.constant = -21
        }
    }

    private func setupTokenBalanceState(height: CGFloat) {
        if height > ContainerOffsetsConstant.walletWithTokenAnimationHeight {
            tokenBalanceTopConstraint.constant = 26
        } else if tokenBalanceRange.contains(height) {
            tokenBalanceTopConstraint.constant = height - 194
        } else {
            tokenBalanceTopConstraint.constant = -42
        }
    }
    
    private func setupBalanceRateState(height: CGFloat) {
        if height > ContainerOffsetsConstant.walletWithTokenAnimationHeight {
            balanceRateTopConstraint.constant = 106
        } else if rateRange.contains(height) {
            balanceRateTopConstraint.constant = height - 114
        } else {
            balanceRateTopConstraint.constant = -42
        }
    }
    
    private func setupBalanceTitleState(height: CGFloat) {
        if height > ContainerOffsetsConstant.walletWithTokenAnimationHeight {
            balanceTitleTopConstraint.constant = 5
        } else if balanceTitleRange.contains(height) {
            balanceTitleTopConstraint.constant = height - 215
        } else {
            balanceTitleTopConstraint.constant = -20
        }
    }
    
    // MARK: Actions
    
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

// MARK: - WalletWithTokenViewInput

extension WalletWithTokenViewController: WalletWithTokenViewInput {
    func setupButtonState(isBackButtonHidden: Bool) {
        backButton.isHidden = isBackButtonHidden
    }

    func setupAddress(entity: WalletAddressEntity) {
        accountInfoLabel.text = entity.address
    }
    
    func setupBalance(entity: WalletBalanceEntity) {
        balanceValueLabel.attributedText = entity.balanceWithCurrency
    }
    
    func setupTokenBalance(entity: WalletTokenBalanceEntity) {
        tokenBalanceLabel.attributedText = entity.tokenBalanceWithCurrency
        tokenBalanceCompactLabel.attributedText = entity.tokenBalanceWithCurrencyCompact
    }
    
    func setupState(height: CGFloat) {
        setupTokenBalanceCompactState(height: height)
        setupAccountNameViewState(height: height)
        setupStackViewState(height: height)
        setupTokenBalanceState(height: height)
        setupBalanceTitleState(height: height)
        setupBalanceRateState(height: height)
    }
    
    func setupBalanceRate(entity: WalletBalanceRateEntity) {
        balanceRateLabel.text = entity.symbol + entity.rate
    }
}
