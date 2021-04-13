//
//  TextView.swift
//  SharedUIModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SnapKit
import UIKit

public protocol TextViewDelegate: class {
    func textDidChange(textView: TextView, resultText: String?)
    func textViewDidBeginEditing(textView: TextView)
    func textViewDidEndEditing(textView: TextView)
    func returnDidTap(textView: TextView)
    func shouldChangeCharacters(textView: TextView, in range: NSRange, replacementString string: String) -> Bool
}

public extension TextViewDelegate {
    func textDidChange(textView: TextView, resultText: String?) {}
    func textViewDidBeginEditing(textView: TextView) {}
    func textViewDidEndEditing(textView: TextView) {}
    func returnDidTap(textView: TextView) {}
    func shouldChangeCharacters(textView: TextView, in range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

public class TextView: UIView {
    public weak var delegate: TextViewDelegate?
    
    fileprivate var isErrorShowed = false
    fileprivate var isHighlighted = false
    
    public let textView = UITextView()
    
    private let textViewContainer = UIView()
    private let placeholderLabel = UILabel()
    private let errorLabel = UILabel()
    
    private let errorTopOffset: CGFloat = 6
    private let containerHeight: CGFloat = 77
    private let textViewHorizontalOffset: CGFloat = 10
    private let textViewVerticalOffset: CGFloat = 8
    
    private let borderWidth: CGFloat = 1
    private let highlightBorderWidth: CGFloat = 2
    private let cornerRadius: CGFloat = 2
    
    private let placeholderAlpha: CGFloat = 0.5
    private let textDisabledAlpha: CGFloat = 0.8
    
    private let backgroundAlpha: CGFloat = 0.1
    private let backgroundDisabledAlpha: CGFloat = 0.2
    private let bordersAlpha: CGFloat = 0.3
    
    public var textColor: UIColor? {
        didSet {
            placeholderLabel.textColor = textColor?.withAlphaComponent(placeholderAlpha)
            textView.textColor = textColor
        }
    }
    
    public var mainColor: UIColor? {
        didSet {
            textViewContainer.backgroundColor = mainColor?.withAlphaComponent(backgroundAlpha)
            textViewContainer.layer.borderColor = mainColor?.withAlphaComponent(bordersAlpha).cgColor
        }
    }
    
    public var highlightColor: UIColor? {
        didSet {
            textView.tintColor = highlightColor
        }
    }
    
    public var errorColor: UIColor? {
        didSet {
            errorLabel.textColor = errorColor
        }
    }
    
    public var placeholderText: String? {
        didSet {
            placeholderLabel.text = placeholderText
        }
    }
    
    public var font: UIFont? {
        didSet {
            textView.font = font
            placeholderLabel.font = font
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
        
        configContainer()
        confgiPlaceholderLabel()
        configTextView()
        configErrorLabel()
    }
    
    private func configContainer() {
        textViewContainer.layer.masksToBounds = true
        textViewContainer.layer.cornerRadius = cornerRadius
        textViewContainer.layer.borderWidth = borderWidth
        
        addSubview(textViewContainer)
        textViewContainer.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(containerHeight)
        }
    }
    
    private func configTextView() {
        textView.delegate = self
        textView.backgroundColor = UIColor.clear
        
        textViewContainer.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(textViewVerticalOffset)
            make.bottom.equalToSuperview().offset(-textViewVerticalOffset)
            make.left.equalToSuperview().offset(textViewHorizontalOffset)
            make.right.equalToSuperview().offset(-textViewHorizontalOffset)
        }
    }
    
    private func confgiPlaceholderLabel() {
        textViewContainer.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(textViewVerticalOffset)
            make.left.equalToSuperview().offset(textViewHorizontalOffset)
        }
    }
    
    private func configErrorLabel() {
        addSubview(errorLabel)
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(textViewContainer.snp.bottom).offset(errorTopOffset)
            make.right.equalToSuperview()
        }
    }
    
    // MARK: Layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
    }
    
    // MARK: Private
    
    private func showOrHidePlaceholder() {
        if textView.text == nil || textView.text?.isEmpty == true {
            placeholderLabel.alpha = 1.0
        } else {
            placeholderLabel.alpha = 0.0
        }
    }
    
    private func highlightView() {
        isHighlighted = true
        textViewContainer.layer.borderWidth = highlightBorderWidth
        textViewContainer.layer.borderColor = highlightColor?.cgColor
    }
    
    private func unhighlightView() {
        isHighlighted = false
        textViewContainer.layer.borderWidth = borderWidth
        textViewContainer.layer.borderColor = mainColor?.withAlphaComponent(bordersAlpha).cgColor
    }
    
    // MARK: Public
    
    public func showError (_ errorText: String) {
        if isErrorShowed {
            return
        }
        
        isErrorShowed = true
        errorLabel.text = errorText
        errorLabel.isHidden = false
        
        textViewContainer.layer.borderWidth = highlightBorderWidth
        textViewContainer.layer.borderColor = errorColor?.cgColor
    }
    
    public func hideError () {
        isErrorShowed = false
        errorLabel.isHidden = true
        
        if isHighlighted {
            highlightView()
        } else {
            unhighlightView()
        }
    }
    
    public func setText(_ text: String?) {
        if let text = text, !text.isEmpty {
            textView.text = text
        } else {
            textView.text = ""
            unhighlightView()
        }
    }
    
    public func getText() -> String? {
        return textView.text
    }
}

extension TextView: UITextViewDelegate {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.textViewDidBeginEditing(textView: self)
        
        hideError()
        
        showOrHidePlaceholder()
        highlightView()
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        showOrHidePlaceholder()
        unhighlightView()
        
        delegate?.textViewDidEndEditing(textView: self)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var shoudReplace = true
        
        if let shoud = delegate?.shouldChangeCharacters(textView: self, in: range, replacementString: text) {
            shoudReplace = shoud
        }
        
        return shoudReplace
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        showOrHidePlaceholder()
        delegate?.textDidChange(textView: self, resultText: textView.text)
    }
}
