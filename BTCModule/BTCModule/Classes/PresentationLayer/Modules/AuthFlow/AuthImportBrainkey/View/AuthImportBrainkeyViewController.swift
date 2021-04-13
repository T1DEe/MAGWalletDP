//
//  AuthImportBrainkeyAuthImportBrainkeyViewController.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Lottie
import SharedUIModule
import UIKit

class AuthImportBrainkeyViewController: UIViewController {
    var output: AuthImportBrainkeyViewOutput!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var importButton: TextButton!
    @IBOutlet weak var backButton: ImageButton!
    @IBOutlet weak var wifTextView: TextView!
    @IBOutlet weak var textViewTopConstraint: NSLayoutConstraint!
    
    private var textViewTopDefault: CGFloat?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        output.viewIsReady()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Config
    
    private func config() {
        textViewTopDefault = textViewTopConstraint.constant
        
        configFonts()
        configColors()
        configLocalization()
        configActions()
        configButton()
        configTextView()
        configGesture()
        configKeyboardNotification()
    }
    
    private func configFonts() {
        titleLabel.font = R.font.poppinsMedium(size: 22)
        subtitleLabel.font = R.font.poppinsRegular(size: 16)
        importButton.titleFont = R.font.poppinsRegular(size: 17)
        wifTextView.font = R.font.poppinsMedium(size: 14)
        wifTextView.errorFont = R.font.poppinsMedium(size: 12)
    }
    
    private func configColors() {
        view.backgroundColor = R.color.gray2()
        titleLabel.textColor = R.color.dark()
        subtitleLabel.textColor = R.color.gray1()
        
        importButton.style = .additional
        importButton.colorBackground = R.color.blue()
        importButton.colorAdditionalBackground = R.color.light()
        importButton.colorTitle = R.color.light()
        if let bundle = Bundle(identifier: Constants.bundleIdentifier) {
            let animation = Animation.named(Constants.LottieConstants.lightLoader,
                                            bundle: bundle,
                                            subdirectory: nil,
                                            animationCache: nil)
            
            importButton.animation = animation
        }
        
        backButton.style = .withoutBackground
        backButton.colorAdditionalBackground = R.color.gray1()
        
        wifTextView.highlightColor = R.color.purple()
        wifTextView.errorColor = R.color.pink()
        wifTextView.mainColor = R.color.gray1()
        wifTextView.textColor = R.color.dark()
    }
    
    private func configLocalization() {
        titleLabel.text = R.string.localization.authFlowImportTitle()
        subtitleLabel.text = R.string.localization.authFlowImportSubtitle()
        importButton.title = R.string.localization.authFlowImportImport()
        importButton.loadingTitle = R.string.localization.authFlowImportLoading()
        wifTextView.placeholderText = R.string.localization.authFlowImportPlaceholder()
    }
    
    private func configButton() {
        importButton.disabled = true
        backButton.image = R.image.backIcon()
    }
    
    private func configTextView() {
        wifTextView.delegate = self
        wifTextView.textView.spellCheckingType = .no
        wifTextView.textView.autocorrectionType = .no
    }
    
    private func configActions() {
        importButton.touchUpInside = { [weak self] _ in
            self?.makeImport()
        }
        
        backButton.touchUpInside = { [weak self] _ in
            self?.output.actionBack()
        }
    }
    
    private func configGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(actionTap))
        view.addGestureRecognizer(gesture)
    }
    
    private func configKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    // MARK: Actions
    
    @objc
    private func actionTap() {
        view.endEditing(true)
    }
    
    @objc
    private func keyboardWillShow(notification: Notification) {
        let tuple = getKeyboardParams(notification: notification)
        
        guard checkNeedMoveTextView(keyboardHeigh: tuple.height) else {
            return
        }
        
        let titleHeight = titleLabel.frame.size.height
        let subtitleHeight = subtitleLabel.frame.size.height
        textViewTopConstraint.constant = -titleHeight - subtitleHeight
        
        UIView.animate(withDuration: tuple.duration,
                       delay: 0.0,
                       options: UIView.AnimationOptions(rawValue: tuple.curve),
                       animations: { [weak self] in
                        self?.titleLabel.alpha = 0
                        self?.subtitleLabel.alpha = -1
                        self?.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    @objc
    private func keyboardWillHide(notification: Notification) {
        let topDefault = textViewTopDefault ?? 0
        textViewTopConstraint.constant = topDefault
        
        let tuple = getKeyboardParams(notification: notification)
        
        UIView.animate(withDuration: tuple.duration,
                       delay: 0.0,
                       options: UIView.AnimationOptions(rawValue: tuple.curve),
                       animations: { [weak self] in
                        self?.titleLabel.alpha = 1
                        self?.subtitleLabel.alpha = 1
                        self?.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    private func checkNeedMoveTextView(keyboardHeigh: CGFloat) -> Bool {
        let textViewMaxY = wifTextView.frame.maxY
        let keyboardY = view.frame.size.height - keyboardHeigh
        
        return textViewMaxY >= keyboardY
    }
    
    // MARK: Private
    
    private func getKeyboardParams(notification: Notification) -> (duration: TimeInterval, curve: UInt, height: CGFloat) {
        let durationNumber = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber
        let curveNumber = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let heightNumber = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        let durationTimeInterval = durationNumber?.doubleValue ?? 0
        let curve = curveNumber?.uintValue ?? 0
        let height = heightNumber?.cgRectValue.height ?? 0
        
        return (durationTimeInterval, curve, height)
    }
    
    private func makeImport() {
        guard let wif = wifTextView.getText() else {
            return
        }
        output.actionImport(seed: wif)
    }
}

// MARK: - TextViewDelegate

extension AuthImportBrainkeyViewController: TextViewDelegate {
    func textViewDidEndEditing(textView: TextView) {
        guard textView.getText()?.isEmpty == false else {
            importButton.disabled = true
            return
        }
        if output?.actionCheckBrainkey(seed: textView.getText()) == true {
            importButton.disabled = false
            textView.hideError()
        } else {
            importButton.disabled = true
            textView.showError(R.string.localization.authFlowImportError())
        }
    }
}

// MARK: - AuthImportBrainkeyViewInput

extension AuthImportBrainkeyViewController: AuthImportBrainkeyViewInput {
    func setupInitialState() {
    }
    
    func startLoading() {
        importButton.startLoading()
    }
    
    func endLoading() {
        importButton.endLoading()
    }
    
    func makeTryAction() {
        makeImport()
    }
}
