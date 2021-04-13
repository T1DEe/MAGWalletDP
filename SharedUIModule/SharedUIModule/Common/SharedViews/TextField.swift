//
//  TextField.swift
//  SharedUIModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SnapKit
import UIKit

public protocol TextFieldDelegate: class {
    func textDidChange(textField: TextField, resultText: String?)
    func textFieldDidBeginEditing(textField: TextField)
    func textFieldDidEndEditing(textField: TextField)
    func returnDidTap(textField: TextField)
    func additinalViewTap(textField: TextField)
    func shouldChangeCharacters(textField: TextField, in range: NSRange, replacementString string: String) -> Bool
}

public extension TextFieldDelegate {
    func textDidChange(textField: TextField, resultText: String?) {}
    func textFieldDidBeginEditing(textField: TextField) {}
    func textFieldDidEndEditing(textField: TextField) {}
    func returnDidTap(textField: TextField) {}
    func shouldChangeCharacters(textField: TextField, in range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func additinalViewTap(textField: TextField) {}
}

public class TextField: UIView {
    public weak var delegate: TextFieldDelegate?
    public let textField = UITextField()

    private var isErrorShowed = false
    private var isHighlighted = false
    private var isEnable = true

    private let titleLabel = UILabel()
    private let textFieldContainer = UIView()
    private let additionMenuContainer = UIView()
    private let additionMenuLabel = UILabel()
    private let placeholderLabel = UILabel()
    private let errorLabel = UILabel()
    private let dropDownImageView = UIImageView()

    private var additionalViewExpandConstraint: ConstraintMakerEditable?
    private var additionalViewCompactConstraint: ConstraintMakerEditable?
    private let containerTopOffset: CGFloat = 4
    private let errorTopOffset: CGFloat = 6
    private let containerHeight: CGFloat = 48
    private let textFieldHorizontalOffset: CGFloat = 10
    private let additionContainerWidth: CGFloat = 119
    private let additionLabelLeft: CGFloat = 16
    private let additionLabelRight: CGFloat = 46

    private let borderWidth: CGFloat = 1
    private let highlightBorderWidth: CGFloat = 2
    private let cornerRadius: CGFloat = 2
    
    private let titleAlpha: CGFloat = 0.5
    private let placeholderAlpha: CGFloat = 0.5
    private let textDisabledAlpha: CGFloat = 0.8
    
    private let backgroundAlpha: CGFloat = 0.1
    private let backgroundDisabledAlpha: CGFloat = 0.2
    private let bordersAlpha: CGFloat = 0.3
    
    public var textColor: UIColor? {
        didSet {
            titleLabel.textColor = textColor?.withAlphaComponent(titleAlpha)
            placeholderLabel.textColor = textColor?.withAlphaComponent(placeholderAlpha)
            textField.textColor = textColor
            additionMenuLabel.textColor = textColor
        }
    }
    
    public var dropDownImage: UIImage? {
        didSet {
            dropDownImageView.image = dropDownImage
        }
    }
    
    public var mainColor: UIColor? {
        didSet {
            textFieldContainer.backgroundColor = mainColor?.withAlphaComponent(backgroundAlpha)
            textFieldContainer.layer.borderColor = mainColor?.withAlphaComponent(bordersAlpha).cgColor
            additionMenuContainer.backgroundColor = mainColor?.withAlphaComponent(backgroundAlpha)
            additionMenuContainer.layer.borderColor = mainColor?.withAlphaComponent(bordersAlpha).cgColor
        }
    }
    
    public var disabledMainColor: UIColor?
    
    public var highlightColor: UIColor? {
        didSet {
            textField.tintColor = highlightColor
        }
    }
    
    public var errorColor: UIColor? {
        didSet {
            errorLabel.textColor = errorColor
        }
    }
    
    public var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    public var placeholderText: String? {
        didSet {
            placeholderLabel.text = placeholderText
        }
    }
    
    public var font: UIFont? {
        didSet {
            textField.font = font
            placeholderLabel.font = font
            titleLabel.font = font
            additionMenuLabel.font = font
        }
    }
    
    public var errorFont: UIFont? {
        didSet {
            errorLabel.font = errorFont
        }
    }
    
    // MARK: Init
    
    public init() {
        super.init(frame: CGRect.zero)
        
        config()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        config()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        config()
    }
    
    // MARK: Config
    
    private func config() {
        backgroundColor = UIColor.clear
        
        configTitleLabel()
        configContainer()
        confgiPlaceholderLabel()
        configTextField()
        configAdditionContainer()
        configErrorLabel()
    }
    
    private func configTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
    }
    
