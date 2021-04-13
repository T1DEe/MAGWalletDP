//
//  SendViewController.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Lottie
import SharedFilesModule
import SharedUIModule
import SnapKit
import UIKit

class SendViewController: UIViewController {
    var output: SendViewOutput!
    
    @IBOutlet weak var backButton: ImageButton!
    @IBOutlet weak var qrcodeButton: ImageButton!
    @IBOutlet weak var balanceValueLabel: UILabel!
    @IBOutlet weak var sendButton: TextButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var addressTextField: TextField!
    @IBOutlet weak var amountTextField: TextField!
    @IBOutlet weak var currencyAmountTextField: TextField!
    @IBOutlet weak var sendAllButton: UIButton!
    @IBOutlet weak var feeTextField: TextField!
    @IBOutlet weak var tokenBalanceValueLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomGradientView: UIView!
    @IBOutlet weak var topGradientView: UIView!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendAllCurrencyButton: UIButton!
    
    private let contentViewBottomConstant: CGFloat = 96
    private let contentViewBottomWithKeyboardConstant: CGFloat = 20
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        bindToKeyboard()
        output.viewIsReady()
    }
    
    // MARK: Config
    
    private func config() {
        configBackground()
        configColors()
        configFonts()
        configLocalization()
        configButton()
        configAccountName()
        configAmount()
        configCurrencyAmount()
        configFee()
        configTopGradientView()
        configBottomGradientView()
    }
    
    private func configBackground() {
        view.backgroundColor = R.color.light()
    }
    
    private func configAccountName() {
        addressTextField.delegate = self
        addressTextField.textField.autocorrectionType = .no
    }
    
    private func configAmount() {
        amountTextField.delegate = self
        amountTextField.textField.spellCheckingType = .no
        amountTextField.textField.autocorrectionType = .no
        amountTextField.textField.keyboardType = .decimalPad
    }
    
    private func configCurrencyAmount() {
        currencyAmountTextField.delegate = self
        currencyAmountTextField.dropDownImage = nil
        currencyAmountTextField.textField.spellCheckingType = .no
        currencyAmountTextField.textField.autocorrectionType = .no
        currencyAmountTextField.textField.keyboardType = .decimalPad
        currencyAmountTextField.showAdditionals()
    }
    
    private func configFee() {
        feeTextField.delegate = self
        feeTextField.setEnableState(isEnable: false)
        feeTextField.textField.keyboardType = .decimalPad
        feeTextField.textField.autocorrectionType = .no
    }
    
    private func configColors() {
        balanceValueLabel.textColor = R.color.dark()
        rateLabel.textColor = R.color.gray1()?.withAlphaComponent(0.7)
        titleLabel.textColor = R.color.dark()
        backButton.style = .withoutBackground
        backButton.colorAdditionalBackground = R.color.gray1()
        qrcodeButton.style = .withoutBackground
        qrcodeButton.colorAdditionalBackground = R.color.gray1()
        
        feeTextField.highlightColor = R.color.purple()
        feeTextField.errorColor = R.color.pink()
        feeTextField.mainColor = R.color.gray1()
        feeTextField.textColor = R.color.dark()
        feeTextField.disabledMainColor = R.color.gray1()

        amountTextField.highlightColor = R.color.purple()
        amountTextField.errorColor = R.color.pink()
        amountTextField.mainColor = R.color.gray1()
        amountTextField.textColor = R.color.dark()
        amountTextField.dropDownImage = R.image.drop_down()

        currencyAmountTextField.highlightColor = R.color.purple()
        currencyAmountTextField.errorColor = R.color.pink()
        currencyAmountTextField.mainColor = R.color.gray1()
        currencyAmountTextField.textColor = R.color.dark()
        currencyAmountTextField.dropDownImage = R.image.drop_down()
        
        addressTextField.highlightColor = R.color.purple()
        addressTextField.errorColor = R.color.pink()
        addressTextField.mainColor = R.color.gray1()
        addressTextField.textColor = R.color.dark()
        
        sendButton.style = .main
        sendButton.colorBackground = R.color.purple()
        sendButton.colorAdditionalBackground = R.color.light()
        sendButton.colorTitle = R.color.light()
        if let bundle = Bundle(identifier: Constants.bundleIdentifier) {
            let animation = Animation.named(Constants.LottieConstants.lightLoader,
                                            bundle: bundle,
                                            subdirectory: nil,
                                            animationCache: nil)
            sendButton.animation = animation
        }
        
        sendAllButton.setTitleColor(R.color.blue(), for: .normal)
    }
    
    private func configButton() {
        backButton.image = R.image.backIcon()
        backButton.touchUpInside = { [weak self] _ in
            self?.output.actionBack()
        }
        
        qrcodeButton.image = R.image.qrcode()
        qrcodeButton.touchUpInside = { [weak self] _ in
            self?.output.actionQRCode()
        }
        
        sendButton.touchUpInside = { [weak self] _ in
            self?.output.actionSend()
        }
    }
    
    private func configLocalization() {
        titleLabel.text = R.string.localization.sendFlowTitle()
        addressTextField.titleText = R.string.localization.sendFlowAddressTextFieldTitle()
        addressTextField.placeholderText = R.string.localization.sendFlowAddressTextFieldPlaceholder()
        
        amountTextField.titleText = R.string.localization.sendFlowAmountTextFieldTitle()
        amountTextField.placeholderText = R.string.localization.sendFlowAmountTextFieldPlaceholder().toFormattedCropNumber()
        
        currencyAmountTextField.titleText = R.string.localization.sendFlowAmountCurrencyTextField()
        currencyAmountTextField.placeholderText = R.string.localization.sendFlowAmountCurrencyTextFieldPlaceholder().toFormattedCropNumber()
        currencyAmountTextField.setAdditionalText(R.string.localization.sendFlowAmountCurrencyTextFieldAdditional())
        
        feeTextField.titleText = R.string.localization.sendFlowFeeTextFieldTitle()
        feeTextField.placeholderText = R.string.localization.sendFlowFeeTextFieldPlaceholder().toFormattedCropNumber()
        
        sendButton.title = R.string.localization.sendFlowSendButtonText()
        sendButton.loadingTitle = R.string.localization.sendFlowSendButtonLoadingText()
        
        sendAllButton.setTitle(R.string.localization.sendFlowSendAllButtonText(), for: .normal)
    }
    
    private func configFonts() {
        titleLabel.font = R.font.poppinsRegular(size: 22)
        
        balanceValueLabel.font = R.font.poppinsMedium(size: 14)
        rateLabel.font = R.font.poppinsMedium(size: 12)
        
        sendButton.titleFont = R.font.poppinsRegular(size: 17)
        feeTextField.font = R.font.poppinsMedium(size: 14)
        feeTextField.errorFont = R.font.poppinsMedium(size: 12)
        
        amountTextField.font = R.font.poppinsMedium(size: 14)
        amountTextField.errorFont = R.font.poppinsMedium(size: 12)
        
        currencyAmountTextField.font = R.font.poppinsMedium(size: 14)
        currencyAmountTextField.errorFont = R.font.poppinsMedium(size: 12)
        
        addressTextField.font = R.font.poppinsMedium(size: 14)
        addressTextField.errorFont = R.font.poppinsMedium(size: 12)
        
        sendAllButton.titleLabel?.font = R.font.poppinsMedium(size: 14)
    }
    
    private func configTopGradientView() {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.locations = [0.0, 0.8, 0.8, 1]
        gradient.colors = [
            UIColor.white.withAlphaComponent(1.0).cgColor,
            UIColor.white.withAlphaComponent(1.0).cgColor,
            UIColor.white.withAlphaComponent(0.8).cgColor,
            UIColor.white.withAlphaComponent(0).cgColor
        ]
        gradient.frame = topGradientView.bounds
        topGradientView.layer.mask = gradient
    }
    
    private func configBottomGradientView() {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.locations = [0.0, 0.2, 0.2, 1]
        gradient.colors = [
            UIColor.white.withAlphaComponent(0.0).cgColor,
            UIColor.white.withAlphaComponent(0.8).cgColor,
            UIColor.white.withAlphaComponent(1.0).cgColor,
            UIColor.white.withAlphaComponent(1.0).cgColor
        ]
        gradient.frame = bottomGradientView.bounds
        bottomGradientView.layer.mask = gradient
    }
    
    private func updateAmount(for textField: TextField, decimals: Int) {
        let text = textField.getText()
        guard let dotIndex = text.firstIndex(of: ".") else {
            return
        }
        let end = String(text[dotIndex..<text.endIndex])
        if end.count > decimals {
            let updatedText = String(text.dropLast(end.count - decimals - 1))
            textField.setText(updatedText)
        }
    }
    
    // MARK: Actions
    @IBAction func actionVoidTap(_ sender: Any) {
        view.endEditing(false)
    }
    
    @IBAction func actionSendAll(_ sender: Any) {
        output?.actionSendAll()
        output?.actionUpdateFee()
    }
    
    @IBAction func actionSendAllCurrency(_ sender: Any) {
        output?.actionSendAll()
        output?.actionUpdateFee()
    }
}

