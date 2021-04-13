//
//  ImageButton.swift
//  SharedUIModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SnapKit
import UIKit

public enum ImageButtonStyle {
    case withoutBackground
    case withBackground
    
    public var imageNormalAlpha: CGFloat {
        return 1.0
    }
    
    public var imageHilightAlpha: CGFloat {
        return 0.8
    }
    
    public var addBackgroundNormalAlpha: CGFloat {
        return 0.0
    }
    
    public var addBackgroundHilightAlpha: CGFloat {
        return 0.2
    }
}

public typealias ImageButtonAction = ((ImageButton) -> Void)

public class ImageButton: UIView {
    public var style: ImageButtonStyle = .withoutBackground
    public var touchUpInside: ImageButtonAction?
    
    public var image: UIImage? {
        didSet {
            imageView.image = image
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
    
    private let imageView = UIImageView()
    private let additionalBackground = UIView()
    private let button = UIButton()
    
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
    
    // MARK: Layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2
    }
    
    // MARK: Config
    
    private func config() {
        configAdditionalBackground()
        configImageView()
        configButton()
        configActions()
        configBorders()
    }
    
    private func configAdditionalBackground() {
        addSubview(additionalBackground)
        additionalBackground.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    private func configImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
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
        imageView.alpha = style.imageNormalAlpha
        backgroundColor = colorBackground
        additionalBackground.backgroundColor = colorAdditionalBackground?.withAlphaComponent(style.addBackgroundNormalAlpha)
    }
    
    private func configHilightColors() {
        imageView.alpha = style.imageHilightAlpha
        additionalBackground.backgroundColor = colorAdditionalBackground?.withAlphaComponent(style.addBackgroundHilightAlpha)
    }
}