    private func configContainer() {
        textFieldContainer.layer.masksToBounds = true
        textFieldContainer.layer.cornerRadius = cornerRadius
        textFieldContainer.layer.borderWidth = borderWidth
        
        addSubview(textFieldContainer)
        textFieldContainer.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(containerHeight)
            make.top.equalTo(titleLabel.snp.bottom).offset(containerTopOffset)
        }
    }
    
    private func configAdditionContainer() {
        additionMenuContainer.layer.masksToBounds = true
        additionMenuContainer.layer.cornerRadius = cornerRadius
        additionMenuContainer.layer.borderWidth = borderWidth
        
        addSubview(additionMenuContainer)
        additionMenuContainer.snp.makeConstraints { make in
            make.left.equalTo(textFieldContainer.snp.right).inset(borderWidth)
            make.right.equalToSuperview()
            make.height.equalTo(containerHeight)
            additionalViewCompactConstraint = make.width.equalTo(0)
            make.top.equalTo(titleLabel.snp.bottom).offset(containerTopOffset)
        }

        additionMenuContainer.addSubview(dropDownImageView)
        dropDownImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(86).priority(999)
            make.right.equalToSuperview().inset(12)
            make.height.width.equalTo(22)
            make.centerY.equalToSuperview()
        }

        additionMenuContainer.addSubview(additionMenuLabel)
        additionMenuLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(additionLabelLeft).priority(999)
            make.right.equalToSuperview().inset(additionLabelRight)
            make.top.bottom.equalToSuperview()
        }
        
        let button = UIButton()
        additionMenuContainer.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        button.addTarget(self, action: #selector(actionSelectAddition), for: .touchUpInside)
    }
    
    private func configTextField() {
        textField.borderStyle = .none
        textField.autocapitalizationType = .none
        textField.delegate = self
        textField.backgroundColor = UIColor.clear
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                            for: UIControl.Event.editingChanged)
        
        textFieldContainer.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(textFieldHorizontalOffset)
            make.right.equalToSuperview().offset(-textFieldHorizontalOffset)
        }
    }
    
    private func confgiPlaceholderLabel() {
        textFieldContainer.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(textFieldHorizontalOffset)
        }
    }
    
    private func configErrorLabel() {
        addSubview(errorLabel)
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldContainer.snp.bottom).offset(errorTopOffset)
            make.right.equalTo(textFieldContainer.snp.right)
        }
    }
    
    // MARK: Private
    
    private func showOrHidePlaceholder() {
        if textField.text == nil || textField.text?.isEmpty == true {
            placeholderLabel.alpha = 1.0
        } else {
            placeholderLabel.alpha = 0.0
        }
    }
    
    private func highlightView() {
        isHighlighted = true
        textFieldContainer.layer.borderWidth = highlightBorderWidth
        textFieldContainer.layer.borderColor = highlightColor?.cgColor
    }
    
    private func unhighlightView() {
        isHighlighted = false
        if isErrorShowed {
            textFieldContainer.layer.borderWidth = highlightBorderWidth
            textFieldContainer.layer.borderColor = errorColor?.cgColor
        } else {
            errorLabel.isHidden = true
            textFieldContainer.layer.borderWidth = borderWidth
            textFieldContainer.layer.borderColor = mainColor?.withAlphaComponent(bordersAlpha).cgColor
        }
    }
    
    // MARK: Public
    
    public func setAdditionalText(_ text: String) {
        additionMenuLabel.text = text
    }
    
    public func showAdditionals() {
        additionMenuContainer.snp.remakeConstraints { make in
            make.left.equalTo(textFieldContainer.snp.right).inset(borderWidth)
            make.right.equalToSuperview()
            make.height.equalTo(containerHeight)
            additionalViewExpandConstraint = make.width.equalTo(additionContainerWidth)
            make.top.equalTo(titleLabel.snp.bottom).offset(containerTopOffset)
        }
        
        layoutIfNeeded()
    }
    
    public func hideAdditionals() {
        additionMenuContainer.snp.remakeConstraints { make in
            make.left.equalTo(textFieldContainer.snp.right).inset(borderWidth)
            make.right.equalToSuperview()
            make.height.equalTo(containerHeight)
            additionalViewExpandConstraint = make.width.equalTo(0)
            make.top.equalTo(titleLabel.snp.bottom).offset(containerTopOffset)
        }
        layoutIfNeeded()
    }
    
    public func showError(_ errorText: String) {
        if isErrorShowed {
            return
        }
        
        isErrorShowed = true
        errorLabel.text = errorText
        errorLabel.isHidden = false
        
        textFieldContainer.layer.borderWidth = highlightBorderWidth
        textFieldContainer.layer.borderColor = errorColor?.cgColor
    }
    
    public func hideError() {
        isErrorShowed = false
        errorLabel.isHidden = true
        
        if isHighlighted {
            highlightView()
        } else {
            unhighlightView()
        }
    }
    
    public func setEnableState(isEnable: Bool) {
        self.isEnable = isEnable
        if isEnable {
            textField.isUserInteractionEnabled = true
            textFieldContainer.backgroundColor = mainColor?.withAlphaComponent(backgroundAlpha)
        } else {
            textField.isUserInteractionEnabled = false
            textFieldContainer.backgroundColor = disabledMainColor?.withAlphaComponent(backgroundDisabledAlpha)
        }
    }
    
    public func setText(_ text: String?) {
        if let text = text, !text.isEmpty {
            textField.text = text
        } else {
            textField.text = ""
            unhighlightView()
        }
        showOrHidePlaceholder()
        hideError()
    }
    
    public func getText() -> String {
        return textField.text ?? ""
    }
    
    // MARK: Actions
    @objc
    private func actionSelectAddition() {
        delegate?.additinalViewTap(textField: self)
    }
}

extension TextField: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldDidBeginEditing(textField: self)
        
        hideError()
        
        showOrHidePlaceholder()
        highlightView()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        showOrHidePlaceholder()
        unhighlightView()
        
        delegate?.textFieldDidEndEditing(textField: self)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var shoudReplace = true
        
        if let shoud = delegate?.shouldChangeCharacters(textField: self,
                                                        in: range,
                                                        replacementString: string) {
            shoudReplace = shoud
        }
        
        if shoudReplace {
            hideError()
        }
        
        return shoudReplace
    }
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        showOrHidePlaceholder()
        delegate?.textDidChange(textField: self, resultText: textField.text)
    }
}