extension SendViewController {
    private func bindToKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc
    private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return
        }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        scrollViewBottomConstraint.constant = -keyboardHeight + view.safeAreaInsets.bottom
        contentViewBottomConstraint.constant = contentViewBottomWithKeyboardConstant
        
        UIView.animate(withDuration: Double(truncating: duration)) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    private func keyboardHide(notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return
        }
        
        scrollViewBottomConstraint.constant = 0
        contentViewBottomConstraint.constant = contentViewBottomConstant
        
        UIView.animate(withDuration: Double(truncating: duration)) {
            self.view.layoutIfNeeded()
        }
    }
}

extension SendViewController: TextFieldDelegate {
    func shouldChangeCharacters(textField: TextField, in range: NSRange, replacementString string: String) -> Bool {
        let nsstring = NSMutableString(string: textField.getText())
        let text = String(nsstring.replacingCharacters(in: range, with: string))
        
        if textField == amountTextField {
            if textField.getText().count > text.count { // delete character without problem
                return true
            }
            return output.actionValidateAmountFormat(amount: text)
        }
        
        if textField == currencyAmountTextField {
            if textField.getText().count > text.count {
                return true
            }
            return output.actionValidateCurrencyAmountFormat(amount: text)
        }
        
        if textField == addressTextField {
            output.actionValidateToAddress(toAddress: text)
        }
        
        return true
    }
    
