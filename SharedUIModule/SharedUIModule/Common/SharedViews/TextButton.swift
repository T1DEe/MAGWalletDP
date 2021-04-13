//
//  TextButton.swift
//  SharedUIModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Lottie
import SnapKit
import UIKit

public enum TextButtonStyle {
    case main
    case additional
    case popup
    
    public var titleNormalAlpha: CGFloat {
        return 1.0
    }
    
    public var titleHilightAlpha: CGFloat {
        return 0.9
    }
    
    public var titleDisabledAlpha: CGFloat {
        switch self {
        case .main:
            return 0.4

        case .additional:
            return 0.5

        case .popup:
            return 0.2
        }
    }
    
    public var addBackgroundNormalAlpha: CGFloat {
        return 0.0
    }
    
    public var addBackgroundHilightAlpha: CGFloat {
        switch self {
        case .main:
            return 0.2

        case .additional:
            return 0.2

        case .popup:
            return 0.3
        }
    }
    
    public var addBackgroundDisabledAlpha: CGFloat {
        return 0.0
    }
    
    public var backgroundNormalAlpha: CGFloat {
        switch self {
        case .main:
            return 1.0

        case .additional:
            return 1.0

        case .popup:
            return 0.05
        }
    }
    
    public var backgroundHilightAlpha: CGFloat {
        switch self {
        case .main:
            return 1.0

        case .additional:
            return 1.0

        case .popup:
            return 0.05
        }
    }
    
    public var backgroundDisabledAlpha: CGFloat {
        switch self {
        case .main:
            return 0.4

        case .additional:
            return 0.3

        case .popup:
            return 0.05
        }
    }
}

public typealias TextButtonAction = ((TextButton) -> Void)

public class TextButton: UIView {
    public var style: TextButtonStyle = .main
    public var touchUpInside: TextButtonAction?
    
    public var disabled: Bool = false {
        didSet {
            if disabled {
                configDisabledColors()
            } else {
                configNormalColors()
            }
            
            button.isUserInteractionEnabled = !disabled
        }
    }
    
    public var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    public var animation: Animation? {
        didSet {
            loaderAnimation.animation = animation
            loaderAnimation.loopMode = .loop
        }
    }
    
    public var loadingTitle: String? {
        didSet {
            loaderLabel.text = loadingTitle
        }
    }
    
    public var colorTitle: UIColor? {
        didSet {
            configNormalColors()
        }
    }
    
    public var colorBackground: UIColor? {
        didSet {
            configNormalColors()
        }
    }
    
    public var colorAdditionalBackground: UIColor? {
        didSet {
            configNormalColors()
        }
    }
    
    public var titleFont: UIFont? {
        didSet {
            titleLabel.font = titleFont
            loaderLabel.font = titleFont
        }
    }
    
    private let titleLabel = UILabel()
    private let additionalBackground = UIView()
    private let button = UIButton()
    private let loaderContainer = UIView()
    private let loaderAnimation = AnimationView()
    private let loaderLabel = UILabel()
    
    private let labelOffset: CGFloat = 8
    private let cornerRadius: CGFloat = 10
    private let loaderLabelOffset: CGFloat = 6
    private let loaderWidth: CGFloat = 14
    
    // MARK: Init
    
    public init() {
        super.init(frame: CGRect.zero)
        
        config()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        config()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        config()
    }
    
    // MARK: Config
    
    private func config() {
        configAdditionalBackground()
        configLabel()
        configButton()
        configActions()
        configBorders()
        configLoader()
    }
    
    private func configAdditionalBackground() {
        addSubview(additionalBackground)
        additionalBackground.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    private func configLabel() {
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(labelOffset)
            make.right.equalToSuperview().offset(-labelOffset)
        }
    }
    
    private func configButton() {
        button.isExclusiveTouch = true
        addSubview(button)
        button.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    private func configActions() {
        button.addTarget(self, action: #selector(actionTouchUpInside), for: .touchUpInside)
        button.addTarget(self, action: #selector(actionTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(actionTouchCancel), for: .touchCancel)
        button.addTarget(self, action: #selector(actionTouchUpOutside), for: .touchUpOutside)
    }
    
    private func configBorders() {
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
    }
    
    private func configLoader() {
        loaderLabel.numberOfLines = 1
        loaderLabel.adjustsFontSizeToFitWidth = true
        loaderContainer.isHidden = true
        addSubview(loaderContainer)
        loaderContainer.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview().offset(labelOffset)
            make.right.lessThanOrEqualToSuperview().offset(-labelOffset)
        }

        loaderContainer.addSubview(loaderAnimation)
        loaderContainer.addSubview(loaderLabel)
        
        loaderAnimation.snp.makeConstraints { make in
            make.right.equalTo(loaderLabel.snp.left).offset(-loaderLabelOffset)
            make.width.height.equalTo(loaderWidth)
            make.left.centerY.equalToSuperview()
        }
        
        loaderLabel.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
        }
    }
    
    // MARK: Public
    
    public func startLoading() {
        loaderAnimation.play()
        loaderContainer.isHidden = false
        titleLabel.isHidden = true
        button.isUserInteractionEnabled = false
    }
    
    public func endLoading() {
        loaderAnimation.stop()
        loaderContainer.isHidden = true
        titleLabel.isHidden = false
        button.isUserInteractionEnabled = true
    }
    
    // MARK: Actions
    
    @objc
    private func actionTouchDown() {
        configHilightColors()
    }
    
    @objc
    private func actionTouchUpInside() {
        configNormalColors()
        touchUpInside?(self)
    }
    
    @objc
    private func actionTouchUpOutside() {
        configNormalColors()
    }
    
    @objc
    private func actionTouchCancel() {
        configNormalColors()
    }
    
    // MARK: Colors
    
    private func configNormalColors() {
        loaderLabel.textColor = colorTitle?.withAlphaComponent(style.titleNormalAlpha)
        titleLabel.textColor = colorTitle?.withAlphaComponent(style.titleNormalAlpha)
        backgroundColor = colorBackground?.withAlphaComponent(style.backgroundNormalAlpha)
        additionalBackground.backgroundColor = colorAdditionalBackground?.withAlphaComponent(style.addBackgroundNormalAlpha)
    }
    
    private func configHilightColors() {
        titleLabel.textColor = colorTitle?.withAlphaComponent(style.titleHilightAlpha)
        backgroundColor = colorBackground?.withAlphaComponent(style.backgroundHilightAlpha)
        additionalBackground.backgroundColor = colorAdditionalBackground?.withAlphaComponent(style.addBackgroundHilightAlpha)
    }
    
    private func configDisabledColors() {
        titleLabel.textColor = colorTitle?.withAlphaComponent(style.titleDisabledAlpha)
        backgroundColor = colorBackground?.withAlphaComponent(style.backgroundDisabledAlpha)
        additionalBackground.backgroundColor = colorAdditionalBackground?.withAlphaComponent(style.addBackgroundDisabledAlpha)
    }
}