    func textDidChange(textField: TextField, resultText: String?) {
        if textField == amountTextField {
            output.actionUpdateCurrencyAmount(amount: textField.getText(), shouldFieldError: false)
        }
        
        if textField == currencyAmountTextField, !currencyAmountTextField.isHidden {
            output.actionUpdateAmount(amount: textField.getText(), shouldFieldError: false)
        }
        
        output.actionUpdateFee()
    }
    
    func additinalViewTap(textField: TextField) {
        hideKeyboard()
        if textField == feeTextField {
            output.actionSelectFeeCurrencies()
        } else if textField == amountTextField {
            output.actionSelectAmountCurrencies()
        }
    }
    
    func textFieldDidEndEditing(textField: TextField) {
        if textField == addressTextField {
            output.actionValidateToAddress(toAddress: textField.getText())
        }
        
        if textField == amountTextField {
            output.actionValidateAmount(amount: textField.getText())
        }
        
        if textField == currencyAmountTextField, !currencyAmountTextField.isHidden {
            output.actionValidateCurrencyAmount(amount: textField.getText())
        }
    }
}

// MARK: - SendViewInput

extension SendViewController: SendViewInput {
    func setCurrencyForAmount(_ currency: Currency) {
        amountTextField.setAdditionalText(currency.symbol)
        updateAmount(for: amountTextField, decimals: currency.decimals)
        updateAmount(for: currencyAmountTextField, decimals: currency.decimals)
        amountTextField.hideError()
        currencyAmountTextField.hideError()
        output.actionValidateAmount(amount: amountTextField.getText())
        output.actionValidateCurrencyAmount(amount: currencyAmountTextField.getText())
    }
    
    func setCurrencyForFee(_ currency: Currency) {
        feeTextField.setAdditionalText(currency.symbol)
    }
    
    func setupAdditionalTokenInputs() {
        amountTextField.showAdditionals()
        feeTextField.showAdditionals()
        
        amountTextField.titleText = R.string.localization.sendFlowAmountTextFieldTitleWithoutCurrency()
    }
    
    func setupBalance(entity: WalletBalanceEntity, hasToken: Bool) {
        if hasToken {
            tokenBalanceValueLabel.attributedText = entity.balanceWithCurrency
        } else {
            balanceValueLabel.attributedText = entity.balanceWithCurrency
        }
    }
    
    func setupTokenBalance(entity: WalletTokenBalanceEntity) {
        balanceValueLabel.attributedText = entity.tokenBalanceWithCurrency
    }
    
    func setupBalance(entity: SendCurrentBalanceEntity) {
        balanceValueLabel.attributedText = entity.balance
    }
    
    func setupBalanceRate(entity: WalletBalanceRateEntity) {
        rateLabel.text = entity.symbol + entity.rate
    }
    
    func setupErrors(entity: SendErrorEntity) {
        if let amountError = entity.amountError {
            amountTextField.showError(amountError)
            if !currencyAmountTextField.isHidden {
                currencyAmountTextField.showError(amountError)
            }
        }
        
        if let toAddressError = entity.toAddressError {
            addressTextField.showError(toAddressError)
        }
        
        if let feeError = entity.feeError {
            feeTextField.showError(feeError)
        }
    }
    
    func setupFee(entity: SendFeeEntity) {
        feeTextField.setText(entity.fee)
    }
    
    func setupToAddress(entity: SendToAddressEntity) {
        addressTextField.setText(entity.toAddress)
        output.actionValidateToAddress(toAddress: entity.toAddress ?? "")
    }
    
    func setupAmount(entity: SendAmountEntity, shouldValidate: Bool) {
        amountTextField.setText(entity.amount)
        if shouldValidate {
            output.actionValidateAmount(amount: entity.amount ?? "")
        }
    }
    
    func setupCurrencyAmount(entity: SendAmountEntity, shouldValidate: Bool) {
        currencyAmountTextField.setText(entity.currencyAmount)
        if shouldValidate {
            output.actionValidateCurrencyAmount(amount: entity.currencyAmount ?? "")
        }
    }
    
    func obtainAmount() -> String {
        return amountTextField.getText()
    }
    
    func obtainAccountName() -> String {
        return addressTextField.getText()
    }
    
    func hideKeyboard() {
        view.endEditing(false)
    }
    
    func showLoader() {
        sendButton.startLoading()
    }
    
    func hideLoader() {
        sendButton.endLoading()
    }
    
    func changeRatesVisibility(_ visible: Bool) {
        currencyAmountTextField.isHidden = !visible
    }
}
